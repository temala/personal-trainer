import 'dart:async';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'package:fitness_training_app/core/utils/logger.dart';
import 'package:fitness_training_app/shared/data/models/offline/hive_adapters.dart';
import 'package:fitness_training_app/shared/data/models/offline/local_database.dart';
import 'package:fitness_training_app/shared/data/models/offline/offline_models.dart';
import 'package:fitness_training_app/shared/data/services/offline_manager.dart';
import 'package:fitness_training_app/shared/data/services/sync_manager.dart';
import 'package:fitness_training_app/shared/domain/entities/entities.dart';

/// Comprehensive local storage service with automatic sync queuing
class LocalStorageService {
  final OfflineManager _offlineManager;
  final SyncManager _syncManager;

  static const Duration _autoCleanupInterval = Duration(hours: 6);
  Timer? _cleanupTimer;

  LocalStorageService({
    OfflineManager? offlineManager,
    SyncManager? syncManager,
  }) : _offlineManager = offlineManager ?? OfflineManager(),
       _syncManager = syncManager ?? SyncManager();

  /// Initialize the local storage service
  Future<void> initialize() async {
    try {
      AppLogger.info('Initializing LocalStorageService...');

      // Initialize Hive with proper path
      final appDocumentDir = await getApplicationDocumentsDirectory();
      Hive.init(appDocumentDir.path);

      // Register all type adapters
      HiveAdapters.registerAdapters();

      // Initialize local database
      await LocalDatabase.initialize();

      // Initialize offline manager
      await _offlineManager.initialize();

      // Initialize sync manager
      await _syncManager.initialize();

      // Start automatic cleanup
      _startAutoCleanup();

      AppLogger.info('LocalStorageService initialized successfully');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to initialize LocalStorageService',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  /// Dispose resources
  Future<void> dispose() async {
    try {
      _cleanupTimer?.cancel();
      await _offlineManager.dispose();
      await _syncManager.dispose();
      await LocalDatabase.close();
      AppLogger.info('LocalStorageService disposed');
    } catch (e, stackTrace) {
      AppLogger.error('Error disposing LocalStorageService', e, stackTrace);
    }
  }

  // User Profile Storage

  /// Store user profile with automatic sync queuing
  Future<void> storeUserProfile(UserProfile profile) async {
    try {
      // Store in local cache
      await LocalDatabase.userProfileBox.put(profile.id, profile);
      AppLogger.info('Stored user profile ${profile.id} locally');

      // Queue for sync if online or when connection is restored
      if (!_offlineManager.isOnline) {
        final syncItem = SyncQueueItem.forUserProfile(
          profile,
          operation: SyncOperation.update,
          priority: 0, // High priority for user profiles
        );
        await _syncManager.queueForSync(syncItem);
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error storing user profile ${profile.id}',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  /// Get user profile from local storage
  Future<UserProfile?> getUserProfile(String userId) async {
    try {
      final profile = LocalDatabase.userProfileBox.get(userId) as UserProfile?;
      if (profile != null) {
        AppLogger.debug('Retrieved user profile $userId from local storage');
      }
      return profile;
    } catch (e, stackTrace) {
      AppLogger.error('Error getting user profile $userId', e, stackTrace);
      return null;
    }
  }

  /// Delete user profile from local storage
  Future<void> deleteUserProfile(String userId) async {
    try {
      await LocalDatabase.userProfileBox.delete(userId);
      AppLogger.info('Deleted user profile $userId from local storage');

      // Queue deletion for sync
      if (!_offlineManager.isOnline) {
        final syncItem = SyncQueueItem(
          id: 'delete_profile_$userId',
          operation: SyncOperation.delete,
          entityType: 'UserProfile',
          entityId: userId,
          data: {},
          createdAt: DateTime.now(),
          priority: 0,
          metadata: {'userId': userId},
        );
        await _syncManager.queueForSync(syncItem);
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error deleting user profile $userId', e, stackTrace);
      rethrow;
    }
  }

  // Exercise Storage

  /// Store cached exercise
  Future<void> storeCachedExercise(
    Exercise exercise, {
    bool isPreloaded = false,
  }) async {
    try {
      final cachedExercise = CachedExercise.fromExercise(
        exercise,
        isPreloaded: isPreloaded,
      );
      await LocalDatabase.cachedExercisesBox.put(exercise.id, cachedExercise);
      AppLogger.debug('Stored cached exercise ${exercise.id}');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error storing cached exercise ${exercise.id}',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  /// Get cached exercise
  Future<Exercise?> getCachedExercise(String exerciseId) async {
    try {
      final cachedExercise = LocalDatabase.cachedExercisesBox.get(exerciseId);
      if (cachedExercise != null) {
        cachedExercise.markAccessed();
        AppLogger.debug('Retrieved cached exercise $exerciseId');
        return cachedExercise.exercise;
      }
      return null;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error getting cached exercise $exerciseId',
        e,
        stackTrace,
      );
      return null;
    }
  }

  /// Get all cached exercises
  Future<List<Exercise>> getAllCachedExercises() async {
    try {
      final cachedExercises =
          LocalDatabase.cachedExercisesBox.values
              .map((cached) => cached.exercise)
              .toList();
      AppLogger.debug('Retrieved ${cachedExercises.length} cached exercises');
      return cachedExercises;
    } catch (e, stackTrace) {
      AppLogger.error('Error getting all cached exercises', e, stackTrace);
      return [];
    }
  }

  /// Preload exercises for offline use
  Future<void> preloadExercises(List<Exercise> exercises) async {
    try {
      for (final exercise in exercises) {
        await storeCachedExercise(exercise, isPreloaded: true);
      }
      AppLogger.info('Preloaded ${exercises.length} exercises for offline use');
    } catch (e, stackTrace) {
      AppLogger.error('Error preloading exercises', e, stackTrace);
      rethrow;
    }
  }

  // Workout Plan Storage

  /// Store cached workout plan
  Future<void> storeCachedWorkoutPlan(WorkoutPlan plan, String userId) async {
    try {
      final cachedPlan = CachedWorkoutPlan.fromWorkoutPlan(
        plan,
        userId: userId,
      );
      await LocalDatabase.cachedWorkoutPlansBox.put(plan.id, cachedPlan);
      AppLogger.info('Stored cached workout plan ${plan.id}');

      // Queue for sync if needed
      if (!_offlineManager.isOnline) {
        final syncItem = SyncQueueItem(
          id: 'sync_plan_${plan.id}',
          operation: SyncOperation.update,
          entityType: 'WorkoutPlan',
          entityId: plan.id,
          data: plan.toJson(),
          createdAt: DateTime.now(),
          priority: 1,
          metadata: {'userId': userId},
        );
        await _syncManager.queueForSync(syncItem);
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error storing cached workout plan ${plan.id}',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  /// Get cached workout plan
  Future<WorkoutPlan?> getCachedWorkoutPlan(String planId) async {
    try {
      final cachedPlan = LocalDatabase.cachedWorkoutPlansBox.get(planId);
      if (cachedPlan != null) {
        AppLogger.debug('Retrieved cached workout plan $planId');
        return cachedPlan.workoutPlan;
      }
      return null;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error getting cached workout plan $planId',
        e,
        stackTrace,
      );
      return null;
    }
  }

  /// Get cached workout plans for user
  Future<List<WorkoutPlan>> getCachedWorkoutPlansForUser(String userId) async {
    try {
      final userPlans =
          LocalDatabase.cachedWorkoutPlansBox.values
              .where((cached) => cached.userId == userId)
              .map((cached) => cached.workoutPlan)
              .toList();
      AppLogger.debug(
        'Retrieved ${userPlans.length} cached workout plans for user $userId',
      );
      return userPlans;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error getting cached workout plans for user $userId',
        e,
        stackTrace,
      );
      return [];
    }
  }

  /// Delete cached workout plan
  Future<void> deleteCachedWorkoutPlan(String planId) async {
    try {
      await LocalDatabase.cachedWorkoutPlansBox.delete(planId);
      AppLogger.info('Deleted cached workout plan $planId');

      // Queue deletion for sync
      if (!_offlineManager.isOnline) {
        final syncItem = SyncQueueItem(
          id: 'delete_plan_$planId',
          operation: SyncOperation.delete,
          entityType: 'WorkoutPlan',
          entityId: planId,
          data: {},
          createdAt: DateTime.now(),
          priority: 1,
          metadata: {},
        );
        await _syncManager.queueForSync(syncItem);
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error deleting cached workout plan $planId',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  // Workout Session Storage

  /// Store offline workout session
  Future<void> storeOfflineWorkoutSession(WorkoutSession session) async {
    try {
      final offlineSession = OfflineWorkoutSession.fromSession(
        session,
        userId: session.userId,
      );
      await LocalDatabase.offlineSessionsBox.put(session.id, offlineSession);
      AppLogger.info('Stored offline workout session ${session.id}');

      // Queue for sync
      final syncItem = SyncQueueItem.forWorkoutSession(
        session,
        operation: SyncOperation.create,
        priority: 0, // High priority for workout sessions
      );
      await _syncManager.queueForSync(syncItem);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error storing offline workout session ${session.id}',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  /// Update offline workout session
  Future<void> updateOfflineWorkoutSession(WorkoutSession session) async {
    try {
      final offlineSession = OfflineWorkoutSession.fromSession(
        session,
        userId: session.userId,
      );
      await LocalDatabase.offlineSessionsBox.put(session.id, offlineSession);
      AppLogger.info('Updated offline workout session ${session.id}');

      // Queue for sync
      final syncItem = SyncQueueItem.forWorkoutSession(
        session,
        operation: SyncOperation.update,
        priority: 0, // High priority for workout sessions
      );
      await _syncManager.queueForSync(syncItem);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error updating offline workout session ${session.id}',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  /// Get offline workout session
  Future<WorkoutSession?> getOfflineWorkoutSession(String sessionId) async {
    try {
      final offlineSession = LocalDatabase.offlineSessionsBox.get(sessionId);
      if (offlineSession != null) {
        AppLogger.debug('Retrieved offline workout session $sessionId');
        return offlineSession.session;
      }
      return null;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error getting offline workout session $sessionId',
        e,
        stackTrace,
      );
      return null;
    }
  }

  /// Get offline workout sessions for user
  Future<List<WorkoutSession>> getOfflineWorkoutSessionsForUser(
    String userId,
  ) async {
    try {
      final userSessions =
          LocalDatabase.offlineSessionsBox.values
              .where((offline) => offline.userId == userId)
              .map((offline) => offline.session)
              .toList();

      // Sort by start date descending
      userSessions.sort((a, b) => b.startedAt.compareTo(a.startedAt));

      AppLogger.debug(
        'Retrieved ${userSessions.length} offline workout sessions for user $userId',
      );
      return userSessions;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error getting offline workout sessions for user $userId',
        e,
        stackTrace,
      );
      return [];
    }
  }

  /// Get active offline workout session for user
  Future<WorkoutSession?> getActiveOfflineWorkoutSession(String userId) async {
    try {
      final activeSessions =
          LocalDatabase.offlineSessionsBox.values
              .where(
                (offline) =>
                    offline.userId == userId && offline.session.isActive,
              )
              .map((offline) => offline.session)
              .toList();

      if (activeSessions.isNotEmpty) {
        // Return the most recent active session
        activeSessions.sort((a, b) => b.startedAt.compareTo(a.startedAt));
        AppLogger.debug(
          'Retrieved active offline workout session for user $userId',
        );
        return activeSessions.first;
      }

      return null;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error getting active offline workout session for user $userId',
        e,
        stackTrace,
      );
      return null;
    }
  }

  /// Delete offline workout session
  Future<void> deleteOfflineWorkoutSession(String sessionId) async {
    try {
      await LocalDatabase.offlineSessionsBox.delete(sessionId);
      AppLogger.info('Deleted offline workout session $sessionId');

      // Queue deletion for sync
      if (!_offlineManager.isOnline) {
        final syncItem = SyncQueueItem(
          id: 'delete_session_$sessionId',
          operation: SyncOperation.delete,
          entityType: 'WorkoutSession',
          entityId: sessionId,
          data: {},
          createdAt: DateTime.now(),
          priority: 0,
          metadata: {},
        );
        await _syncManager.queueForSync(syncItem);
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error deleting offline workout session $sessionId',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  // Sync Management

  /// Get sync queue status
  Map<String, dynamic> getSyncStatus() {
    return _syncManager.getSyncStatus();
  }

  /// Get pending sync operations for user
  Future<List<Map<String, dynamic>>> getPendingSyncOperationsForUser(
    String userId,
  ) async {
    try {
      final pendingItems =
          LocalDatabase.syncQueueBox.values
              .where((item) => item.metadata['userId'] == userId)
              .map(
                (item) => {
                  'id': item.id,
                  'operation': item.operation.name,
                  'entityType': item.entityType,
                  'entityId': item.entityId,
                  'createdAt': item.createdAt.toIso8601String(),
                  'priority': item.priority,
                  'retryCount': item.retryCount,
                  'error': item.error,
                  'isReadyForRetry': item.isReadyForRetry,
                },
              )
              .toList();

      AppLogger.debug(
        'Retrieved ${pendingItems.length} pending sync operations for user $userId',
      );
      return pendingItems;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error getting pending sync operations for user $userId',
        e,
        stackTrace,
      );
      return [];
    }
  }

  /// Force sync all pending operations
  Future<void> forceSyncAll() async {
    try {
      await _syncManager.syncWhenOnline();
      AppLogger.info('Forced sync of all pending operations');
    } catch (e, stackTrace) {
      AppLogger.error('Error forcing sync of all operations', e, stackTrace);
      rethrow;
    }
  }

  /// Clear failed sync items
  Future<void> clearFailedSyncItems() async {
    try {
      await _syncManager.clearFailedSyncItems();
      AppLogger.info('Cleared failed sync items');
    } catch (e, stackTrace) {
      AppLogger.error('Error clearing failed sync items', e, stackTrace);
      rethrow;
    }
  }

  /// Retry failed sync items
  Future<void> retryFailedSyncItems() async {
    try {
      await _syncManager.retryFailedSyncItems();
      AppLogger.info('Retried failed sync items');
    } catch (e, stackTrace) {
      AppLogger.error('Error retrying failed sync items', e, stackTrace);
      rethrow;
    }
  }

  // Storage Management

  /// Get storage statistics
  Future<Map<String, dynamic>> getStorageStatistics() async {
    try {
      final dbStats = LocalDatabase.getStatistics();
      final offlineStats = await _offlineManager.getOfflineStorageStats();

      return {
        'database': dbStats,
        'offline': offlineStats,
        'connectivity': {
          'isOnline': _offlineManager.isOnline,
          'quality': (await _offlineManager.getConnectivityQuality()).name,
        },
        'sync': getSyncStatus(),
      };
    } catch (e, stackTrace) {
      AppLogger.error('Error getting storage statistics', e, stackTrace);
      return {'error': e.toString()};
    }
  }

  /// Perform storage cleanup
  Future<void> performStorageCleanup() async {
    try {
      AppLogger.info('Starting storage cleanup...');

      // Perform database cleanup
      await LocalDatabase.performCacheCleanup();

      // Optimize offline storage
      await _offlineManager.optimizeOfflineStorage();

      // Compact database
      await LocalDatabase.compactDatabase();

      AppLogger.info('Storage cleanup completed');
    } catch (e, stackTrace) {
      AppLogger.error('Error performing storage cleanup', e, stackTrace);
      rethrow;
    }
  }

  /// Clear all local data (for logout or reset)
  Future<void> clearAllLocalData() async {
    try {
      AppLogger.warning('Clearing all local data');

      // Clear database
      await LocalDatabase.clearAllData();

      // Clear offline manager caches
      await _offlineManager.clearOfflineCache(dataType: 'all');

      // Clear failed sync items
      await _syncManager.clearFailedSyncItems();

      AppLogger.info('All local data cleared');
    } catch (e, stackTrace) {
      AppLogger.error('Error clearing all local data', e, stackTrace);
      rethrow;
    }
  }

  /// Clear user-specific data
  Future<void> clearUserData(String userId) async {
    try {
      AppLogger.info('Clearing data for user $userId');

      // Clear user profile
      await deleteUserProfile(userId);

      // Clear user's workout plans
      final userPlans = await getCachedWorkoutPlansForUser(userId);
      for (final plan in userPlans) {
        await deleteCachedWorkoutPlan(plan.id);
      }

      // Clear user's workout sessions
      final userSessions = await getOfflineWorkoutSessionsForUser(userId);
      for (final session in userSessions) {
        await deleteOfflineWorkoutSession(session.id);
      }

      // Clear offline manager user-specific caches
      await _offlineManager.clearOfflineCache(
        dataType: 'user_profile',
        userId: userId,
      );
      await _offlineManager.clearOfflineCache(
        dataType: 'workout_plans',
        userId: userId,
      );
      await _offlineManager.clearOfflineCache(
        dataType: 'workout_sessions',
        userId: userId,
      );

      AppLogger.info('Cleared all data for user $userId');
    } catch (e, stackTrace) {
      AppLogger.error('Error clearing data for user $userId', e, stackTrace);
      rethrow;
    }
  }

  // Data Availability Checks

  /// Check if user data is available offline
  Future<bool> isUserDataAvailableOffline(String userId) async {
    try {
      final hasProfile = await _offlineManager.isDataAvailableOffline(
        dataType: 'user_profile',
        userId: userId,
      );
      final hasPlans = await _offlineManager.isDataAvailableOffline(
        dataType: 'workout_plans',
        userId: userId,
      );
      final hasExercises = await _offlineManager.isDataAvailableOffline(
        dataType: 'exercises',
      );

      return hasProfile && hasPlans && hasExercises;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error checking offline data availability for user $userId',
        e,
        stackTrace,
      );
      return false;
    }
  }

  /// Check if exercises are available offline
  Future<bool> areExercisesAvailableOffline() async {
    try {
      return await _offlineManager.isDataAvailableOffline(
        dataType: 'exercises',
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error checking exercise offline availability',
        e,
        stackTrace,
      );
      return false;
    }
  }

  // Private methods

  void _startAutoCleanup() {
    _cleanupTimer = Timer.periodic(_autoCleanupInterval, (_) async {
      if (LocalDatabase.isCacheCleanupNeeded()) {
        await performStorageCleanup();
      }
    });
  }
}
