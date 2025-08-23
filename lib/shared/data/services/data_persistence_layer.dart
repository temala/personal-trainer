import 'dart:async';

import 'package:fitness_training_app/core/utils/logger.dart';
import 'package:fitness_training_app/shared/data/repositories/firebase_exercise_repository.dart';
import 'package:fitness_training_app/shared/data/repositories/firebase_user_repository.dart';
import 'package:fitness_training_app/shared/data/repositories/firebase_workout_repository.dart';
import 'package:fitness_training_app/shared/data/services/local_storage_service.dart';
import 'package:fitness_training_app/shared/data/services/offline_manager.dart';
import 'package:fitness_training_app/shared/data/services/sync_manager.dart';
import 'package:fitness_training_app/shared/domain/entities/entities.dart';
import 'package:fitness_training_app/shared/domain/repositories/exercise_repository.dart';
import 'package:fitness_training_app/shared/domain/repositories/user_repository.dart';
import 'package:fitness_training_app/shared/domain/repositories/workout_repository.dart';

/// Unified data persistence layer that coordinates between Firebase and local storage
class DataPersistenceLayer {
  final ExerciseRepository _exerciseRepository;
  final UserRepository _userRepository;
  final WorkoutRepository _workoutRepository;
  final LocalStorageService _localStorageService;
  final OfflineManager _offlineManager;
  final SyncManager _syncManager;

  DataPersistenceLayer({
    ExerciseRepository? exerciseRepository,
    UserRepository? userRepository,
    WorkoutRepository? workoutRepository,
    LocalStorageService? localStorageService,
    OfflineManager? offlineManager,
    SyncManager? syncManager,
  }) : _exerciseRepository = exerciseRepository ?? FirebaseExerciseRepository(),
       _userRepository = userRepository ?? FirebaseUserRepository(),
       _workoutRepository = workoutRepository ?? FirebaseWorkoutRepository(),
       _localStorageService = localStorageService ?? LocalStorageService(),
       _offlineManager = offlineManager ?? OfflineManager(),
       _syncManager = syncManager ?? SyncManager();

