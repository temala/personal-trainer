import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fitness_training_app/core/constants/firebase_constants.dart';
import 'package:fitness_training_app/core/utils/logger.dart';
import 'package:fitness_training_app/shared/domain/entities/exercise.dart';

/// Service for managing exercise database structure and seeding
class ExerciseDatabaseService {
  ExerciseDatabaseService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  /// Initialize exercise database with proper indexes and seed data
  Future<void> initializeDatabase() async {
    try {
      AppLogger.info('Initializing exercise database...');

      // Check if database is already initialized
      final isInitialized = await _isDatabaseInitialized();
      if (isInitialized) {
        AppLogger.info('Exercise database already initialized');
        return;
      }

      // Create Firestore indexes (these need to be created in Firebase Console)
      await _logRequiredIndexes();

      // Seed initial exercise data
      await _seedExerciseData();

      // Mark database as initialized
      await _markDatabaseInitialized();

      AppLogger.info('Exercise database initialization completed');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to initialize exercise database', e, stackTrace);
      rethrow;
    }
  }

  /// Check if database has been initialized
  Future<bool> _isDatabaseInitialized() async {
    try {
      final doc =
          await _firestore.collection('_system').doc('exercise_database').get();

      return doc.exists && doc.data()?['initialized'] == true;
    } catch (e) {
      AppLogger.warning('Could not check database initialization status: $e');
      return false;
    }
  }

  /// Mark database as initialized
  Future<void> _markDatabaseInitialized() async {
    await _firestore.collection('_system').doc('exercise_database').set({
      'initialized': true,
      'version': 1,
      'initializedAt': FieldValue.serverTimestamp(),
      'exerciseCount': await _getExerciseCount(),
    });
  }

  /// Get current exercise count
  Future<int> _getExerciseCount() async {
    final snapshot =
        await _firestore.collection(FirebaseConstants.exercises).count().get();
    return snapshot.count ?? 0;
  }

  /// Log required Firestore indexes for optimal performance
  Future<void> _logRequiredIndexes() async {
    AppLogger.info('''
Required Firestore indexes for exercises collection:
1. category (ascending)
2. difficulty (ascending) 
3. targetMuscles (array-contains)
4. equipment (array-contains)
5. isActive (ascending)
6. category (ascending), difficulty (ascending)
7. category (ascending), targetMuscles (array-contains)
8. difficulty (ascending), targetMuscles (array-contains)
9. category (ascending), equipment (array-contains)
10. isActive (ascending), category (ascending)

Please create these indexes in Firebase Console for optimal query performance.
    ''');
  }

  /// Seed initial exercise data
  Future<void> _seedExerciseData() async {
    AppLogger.info('Seeding initial exercise data...');

    final exercises = _getInitialExercises();
    final batch = _firestore.batch();

    for (final exercise in exercises) {
      final docRef = _firestore
          .collection(FirebaseConstants.exercises)
          .doc(exercise.id);
      batch.set(docRef, exercise.toFirestore());
    }

    await batch.commit();
    AppLogger.info('Seeded ${exercises.length} exercises');
  }

