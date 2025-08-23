import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';

import 'package:fitness_training_app/core/constants/firebase_constants.dart';
import 'package:fitness_training_app/core/utils/logger.dart';
import 'package:fitness_training_app/shared/data/models/offline/offline_models.dart';
import 'package:fitness_training_app/shared/domain/entities/workout_plan.dart';
import 'package:fitness_training_app/shared/domain/entities/workout_session.dart';
import 'package:fitness_training_app/shared/domain/repositories/workout_repository.dart';

/// Firebase implementation of WorkoutRepository with offline caching
class FirebaseWorkoutRepository implements WorkoutRepository {
  final FirebaseFirestore _firestore;
  final Box<CachedWorkoutPlan> _planCache;
  final Box<OfflineWorkoutSession> _sessionCache;
  final Box<SyncQueueItem> _syncQueue;
  final Connectivity _connectivity;

  static const String _planCacheBoxName = 'workout_plans_cache';
  static const String _sessionCacheBoxName = 'workout_sessions_cache';
  static const String _syncQueueBoxName = 'sync_queue';

  FirebaseWorkoutRepository({
    FirebaseFirestore? firestore,
    Box<CachedWorkoutPlan>? planCache,
    Box<OfflineWorkoutSession>? sessionCache,
    Box<SyncQueueItem>? syncQueue,
    Connectivity? connectivity,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _planCache = planCache ?? Hive.box<CachedWorkoutPlan>(_planCacheBoxName),
       _sessionCache =
           sessionCache ??
           Hive.box<OfflineWorkoutSession>(_sessionCacheBoxName),
       _syncQueue = syncQueue ?? Hive.box<SyncQueueItem>(_syncQueueBoxName),
       _connectivity = connectivity ?? Connectivity();

  // Workout Plan methods

  @override
  Future<WorkoutPlan?> getWorkoutPlan(String planId) async {
    try {
      // Check cache first
      final cachedPlan = _planCache.get(planId);
      final isOnline = await _isOnline();

      // If offline, return cached plan
      if (!isOnline && cachedPlan != null) {
        AppLogger.info('Returning workout plan $planId from cache (offline)');
        return cachedPlan.workoutPlan;
      }

      // Try to fetch from Firestore if online
      if (isOnline) {
        final doc =
            await _firestore
                .collection(FirebaseConstants.workoutPlans)
                .doc(planId)
                .get();

        if (doc.exists && doc.data() != null) {
          final plan = WorkoutPlan.fromFirestore(doc.id, doc.data()!);
          await _cacheWorkoutPlan(plan);
          AppLogger.info(
            'Fetched and cached workout plan $planId from Firestore',
          );
          return plan;
        }
      }

      // Return cached plan if available
      if (cachedPlan != null) {
        AppLogger.info('Returning cached workout plan $planId');
        return cachedPlan.workoutPlan;
      }

      AppLogger.warning('Workout plan $planId not found');
      return null;
    } catch (e, stackTrace) {
      AppLogger.error('Error getting workout plan $planId', e, stackTrace);

      // Fallback to cache on error
      final cachedPlan = _planCache.get(planId);
      if (cachedPlan != null) {
        AppLogger.info('Returning cached workout plan $planId due to error');
        return cachedPlan.workoutPlan;
      }

      rethrow;
    }
  }

  @override
  Future<List<WorkoutPlan>> getWorkoutPlansForUser(String userId) async {
    try {
      final isOnline = await _isOnline();

      // Try to fetch from Firestore if online
      if (isOnline) {
        final snapshot =
            await _firestore
                .collection(FirebaseConstants.workoutPlans)
                .where('userId', isEqualTo: userId)
                .orderBy('createdAt', descending: true)
                .get();

        final plans =
            snapshot.docs
                .map((doc) => WorkoutPlan.fromFirestore(doc.id, doc.data()))
                .toList();

        // Cache the plans
        for (final plan in plans) {
          await _cacheWorkoutPlan(plan);
        }

        AppLogger.info(
          'Fetched and cached ${plans.length} workout plans for user $userId from Firestore',
        );
        return plans;
      }

      // Return cached plans if offline
      final cachedPlans =
          _planCache.values
              .where((cached) => cached.userId == userId)
              .map((cached) => cached.workoutPlan)
              .toList();

      AppLogger.info(
        'Returning ${cachedPlans.length} cached workout plans for user $userId',
      );
      return cachedPlans;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error getting workout plans for user $userId',
        e,
        stackTrace,
      );

      // Fallback to cache on error
      final cachedPlans =
          _planCache.values
              .where((cached) => cached.userId == userId)
              .map((cached) => cached.workoutPlan)
              .toList();

      if (cachedPlans.isNotEmpty) {
        AppLogger.info(
          'Returning cached workout plans for user $userId due to error',
        );
        return cachedPlans;
      }

      rethrow;
    }
  }

  @override
  Future<WorkoutPlan> createWorkoutPlan(WorkoutPlan plan) async {
    try {
      // Validate plan data
      final validationErrors = plan.validate();
      if (validationErrors.isNotEmpty) {
        throw ArgumentError(
          'Invalid workout plan: ${validationErrors.join(', ')}',
        );
      }

      final isOnline = await _isOnline();

      if (isOnline) {
        // Create in Firestore
        final docRef = await _firestore
            .collection(FirebaseConstants.workoutPlans)
            .add(plan.toFirestore());

        final createdPlan = plan.copyWith(id: docRef.id);
        await _cacheWorkoutPlan(createdPlan);

        AppLogger.info('Created workout plan ${createdPlan.id} in Firestore');
        return createdPlan;
      } else {
        // Generate temporary ID and queue for sync
        final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
        final planWithId = plan.copyWith(id: tempId);

        final syncItem = SyncQueueItem(
          id: 'create_plan_$tempId',
          operation: SyncOperation.create,
          entityType: 'WorkoutPlan',
          entityId: tempId,
          data: planWithId.toJson(),
          createdAt: DateTime.now(),
          priority: 1, // High priority
          metadata: {'userId': plan.userId ?? '', 'type': 'workoutPlan'},
        );

        await _syncQueue.put(syncItem.id, syncItem);
        await _cacheWorkoutPlan(planWithId);

        AppLogger.info('Queued workout plan $tempId creation for sync');
        return planWithId;
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error creating workout plan', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<WorkoutPlan> updateWorkoutPlan(WorkoutPlan plan) async {
    try {
      // Validate plan data
      final validationErrors = plan.validate();
      if (validationErrors.isNotEmpty) {
        throw ArgumentError(
          'Invalid workout plan: ${validationErrors.join(', ')}',
        );
      }

      final isOnline = await _isOnline();

      if (isOnline) {
        // Update in Firestore
        await _firestore
            .collection(FirebaseConstants.workoutPlans)
            .doc(plan.id)
            .update(plan.toFirestore());

        AppLogger.info('Updated workout plan ${plan.id} in Firestore');
      } else {
        // Queue for sync when online
        final syncItem = SyncQueueItem(
          id: 'update_plan_${plan.id}',
          operation: SyncOperation.update,
          entityType: 'WorkoutPlan',
          entityId: plan.id,
          data: plan.toJson(),
          createdAt: DateTime.now(),
          priority: 1, // High priority
          metadata: {'userId': plan.userId ?? '', 'type': 'workoutPlan'},
        );

        await _syncQueue.put(syncItem.id, syncItem);
        AppLogger.info('Queued workout plan ${plan.id} update for sync');
      }

      // Cache the updated plan
      await _cacheWorkoutPlan(plan);

      return plan;
    } catch (e, stackTrace) {
      AppLogger.error('Error updating workout plan ${plan.id}', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> deleteWorkoutPlan(String planId) async {
    try {
      final isOnline = await _isOnline();

      if (isOnline) {
        // Delete from Firestore
        await _firestore
            .collection(FirebaseConstants.workoutPlans)
            .doc(planId)
            .delete();

        AppLogger.info('Deleted workout plan $planId from Firestore');
      } else {
        // Queue for sync when online
        final syncItem = SyncQueueItem(
          id: 'delete_plan_$planId',
          operation: SyncOperation.delete,
          entityType: 'WorkoutPlan',
          entityId: planId,
          data: {},
          createdAt: DateTime.now(),
          priority: 1, // High priority
          metadata: {'type': 'workoutPlan'},
        );

        await _syncQueue.put(syncItem.id, syncItem);
        AppLogger.info('Queued workout plan $planId deletion for sync');
      }

      // Remove from cache
      await _planCache.delete(planId);
    } catch (e, stackTrace) {
      AppLogger.error('Error deleting workout plan $planId', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<WorkoutPlan?> getActiveWorkoutPlan(String userId) async {
    try {
      final plans = await getWorkoutPlansForUser(userId);
      return plans.where((plan) => plan.isActive == true).firstOrNull;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error getting active workout plan for user $userId',
        e,
        stackTrace,
      );
      return null;
    }
  }

  @override
  Future<void> setActiveWorkoutPlan(String userId, String planId) async {
    try {
      final plan = await getWorkoutPlan(planId);
      if (plan == null) {
        throw Exception('Workout plan $planId not found');
      }

      // Deactivate all other plans for the user
      final userPlans = await getWorkoutPlansForUser(userId);
      for (final userPlan in userPlans) {
        if (userPlan.isActive == true && userPlan.id != planId) {
          await updateWorkoutPlan(userPlan.copyWith(isActive: false));
        }
      }

      // Activate the selected plan
      await updateWorkoutPlan(plan.copyWith(isActive: true));

      AppLogger.info('Set workout plan $planId as active for user $userId');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error setting active workout plan $planId for user $userId',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  // Workout Session methods

  @override
  Future<WorkoutSession?> getWorkoutSession(String sessionId) async {
    try {
      // Check cache first
      final cachedSession = _sessionCache.get(sessionId);
      final isOnline = await _isOnline();

      // If offline, return cached session
      if (!isOnline && cachedSession != null) {
        AppLogger.info(
          'Returning workout session $sessionId from cache (offline)',
        );
        return cachedSession.session;
      }

      // Try to fetch from Firestore if online
      if (isOnline) {
        final doc =
            await _firestore
                .collection(FirebaseConstants.workoutSessions)
                .doc(sessionId)
                .get();

        if (doc.exists && doc.data() != null) {
          final session = WorkoutSession.fromFirestore(doc.id, doc.data()!);
          await _cacheWorkoutSession(session);
          AppLogger.info(
            'Fetched and cached workout session $sessionId from Firestore',
          );
          return session;
        }
      }

      // Return cached session if available
      if (cachedSession != null) {
        AppLogger.info('Returning cached workout session $sessionId');
        return cachedSession.session;
      }

      AppLogger.warning('Workout session $sessionId not found');
      return null;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error getting workout session $sessionId',
        e,
        stackTrace,
      );

      // Fallback to cache on error
      final cachedSession = _sessionCache.get(sessionId);
      if (cachedSession != null) {
        AppLogger.info(
          'Returning cached workout session $sessionId due to error',
        );
        return cachedSession.session;
      }

      rethrow;
    }
  }

  @override
  Future<List<WorkoutSession>> getWorkoutSessionsForUser(
    String userId, {
    int? limit,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final isOnline = await _isOnline();

      // Try to fetch from Firestore if online
      if (isOnline) {
        Query query = _firestore
            .collection(FirebaseConstants.workoutSessions)
            .where('userId', isEqualTo: userId)
            .orderBy('startedAt', descending: true);

        if (startDate != null) {
          query = query.where('startedAt', isGreaterThanOrEqualTo: startDate);
        }

        if (endDate != null) {
          query = query.where('startedAt', isLessThanOrEqualTo: endDate);
        }

        if (limit != null) {
          query = query.limit(limit);
        }

        final snapshot = await query.get();
        final sessions =
            snapshot.docs
                .map(
                  (doc) => WorkoutSession.fromFirestore(
                    doc.id,
                    doc.data() as Map<String, dynamic>,
                  ),
                )
                .toList();

        // Cache the sessions
        for (final session in sessions) {
          await _cacheWorkoutSession(session);
        }

        AppLogger.info(
          'Fetched and cached ${sessions.length} workout sessions for user $userId from Firestore',
        );
        return sessions;
      }

      // Return cached sessions if offline
      var cachedSessions =
          _sessionCache.values
              .where((cached) => cached.userId == userId)
              .map((cached) => cached.session)
              .toList();

      // Apply filters to cached data
      if (startDate != null) {
        cachedSessions =
            cachedSessions
                .where(
                  (session) =>
                      session.startedAt.isAfter(startDate) ||
                      session.startedAt.isAtSameMomentAs(startDate),
                )
                .toList();
      }

      if (endDate != null) {
        cachedSessions =
            cachedSessions
                .where(
                  (session) =>
                      session.startedAt.isBefore(endDate) ||
                      session.startedAt.isAtSameMomentAs(endDate),
                )
                .toList();
      }

      // Sort by start date descending
      cachedSessions.sort((a, b) => b.startedAt.compareTo(a.startedAt));

      if (limit != null && cachedSessions.length > limit) {
        cachedSessions = cachedSessions.take(limit).toList();
      }

      AppLogger.info(
        'Returning ${cachedSessions.length} cached workout sessions for user $userId',
      );
      return cachedSessions;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error getting workout sessions for user $userId',
        e,
        stackTrace,
      );

      // Fallback to cache on error
      final cachedSessions =
          _sessionCache.values
              .where((cached) => cached.userId == userId)
              .map((cached) => cached.session)
              .toList();

      if (cachedSessions.isNotEmpty) {
        AppLogger.info(
          'Returning cached workout sessions for user $userId due to error',
        );
        return cachedSessions;
      }

      rethrow;
    }
  }

  @override
  Future<WorkoutSession> createWorkoutSession(WorkoutSession session) async {
    try {
      // Validate session data
      final validationErrors = session.validate();
      if (validationErrors.isNotEmpty) {
        throw ArgumentError(
          'Invalid workout session: ${validationErrors.join(', ')}',
        );
      }

      final isOnline = await _isOnline();

      if (isOnline) {
        // Create in Firestore
        final docRef = await _firestore
            .collection(FirebaseConstants.workoutSessions)
            .add(session.toFirestore());

        final createdSession = session.copyWith(id: docRef.id);
        await _cacheWorkoutSession(createdSession);

        AppLogger.info(
          'Created workout session ${createdSession.id} in Firestore',
        );
        return createdSession;
      } else {
        // Generate temporary ID and queue for sync
        final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
        final sessionWithId = session.copyWith(id: tempId);

        final syncItem = SyncQueueItem.forWorkoutSession(
          sessionWithId,
          operation: SyncOperation.create,
          priority: 0, // Critical priority for workout sessions
        );

        await _syncQueue.put(syncItem.id, syncItem);
        await _cacheWorkoutSession(sessionWithId);

        AppLogger.info('Queued workout session $tempId creation for sync');
        return sessionWithId;
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error creating workout session', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<WorkoutSession> updateWorkoutSession(WorkoutSession session) async {
    try {
      // Validate session data
      final validationErrors = session.validate();
      if (validationErrors.isNotEmpty) {
        throw ArgumentError(
          'Invalid workout session: ${validationErrors.join(', ')}',
        );
      }

      final isOnline = await _isOnline();

      if (isOnline) {
        // Update in Firestore
        await _firestore
            .collection(FirebaseConstants.workoutSessions)
            .doc(session.id)
            .update(session.toFirestore());

        AppLogger.info('Updated workout session ${session.id} in Firestore');
      } else {
        // Queue for sync when online
        final syncItem = SyncQueueItem.forWorkoutSession(
          session,
          operation: SyncOperation.update,
          priority: 0, // Critical priority for workout sessions
        );

        await _syncQueue.put(syncItem.id, syncItem);
        AppLogger.info('Queued workout session ${session.id} update for sync');
      }

      // Cache the updated session
      await _cacheWorkoutSession(session);

      return session;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error updating workout session ${session.id}',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<void> deleteWorkoutSession(String sessionId) async {
    try {
      final isOnline = await _isOnline();

      if (isOnline) {
        // Delete from Firestore
        await _firestore
            .collection(FirebaseConstants.workoutSessions)
            .doc(sessionId)
            .delete();

        AppLogger.info('Deleted workout session $sessionId from Firestore');
      } else {
        // Queue for sync when online
        final syncItem = SyncQueueItem(
          id: 'delete_session_$sessionId',
          operation: SyncOperation.delete,
          entityType: 'WorkoutSession',
          entityId: sessionId,
          data: {},
          createdAt: DateTime.now(),
          priority: 1, // High priority
          metadata: {'type': 'workoutSession'},
        );

        await _syncQueue.put(syncItem.id, syncItem);
        AppLogger.info('Queued workout session $sessionId deletion for sync');
      }

      // Remove from cache
      await _sessionCache.delete(sessionId);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error deleting workout session $sessionId',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<WorkoutSession?> getActiveWorkoutSession(String userId) async {
    try {
      final sessions = await getWorkoutSessionsForUser(userId, limit: 10);
      return sessions.where((session) => session.isActive).firstOrNull;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error getting active workout session for user $userId',
        e,
        stackTrace,
      );
      return null;
    }
  }

  @override
  Future<WorkoutSession> completeWorkoutSession(
    String sessionId,
    Map<String, dynamic> completionData,
  ) async {
    try {
      final session = await getWorkoutSession(sessionId);
      if (session == null) {
        throw Exception('Workout session $sessionId not found');
      }

      final completedSession = session.copyWith(
        status: SessionStatus.completed,
        completedAt: DateTime.now(),
        totalDurationSeconds: completionData['totalDurationSeconds'],
        completionPercentage: completionData['completionPercentage'],
        totalCaloriesBurned: completionData['totalCaloriesBurned'],
        aiEvaluation: completionData['aiEvaluation'],
        userNotes: completionData['userNotes'],
        sessionData: completionData,
      );

      return await updateWorkoutSession(completedSession);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error completing workout session $sessionId',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<WorkoutSession> abandonWorkoutSession(
    String sessionId,
    String reason,
  ) async {
    try {
      final session = await getWorkoutSession(sessionId);
      if (session == null) {
        throw Exception('Workout session $sessionId not found');
      }

      final abandonedSession = session.copyWith(
        status: SessionStatus.abandoned,
        completedAt: DateTime.now(),
        userNotes: reason,
        sessionData: {'abandonReason': reason},
      );

      return await updateWorkoutSession(abandonedSession);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error abandoning workout session $sessionId',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  // Statistics and Analytics methods

  @override
  Future<Map<String, dynamic>> getUserWorkoutStats(String userId) async {
    try {
      final sessions = await getWorkoutSessionsForUser(userId);

      final completedSessions = sessions.where((s) => s.isCompleted).toList();
      final totalSessions = sessions.length;
      final completionRate =
          totalSessions > 0
              ? (completedSessions.length / totalSessions) * 100
              : 0.0;

      final totalWorkoutTime = completedSessions.fold<int>(
        0,
        (sum, session) => sum + (session.totalDurationSeconds ?? 0),
      );

      final totalCalories = completedSessions.fold<int>(
        0,
        (sum, session) => sum + (session.totalCaloriesBurned ?? 0),
      );

      return {
        'totalSessions': totalSessions,
        'completedSessions': completedSessions.length,
        'completionRate': completionRate,
        'totalWorkoutTimeSeconds': totalWorkoutTime,
        'totalCaloriesBurned': totalCalories,
        'averageSessionDuration':
            completedSessions.isNotEmpty
                ? totalWorkoutTime / completedSessions.length
                : 0,
        'lastWorkoutDate':
            sessions.isNotEmpty
                ? sessions.first.startedAt.toIso8601String()
                : null,
      };
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error getting workout stats for user $userId',
        e,
        stackTrace,
      );
      return {};
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getUserProgressData(
    String userId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final sessions = await getWorkoutSessionsForUser(
        userId,
        startDate: startDate,
        endDate: endDate,
      );

      return sessions
          .map(
            (session) => {
              'date': session.startedAt.toIso8601String(),
              'completed': session.isCompleted,
              'completionPercentage': session.actualCompletionPercentage,
              'duration': session.sessionDurationMinutes,
              'caloriesBurned': session.totalCaloriesBurned ?? 0,
              'exercisesCompleted': session.completedExercisesCount,
              'totalExercises': session.totalExercisesCount,
            },
          )
          .toList();
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error getting progress data for user $userId',
        e,
        stackTrace,
      );
      return [];
    }
  }

  @override
  Future<double> getWorkoutCompletionRate(String userId) async {
    try {
      final stats = await getUserWorkoutStats(userId);
      return stats['completionRate'] ?? 0.0;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error getting completion rate for user $userId',
        e,
        stackTrace,
      );
      return 0.0;
    }
  }

  // Streaming methods

  @override
  Stream<List<WorkoutPlan>> watchWorkoutPlansForUser(String userId) {
    return _firestore
        .collection(FirebaseConstants.workoutPlans)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          final plans =
              snapshot.docs
                  .map((doc) => WorkoutPlan.fromFirestore(doc.id, doc.data()))
                  .toList();

          // Cache the plans asynchronously
          for (final plan in plans) {
            _cacheWorkoutPlan(plan);
          }

          return plans;
        })
        .handleError((error, stackTrace) {
          AppLogger.error(
            'Error watching workout plans for user $userId',
            error,
            stackTrace,
          );
          // Return cached plans on error
          final cachedPlans =
              _planCache.values
                  .where((cached) => cached.userId == userId)
                  .map((cached) => cached.workoutPlan)
                  .toList();
          return Stream.value(cachedPlans);
        });
  }

  @override
  Stream<List<WorkoutSession>> watchWorkoutSessionsForUser(String userId) {
    return _firestore
        .collection(FirebaseConstants.workoutSessions)
        .where('userId', isEqualTo: userId)
        .orderBy('startedAt', descending: true)
        .snapshots()
        .map((snapshot) {
          final sessions =
              snapshot.docs
                  .map(
                    (doc) => WorkoutSession.fromFirestore(doc.id, doc.data()),
                  )
                  .toList();

          // Cache the sessions asynchronously
          for (final session in sessions) {
            _cacheWorkoutSession(session);
          }

          return sessions;
        })
        .handleError((error, stackTrace) {
          AppLogger.error(
            'Error watching workout sessions for user $userId',
            error,
            stackTrace,
          );
          // Return cached sessions on error
          final cachedSessions =
              _sessionCache.values
                  .where((cached) => cached.userId == userId)
                  .map((cached) => cached.session)
                  .toList();
          return Stream.value(cachedSessions);
        });
  }

  @override
  Stream<WorkoutSession?> watchActiveWorkoutSession(String userId) {
    return _firestore
        .collection(FirebaseConstants.workoutSessions)
        .where('userId', isEqualTo: userId)
        .where(
          'status',
          whereIn: [SessionStatus.inProgress.name, SessionStatus.paused.name],
        )
        .orderBy('startedAt', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isNotEmpty) {
            final session = WorkoutSession.fromFirestore(
              snapshot.docs.first.id,
              snapshot.docs.first.data(),
            );
            // Cache the session asynchronously
            _cacheWorkoutSession(session);
            return session;
          }
          return null;
        })
        .handleError((error, stackTrace) {
          AppLogger.error(
            'Error watching active workout session for user $userId',
            error,
            stackTrace,
          );
          // Return cached active session on error
          final cachedSessions =
              _sessionCache.values
                  .where(
                    (cached) =>
                        cached.userId == userId && cached.session.isActive,
                  )
                  .map((cached) => cached.session)
                  .toList();
          return Stream.value(
            cachedSessions.isNotEmpty ? cachedSessions.first : null,
          );
        });
  }

  // Offline support methods

  @override
  Future<bool> isAvailableOffline(String userId) async {
    final hasPlans = _planCache.values.any((cached) => cached.userId == userId);
    final hasSessions = _sessionCache.values.any(
      (cached) => cached.userId == userId,
    );
    return hasPlans || hasSessions;
  }

  @override
  Future<void> refreshFromRemote(String userId) async {
    if (!await _isOnline()) {
      throw Exception('Cannot refresh from remote while offline');
    }

    try {
      // Refresh workout plans
      final plansSnapshot =
          await _firestore
              .collection(FirebaseConstants.workoutPlans)
              .where('userId', isEqualTo: userId)
              .get();

      for (final doc in plansSnapshot.docs) {
        final plan = WorkoutPlan.fromFirestore(doc.id, doc.data());
        await _cacheWorkoutPlan(plan);
      }

      // Refresh workout sessions
      final sessionsSnapshot =
          await _firestore
              .collection(FirebaseConstants.workoutSessions)
              .where('userId', isEqualTo: userId)
              .get();

      for (final doc in sessionsSnapshot.docs) {
        final session = WorkoutSession.fromFirestore(doc.id, doc.data());
        await _cacheWorkoutSession(session);
      }

      AppLogger.info(
        'Successfully refreshed workout data for user $userId from remote',
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error refreshing workout data for user $userId from remote',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getCacheStatus(String userId) async {
    final userPlans =
        _planCache.values.where((cached) => cached.userId == userId).length;
    final userSessions =
        _sessionCache.values.where((cached) => cached.userId == userId).length;
    final pendingSyncItems =
        _syncQueue.values
            .where((item) => item.metadata['userId'] == userId)
            .length;

    return {
      'cachedPlans': userPlans,
      'cachedSessions': userSessions,
      'pendingSyncItems': pendingSyncItems,
      'isOnline': await _isOnline(),
    };
  }

  @override
  Future<List<Map<String, dynamic>>> getPendingSyncOperations(
    String userId,
  ) async {
    final pendingItems =
        _syncQueue.values
            .where((item) => item.metadata['userId'] == userId)
            .toList();

    return pendingItems
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
          },
        )
        .toList();
  }

  // Private helper methods

  Future<void> _cacheWorkoutPlan(WorkoutPlan plan) async {
    final cachedPlan = CachedWorkoutPlan.fromWorkoutPlan(
      plan,
      userId: plan.userId ?? '',
    );
    await _planCache.put(plan.id, cachedPlan);
  }

  Future<void> _cacheWorkoutSession(WorkoutSession session) async {
    final cachedSession = OfflineWorkoutSession.fromSession(
      session,
      userId: session.userId,
    );
    await _sessionCache.put(session.id, cachedSession);
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