  /// Initialize the data persistence layer
  Future<void> initialize() async {
    try {
      AppLogger.info('Initializing DataPersistenceLayer...');

      // Initialize local storage service (which initializes offline manager and sync manager)
      await _localStorageService.initialize();

      AppLogger.info('DataPersistenceLayer initialized successfully');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to initialize DataPersistenceLayer',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  /// Dispose resources
  Future<void> dispose() async {
    try {
      await _localStorageService.dispose();
      AppLogger.info('DataPersistenceLayer disposed');
    } catch (e, stackTrace) {
      AppLogger.error('Error disposing DataPersistenceLayer', e, stackTrace);
    }
  }

  // Exercise Operations

  /// Get all exercises with offline fallback
  Future<List<Exercise>> getAllExercises() async {
    try {
      if (_offlineManager.isOnline) {
        // Try to get from Firebase first
        final exercises = await _exerciseRepository.getAllExercises();

        // Cache exercises for offline use
        await _localStorageService.preloadExercises(exercises);

        return exercises;
      } else {
        // Get from local cache when offline
        return await _localStorageService.getAllCachedExercises();
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error getting all exercises', e, stackTrace);

      // Fallback to cached exercises on error
      return await _localStorageService.getAllCachedExercises();
    }
  }

  /// Get exercise by ID with offline fallback
  Future<Exercise?> getExerciseById(String id) async {
    try {
      if (_offlineManager.isOnline) {
        // Try to get from Firebase first
        final exercise = await _exerciseRepository.getExerciseById(id);

        // Cache exercise for offline use
        if (exercise != null) {
          await _localStorageService.storeCachedExercise(exercise);
        }

        return exercise;
      } else {
        // Get from local cache when offline
        return await _localStorageService.getCachedExercise(id);
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error getting exercise $id', e, stackTrace);

      // Fallback to cached exercise on error
      return await _localStorageService.getCachedExercise(id);
    }
  }

  /// Get exercises by category with offline fallback
  Future<List<Exercise>> getExercisesByCategory(
    ExerciseCategory category,
  ) async {
    try {
      if (_offlineManager.isOnline) {
        return await _exerciseRepository.getExercisesByCategory(category);
      } else {
        final allExercises = await _localStorageService.getAllCachedExercises();
        return allExercises
            .where((exercise) => exercise.category == category)
            .toList();
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error getting exercises by category ${category.name}',
        e,
        stackTrace,
      );

      // Fallback to cached exercises
      final allExercises = await _localStorageService.getAllCachedExercises();
      return allExercises
          .where((exercise) => exercise.category == category)
          .toList();
    }
  }

  /// Get alternative exercises with offline fallback
  Future<List<Exercise>> getAlternativeExercises(String exerciseId) async {
    try {
      if (_offlineManager.isOnline) {
        return await _exerciseRepository.getAlternativeExercises(exerciseId);
      } else {
        // Get alternatives from cached data
        final exercise = await _localStorageService.getCachedExercise(
          exerciseId,
        );
        if (exercise?.alternativeExerciseIds != null) {
          final alternatives = <Exercise>[];
          for (final altId in exercise!.alternativeExerciseIds!) {
            final altExercise = await _localStorageService.getCachedExercise(
              altId,
            );
            if (altExercise != null) {
              alternatives.add(altExercise);
            }
          }
          return alternatives;
        }
        return [];
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error getting alternative exercises for $exerciseId',
        e,
        stackTrace,
      );
      return [];
    }
  }

  /// Search exercises with offline fallback
  Future<List<Exercise>> searchExercises(String query) async {
    try {
      if (_offlineManager.isOnline) {
        return await _exerciseRepository.searchExercises(query);
      } else {
        final allExercises = await _localStorageService.getAllCachedExercises();
        final lowercaseQuery = query.toLowerCase();

        return allExercises.where((exercise) {
          return exercise.name.toLowerCase().contains(lowercaseQuery) ||
              exercise.description.toLowerCase().contains(lowercaseQuery) ||
              exercise.instructions.any(
                (instruction) =>
                    instruction.toLowerCase().contains(lowercaseQuery),
              );
        }).toList();
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error searching exercises with query "$query"',
        e,
        stackTrace,
      );
      return [];
    }
  }

  // User Profile Operations

  /// Get user profile with offline fallback
  Future<UserProfile?> getUserProfile(String userId) async {
    try {
      if (_offlineManager.isOnline) {
        // Try to get from Firebase first
        final profile = await _userRepository.getUserProfile(userId);

        // Cache profile for offline use
        if (profile != null) {
          await _localStorageService.storeUserProfile(profile);
        }

        return profile;
      } else {
        // Get from local cache when offline
        return await _localStorageService.getUserProfile(userId);
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error getting user profile $userId', e, stackTrace);

      // Fallback to cached profile on error
      return await _localStorageService.getUserProfile(userId);
    }
  }

  /// Create user profile with offline support
  Future<UserProfile> createUserProfile(UserProfile profile) async {
    try {
      if (_offlineManager.isOnline) {
        // Create in Firebase
        final createdProfile = await _userRepository.createUserProfile(profile);

        // Cache the created profile
        await _localStorageService.storeUserProfile(createdProfile);

        return createdProfile;
      } else {
        // Store locally and queue for sync
        await _localStorageService.storeUserProfile(profile);
        return profile;
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error creating user profile ${profile.id}',
        e,
        stackTrace,
      );

      // Store locally as fallback
      await _localStorageService.storeUserProfile(profile);
      return profile;
    }
  }

  /// Update user profile with offline support
  Future<UserProfile> updateUserProfile(UserProfile profile) async {
    try {
      if (_offlineManager.isOnline) {
        // Update in Firebase
        final updatedProfile = await _userRepository.updateUserProfile(profile);

        // Cache the updated profile
        await _localStorageService.storeUserProfile(updatedProfile);

        return updatedProfile;
      } else {
        // Store locally and queue for sync
        await _localStorageService.storeUserProfile(profile);
        return profile;
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error updating user profile ${profile.id}',
        e,
        stackTrace,
      );

      // Store locally as fallback
      await _localStorageService.storeUserProfile(profile);
      return profile;
    }
  }

  /// Delete user profile with offline support
  Future<void> deleteUserProfile(String userId) async {
    try {
      if (_offlineManager.isOnline) {
        // Delete from Firebase
        await _userRepository.deleteUserProfile(userId);
      }

      // Always delete from local storage
      await _localStorageService.deleteUserProfile(userId);
    } catch (e, stackTrace) {
      AppLogger.error('Error deleting user profile $userId', e, stackTrace);
      rethrow;
    }
  }

  // Workout Plan Operations

  /// Get workout plan with offline fallback
  Future<WorkoutPlan?> getWorkoutPlan(String planId) async {
    try {
      if (_offlineManager.isOnline) {
        // Try to get from Firebase first
        final plan = await _workoutRepository.getWorkoutPlan(planId);

        // Cache plan for offline use
        if (plan != null) {
          await _localStorageService.storeCachedWorkoutPlan(
            plan,
            plan.userId ?? '',
          );
        }

        return plan;
      } else {
        // Get from local cache when offline
        return await _localStorageService.getCachedWorkoutPlan(planId);
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error getting workout plan $planId', e, stackTrace);

      // Fallback to cached plan on error
      return await _localStorageService.getCachedWorkoutPlan(planId);
    }
  }

  /// Get workout plans for user with offline fallback
  Future<List<WorkoutPlan>> getWorkoutPlansForUser(String userId) async {
    try {
      if (_offlineManager.isOnline) {
        // Try to get from Firebase first
        final plans = await _workoutRepository.getWorkoutPlansForUser(userId);

        // Cache plans for offline use
        for (final plan in plans) {
          await _localStorageService.storeCachedWorkoutPlan(plan, userId);
        }

        return plans;
      } else {
        // Get from local cache when offline
        return await _localStorageService.getCachedWorkoutPlansForUser(userId);
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error getting workout plans for user $userId',
        e,
        stackTrace,
      );

      // Fallback to cached plans on error
      return await _localStorageService.getCachedWorkoutPlansForUser(userId);
    }
  }

  /// Create workout plan with offline support
  Future<WorkoutPlan> createWorkoutPlan(WorkoutPlan plan) async {
    try {
      if (_offlineManager.isOnline) {
        // Create in Firebase
        final createdPlan = await _workoutRepository.createWorkoutPlan(plan);

        // Cache the created plan
        await _localStorageService.storeCachedWorkoutPlan(
          createdPlan,
          plan.userId ?? '',
        );

        return createdPlan;
      } else {
        // Store locally and queue for sync
        await _localStorageService.storeCachedWorkoutPlan(
          plan,
          plan.userId ?? '',
        );
        return plan;
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error creating workout plan ${plan.id}', e, stackTrace);

      // Store locally as fallback
      await _localStorageService.storeCachedWorkoutPlan(
        plan,
        plan.userId ?? '',
      );
      return plan;
    }
  }

  /// Update workout plan with offline support
  Future<WorkoutPlan> updateWorkoutPlan(WorkoutPlan plan) async {
    try {
      if (_offlineManager.isOnline) {
        // Update in Firebase
        final updatedPlan = await _workoutRepository.updateWorkoutPlan(plan);

        // Cache the updated plan
        await _localStorageService.storeCachedWorkoutPlan(
          updatedPlan,
          plan.userId ?? '',
        );

        return updatedPlan;
      } else {
        // Store locally and queue for sync
        await _localStorageService.storeCachedWorkoutPlan(
          plan,
          plan.userId ?? '',
        );
        return plan;
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error updating workout plan ${plan.id}', e, stackTrace);

      // Store locally as fallback
      await _localStorageService.storeCachedWorkoutPlan(
        plan,
        plan.userId ?? '',
      );
      return plan;
    }
  }

  /// Delete workout plan with offline support
  Future<void> deleteWorkoutPlan(String planId) async {
    try {
      if (_offlineManager.isOnline) {
        // Delete from Firebase
        await _workoutRepository.deleteWorkoutPlan(planId);
      }

      // Always delete from local storage
      await _localStorageService.deleteCachedWorkoutPlan(planId);
    } catch (e, stackTrace) {
      AppLogger.error('Error deleting workout plan $planId', e, stackTrace);
      rethrow;
    }
  }

  // Workout Session Operations

  /// Get workout session with offline fallback
  Future<WorkoutSession?> getWorkoutSession(String sessionId) async {
    try {
      if (_offlineManager.isOnline) {
        // Try to get from Firebase first
        final session = await _workoutRepository.getWorkoutSession(sessionId);

        // Cache session for offline use
        if (session != null) {
          await _localStorageService.storeOfflineWorkoutSession(session);
        }

        return session;
      } else {
        // Get from local cache when offline
        return await _localStorageService.getOfflineWorkoutSession(sessionId);
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error getting workout session $sessionId',
        e,
        stackTrace,
      );

      // Fallback to cached session on error
      return await _localStorageService.getOfflineWorkoutSession(sessionId);
    }
  }

  /// Get workout sessions for user with offline fallback
  Future<List<WorkoutSession>> getWorkoutSessionsForUser(
    String userId, {
    int? limit,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      if (_offlineManager.isOnline) {
        // Try to get from Firebase first
        final sessions = await _workoutRepository.getWorkoutSessionsForUser(
          userId,
          limit: limit,
          startDate: startDate,
          endDate: endDate,
        );

        // Cache sessions for offline use
        for (final session in sessions) {
          await _localStorageService.storeOfflineWorkoutSession(session);
        }

        return sessions;
      } else {
        // Get from local cache when offline
        var sessions = await _localStorageService
            .getOfflineWorkoutSessionsForUser(userId);

        // Apply filters to cached data
        if (startDate != null) {
          sessions =
              sessions
                  .where(
                    (session) =>
                        session.startedAt.isAfter(startDate) ||
                        session.startedAt.isAtSameMomentAs(startDate),
                  )
                  .toList();
        }

        if (endDate != null) {
          sessions =
              sessions
                  .where(
                    (session) =>
                        session.startedAt.isBefore(endDate) ||
                        session.startedAt.isAtSameMomentAs(endDate),
                  )
                  .toList();
        }

        if (limit != null && sessions.length > limit) {
          sessions = sessions.take(limit).toList();
        }

        return sessions;
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error getting workout sessions for user $userId',
        e,
        stackTrace,
      );

      // Fallback to cached sessions on error
      return await _localStorageService.getOfflineWorkoutSessionsForUser(
        userId,
      );
    }
  }

  /// Create workout session with offline support
  Future<WorkoutSession> createWorkoutSession(WorkoutSession session) async {
    try {
      if (_offlineManager.isOnline) {
        // Create in Firebase
        final createdSession = await _workoutRepository.createWorkoutSession(
          session,
        );

        // Cache the created session
        await _localStorageService.storeOfflineWorkoutSession(createdSession);

        return createdSession;
      } else {
        // Store locally and queue for sync
        await _localStorageService.storeOfflineWorkoutSession(session);
        return session;
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error creating workout session ${session.id}',
        e,
        stackTrace,
      );

      // Store locally as fallback
      await _localStorageService.storeOfflineWorkoutSession(session);
      return session;
    }
  }

  /// Update workout session with offline support
  Future<WorkoutSession> updateWorkoutSession(WorkoutSession session) async {
    try {
      if (_offlineManager.isOnline) {
        // Update in Firebase
        final updatedSession = await _workoutRepository.updateWorkoutSession(
          session,
        );

        // Cache the updated session
        await _localStorageService.updateOfflineWorkoutSession(updatedSession);

        return updatedSession;
      } else {
        // Store locally and queue for sync
        await _localStorageService.updateOfflineWorkoutSession(session);
        return session;
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error updating workout session ${session.id}',
        e,
        stackTrace,
      );

      // Store locally as fallback
      await _localStorageService.updateOfflineWorkoutSession(session);
      return session;
    }
  }

  /// Get active workout session for user with offline fallback
  Future<WorkoutSession?> getActiveWorkoutSession(String userId) async {
    try {
      if (_offlineManager.isOnline) {
        // Try to get from Firebase first
        final session = await _workoutRepository.getActiveWorkoutSession(
          userId,
        );

        // Cache session for offline use
        if (session != null) {
          await _localStorageService.storeOfflineWorkoutSession(session);
        }

        return session;
      } else {
        // Get from local cache when offline
        return await _localStorageService.getActiveOfflineWorkoutSession(
          userId,
        );
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error getting active workout session for user $userId',
        e,
        stackTrace,
      );

      // Fallback to cached session on error
      return await _localStorageService.getActiveOfflineWorkoutSession(userId);
    }
  }

  /// Complete workout session with offline support
  Future<WorkoutSession> completeWorkoutSession(
    String sessionId,
    Map<String, dynamic> completionData,
  ) async {
    try {
      if (_offlineManager.isOnline) {
        // Complete in Firebase
        final completedSession = await _workoutRepository
            .completeWorkoutSession(sessionId, completionData);

        // Cache the completed session
        await _localStorageService.updateOfflineWorkoutSession(
          completedSession,
        );

        return completedSession;
      } else {
        // Get session from local cache and update it
        final session = await _localStorageService.getOfflineWorkoutSession(
          sessionId,
        );
        if (session == null) {
          throw Exception('Workout session $sessionId not found');
        }

        final completedSession = session.copyWith(
          status: SessionStatus.completed,
          completedAt: DateTime.now(),
          totalDurationSeconds: completionData['totalDurationSeconds'] as int?,
          completionPercentage:
              completionData['completionPercentage'] as double?,
          totalCaloriesBurned: completionData['totalCaloriesBurned'] as int?,
          aiEvaluation: completionData['aiEvaluation'] as Map<String, dynamic>?,
          userNotes: completionData['userNotes'] as String?,
          sessionData: completionData,
        );

        await _localStorageService.updateOfflineWorkoutSession(
          completedSession,
        );
        return completedSession;
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error completing workout session $sessionId',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  // Utility Methods

  /// Check if user data is available offline
  Future<bool> isUserDataAvailableOffline(String userId) async {
    return await _localStorageService.isUserDataAvailableOffline(userId);
  }

  /// Check if exercises are available offline
  Future<bool> areExercisesAvailableOffline() async {
    return await _localStorageService.areExercisesAvailableOffline();
  }

  /// Get connectivity status
  bool get isOnline => _offlineManager.isOnline;

  /// Stream of connectivity changes
  Stream<bool> get connectivityStream => _offlineManager.connectivityStatus;

  /// Get storage statistics
  Future<Map<String, dynamic>> getStorageStatistics() async {
    return await _localStorageService.getStorageStatistics();
  }

  /// Get sync status
  Map<String, dynamic> getSyncStatus() {
    return _localStorageService.getSyncStatus();
  }

  /// Force sync all pending operations
  Future<void> forceSyncAll() async {
    await _localStorageService.forceSyncAll();
  }

  /// Perform storage cleanup
  Future<void> performStorageCleanup() async {
    await _localStorageService.performStorageCleanup();
  }

  /// Clear all local data
  Future<void> clearAllLocalData() async {
    await _localStorageService.clearAllLocalData();
  }

  /// Clear user-specific data
  Future<void> clearUserData(String userId) async {
    await _localStorageService.clearUserData(userId);
  }
}
