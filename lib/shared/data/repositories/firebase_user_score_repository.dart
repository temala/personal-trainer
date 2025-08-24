import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_training_app/core/constants/firebase_constants.dart';
import 'package:fitness_training_app/core/utils/logger.dart';
import 'package:fitness_training_app/shared/data/services/offline_manager.dart';
import 'package:fitness_training_app/shared/domain/entities/user_score.dart';
import 'package:fitness_training_app/shared/domain/repositories/user_score_repository.dart';

/// Firebase implementation of UserScoreRepository
class FirebaseUserScoreRepository implements UserScoreRepository {
  final FirebaseFirestore _firestore;
  final OfflineManager _offlineManager;

  FirebaseUserScoreRepository({
    required FirebaseFirestore firestore,
    required OfflineManager offlineManager,
  }) : _firestore = firestore,
       _offlineManager = offlineManager;

  CollectionReference get _collection =>
      _firestore.collection(FirebaseCollections.userScores);

  @override
  Future<UserScore?> getUserScore(String userId) async {
    try {
      AppLogger.info('Fetching user score for user: $userId');

      // Try offline first
      if (!_offlineManager.isOnline) {
        final cachedScore = await _offlineManager.getCachedUserScore(userId);
        if (cachedScore != null) {
          AppLogger.info('Returning cached user score for user: $userId');
          return UserScoreHelper.fromFirestore(userId, cachedScore);
        }
      }

      final doc = await _collection.doc(userId).get();

      if (!doc.exists) {
        AppLogger.info('No user score found for user: $userId');
        return null;
      }

      final data = doc.data()! as Map<String, dynamic>;
      final userScore = UserScoreHelper.fromFirestore(doc.id, data);

      // Cache for offline use
      await _offlineManager.cacheUserScore(userScore.toFirestore());

      AppLogger.info('Successfully fetched user score for user: $userId');
      return userScore;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error fetching user score for user: $userId',
        e,
        stackTrace,
      );

      // Try to return cached data on error
      final cachedScore = await _offlineManager.getCachedUserScore(userId);
      if (cachedScore != null) {
        AppLogger.info(
          'Returning cached user score due to error for user: $userId',
        );
        return UserScoreHelper.fromFirestore(userId, cachedScore);
      }

      rethrow;
    }
  }

  @override
  Future<void> saveUserScore(UserScore userScore) async {
    try {
      AppLogger.info('Saving user score for user: ${userScore.userId}');

      final data = userScore.toFirestore();

      if (_offlineManager.isOnline) {
        await _collection
            .doc(userScore.userId)
            .set(data, SetOptions(merge: true));
        AppLogger.info(
          'Successfully saved user score to Firestore for user: ${userScore.userId}',
        );
      } else {
        // Queue for offline sync
        await _offlineManager.queueUserScoreUpdate(userScore.userId, data);
        AppLogger.info(
          'Queued user score update for offline sync: ${userScore.userId}',
        );
      }

      // Always cache locally
      await _offlineManager.cacheUserScore(data);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error saving user score for user: ${userScore.userId}',
        e,
        stackTrace,
      );

      // Cache locally and queue for sync even on error
      await _offlineManager.cacheUserScore(userScore.toFirestore());
      await _offlineManager.queueUserScoreUpdate(
        userScore.userId,
        userScore.toFirestore(),
      );

      rethrow;
    }
  }

  @override
  Future<void> updateUserScore(
    String userId,
    Map<String, dynamic> updates,
  ) async {
    try {
      AppLogger.info('Updating user score for user: $userId');

      // Add timestamp
      updates['lastUpdated'] = FieldValue.serverTimestamp();

      if (_offlineManager.isOnline) {
        await _collection.doc(userId).update(updates);
        AppLogger.info(
          'Successfully updated user score in Firestore for user: $userId',
        );
      } else {
        // Queue for offline sync
        await _offlineManager.queueUserScoreUpdate(userId, updates);
        AppLogger.info('Queued user score update for offline sync: $userId');
      }

      // Update local cache
      await _offlineManager.updateCachedUserScore(userId, updates);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error updating user score for user: $userId',
        e,
        stackTrace,
      );

      // Queue for sync even on error
      await _offlineManager.queueUserScoreUpdate(userId, updates);
      await _offlineManager.updateCachedUserScore(userId, updates);

      rethrow;
    }
  }

  @override
  Future<void> deleteUserScore(String userId) async {
    try {
      AppLogger.info('Deleting user score for user: $userId');

      if (_offlineManager.isOnline) {
        await _collection.doc(userId).delete();
        AppLogger.info(
          'Successfully deleted user score from Firestore for user: $userId',
        );
      } else {
        // Queue deletion for offline sync
        await _offlineManager.queueUserScoreDeletion(userId);
        AppLogger.info('Queued user score deletion for offline sync: $userId');
      }

      // Remove from local cache
      await _offlineManager.removeCachedUserScore(userId);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error deleting user score for user: $userId',
        e,
        stackTrace,
      );

      // Queue for sync even on error
      await _offlineManager.queueUserScoreDeletion(userId);
      await _offlineManager.removeCachedUserScore(userId);

      rethrow;
    }
  }

  @override
  Future<List<UserScore>> getTopScores({int limit = 10}) async {
    try {
      AppLogger.info('Fetching top $limit user scores');

      // This requires online connection for leaderboard
      if (!_offlineManager.isOnline) {
        AppLogger.warning('Cannot fetch leaderboard while offline');
        return [];
      }

      final query =
          await _collection
              .orderBy('totalScore', descending: true)
              .limit(limit)
              .get();

      final scores =
          query.docs.map((doc) {
            final data = doc.data()! as Map<String, dynamic>;
            return UserScoreHelper.fromFirestore(doc.id, data);
          }).toList();

      AppLogger.info('Successfully fetched ${scores.length} top scores');
      return scores;
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching top scores', e, stackTrace);
      return [];
    }
  }

  @override
  Future<int> getUserRank(String userId) async {
    try {
      AppLogger.info('Calculating rank for user: $userId');

      // This requires online connection
      if (!_offlineManager.isOnline) {
        AppLogger.warning('Cannot calculate rank while offline');
        return 0;
      }

      // Get user's score first
      final userScore = await getUserScore(userId);
      if (userScore == null) {
        AppLogger.warning('User score not found for rank calculation: $userId');
        return 0;
      }

      // Count users with higher scores
      final higherScoresQuery =
          await _collection
              .where('totalScore', isGreaterThan: userScore.totalScore)
              .count()
              .get();

      final rank = higherScoresQuery.count! + 1;

      AppLogger.info('User $userId rank: $rank');
      return rank;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error calculating user rank for user: $userId',
        e,
        stackTrace,
      );
      return 0;
    }
  }

  @override
  Future<List<UserScore>> getSimilarScores(
    String userId, {
    int limit = 5,
  }) async {
    try {
      AppLogger.info('Fetching similar scores for user: $userId');

      // This requires online connection
      if (!_offlineManager.isOnline) {
        AppLogger.warning('Cannot fetch similar scores while offline');
        return [];
      }

      // Get user's score first
      final userScore = await getUserScore(userId);
      if (userScore == null) {
        AppLogger.warning('User score not found for similar scores: $userId');
        return [];
      }

      // Define score range (±10% of user's score)
      final scoreRange = (userScore.totalScore * 0.1).round();
      final minScore = userScore.totalScore - scoreRange;
      final maxScore = userScore.totalScore + scoreRange;

      final query =
          await _collection
              .where('totalScore', isGreaterThanOrEqualTo: minScore)
              .where('totalScore', isLessThanOrEqualTo: maxScore)
              .where(FieldPath.documentId, isNotEqualTo: userId)
              .limit(limit)
              .get();

      final scores =
          query.docs.map((doc) {
            final data = doc.data()! as Map<String, dynamic>;
            return UserScoreHelper.fromFirestore(doc.id, data);
          }).toList();

      AppLogger.info(
        'Successfully fetched ${scores.length} similar scores for user: $userId',
      );
      return scores;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error fetching similar scores for user: $userId',
        e,
        stackTrace,
      );
      return [];
    }
  }

  @override
  Stream<UserScore?> watchUserScore(String userId) {
    AppLogger.info('Starting to watch user score for user: $userId');

    return _collection
        .doc(userId)
        .snapshots()
        .map((doc) {
          if (!doc.exists) {
            return null;
          }

          final data = doc.data()! as Map<String, dynamic>;
          final userScore = UserScoreHelper.fromFirestore(doc.id, data);

          // Cache the updated score
          _offlineManager.cacheUserScore(userScore.toFirestore());

          return userScore;
        })
        .handleError((Object error, StackTrace stackTrace) {
          AppLogger.error(
            'Error watching user score for user: $userId',
            error,
            stackTrace,
          );
        });
  }

  @override
  Future<void> batchUpdateScores(
    Map<String, Map<String, dynamic>> updates,
  ) async {
    try {
      AppLogger.info(
        'Performing batch update for ${updates.length} user scores',
      );

      if (!_offlineManager.isOnline) {
        // Queue all updates for offline sync
        for (final entry in updates.entries) {
          await _offlineManager.queueUserScoreUpdate(entry.key, entry.value);
        }
        AppLogger.info(
          'Queued ${updates.length} score updates for offline sync',
        );
        return;
      }

      final batch = _firestore.batch();

      for (final entry in updates.entries) {
        final userId = entry.key;
        final updateData = entry.value;
        updateData['lastUpdated'] = FieldValue.serverTimestamp();

        batch.update(_collection.doc(userId), updateData);
      }

      await batch.commit();
      AppLogger.info(
        'Successfully completed batch update for ${updates.length} user scores',
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error performing batch score updates', e, stackTrace);

      // Queue all updates for offline sync on error
      for (final entry in updates.entries) {
        await _offlineManager.queueUserScoreUpdate(entry.key, entry.value);
      }

      rethrow;
    }
  }

  @override
  Future<Map<String, int>> getAchievementStatistics() async {
    try {
      AppLogger.info('Fetching achievement statistics');

      // This requires online connection
      if (!_offlineManager.isOnline) {
        AppLogger.warning('Cannot fetch achievement statistics while offline');
        return {};
      }

      // This would require aggregation queries or cloud functions
      // For now, return empty map as this is a complex query
      AppLogger.warning('Achievement statistics not implemented yet');
      return {};
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching achievement statistics', e, stackTrace);
      return {};
    }
  }

  @override
  Future<List<UserScore>> getUsersWithAchievement(String achievementId) async {
    try {
      AppLogger.info('Fetching users with achievement: $achievementId');

      // This requires online connection
      if (!_offlineManager.isOnline) {
        AppLogger.warning('Cannot fetch users with achievement while offline');
        return [];
      }

      final query =
          await _collection
              .where(
                'achievements',
                arrayContainsAny: [
                  {'id': achievementId},
                ],
              )
              .get();

      final scores =
          query.docs.map((doc) {
            final data = doc.data()! as Map<String, dynamic>;
            return UserScoreHelper.fromFirestore(doc.id, data);
          }).toList();

      AppLogger.info(
        'Found ${scores.length} users with achievement: $achievementId',
      );
      return scores;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error fetching users with achievement: $achievementId',
        e,
        stackTrace,
      );
      return [];
    }
  }

  @override
  Future<void> updatePeriodicScores(
    String userId, {
    int? weeklyScore,
    int? monthlyScore,
  }) async {
    try {
      AppLogger.info('Updating periodic scores for user: $userId');

      final updates = <String, dynamic>{
        'lastUpdated': FieldValue.serverTimestamp(),
      };

      if (weeklyScore != null) {
        updates['weeklyScore'] = weeklyScore;
      }

      if (monthlyScore != null) {
        updates['monthlyScore'] = monthlyScore;
      }

      await updateUserScore(userId, updates);
      AppLogger.info('Successfully updated periodic scores for user: $userId');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error updating periodic scores for user: $userId',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<void> resetUserScore(String userId) async {
    try {
      AppLogger.info('Resetting user score for user: $userId');

      final initialScore = UserScoreHelper.createInitial(userId: userId);
      await saveUserScore(initialScore.copyWith(id: userId));

      AppLogger.info('Successfully reset user score for user: $userId');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error resetting user score for user: $userId',
        e,
        stackTrace,
      );
      rethrow;
    }
  }
}
