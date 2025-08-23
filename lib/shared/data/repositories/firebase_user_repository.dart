import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';

import 'package:fitness_training_app/core/constants/firebase_constants.dart';
import 'package:fitness_training_app/core/utils/logger.dart';
import 'package:fitness_training_app/shared/data/models/offline/offline_models.dart';
import 'package:fitness_training_app/shared/domain/entities/user_profile.dart';
import 'package:fitness_training_app/shared/domain/repositories/user_repository.dart';

/// Firebase implementation of UserRepository with offline caching
class FirebaseUserRepository implements UserRepository {
  final FirebaseFirestore _firestore;
  final Connectivity _connectivity;

  Box<UserProfile>? _userCache;
  Box<SyncQueueItem>? _syncQueue;

  static const String _userCacheBoxName = 'user_profiles';
  static const String _syncQueueBoxName = 'sync_queue';

  FirebaseUserRepository({
    FirebaseFirestore? firestore,
    Connectivity? connectivity,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _connectivity = connectivity ?? Connectivity();

  /// Safely get user cache box
  Box<UserProfile>? get _safeUserCache {
    try {
      _userCache ??= Hive.box<UserProfile>(_userCacheBoxName);
      return _userCache;
    } catch (e) {
      AppLogger.warning('User cache box not available: $e');
      return null;
    }
  }

  /// Safely get sync queue box
  Box<SyncQueueItem>? get _safeSyncQueue {
    try {
      _syncQueue ??= Hive.box<SyncQueueItem>(_syncQueueBoxName);
      return _syncQueue;
    } catch (e) {
      AppLogger.warning('Sync queue box not available: $e');
      return null;
    }
  }

  @override
  Future<UserProfile?> getUserProfile(String userId) async {
    try {
      // Check cache first
      final userCache = _safeUserCache;
      final cachedProfile = userCache?.get(userId);
      final isOnline = await _isOnline();

      // If offline, return cached profile
      if (!isOnline && cachedProfile != null) {
        AppLogger.info('Returning user profile $userId from cache (offline)');
        return cachedProfile;
      }

      // Try to fetch from Firestore if online
      if (isOnline) {
        final doc =
            await _firestore
                .collection(FirebaseConstants.users)
                .doc(userId)
                .get();

        if (doc.exists && doc.data() != null) {
          final profile = UserProfileHelper.fromFirestore(doc.id, doc.data()!);
          await _cacheUserProfile(profile);
          AppLogger.info(
            'Fetched and cached user profile $userId from Firestore',
          );
          return profile;
        }
      }

      // Return cached profile if available
      if (cachedProfile != null) {
        AppLogger.info('Returning cached user profile $userId');
        return cachedProfile;
      }

      AppLogger.warning('User profile $userId not found');
      return null;
    } catch (e, stackTrace) {
      AppLogger.error('Error getting user profile $userId', e, stackTrace);

      // Fallback to cache on error
      final userCache = _safeUserCache;
      final cachedProfile = userCache?.get(userId);
      if (cachedProfile != null) {
        AppLogger.info('Returning cached user profile $userId due to error');
        return cachedProfile;
      }

      rethrow;
    }
  }

  @override
  Future<UserProfile> createUserProfile(UserProfile profile) async {
    try {
      // Validate profile data
      final validationErrors = profile.validate();
      if (validationErrors.isNotEmpty) {
        throw ArgumentError(
          'Invalid user profile: ${validationErrors.join(', ')}',
        );
      }

      final isOnline = await _isOnline();

      if (isOnline) {
        // Create in Firestore
        await _firestore
            .collection(FirebaseConstants.users)
            .doc(profile.id)
            .set(profile.toFirestore());

        AppLogger.info('Created user profile ${profile.id} in Firestore');
      } else {
        // Queue for sync when online
        final syncQueue = _safeSyncQueue;
        if (syncQueue != null) {
          final syncItem = SyncQueueItem.forUserProfile(
            profile,
            operation: SyncOperation.create,
            priority: 0, // High priority
          );
          await syncQueue.put(syncItem.id, syncItem);
          AppLogger.info('Queued user profile ${profile.id} creation for sync');
        } else {
          AppLogger.warning(
            'Sync queue not available, cannot queue profile creation',
          );
        }
      }

      // Cache the profile
      await _cacheUserProfile(profile);

      return profile;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error creating user profile ${profile.id}',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<UserProfile> updateUserProfile(UserProfile profile) async {
    try {
      // Validate profile data
      final validationErrors = profile.validate();
      if (validationErrors.isNotEmpty) {
        throw ArgumentError(
          'Invalid user profile: ${validationErrors.join(', ')}',
        );
      }

      final isOnline = await _isOnline();

      if (isOnline) {
        // Update in Firestore
        await _firestore
            .collection(FirebaseConstants.users)
            .doc(profile.id)
            .update(profile.toFirestore());

        AppLogger.info('Updated user profile ${profile.id} in Firestore');
      } else {
        // Queue for sync when online
        final syncQueue = _safeSyncQueue;
        if (syncQueue != null) {
          final syncItem = SyncQueueItem.forUserProfile(
            profile,
            operation: SyncOperation.update,
            priority: 1, // High priority
          );
          await syncQueue.put(syncItem.id, syncItem);
          AppLogger.info('Queued user profile ${profile.id} update for sync');
        } else {
          AppLogger.warning(
            'Sync queue not available, cannot queue profile update',
          );
        }
      }

      // Cache the updated profile
      await _cacheUserProfile(profile);

      return profile;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error updating user profile ${profile.id}',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<void> deleteUserProfile(String userId) async {
    try {
      final isOnline = await _isOnline();

      if (isOnline) {
        // Delete from Firestore
        await _firestore
            .collection(FirebaseConstants.users)
            .doc(userId)
            .delete();

        AppLogger.info('Deleted user profile $userId from Firestore');
      } else {
        // Queue for sync when online
        final syncQueue = _safeSyncQueue;
        if (syncQueue != null) {
          final syncItem = SyncQueueItem(
            id: 'delete_profile_$userId',
            operation: SyncOperation.delete,
            entityType: 'UserProfile',
            entityId: userId,
            data: {},
            createdAt: DateTime.now(),
            priority: 0, // High priority
            metadata: {'userId': userId},
          );
          await syncQueue.put(syncItem.id, syncItem);
          AppLogger.info('Queued user profile $userId deletion for sync');
        } else {
          AppLogger.warning(
            'Sync queue not available, cannot queue profile deletion',
          );
        }
      }

      // Remove from cache
      final userCache = _safeUserCache;
      if (userCache != null) {
        await userCache.delete(userId);
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error deleting user profile $userId', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> updateUserPreferences(
    String userId,
    Map<String, dynamic> preferences,
  ) async {
    try {
      final isOnline = await _isOnline();

      if (isOnline) {
        // Update preferences in Firestore
        await _firestore.collection(FirebaseConstants.users).doc(userId).update(
          {'preferences': preferences},
        );

        AppLogger.info('Updated user preferences for $userId in Firestore');
      } else {
        // Queue for sync when online
        final syncQueue = _safeSyncQueue;
        if (syncQueue != null) {
          final syncItem = SyncQueueItem(
            id: 'update_preferences_$userId',
            operation: SyncOperation.update,
            entityType: 'UserProfile',
            entityId: userId,
            data: {'preferences': preferences},
            createdAt: DateTime.now(),
            priority: 2, // Medium priority
            metadata: {'userId': userId, 'updateType': 'preferences'},
          );
          await syncQueue.put(syncItem.id, syncItem);
          AppLogger.info('Queued user preferences update for $userId for sync');
        } else {
          AppLogger.warning(
            'Sync queue not available, cannot queue preferences update',
          );
        }
      }

      // Update cached profile if available
      final userCache = _safeUserCache;
      final cachedProfile = userCache?.get(userId);
      if (cachedProfile != null) {
        final updatedProfile = cachedProfile.copyWith(
          preferences: preferences,
          updatedAt: DateTime.now(),
        );
        await _cacheUserProfile(updatedProfile);
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error updating user preferences for $userId',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<void> updateFitnessMetrics({
    required String userId,
    double? weight,
    double? targetWeight,
    double? height,
  }) async {
    try {
      final updateData = <String, dynamic>{};
      if (weight != null) updateData['weight'] = weight;
      if (targetWeight != null) updateData['targetWeight'] = targetWeight;
      if (height != null) updateData['height'] = height;
      updateData['updatedAt'] = FieldValue.serverTimestamp();

      final isOnline = await _isOnline();

      if (isOnline) {
        // Update metrics in Firestore
        await _firestore
            .collection(FirebaseConstants.users)
            .doc(userId)
            .update(updateData);

        AppLogger.info('Updated fitness metrics for $userId in Firestore');
      } else {
        // Queue for sync when online
        final syncQueue = _safeSyncQueue;
        if (syncQueue != null) {
          final syncItem = SyncQueueItem(
            id: 'update_metrics_$userId',
            operation: SyncOperation.update,
            entityType: 'UserProfile',
            entityId: userId,
            data: updateData,
            createdAt: DateTime.now(),
            priority: 1, // High priority
            metadata: {'userId': userId, 'updateType': 'fitnessMetrics'},
          );
          await syncQueue.put(syncItem.id, syncItem);
          AppLogger.info('Queued fitness metrics update for $userId for sync');
        } else {
          AppLogger.warning(
            'Sync queue not available, cannot queue metrics update',
          );
        }
      }

      // Update cached profile if available
      final userCache = _safeUserCache;
      final cachedProfile = userCache?.get(userId);
      if (cachedProfile != null) {
        final updatedProfile = cachedProfile.copyWith(
          weight: weight ?? cachedProfile.weight,
          targetWeight: targetWeight ?? cachedProfile.targetWeight,
          height: height ?? cachedProfile.height,
          updatedAt: DateTime.now(),
        );
        await _cacheUserProfile(updatedProfile);
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error updating fitness metrics for $userId',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<void> updatePremiumStatus({
    required String userId,
    required bool isPremium,
    DateTime? expiresAt,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'isPremium': isPremium,
        'premiumExpiresAt': expiresAt?.toIso8601String(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      final isOnline = await _isOnline();

      if (isOnline) {
        // Update premium status in Firestore
        await _firestore
            .collection(FirebaseConstants.users)
            .doc(userId)
            .update(updateData);

        AppLogger.info('Updated premium status for $userId in Firestore');
      } else {
        // Queue for sync when online
        final syncQueue = _safeSyncQueue;
        if (syncQueue != null) {
          final syncItem = SyncQueueItem(
            id: 'update_premium_$userId',
            operation: SyncOperation.update,
            entityType: 'UserProfile',
            entityId: userId,
            data: updateData,
            createdAt: DateTime.now(),
            priority: 0, // High priority
            metadata: {'userId': userId, 'updateType': 'premiumStatus'},
          );
          await syncQueue.put(syncItem.id, syncItem);
          AppLogger.info('Queued premium status update for $userId for sync');
        } else {
          AppLogger.warning(
            'Sync queue not available, cannot queue premium status update',
          );
        }
      }

      // Update cached profile if available
      final userCache = _safeUserCache;
      final cachedProfile = userCache?.get(userId);
      if (cachedProfile != null) {
        final updatedProfile = cachedProfile.copyWith(
          isPremium: isPremium,
          premiumExpiresAt: expiresAt,
          updatedAt: DateTime.now(),
        );
        await _cacheUserProfile(updatedProfile);
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error updating premium status for $userId',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<void> updateFCMToken(String userId, String? fcmToken) async {
    try {
      final updateData = <String, dynamic>{
        'fcmToken': fcmToken,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      final isOnline = await _isOnline();

      if (isOnline) {
        // Update FCM token in Firestore
        await _firestore
            .collection(FirebaseConstants.users)
            .doc(userId)
            .update(updateData);

        AppLogger.info('Updated FCM token for $userId in Firestore');
      } else {
        // Queue for sync when online
        final syncQueue = _safeSyncQueue;
        if (syncQueue != null) {
          final syncItem = SyncQueueItem(
            id: 'update_fcm_$userId',
            operation: SyncOperation.update,
            entityType: 'UserProfile',
            entityId: userId,
            data: updateData,
            createdAt: DateTime.now(),
            priority: 2, // Medium priority
            metadata: {'userId': userId, 'updateType': 'fcmToken'},
          );
          await syncQueue.put(syncItem.id, syncItem);
          AppLogger.info('Queued FCM token update for $userId for sync');
        } else {
          AppLogger.warning(
            'Sync queue not available, cannot queue FCM token update',
          );
        }
      }

      // Update cached profile if available
      final userCache = _safeUserCache;
      final cachedProfile = userCache?.get(userId);
      if (cachedProfile != null) {
        final updatedProfile = cachedProfile.copyWith(
          fcmToken: fcmToken,
          updatedAt: DateTime.now(),
        );
        await _cacheUserProfile(updatedProfile);
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error updating FCM token for $userId', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> updateAIProviderConfig(
    String userId,
    Map<String, dynamic> config,
  ) async {
    try {
      final updateData = <String, dynamic>{
        'aiProviderConfig': config,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      final isOnline = await _isOnline();

      if (isOnline) {
        // Update AI provider config in Firestore
        await _firestore
            .collection(FirebaseConstants.users)
            .doc(userId)
            .update(updateData);

        AppLogger.info('Updated AI provider config for $userId in Firestore');
      } else {
        // Queue for sync when online
        final syncQueue = _safeSyncQueue;
        if (syncQueue != null) {
          final syncItem = SyncQueueItem(
            id: 'update_ai_config_$userId',
            operation: SyncOperation.update,
            entityType: 'UserProfile',
            entityId: userId,
            data: updateData,
            createdAt: DateTime.now(),
            priority: 2, // Medium priority
            metadata: {'userId': userId, 'updateType': 'aiProviderConfig'},
          );
          await syncQueue.put(syncItem.id, syncItem);
          AppLogger.info(
            'Queued AI provider config update for $userId for sync',
          );
        } else {
          AppLogger.warning(
            'Sync queue not available, cannot queue AI config update',
          );
        }
      }

      // Update cached profile if available
      final userCache = _safeUserCache;
      final cachedProfile = userCache?.get(userId);
      if (cachedProfile != null) {
        final updatedProfile = cachedProfile.copyWith(
          aiProviderConfig: config,
          updatedAt: DateTime.now(),
        );
        await _cacheUserProfile(updatedProfile);
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error updating AI provider config for $userId',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  @override
  Stream<UserProfile?> watchUserProfile(String userId) {
    return _firestore
        .collection(FirebaseConstants.users)
        .doc(userId)
        .snapshots()
        .map((doc) {
          if (doc.exists && doc.data() != null) {
            final profile = UserProfileHelper.fromFirestore(
              doc.id,
              doc.data()!,
            );
            // Cache the profile asynchronously
            _cacheUserProfile(profile);
            return profile;
          }
          return null;
        })
        .handleError((Object error, StackTrace stackTrace) {
          AppLogger.error(
            'Error watching user profile $userId',
            error,
            stackTrace,
          );
          // Return cached profile on error
          final userCache = _safeUserCache;
          final cachedProfile = userCache?.get(userId);
          return Stream.value(cachedProfile);
        });
  }

  @override
  Future<bool> userExists(String userId) async {
    try {
      // Check cache first
      final userCache = _safeUserCache;
      if (userCache?.containsKey(userId) == true) {
        return true;
      }

      // Check Firestore if online
      if (await _isOnline()) {
        final doc =
            await _firestore
                .collection(FirebaseConstants.users)
                .doc(userId)
                .get();
        return doc.exists;
      }

      return false;
    } catch (e, stackTrace) {
      AppLogger.error('Error checking if user $userId exists', e, stackTrace);
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>> getUserExercisePreferences(String userId) async {
    try {
      final profile = await getUserProfile(userId);
      if (profile == null) {
        return {};
      }

      return {
        'preferredExerciseTypes': profile.preferredExerciseTypes,
        'dislikedExercises': profile.dislikedExercises,
        'fitnessGoal': profile.fitnessGoal.name,
        'activityLevel': profile.activityLevel.name,
        'preferences': profile.preferences,
      };
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error getting exercise preferences for $userId',
        e,
        stackTrace,
      );
      return {};
    }
  }

  @override
  Future<void> updateExercisePreferences(
    String userId,
    Map<String, dynamic> preferences,
  ) async {
    try {
      final profile = await getUserProfile(userId);
      if (profile == null) {
        throw Exception('User profile not found');
      }

      final updatedProfile = profile.copyWith(
        preferredExerciseTypes:
            (preferences['preferredExerciseTypes'] as List<String>?) ??
            profile.preferredExerciseTypes,
        dislikedExercises:
            (preferences['dislikedExercises'] as List<String>?) ??
            profile.dislikedExercises,
        preferences: {...profile.preferences, ...preferences},
        updatedAt: DateTime.now(),
      );

      await updateUserProfile(updatedProfile);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error updating exercise preferences for $userId',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<bool> isAvailableOffline(String userId) async {
    final userCache = _safeUserCache;
    return userCache?.containsKey(userId) ?? false;
  }

  @override
  Future<void> refreshFromRemote(String userId) async {
    if (!await _isOnline()) {
      throw Exception('Cannot refresh from remote while offline');
    }

    try {
      final doc =
          await _firestore
              .collection(FirebaseConstants.users)
              .doc(userId)
              .get();

      if (doc.exists && doc.data() != null) {
        final profile = UserProfileHelper.fromFirestore(doc.id, doc.data()!);
        await _cacheUserProfile(profile);
        AppLogger.info(
          'Successfully refreshed user profile $userId from remote',
        );
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error refreshing user profile $userId from remote',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getCacheStatus(String userId) async {
    final userCache = _safeUserCache;
    final syncQueue = _safeSyncQueue;

    final hasCachedProfile = userCache?.containsKey(userId) ?? false;
    final cachedProfile = userCache?.get(userId);

    return {
      'hasCachedProfile': hasCachedProfile,
      'lastUpdated': cachedProfile?.updatedAt.toIso8601String(),
      'isOnline': await _isOnline(),
      'pendingSyncItems':
          syncQueue?.values
              .where((item) => item.metadata['userId'] == userId)
              .length ??
          0,
    };
  }

  // Private helper methods

  Future<void> _cacheUserProfile(UserProfile profile) async {
    final userCache = _safeUserCache;
    if (userCache != null) {
      await userCache.put(profile.id, profile);
    } else {
      AppLogger.warning(
        'User cache not available, cannot cache profile ${profile.id}',
      );
    }
  }

  Future<bool> _isOnline() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      return connectivityResult.contains(ConnectivityResult.mobile) ||
          connectivityResult.contains(ConnectivityResult.wifi) ||
          connectivityResult.contains(ConnectivityResult.ethernet);
    } catch (e) {
      AppLogger.warning('Error checking connectivity, assuming offline');
      return false;
    }
  }
}
