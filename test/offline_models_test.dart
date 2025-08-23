import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_training_app/shared/data/models/offline/offline.dart';
import 'package:fitness_training_app/shared/domain/entities/entities.dart';

void main() {
  group('Offline Models Tests', () {
    group('CachedWorkoutPlan', () {
      test('should create from WorkoutPlan', () {
        final workoutPlan = WorkoutPlan(
          id: 'plan_1',
          name: 'Test Plan',
          description: 'A test workout plan',
          exercises: [],
          type: WorkoutType.strengthTraining,
          difficulty: DifficultyLevel.beginner,
          estimatedDurationMinutes: 30,
          targetMuscleGroups: ['chest', 'arms'],
          metadata: {},
        );

        final cachedPlan = CachedWorkoutPlan.fromWorkoutPlan(
          workoutPlan,
          userId: 'user_1',
        );

        expect(cachedPlan.id, equals('plan_1'));
        expect(cachedPlan.userId, equals('user_1'));
        expect(cachedPlan.workoutPlan.name, equals('Test Plan'));
        expect(cachedPlan.needsSync, isFalse);
        expect(cachedPlan.isStale, isFalse);
      });

      test('should mark for sync', () {
        final workoutPlan = WorkoutPlan(
          id: 'plan_1',
          name: 'Test Plan',
          description: 'A test workout plan',
          exercises: [],
          type: WorkoutType.strengthTraining,
          difficulty: DifficultyLevel.beginner,
          estimatedDurationMinutes: 30,
          targetMuscleGroups: ['chest', 'arms'],
          metadata: {},
        );

        final cachedPlan = CachedWorkoutPlan.fromWorkoutPlan(
          workoutPlan,
          userId: 'user_1',
        );

        expect(cachedPlan.needsSync, isFalse);

        cachedPlan.markForSync();

        expect(cachedPlan.needsSync, isTrue);
        expect(cachedPlan.syncMetadata.containsKey('markedForSyncAt'), isTrue);
      });
    });

    group('OfflineWorkoutSession', () {
      test('should create from WorkoutSession', () {
        final workoutSession = WorkoutSession(
          id: 'session_1',
          userId: 'user_1',
          workoutPlanId: 'plan_1',
          status: SessionStatus.completed,
          startedAt: DateTime.now(),
          exerciseExecutions: [],
          metadata: {},
        );

        final offlineSession = OfflineWorkoutSession.fromSession(
          workoutSession,
          userId: 'user_1',
        );

        expect(offlineSession.sessionId, equals('session_1'));
        expect(offlineSession.userId, equals('user_1'));
        expect(offlineSession.syncStatus, equals(SyncStatus.pending));
        expect(offlineSession.isReadyForSync, isTrue);
      });

      test('should handle sync attempts', () {
        final workoutSession = WorkoutSession(
          id: 'session_1',
          userId: 'user_1',
          workoutPlanId: 'plan_1',
          status: SessionStatus.completed,
          startedAt: DateTime.now(),
          exerciseExecutions: [],
          metadata: {},
        );

        final offlineSession = OfflineWorkoutSession.fromSession(
          workoutSession,
          userId: 'user_1',
        );

        expect(offlineSession.syncRetryCount, equals(0));

        offlineSession.markSyncAttempt('Network error');

        expect(offlineSession.syncRetryCount, equals(1));
        expect(offlineSession.syncStatus, equals(SyncStatus.failed));
        expect(offlineSession.syncError, equals('Network error'));
      });
    });

    group('CachedExercise', () {
      test('should create from Exercise', () {
        final exercise = Exercise(
          id: 'exercise_1',
          name: 'Push Up',
          description: 'A basic push up exercise',
          category: ExerciseCategory.strength,
          difficulty: DifficultyLevel.beginner,
          targetMuscles: [MuscleGroup.chest, MuscleGroup.arms],
          equipment: [],
          estimatedDurationSeconds: 60,
          instructions: ['Get in plank position', 'Lower body', 'Push up'],
          tips: ['Keep core tight'],
          metadata: {},
        );

        final cachedExercise = CachedExercise.fromExercise(exercise);

        expect(cachedExercise.id, equals('exercise_1'));
        expect(cachedExercise.exercise.name, equals('Push Up'));
        expect(cachedExercise.accessCount, equals(0));
        expect(cachedExercise.isStale, isFalse);
        expect(cachedExercise.isFrequentlyAccessed, isFalse);
      });

      test('should track access', () {
        final exercise = Exercise(
          id: 'exercise_1',
          name: 'Push Up',
          description: 'A basic push up exercise',
          category: ExerciseCategory.strength,
          difficulty: DifficultyLevel.beginner,
          targetMuscles: [MuscleGroup.chest, MuscleGroup.arms],
          equipment: [],
          estimatedDurationSeconds: 60,
          instructions: ['Get in plank position', 'Lower body', 'Push up'],
          tips: ['Keep core tight'],
          metadata: {},
        );

        final cachedExercise = CachedExercise.fromExercise(exercise);

        expect(cachedExercise.accessCount, equals(0));

        cachedExercise.markAccessed();

        expect(cachedExercise.accessCount, equals(1));
      });
    });

    group('SyncQueueItem', () {
      test('should create for workout session', () {
        final workoutSession = WorkoutSession(
          id: 'session_1',
          userId: 'user_1',
          workoutPlanId: 'plan_1',
          status: SessionStatus.completed,
          startedAt: DateTime.now(),
          exerciseExecutions: [],
          metadata: {},
        );

        final syncItem = SyncQueueItem.forWorkoutSession(workoutSession);

        expect(syncItem.operation, equals(SyncOperation.create));
        expect(syncItem.entityType, equals('WorkoutSession'));
        expect(syncItem.entityId, equals('session_1'));
        expect(syncItem.priority, equals(1));
        expect(syncItem.isReadyForRetry, isTrue);
      });

      test('should handle retry logic', () {
        final workoutSession = WorkoutSession(
          id: 'session_1',
          userId: 'user_1',
          workoutPlanId: 'plan_1',
          status: SessionStatus.completed,
          startedAt: DateTime.now(),
          exerciseExecutions: [],
          metadata: {},
        );

        final syncItem = SyncQueueItem.forWorkoutSession(workoutSession);

        expect(syncItem.retryCount, equals(0));
        expect(syncItem.isReadyForRetry, isTrue);

        syncItem.markAttempt('Network error');

        expect(syncItem.retryCount, equals(1));
        expect(syncItem.error, equals('Network error'));

        // After 3 attempts, should not be ready for retry
        syncItem.markAttempt('Another error');
        syncItem.markAttempt('Final error');

        expect(syncItem.retryCount, equals(3));
        expect(syncItem.isReadyForRetry, isFalse);
      });
    });

    group('Enum Values', () {
      test('should have correct SyncStatus values', () {
        expect(SyncStatus.values.length, equals(5));
        expect(SyncStatus.values, contains(SyncStatus.pending));
        expect(SyncStatus.values, contains(SyncStatus.syncing));
        expect(SyncStatus.values, contains(SyncStatus.synced));
        expect(SyncStatus.values, contains(SyncStatus.failed));
        expect(SyncStatus.values, contains(SyncStatus.conflict));
      });

      test('should have correct SyncOperation values', () {
        expect(SyncOperation.values.length, equals(4));
        expect(SyncOperation.values, contains(SyncOperation.create));
        expect(SyncOperation.values, contains(SyncOperation.update));
        expect(SyncOperation.values, contains(SyncOperation.delete));
        expect(SyncOperation.values, contains(SyncOperation.sync));
      });
    });

    group('LocalDatabase', () {
      test('should have correct schema version', () {
        expect(DatabaseSchema.currentVersion, equals(1));
      });

      test('should have all required box descriptions', () {
        expect(DatabaseSchema.boxDescriptions.length, greaterThan(5));
        expect(
          DatabaseSchema.boxDescriptions.containsKey('user_profiles'),
          isTrue,
        );
        expect(DatabaseSchema.boxDescriptions.containsKey('exercises'), isTrue);
        expect(
          DatabaseSchema.boxDescriptions.containsKey('workout_plans'),
          isTrue,
        );
        expect(
          DatabaseSchema.boxDescriptions.containsKey('workout_sessions'),
          isTrue,
        );
        expect(
          DatabaseSchema.boxDescriptions.containsKey('sync_queue'),
          isTrue,
        );
      });
    });
  });
}
