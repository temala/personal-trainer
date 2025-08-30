import 'dart:async';

import 'package:fitness_training_app/shared/domain/entities/exercise.dart';
import 'package:fitness_training_app/shared/domain/repositories/exercise_repository.dart';

/// Simple in-memory exercise repository for testing and development
class SimpleExerciseRepository implements ExerciseRepository {
  static final List<Exercise> _defaultExercises = [
    const Exercise(
      id: 'default_push_ups',
      name: 'Push-ups',
      description:
          'Classic upper body exercise targeting chest, shoulders, and arms',
      category: ExerciseCategory.strength,
      difficulty: DifficultyLevel.beginner,
      targetMuscles: [
        MuscleGroup.chest,
        MuscleGroup.shoulders,
        MuscleGroup.arms,
      ],
      equipment: [],
      estimatedDurationSeconds: 120,
      instructions: [
        'Start in a plank position with hands shoulder-width apart',
        'Lower your body until your chest nearly touches the floor',
        'Push back up to the starting position',
        'Keep your core engaged throughout the movement',
      ],
      tips: ['Keep your body in a straight line', 'Don\'t let your hips sag'],
      metadata: {'calories_per_minute': 8, 'type': 'bodyweight'},
    ),
    const Exercise(
      id: 'default_squats',
      name: 'Squats',
      description: 'Fundamental lower body exercise for legs and glutes',
      category: ExerciseCategory.strength,
      difficulty: DifficultyLevel.beginner,
      targetMuscles: [MuscleGroup.legs, MuscleGroup.glutes],
      equipment: [],
      estimatedDurationSeconds: 120,
      instructions: [
        'Stand with feet shoulder-width apart',
        'Lower your body as if sitting back into a chair',
        'Keep your chest up and knees behind your toes',
        'Return to standing position',
      ],
      tips: [
        'Keep your weight on your heels',
        'Don\'t let your knees cave inward',
      ],
      metadata: {'calories_per_minute': 6, 'type': 'bodyweight'},
    ),
    const Exercise(
      id: 'default_jumping_jacks',
      name: 'Jumping Jacks',
      description: 'Full-body cardio exercise to get your heart rate up',
      category: ExerciseCategory.cardio,
      difficulty: DifficultyLevel.beginner,
      targetMuscles: [MuscleGroup.fullBody],
      equipment: [],
      estimatedDurationSeconds: 60,
      instructions: [
        'Start standing with feet together and arms at your sides',
        'Jump while spreading your legs shoulder-width apart',
        'Simultaneously raise your arms overhead',
        'Jump back to the starting position',
      ],
      tips: ['Land softly on the balls of your feet', 'Keep a steady rhythm'],
      metadata: {'calories_per_minute': 10, 'type': 'cardio'},
    ),
    const Exercise(
      id: 'default_plank',
      name: 'Plank',
      description: 'Core strengthening exercise that builds stability',
      category: ExerciseCategory.strength,
      difficulty: DifficultyLevel.beginner,
      targetMuscles: [MuscleGroup.core, MuscleGroup.shoulders],
      equipment: [],
      estimatedDurationSeconds: 60,
      instructions: [
        'Start in a push-up position',
        'Lower onto your forearms',
        'Keep your body in a straight line from head to heels',
        'Hold the position while breathing normally',
      ],
      tips: ['Don\'t let your hips sag or pike up', 'Engage your core muscles'],
      metadata: {'calories_per_minute': 4, 'type': 'isometric'},
    ),
    const Exercise(
      id: 'default_lunges',
      name: 'Lunges',
      description: 'Single-leg exercise for lower body strength and balance',
      category: ExerciseCategory.strength,
      difficulty: DifficultyLevel.beginner,
      targetMuscles: [MuscleGroup.legs, MuscleGroup.glutes],
      equipment: [],
      estimatedDurationSeconds: 120,
      instructions: [
        'Stand with feet hip-width apart',
        'Step forward with one leg and lower your hips',
        'Both knees should be bent at 90 degrees',
        'Push back to the starting position and repeat',
      ],
      tips: [
        'Keep your front knee over your ankle',
        'Don\'t let your back knee touch the ground',
      ],
      metadata: {'calories_per_minute': 7, 'type': 'bodyweight'},
    ),
    const Exercise(
      id: 'default_burpees',
      name: 'Burpees',
      description: 'Full-body high-intensity exercise',
      category: ExerciseCategory.cardio,
      difficulty: DifficultyLevel.intermediate,
      targetMuscles: [MuscleGroup.fullBody],
      equipment: [],
      estimatedDurationSeconds: 90,
      instructions: [
        'Start standing with feet shoulder-width apart',
        'Drop into a squat position and place hands on the floor',
        'Jump feet back into a plank position',
        'Do a push-up, then jump feet back to squat position',
        'Jump up with arms overhead',
      ],
      tips: ['Keep your core engaged', 'Land softly when jumping'],
      metadata: {'calories_per_minute': 15, 'type': 'high_intensity'},
    ),
    const Exercise(
      id: 'default_mountain_climbers',
      name: 'Mountain Climbers',
      description: 'Dynamic cardio exercise that targets core and legs',
      category: ExerciseCategory.cardio,
      difficulty: DifficultyLevel.beginner,
      targetMuscles: [MuscleGroup.core, MuscleGroup.legs],
      equipment: [],
      estimatedDurationSeconds: 60,
      instructions: [
        'Start in a plank position',
        'Bring one knee toward your chest',
        'Quickly switch legs, bringing the other knee forward',
        'Continue alternating legs at a fast pace',
      ],
      tips: ['Keep your hips level', 'Maintain a strong plank position'],
      metadata: {'calories_per_minute': 12, 'type': 'cardio'},
    ),
    const Exercise(
      id: 'default_wall_sit',
      name: 'Wall Sit',
      description: 'Isometric exercise for leg strength and endurance',
      category: ExerciseCategory.strength,
      difficulty: DifficultyLevel.beginner,
      targetMuscles: [MuscleGroup.legs, MuscleGroup.glutes],
      equipment: [],
      estimatedDurationSeconds: 60,
      instructions: [
        'Stand with your back against a wall',
        'Slide down until your thighs are parallel to the floor',
        'Keep your knees at 90 degrees',
        'Hold the position while breathing normally',
      ],
      tips: [
        'Keep your back flat against the wall',
        'Don\'t let your knees go past your toes',
      ],
      metadata: {'calories_per_minute': 5, 'type': 'isometric'},
    ),
  ];

