import 'package:flutter_test/flutter_test.dart';

import 'package:fitness_training_app/shared/domain/entities/entities.dart';
import 'package:fitness_training_app/shared/domain/entities/fitness_enums.dart';

void main() {
  group('Data Models Tests', () {
    test('UserProfile creation and validation', () {
      final userProfile = UserProfile(
        id: 'test-user-1',
        email: 'test@example.com',
        lastUpdated: DateTime.now(),
        name: 'Test User',
        age: 25,
        height: 175,
        weight: 70,
        targetWeight: 65,
        fitnessGoal: FitnessGoal.weightLoss,
        activityLevel: ActivityLevel.moderatelyActive,
        preferredExerciseTypes: ['cardio', 'strength'],
        dislikedExercises: [],
        preferences: {},
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(userProfile.name, 'Test User');
      expect(userProfile.bmi, closeTo(22.86, 0.01));
      expect(userProfile.bmiCategory, 'Normal weight');
      expect(userProfile.weightDifference, 5.0);
      expect(userProfile.validate(), isEmpty);
    });

    test('Exercise creation and validation', () {
      const exercise = Exercise(
        id: 'test-exercise-1',
        name: 'Push-ups',
        description: 'Classic bodyweight exercise',
        category: ExerciseCategory.strength,
        difficulty: DifficultyLevel.beginner,
        targetMuscles: [MuscleGroup.chest, MuscleGroup.arms],
        equipment: [],
        estimatedDurationSeconds: 60,
        instructions: ['Get in plank position', 'Lower body', 'Push up'],
        tips: ['Keep core tight'],
        metadata: {},
      );

      expect(exercise.name, 'Push-ups');
      expect(exercise.formattedDuration, '1m 0s');
      expect(exercise.requiresEquipment, false);
      expect(exercise.validate(), isEmpty);
    });

    test('WorkoutPlan creation and validation', () {
      const workoutPlan = WorkoutPlan(
        id: 'test-plan-1',
        name: 'Beginner Strength',
        description: 'A beginner-friendly strength workout',
        exercises: [
          WorkoutExercise(
            exerciseId: 'exercise-1',
            order: 1,
            sets: 3,
            repsPerSet: 10,
            restBetweenSetsSeconds: 60,
          ),
        ],
        type: WorkoutType.strengthTraining,
        difficulty: DifficultyLevel.beginner,
        estimatedDurationMinutes: 30,
        targetMuscleGroups: ['chest', 'arms'],
        metadata: {},
      );

      expect(workoutPlan.name, 'Beginner Strength');
      expect(workoutPlan.totalExercises, 1);
      expect(workoutPlan.validate(), isEmpty);
    });

    test('WorkoutSession creation from plan', () {
      const workoutPlan = WorkoutPlan(
        id: 'test-plan-1',
        name: 'Test Workout',
        description: 'Test description',
        exercises: [
          WorkoutExercise(
            exerciseId: 'exercise-1',
            order: 1,
            sets: 2,
            repsPerSet: 10,
            restBetweenSetsSeconds: 30,
          ),
        ],
        type: WorkoutType.strengthTraining,
        difficulty: DifficultyLevel.beginner,
        estimatedDurationMinutes: 15,
        targetMuscleGroups: ['chest'],
        metadata: {},
      );

      final session = WorkoutSessionHelper.createFromPlan(
        userId: 'user-1',
        workoutPlan: workoutPlan,
      );

      expect(session.userId, 'user-1');
      expect(session.workoutPlanId, 'test-plan-1');
      expect(session.status, SessionStatus.notStarted);
      expect(session.exerciseExecutions.length, 1);
      expect(session.exerciseExecutions.first.setExecutions.length, 2);
    });

    test('JSON serialization and deserialization', () {
      final originalProfile = UserProfile(
        id: 'test-user-1',
        email: 'test@example.com',
        lastUpdated: DateTime.now(),
        name: 'Test User',
        age: 25,
        height: 175,
        weight: 70,
        targetWeight: 65,
        fitnessGoal: FitnessGoal.weightLoss,
        activityLevel: ActivityLevel.moderatelyActive,
        preferredExerciseTypes: ['cardio'],
        dislikedExercises: [],
        preferences: {'theme': 'dark'},
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final json = originalProfile.toJson();
      final deserializedProfile = UserProfile.fromJson(json);

      expect(deserializedProfile.id, originalProfile.id);
      expect(deserializedProfile.name, originalProfile.name);
      expect(deserializedProfile.fitnessGoal, originalProfile.fitnessGoal);
      expect(deserializedProfile.preferences?['theme'], 'dark');
    });
  });
}