  /// Get initial exercise data for seeding
  List<Exercise> _getInitialExercises() {
    return [
      // Cardio exercises
      Exercise(
        id: 'cardio_jumping_jacks',
        name: 'Jumping Jacks',
        description:
            'A full-body cardio exercise that involves jumping while spreading legs and raising arms overhead.',
        category: ExerciseCategory.cardio,
        difficulty: DifficultyLevel.beginner,
        targetMuscles: [MuscleGroup.fullBody, MuscleGroup.legs],
        equipment: [],
        estimatedDurationSeconds: 30,
        instructions: [
          'Stand upright with your legs together and arms at your sides',
          'Jump up and spread your legs shoulder-width apart while raising your arms overhead',
          'Jump again and return to the starting position',
          'Repeat in a continuous, rhythmic motion',
        ],
        tips: [
          'Keep your core engaged throughout the movement',
          'Land softly on the balls of your feet',
          'Maintain a steady breathing pattern',
        ],
        metadata: {
          'caloriesBurnedPerMinute': 8,
          'impactLevel': 'high',
          'spaceRequired': 'small',
        },
        animationUrl: 'animations/cardio/jumping_jacks.json',
        thumbnailUrl: 'thumbnails/cardio/jumping_jacks.jpg',
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),

      Exercise(
        id: 'cardio_high_knees',
        name: 'High Knees',
        description:
            'A cardio exercise that involves running in place while lifting knees high.',
        category: ExerciseCategory.cardio,
        difficulty: DifficultyLevel.beginner,
        targetMuscles: [MuscleGroup.legs, MuscleGroup.core],
        equipment: [],
        estimatedDurationSeconds: 30,
        instructions: [
          'Stand with feet hip-width apart',
          'Run in place, lifting your knees as high as possible',
          'Pump your arms naturally as you would when running',
          'Maintain a quick pace throughout',
        ],
        tips: [
          'Try to bring knees up to hip level',
          'Stay on the balls of your feet',
          'Keep your back straight and core engaged',
        ],
        metadata: {
          'caloriesBurnedPerMinute': 10,
          'impactLevel': 'high',
          'spaceRequired': 'small',
        },
        animationUrl: 'animations/cardio/high_knees.json',
        thumbnailUrl: 'thumbnails/cardio/high_knees.jpg',
        alternativeExerciseIds: ['cardio_jumping_jacks', 'cardio_butt_kicks'],
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),

      Exercise(
        id: 'cardio_butt_kicks',
        name: 'Butt Kicks',
        description:
            'A cardio exercise involving running in place while kicking heels toward glutes.',
        category: ExerciseCategory.cardio,
        difficulty: DifficultyLevel.beginner,
        targetMuscles: [MuscleGroup.legs, MuscleGroup.glutes],
        equipment: [],
        estimatedDurationSeconds: 30,
        instructions: [
          'Stand with feet hip-width apart',
          'Run in place, kicking your heels up toward your glutes',
          'Keep your thighs perpendicular to the ground',
          'Pump your arms as you would when running',
        ],
        tips: [
          'Focus on kicking your heels up, not forward',
          'Keep your knees pointing down',
          'Maintain good posture throughout',
        ],
        metadata: {
          'caloriesBurnedPerMinute': 9,
          'impactLevel': 'high',
          'spaceRequired': 'small',
        },
        animationUrl: 'animations/cardio/butt_kicks.json',
        thumbnailUrl: 'thumbnails/cardio/butt_kicks.jpg',
        alternativeExerciseIds: ['cardio_high_knees', 'cardio_jumping_jacks'],
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),

      // Strength exercises
      Exercise(
        id: 'strength_push_ups',
        name: 'Push-ups',
        description:
            'A classic upper body strength exercise targeting chest, shoulders, and triceps.',
        category: ExerciseCategory.strength,
        difficulty: DifficultyLevel.intermediate,
        targetMuscles: [
          MuscleGroup.chest,
          MuscleGroup.shoulders,
          MuscleGroup.arms,
        ],
        equipment: [],
        estimatedDurationSeconds: 60,
        instructions: [
          'Start in a plank position with hands slightly wider than shoulders',
          'Lower your body until your chest nearly touches the floor',
          'Push back up to the starting position',
          'Keep your body in a straight line throughout',
        ],
        tips: [
          'Engage your core to maintain proper form',
          'Don\'t let your hips sag or pike up',
          'Modify by doing knee push-ups if needed',
        ],
        metadata: {
          'caloriesBurnedPerMinute': 7,
          'impactLevel': 'low',
          'spaceRequired': 'medium',
        },
        animationUrl: 'animations/strength/push_ups.json',
        thumbnailUrl: 'thumbnails/strength/push_ups.jpg',
        alternativeExerciseIds: [
          'strength_knee_push_ups',
          'strength_incline_push_ups',
        ],
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),

      Exercise(
        id: 'strength_knee_push_ups',
        name: 'Knee Push-ups',
        description:
            'A modified push-up performed on knees, ideal for beginners.',
        category: ExerciseCategory.strength,
        difficulty: DifficultyLevel.beginner,
        targetMuscles: [
          MuscleGroup.chest,
          MuscleGroup.shoulders,
          MuscleGroup.arms,
        ],
        equipment: [],
        estimatedDurationSeconds: 60,
        instructions: [
          'Start on your knees with hands placed slightly wider than shoulders',
          'Keep your body straight from knees to head',
          'Lower your chest toward the floor',
          'Push back up to the starting position',
        ],
        tips: [
          'Keep your core engaged',
          'Don\'t rest your weight on your knees',
          'Progress to full push-ups when ready',
        ],
        metadata: {
          'caloriesBurnedPerMinute': 5,
          'impactLevel': 'low',
          'spaceRequired': 'medium',
        },
        animationUrl: 'animations/strength/knee_push_ups.json',
        thumbnailUrl: 'thumbnails/strength/knee_push_ups.jpg',
        alternativeExerciseIds: ['strength_push_ups', 'strength_wall_push_ups'],
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),

      Exercise(
        id: 'strength_squats',
        name: 'Squats',
        description:
            'A fundamental lower body exercise targeting quads, glutes, and hamstrings.',
        category: ExerciseCategory.strength,
        difficulty: DifficultyLevel.beginner,
        targetMuscles: [MuscleGroup.legs, MuscleGroup.glutes],
        equipment: [],
        estimatedDurationSeconds: 60,
        instructions: [
          'Stand with feet shoulder-width apart',
          'Lower your body by bending your knees and pushing your hips back',
          'Go down until your thighs are parallel to the floor',
          'Push through your heels to return to standing',
        ],
        tips: [
          'Keep your chest up and back straight',
          'Don\'t let your knees cave inward',
          'Weight should be on your heels',
        ],
        metadata: {
          'caloriesBurnedPerMinute': 6,
          'impactLevel': 'low',
          'spaceRequired': 'small',
        },
        animationUrl: 'animations/strength/squats.json',
        thumbnailUrl: 'thumbnails/strength/squats.jpg',
        alternativeExerciseIds: ['strength_wall_sits', 'strength_chair_squats'],
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),

      // Flexibility exercises
      Exercise(
        id: 'flexibility_forward_fold',
        name: 'Forward Fold',
        description:
            'A stretching exercise that targets the hamstrings and lower back.',
        category: ExerciseCategory.flexibility,
        difficulty: DifficultyLevel.beginner,
        targetMuscles: [MuscleGroup.legs, MuscleGroup.back],
        equipment: [],
        estimatedDurationSeconds: 30,
        instructions: [
          'Stand with feet hip-width apart',
          'Slowly hinge at the hips and fold forward',
          'Let your arms hang naturally or hold opposite elbows',
          'Hold the stretch and breathe deeply',
        ],
        tips: [
          'Don\'t force the stretch',
          'Bend your knees slightly if needed',
          'Focus on lengthening your spine',
        ],
        metadata: {
          'caloriesBurnedPerMinute': 2,
          'impactLevel': 'none',
          'spaceRequired': 'small',
        },
        animationUrl: 'animations/flexibility/forward_fold.json',
        thumbnailUrl: 'thumbnails/flexibility/forward_fold.jpg',
        alternativeExerciseIds: ['flexibility_seated_forward_fold'],
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),

      // Core exercises
      Exercise(
        id: 'strength_plank',
        name: 'Plank',
        description:
            'An isometric core exercise that strengthens the entire core.',
        category: ExerciseCategory.strength,
        difficulty: DifficultyLevel.intermediate,
        targetMuscles: [MuscleGroup.core, MuscleGroup.shoulders],
        equipment: [],
        estimatedDurationSeconds: 30,
        instructions: [
          'Start in a push-up position',
          'Lower onto your forearms',
          'Keep your body in a straight line from head to heels',
          'Hold the position while breathing normally',
        ],
        tips: [
          'Don\'t let your hips sag or pike up',
          'Engage your core muscles',
          'Keep your neck in neutral position',
        ],
        metadata: {
          'caloriesBurnedPerMinute': 4,
          'impactLevel': 'none',
          'spaceRequired': 'medium',
        },
        animationUrl: 'animations/strength/plank.json',
        thumbnailUrl: 'thumbnails/strength/plank.jpg',
        alternativeExerciseIds: ['strength_knee_plank', 'strength_wall_plank'],
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  /// Update exercise database with new exercises or modifications
  Future<void> updateExerciseDatabase(List<Exercise> exercises) async {
    try {
      AppLogger.info(
        'Updating exercise database with ${exercises.length} exercises',
      );

      final batch = _firestore.batch();

      for (final exercise in exercises) {
        final docRef = _firestore
            .collection(FirebaseConstants.exercises)
            .doc(exercise.id);
        batch.set(docRef, exercise.toFirestore(), SetOptions(merge: true));
      }

      await batch.commit();
      AppLogger.info('Successfully updated exercise database');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to update exercise database', e, stackTrace);
      rethrow;
    }
  }

  /// Create exercise categories metadata
  Future<void> createCategoriesMetadata() async {
    final categories =
        ExerciseCategory.values
            .map(
              (category) => {
                'id': category.name,
                'name': _getCategoryDisplayName(category),
                'description': _getCategoryDescription(category),
                'icon': _getCategoryIcon(category),
                'color': _getCategoryColor(category),
              },
            )
            .toList();

    await _firestore.collection('_metadata').doc('exercise_categories').set({
      'categories': categories,
    });
  }

  /// Create difficulty levels metadata
  Future<void> createDifficultyMetadata() async {
    final difficulties =
        DifficultyLevel.values
            .map(
              (difficulty) => {
                'id': difficulty.name,
                'name': _getDifficultyDisplayName(difficulty),
                'description': _getDifficultyDescription(difficulty),
                'color': _getDifficultyColor(difficulty),
                'order': DifficultyLevel.values.indexOf(difficulty),
              },
            )
            .toList();

    await _firestore.collection('_metadata').doc('difficulty_levels').set({
      'difficulties': difficulties,
    });
  }

  /// Create muscle groups metadata
  Future<void> createMuscleGroupsMetadata() async {
    final muscleGroups =
        MuscleGroup.values
            .map(
              (muscle) => {
                'id': muscle.name,
                'name': _getMuscleGroupDisplayName(muscle),
                'description': _getMuscleGroupDescription(muscle),
                'icon': _getMuscleGroupIcon(muscle),
              },
            )
            .toList();

    await _firestore.collection('_metadata').doc('muscle_groups').set({
      'muscleGroups': muscleGroups,
    });
  }

  // Helper methods for metadata
  String _getCategoryDisplayName(ExerciseCategory category) {
    switch (category) {
      case ExerciseCategory.cardio:
        return 'Cardio';
      case ExerciseCategory.strength:
        return 'Strength';
      case ExerciseCategory.flexibility:
        return 'Flexibility';
      case ExerciseCategory.balance:
        return 'Balance';
      case ExerciseCategory.sports:
        return 'Sports';
      case ExerciseCategory.rehabilitation:
        return 'Rehabilitation';
    }
  }

  String _getCategoryDescription(ExerciseCategory category) {
    switch (category) {
      case ExerciseCategory.cardio:
        return 'Exercises that improve cardiovascular health and endurance';
      case ExerciseCategory.strength:
        return 'Exercises that build muscle strength and power';
      case ExerciseCategory.flexibility:
        return 'Exercises that improve range of motion and flexibility';
      case ExerciseCategory.balance:
        return 'Exercises that improve stability and coordination';
      case ExerciseCategory.sports:
        return 'Sport-specific exercises and movements';
      case ExerciseCategory.rehabilitation:
        return 'Therapeutic exercises for injury recovery';
    }
  }

  String _getCategoryIcon(ExerciseCategory category) {
    switch (category) {
      case ExerciseCategory.cardio:
        return '❤️';
      case ExerciseCategory.strength:
        return '💪';
      case ExerciseCategory.flexibility:
        return '🤸';
      case ExerciseCategory.balance:
        return '⚖️';
      case ExerciseCategory.sports:
        return '⚽';
      case ExerciseCategory.rehabilitation:
        return '🏥';
    }
  }

  String _getCategoryColor(ExerciseCategory category) {
    switch (category) {
      case ExerciseCategory.cardio:
        return '#FF5722';
      case ExerciseCategory.strength:
        return '#2196F3';
      case ExerciseCategory.flexibility:
        return '#4CAF50';
      case ExerciseCategory.balance:
        return '#FF9800';
      case ExerciseCategory.sports:
        return '#9C27B0';
      case ExerciseCategory.rehabilitation:
        return '#607D8B';
    }
  }

  String _getDifficultyDisplayName(DifficultyLevel difficulty) {
    switch (difficulty) {
      case DifficultyLevel.beginner:
        return 'Beginner';
      case DifficultyLevel.intermediate:
        return 'Intermediate';
      case DifficultyLevel.advanced:
        return 'Advanced';
      case DifficultyLevel.expert:
        return 'Expert';
    }
  }

  String _getDifficultyDescription(DifficultyLevel difficulty) {
    switch (difficulty) {
      case DifficultyLevel.beginner:
        return 'Perfect for those new to fitness';
      case DifficultyLevel.intermediate:
        return 'For those with some fitness experience';
      case DifficultyLevel.advanced:
        return 'Challenging exercises for experienced individuals';
      case DifficultyLevel.expert:
        return 'Extremely challenging exercises for fitness experts';
    }
  }

  String _getDifficultyColor(DifficultyLevel difficulty) {
    switch (difficulty) {
      case DifficultyLevel.beginner:
        return '#4CAF50';
      case DifficultyLevel.intermediate:
        return '#FF9800';
      case DifficultyLevel.advanced:
        return '#F44336';
      case DifficultyLevel.expert:
        return '#9C27B0';
    }
  }

  String _getMuscleGroupDisplayName(MuscleGroup muscle) {
    switch (muscle) {
      case MuscleGroup.chest:
        return 'Chest';
      case MuscleGroup.back:
        return 'Back';
      case MuscleGroup.shoulders:
        return 'Shoulders';
      case MuscleGroup.arms:
        return 'Arms';
      case MuscleGroup.core:
        return 'Core';
      case MuscleGroup.legs:
        return 'Legs';
      case MuscleGroup.glutes:
        return 'Glutes';
      case MuscleGroup.fullBody:
        return 'Full Body';
    }
  }

  String _getMuscleGroupDescription(MuscleGroup muscle) {
    switch (muscle) {
      case MuscleGroup.chest:
        return 'Pectoral muscles and surrounding areas';
      case MuscleGroup.back:
        return 'Upper and lower back muscles';
      case MuscleGroup.shoulders:
        return 'Deltoid and surrounding shoulder muscles';
      case MuscleGroup.arms:
        return 'Biceps, triceps, and forearm muscles';
      case MuscleGroup.core:
        return 'Abdominal and core stabilizing muscles';
      case MuscleGroup.legs:
        return 'Quadriceps, hamstrings, and calf muscles';
      case MuscleGroup.glutes:
        return 'Gluteal muscles and hip area';
      case MuscleGroup.fullBody:
        return 'Exercises that work multiple muscle groups';
    }
  }

  String _getMuscleGroupIcon(MuscleGroup muscle) {
    switch (muscle) {
      case MuscleGroup.chest:
        return '🫁';
      case MuscleGroup.back:
        return '🔙';
      case MuscleGroup.shoulders:
        return '🤷';
      case MuscleGroup.arms:
        return '💪';
      case MuscleGroup.core:
        return '🎯';
      case MuscleGroup.legs:
        return '🦵';
      case MuscleGroup.glutes:
        return '🍑';
      case MuscleGroup.fullBody:
        return '🏃';
    }
  }
}