  @override
  Future<List<Exercise>> getAllExercises() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 100));
    return List.from(_defaultExercises);
  }

  @override
  Future<Exercise?> getExerciseById(String id) async {
    await Future.delayed(const Duration(milliseconds: 50));
    try {
      return _defaultExercises.firstWhere((exercise) => exercise.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Exercise>> getExercisesByCategory(
    ExerciseCategory category,
  ) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _defaultExercises
        .where((exercise) => exercise.category == category)
        .toList();
  }

  @override
  Future<List<Exercise>> getExercisesByMuscleGroup(
    MuscleGroup muscleGroup,
  ) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _defaultExercises
        .where((exercise) => exercise.targetMuscles.contains(muscleGroup))
        .toList();
  }

  @override
  Future<List<Exercise>> getExercisesByDifficulty(
    DifficultyLevel difficulty,
  ) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _defaultExercises
        .where((exercise) => exercise.difficulty == difficulty)
        .toList();
  }

  @override
  Future<List<Exercise>> getExercisesByEquipment(List<String> equipment) async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (equipment.isEmpty) {
      // Return exercises that don't require equipment
      return _defaultExercises
          .where((exercise) => exercise.equipment.isEmpty)
          .toList();
    }
    return _defaultExercises
        .where(
          (exercise) => exercise.equipment.any((eq) => equipment.contains(eq)),
        )
        .toList();
  }

  @override
  Future<List<Exercise>> searchExercises(String query) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final lowerQuery = query.toLowerCase();
    return _defaultExercises
        .where(
          (exercise) =>
              exercise.name.toLowerCase().contains(lowerQuery) ||
              exercise.description.toLowerCase().contains(lowerQuery),
        )
        .toList();
  }

  @override
  Future<List<Exercise>> getAlternativeExercises(String exerciseId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final exercise = await getExerciseById(exerciseId);
    if (exercise == null) return [];

    // Return exercises with same category and similar difficulty
    return _defaultExercises
        .where(
          (e) =>
              e.id != exerciseId &&
              e.category == exercise.category &&
              e.difficulty == exercise.difficulty,
        )
        .take(3)
        .toList();
  }

  @override
  Future<List<Exercise>> getRecommendedExercises(String userId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    // Return a mix of beginner exercises
    return _defaultExercises
        .where((e) => e.difficulty == DifficultyLevel.beginner)
        .toList();
  }

  @override
  Future<Exercise> createExercise(Exercise exercise) async {
    await Future.delayed(const Duration(milliseconds: 100));
    // In a real implementation, this would save to a database
    return exercise;
  }

  @override
  Future<Exercise> updateExercise(Exercise exercise) async {
    await Future.delayed(const Duration(milliseconds: 100));
    // In a real implementation, this would update the database
    return exercise;
  }

  @override
  Future<void> deleteExercise(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    // In a real implementation, this would delete from the database
  }

  @override
  Future<bool> isAvailableOffline() async {
    return true; // Always available since it's in-memory
  }

  @override
  Future<void> refreshFromRemote() async {
    // No-op for simple repository
  }

  @override
  Future<Map<String, dynamic>> getCacheStatus() async {
    return {
      'exerciseCount': _defaultExercises.length,
      'lastSync': DateTime.now().toIso8601String(),
    };
  }

  @override
  Future<List<Exercise>> getExercisesForUser({
    required List<String> preferredTypes,
    required List<String> dislikedExercises,
    required List<String> availableEquipment,
    DifficultyLevel? maxDifficulty,
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));

    var exercises =
        _defaultExercises.where((exercise) {
          // Filter out disliked exercises
          if (dislikedExercises.contains(exercise.id)) return false;

          // Filter by difficulty if specified
          if (maxDifficulty != null) {
            final difficultyOrder = [
              DifficultyLevel.beginner,
              DifficultyLevel.intermediate,
              DifficultyLevel.advanced,
              DifficultyLevel.expert,
            ];
            final exerciseDifficultyIndex = difficultyOrder.indexOf(
              exercise.difficulty,
            );
            final maxDifficultyIndex = difficultyOrder.indexOf(maxDifficulty);
            if (exerciseDifficultyIndex > maxDifficultyIndex) return false;
          }

          // Filter by equipment availability
          if (availableEquipment.isNotEmpty) {
            if (exercise.equipment.isNotEmpty &&
                !exercise.equipment.any(
                  (eq) => availableEquipment.contains(eq),
                )) {
              return false;
            }
          } else {
            // If no equipment available, only return bodyweight exercises
            if (exercise.equipment.isNotEmpty) return false;
          }

          return true;
        }).toList();

    return exercises;
  }

  @override
  Stream<List<Exercise>> watchAllExercises() {
    return Stream.value(List.from(_defaultExercises));
  }

  @override
  Stream<List<Exercise>> watchExercisesByCategory(ExerciseCategory category) {
    final exercises =
        _defaultExercises
            .where((exercise) => exercise.category == category)
            .toList();
    return Stream.value(exercises);
  }
}
