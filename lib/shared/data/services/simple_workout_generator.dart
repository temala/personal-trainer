import 'dart:math';

import 'package:fitness_training_app/shared/domain/entities/exercise.dart';
import 'package:fitness_training_app/shared/domain/entities/user_profile.dart';
import 'package:fitness_training_app/shared/domain/entities/workout_plan.dart';

/// Simple workout generator that creates basic workout plans without AI
class SimpleWorkoutGenerator {
  static final _random = Random();

  /// Convert string fitness level to DifficultyLevel enum
  static DifficultyLevel _parseDifficultyLevel(String? level) {
    if (level == null) return DifficultyLevel.beginner;

    switch (level.toLowerCase()) {
      case 'beginner':
        return DifficultyLevel.beginner;
      case 'intermediate':
        return DifficultyLevel.intermediate;
      case 'advanced':
        return DifficultyLevel.advanced;
      case 'expert':
        return DifficultyLevel.expert;
      default:
        return DifficultyLevel.beginner;
    }
  }

  /// Generate a simple workout plan based on user profile and available exercises
  static WorkoutPlan generateSimpleWorkout({
    required UserProfile userProfile,
    required List<Exercise> availableExercises,
    Map<String, dynamic>? preferences,
  }) {
    // Filter exercises based on user level and preferences
    final filteredExercises = _filterExercises(
      availableExercises,
      userProfile,
      preferences,
    );

    if (filteredExercises.isEmpty) {
      throw Exception('No suitable exercises found for user profile');
    }

    // Select 6-8 exercises for a balanced workout
    final selectedExercises = _selectExercises(
      filteredExercises,
      6 + _random.nextInt(3),
    );

    // Parse user fitness level
    final userDifficultyLevel = _parseDifficultyLevel(userProfile.fitnessLevel);

    // Create workout exercises with appropriate sets and reps
    final workoutExercises = <WorkoutExercise>[];
    for (int i = 0; i < selectedExercises.length; i++) {
      final exercise = selectedExercises[i];
      workoutExercises.add(
        WorkoutExercise(
          exerciseId: exercise.id,
          order: i + 1,
          sets: _getSetsForExercise(exercise, userDifficultyLevel),
          repsPerSet: _getRepsForExercise(exercise, userDifficultyLevel),
          restBetweenSetsSeconds: _getRestTime(exercise, userDifficultyLevel),
          exerciseName: exercise.name,
          exerciseDescription: exercise.description,
          exerciseMetadata: {
            'category': exercise.category.name,
            'difficulty': exercise.difficulty.name,
            'targetMuscles': exercise.targetMuscles.map((m) => m.name).toList(),
          },
        ),
      );
    }

    // Determine workout type based on selected exercises
    final workoutType = _determineWorkoutType(selectedExercises);

    // Calculate estimated duration
    final estimatedDuration = _calculateDuration(workoutExercises);

    return WorkoutPlan(
      id: 'simple_workout_${DateTime.now().millisecondsSinceEpoch}',
      name: _generateWorkoutName(workoutType, userDifficultyLevel),
      description: _generateWorkoutDescription(
        workoutType,
        selectedExercises.length,
      ),
      exercises: workoutExercises,
      type: workoutType,
      difficulty: userDifficultyLevel,
      estimatedDurationMinutes: estimatedDuration,
      targetMuscleGroups: _getTargetMuscleGroups(selectedExercises),
      metadata: {
        'generatedBy': 'SimpleWorkoutGenerator',
        'generatedAt': DateTime.now().toIso8601String(),
        'userLevel': userDifficultyLevel.name,
        'exerciseCount': selectedExercises.length,
      },
      userId: userProfile.id,
      aiGeneratedBy: null,
      isTemplate: false,
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  static List<Exercise> _filterExercises(
    List<Exercise> exercises,
    UserProfile userProfile,
    Map<String, dynamic>? preferences,
  ) {
    final userLevel = _parseDifficultyLevel(userProfile.fitnessLevel);
    final requiresNoEquipment = preferences?['equipment'] == 'none';

    return exercises.where((exercise) {
      // Filter by difficulty (allow same level or one level below)
      final exerciseDifficultyIndex = DifficultyLevel.values.indexOf(
        exercise.difficulty,
      );
      final userLevelIndex = DifficultyLevel.values.indexOf(userLevel);
      if (exerciseDifficultyIndex > userLevelIndex) {
        return false;
      }

      // Filter by equipment requirements
      if (requiresNoEquipment && exercise.equipment.isNotEmpty) {
        return false;
      }

      // Filter by duration (prefer exercises under 2 minutes)
      if (exercise.estimatedDurationSeconds > 120) {
        return false;
      }

      return true;
    }).toList();
  }

  static List<Exercise> _selectExercises(List<Exercise> exercises, int count) {
    if (exercises.length <= count) {
      return exercises;
    }

    // Try to get a balanced selection across different categories
    final categories = <ExerciseCategory, List<Exercise>>{};
    for (final exercise in exercises) {
      categories.putIfAbsent(exercise.category, () => []).add(exercise);
    }

    final selected = <Exercise>[];
    final availableCategories = categories.keys.toList()..shuffle();

    // Select exercises from different categories
    while (selected.length < count && availableCategories.isNotEmpty) {
      for (final category in availableCategories) {
        if (selected.length >= count) break;

        final categoryExercises = categories[category]!;
        if (categoryExercises.isNotEmpty) {
          final exercise = categoryExercises.removeAt(
            _random.nextInt(categoryExercises.length),
          );
          selected.add(exercise);
        }

        if (categoryExercises.isEmpty) {
          availableCategories.remove(category);
        }
      }
    }

    return selected;
  }

  static int _getSetsForExercise(
    Exercise exercise,
    DifficultyLevel? userLevel,
  ) {
    switch (userLevel ?? DifficultyLevel.beginner) {
      case DifficultyLevel.beginner:
        return 2 + _random.nextInt(2); // 2-3 sets
      case DifficultyLevel.intermediate:
        return 3 + _random.nextInt(2); // 3-4 sets
      case DifficultyLevel.advanced:
      case DifficultyLevel.expert:
        return 3 + _random.nextInt(3); // 3-5 sets
    }
  }

  static int _getRepsForExercise(
    Exercise exercise,
    DifficultyLevel? userLevel,
  ) {
    // Base reps on exercise category
    int baseReps;
    switch (exercise.category) {
      case ExerciseCategory.strength:
        baseReps = 8;
        break;
      case ExerciseCategory.cardio:
        return 30; // 30 seconds for cardio exercises
      case ExerciseCategory.flexibility:
        return 15;
      case ExerciseCategory.balance:
        return 10;
      case ExerciseCategory.sports:
        baseReps = 15;
        break;
      case ExerciseCategory.rehabilitation:
        baseReps = 8;
        break;
    }

    // Adjust based on user level
    switch (userLevel ?? DifficultyLevel.beginner) {
      case DifficultyLevel.beginner:
        return baseReps;
      case DifficultyLevel.intermediate:
        return baseReps + 2;
      case DifficultyLevel.advanced:
        return baseReps + 4;
      case DifficultyLevel.expert:
        return baseReps + 6;
    }
  }

  static int _getRestTime(Exercise exercise, DifficultyLevel? userLevel) {
    // Base rest time on exercise intensity
    int baseRest;
    switch (exercise.category) {
      case ExerciseCategory.strength:
        baseRest = 90; // 90 seconds for strength exercises
        break;
      case ExerciseCategory.cardio:
        baseRest = 30; // 30 seconds for cardio
        break;
      case ExerciseCategory.flexibility:
      case ExerciseCategory.balance:
      case ExerciseCategory.sports:
      case ExerciseCategory.rehabilitation:
        baseRest = 60; // 60 seconds for other exercises
        break;
    }

    // Adjust based on user level (beginners need more rest)
    switch (userLevel ?? DifficultyLevel.beginner) {
      case DifficultyLevel.beginner:
        return baseRest + 30;
      case DifficultyLevel.intermediate:
        return baseRest;
      case DifficultyLevel.advanced:
      case DifficultyLevel.expert:
        return baseRest - 15;
    }
  }

  static WorkoutType _determineWorkoutType(List<Exercise> exercises) {
    final categoryCount = <ExerciseCategory, int>{};
    for (final exercise in exercises) {
      categoryCount[exercise.category] =
          (categoryCount[exercise.category] ?? 0) + 1;
    }

    final dominantCategory =
        categoryCount.entries.reduce((a, b) => a.value > b.value ? a : b).key;

    switch (dominantCategory) {
      case ExerciseCategory.strength:
        return WorkoutType.strengthTraining;
      case ExerciseCategory.cardio:
        return WorkoutType.cardio;
      case ExerciseCategory.flexibility:
        return WorkoutType.stretching;
      case ExerciseCategory.balance:
      case ExerciseCategory.sports:
      case ExerciseCategory.rehabilitation:
        return WorkoutType.mixed;
    }
  }

  static int _calculateDuration(List<WorkoutExercise> exercises) {
    int totalSeconds = 0;
    for (final exercise in exercises) {
      // Estimate 30 seconds per rep for most exercises
      final exerciseTime =
          exercise.sets * exercise.repsPerSet * 2; // 2 seconds per rep
      final restTime = (exercise.sets - 1) * exercise.restBetweenSetsSeconds;
      totalSeconds += exerciseTime + restTime;
    }

    // Add 2 minutes for transitions between exercises
    totalSeconds += (exercises.length - 1) * 120;

    return (totalSeconds / 60).ceil();
  }

  static String _generateWorkoutName(WorkoutType type, DifficultyLevel level) {
    final levelName = level.name.capitalize();
    switch (type) {
      case WorkoutType.strengthTraining:
        return '$levelName Strength Training';
      case WorkoutType.cardio:
        return '$levelName Cardio Blast';
      case WorkoutType.mixed:
        return '$levelName Full Body Workout';
      case WorkoutType.stretching:
        return '$levelName Flexibility Session';
      case WorkoutType.hiit:
      case WorkoutType.yoga:
      case WorkoutType.pilates:
      case WorkoutType.custom:
        return '$levelName Workout';
    }
  }

  static String _generateWorkoutDescription(
    WorkoutType type,
    int exerciseCount,
  ) {
    switch (type) {
      case WorkoutType.strengthTraining:
        return 'A strength-focused workout with $exerciseCount exercises to build muscle and improve power.';
      case WorkoutType.cardio:
        return 'A cardio-intensive workout with $exerciseCount exercises to boost your heart rate and burn calories.';
      case WorkoutType.mixed:
        return 'A balanced full-body workout with $exerciseCount exercises targeting multiple muscle groups.';
      case WorkoutType.stretching:
        return 'A flexibility-focused session with $exerciseCount exercises to improve mobility and reduce tension.';
      case WorkoutType.hiit:
      case WorkoutType.yoga:
      case WorkoutType.pilates:
      case WorkoutType.custom:
        return 'A personalized workout with $exerciseCount exercises tailored to your fitness level.';
    }
  }

  static List<String> _getTargetMuscleGroups(List<Exercise> exercises) {
    final muscleGroups = <String>{};
    for (final exercise in exercises) {
      muscleGroups.addAll(exercise.targetMuscles.map((m) => m.name));
    }
    return muscleGroups.toList();
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }
}
