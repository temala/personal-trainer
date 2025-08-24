import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_training_app/shared/data/services/celebration_service.dart';
import 'package:fitness_training_app/shared/data/services/exercise_animation_service.dart';
import 'package:fitness_training_app/shared/data/services/recovery_timer_service.dart';
import 'package:fitness_training_app/shared/domain/entities/exercise.dart';
import 'package:fitness_training_app/shared/domain/entities/user_profile.dart';
import 'package:fitness_training_app/shared/domain/entities/workout_session.dart';

void main() {
  group('Celebration and Recovery System Tests', () {
    late CelebrationService celebrationService;
    late RecoveryTimerService recoveryTimerService;
    late Exercise testExercise;
    late WorkoutSession testSession;
    late UserProfile testUserProfile;

    setUp(() {
      celebrationService = CelebrationService();
      recoveryTimerService = RecoveryTimerService();

      testExercise = Exercise(
        id: 'test-exercise-1',
        name: 'Push-ups',
        description: 'Classic push-up exercise',
        category: ExerciseCategory.strength,
        difficulty: DifficultyLevel.intermediate,
        targetMuscles: [MuscleGroup.chest, MuscleGroup.arms],
        equipment: [],
        estimatedDurationSeconds: 120,
        instructions: ['Get in plank position', 'Lower body', 'Push up'],
        tips: ['Keep your core tight', 'Maintain straight line'],
        metadata: {},
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      testUserProfile = UserProfile(
        id: 'test-user-1',
        name: 'Test User',
        email: 'test@example.com',
        age: 30,
        height: 175.0,
        weight: 70.0,
        targetWeight: 65.0,
        fitnessGoal: FitnessGoal.loseWeight,
        activityLevel: ActivityLevel.moderatelyActive,
        preferredExerciseTypes: ['strength'],
        dislikedExercises: [],
        preferences: {},
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      testSession = WorkoutSession(
        id: 'test-session-1',
        userId: 'test-user-1',
        workoutPlanId: 'test-plan-1',
        status: SessionStatus.inProgress,
        startedAt: DateTime.now(),
        exerciseExecutions: [],
        metadata: {},
      );
    });

    group('CelebrationService', () {
      test('should generate celebration data for exercise completion', () {
        final celebrationData = celebrationService.generateCelebrationData(
          exercise: testExercise,
          session: testSession,
        );

        expect(celebrationData, isNotNull);
        expect(
          celebrationData['type'],
          equals(CelebrationType.exerciseComplete),
        );
        expect(celebrationData['exercise'], equals(testExercise));
        expect(celebrationData['title'], isNotNull);
        expect(celebrationData['subtitle'], isNotNull);
        expect(celebrationData['messages'], isA<List<String>>());
        expect(celebrationData['score'], isA<int>());
        expect(celebrationData['score'], greaterThan(0));
      });

      test('should generate celebration effects', () {
        final effects = celebrationService.generateCelebrationEffects(
          CelebrationType.exerciseComplete,
        );

        expect(effects, isNotNull);
        expect(effects['confettiCount'], isA<int>());
        expect(effects['confettiColors'], isA<List<int>>());
        expect(effects['animationDuration'], isA<int>());
        expect(effects['particleSize'], isA<double>());
        expect(effects['sparkleIntensity'], isA<double>());
      });
    });

    group('RecoveryTimerService', () {
      test('should calculate recovery time based on exercise', () {
        final recoveryTime = recoveryTimerService.calculateRecoveryTime(
          exercise: testExercise,
        );

        expect(recoveryTime, isNotNull);
        expect(recoveryTime.inSeconds, greaterThan(0));
        expect(recoveryTime.inSeconds, lessThanOrEqualTo(180)); // Max 3 minutes
      });

      test('should adjust recovery time based on difficulty', () {
        final beginnerExercise = testExercise.copyWith(
          difficulty: DifficultyLevel.beginner,
        );
        final expertExercise = testExercise.copyWith(
          difficulty: DifficultyLevel.expert,
        );

        final beginnerRecovery = recoveryTimerService.calculateRecoveryTime(
          exercise: beginnerExercise,
        );
        final expertRecovery = recoveryTimerService.calculateRecoveryTime(
          exercise: expertExercise,
        );

        expect(beginnerRecovery.inSeconds, lessThan(expertRecovery.inSeconds));
      });

      test(
        'should provide recovery activities for different exercise types',
        () {
          final cardioExercise = testExercise.copyWith(
            category: ExerciseCategory.cardio,
          );
          final strengthExercise = testExercise.copyWith(
            category: ExerciseCategory.strength,
          );

          final cardioActivities = recoveryTimerService.getRecoveryActivities(
            cardioExercise,
          );
          final strengthActivities = recoveryTimerService.getRecoveryActivities(
            strengthExercise,
          );

          expect(cardioActivities, isNotEmpty);
          expect(strengthActivities, isNotEmpty);
          expect(cardioActivities, isNot(equals(strengthActivities)));
        },
      );

      test('should provide recovery tips for different difficulty levels', () {
        final beginnerTips = recoveryTimerService.getRecoveryTips(
          DifficultyLevel.beginner,
        );
        final expertTips = recoveryTimerService.getRecoveryTips(
          DifficultyLevel.expert,
        );

        expect(beginnerTips, isNotEmpty);
        expect(expertTips, isNotEmpty);
        expect(beginnerTips, isNot(equals(expertTips)));
      });
    });

    group('CelebrationType', () {
      test('should have all required celebration types', () {
        expect(
          CelebrationType.values,
          contains(CelebrationType.exerciseComplete),
        );
        expect(
          CelebrationType.values,
          contains(CelebrationType.workoutComplete),
        );
        expect(
          CelebrationType.values,
          contains(CelebrationType.personalRecord),
        );
        expect(
          CelebrationType.values,
          contains(CelebrationType.streakAchieved),
        );
        expect(CelebrationType.values, contains(CelebrationType.goalReached));
      });
    });
  });
}
