import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fitness_training_app/core/constants/firebase_constants.dart';
import 'package:fitness_training_app/core/utils/logger.dart';
import 'package:fitness_training_app/shared/data/models/offline/offline_models.dart';
import 'package:fitness_training_app/shared/domain/entities/exercise.dart';
import 'package:fitness_training_app/shared/domain/repositories/exercise_repository.dart';
import 'package:hive/hive.dart';

/// Firebase implementation of ExerciseRepository with offline caching
class FirebaseExerciseRepository implements ExerciseRepository {
  FirebaseExerciseRepository({
    FirebaseFirestore? firestore,
    Connectivity? connectivity,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _connectivity = connectivity ?? Connectivity();

  final FirebaseFirestore _firestore;
  final Connectivity _connectivity;

  Box<CachedExercise>? _exerciseCache;

  static const String _cacheBoxName = 'cached_exercises';
  static const Duration _cacheValidityDuration = Duration(days: 7);

  /// Safely get exercise cache box
  Box<CachedExercise>? get _safeExerciseCache {
    try {
      return _exerciseCache ??= Hive.box<CachedExercise>(_cacheBoxName);
    } catch (e) {
      AppLogger.warning('Exercise cache box not available: $e');
      return null;
    }
  }

  @override
  Future<List<Exercise>> getAllExercises() async {
    try {
      // Try to get from cache first
      final cachedExercises = _getCachedExercises();
      final isOnline = await _isOnline();

      // If we have valid cache and we're offline, return cached data
      if (cachedExercises.isNotEmpty && !isOnline) {
        AppLogger.info(
          'Returning ${cachedExercises.length} exercises from cache (offline)',
        );
        return cachedExercises;
      }

      // If we have valid cache and it's not stale, return cached data
      if (cachedExercises.isNotEmpty && !_isCacheStale()) {
        AppLogger.info(
          'Returning ${cachedExercises.length} exercises from cache (valid)',
        );
        return cachedExercises;
      }

      // Try to fetch from Firestore if online
      if (isOnline) {
        final exercises = await _fetchExercisesFromFirestore();
        await _cacheExercises(exercises);
        AppLogger.info(
          'Fetched and cached ${exercises.length} exercises from Firestore',
        );
        return exercises;
      }

      // Fallback to stale cache if available
      if (cachedExercises.isNotEmpty) {
        AppLogger.warning(
          'Returning stale cached exercises (${cachedExercises.length})',
        );
        return cachedExercises;
      }

      // No data available, return default exercises
      AppLogger.warning(
        'No exercise data available, returning default exercises',
      );
      final defaultExercises = _getDefaultExercises();
      await _cacheExercises(defaultExercises);
      return defaultExercises;
    } catch (e, stackTrace) {
      AppLogger.error('Error getting all exercises', e, stackTrace);

      // Fallback to cache on error
      final cachedExercises = _getCachedExercises();
      if (cachedExercises.isNotEmpty) {
        AppLogger.info('Returning cached exercises due to error');
        return cachedExercises;
      }

      rethrow;
    }
  }

  @override
  Future<Exercise?> getExerciseById(String id) async {
    try {
      // Check cache first
      final cache = _safeExerciseCache;
      final cachedExercise = cache?.get(id);
      if (cachedExercise != null) {
        cachedExercise.markAccessed();

        // Return cached if offline or cache is valid
        if (!await _isOnline() || !cachedExercise.isStale) {
          AppLogger.info('Returning exercise $id from cache');
          return cachedExercise.exercise;
        }
      }

      // Try to fetch from Firestore if online
      if (await _isOnline()) {
        final doc =
            await _firestore
                .collection(FirebaseConstants.exercises)
                .doc(id)
                .get();

        if (doc.exists && doc.data() != null) {
          final exercise = ExerciseHelper.fromFirestore(doc.id, doc.data()!);
          await _cacheExercise(exercise);
          AppLogger.info('Fetched and cached exercise $id from Firestore');
          return exercise;
        }
      }

      // Return cached exercise if available (even if stale)
      if (cachedExercise != null) {
        AppLogger.warning('Returning stale cached exercise $id');
        return cachedExercise.exercise;
      }

      AppLogger.warning('Exercise $id not found');
      return null;
    } catch (e, stackTrace) {
      AppLogger.error('Error getting exercise $id', e, stackTrace);

      // Fallback to cache on error
      final cache = _safeExerciseCache;
      final cachedExercise = cache?.get(id);
      if (cachedExercise != null) {
        AppLogger.info('Returning cached exercise $id due to error');
        return cachedExercise.exercise;
      }

      rethrow;
    }
  }

  @override
  Future<List<Exercise>> getExercisesByCategory(
    ExerciseCategory category,
  ) async {
    final allExercises = await getAllExercises();
    return allExercises
        .where((exercise) => exercise.category == category)
        .toList();
  }

  @override
  Future<List<Exercise>> getExercisesByDifficulty(
    DifficultyLevel difficulty,
  ) async {
    final allExercises = await getAllExercises();
    return allExercises
        .where((exercise) => exercise.difficulty == difficulty)
        .toList();
  }

  @override
  Future<List<Exercise>> getExercisesByMuscleGroup(
    MuscleGroup muscleGroup,
  ) async {
    final allExercises = await getAllExercises();
    return allExercises
        .where((exercise) => exercise.targetMuscles.contains(muscleGroup))
        .toList();
  }

  @override
  Future<List<Exercise>> getAlternativeExercises(String exerciseId) async {
    try {
      final exercise = await getExerciseById(exerciseId);
      if (exercise?.alternativeExerciseIds == null ||
          exercise!.alternativeExerciseIds!.isEmpty) {
        return [];
      }

      final alternatives = <Exercise>[];
      for (final altId in exercise.alternativeExerciseIds!) {
        final altExercise = await getExerciseById(altId);
        if (altExercise != null) {
          alternatives.add(altExercise);
        }
      }

      return alternatives;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error getting alternative exercises for $exerciseId',
        e,
        stackTrace,
      );
      return [];
    }
  }

  @override
  Future<List<Exercise>> searchExercises(String query) async {
    final allExercises = await getAllExercises();
    final lowercaseQuery = query.toLowerCase();

    return allExercises.where((exercise) {
      return exercise.name.toLowerCase().contains(lowercaseQuery) ||
          exercise.description.toLowerCase().contains(lowercaseQuery) ||
          exercise.instructions.any(
            (instruction) => instruction.toLowerCase().contains(lowercaseQuery),
          );
    }).toList();
  }

  @override
  Future<List<Exercise>> getExercisesForUser({
    required List<String> preferredTypes,
    required List<String> dislikedExercises,
    required List<String> availableEquipment,
    DifficultyLevel? maxDifficulty,
  }) async {
    final allExercises = await getAllExercises();

    return allExercises.where((exercise) {
      // Check if exercise matches user preferences
      if (!exercise.matchesPreferences(
        preferredTypes: preferredTypes,
        dislikedExercises: dislikedExercises,
        availableEquipment: availableEquipment,
      )) {
        return false;
      }

      // Check difficulty level
      if (maxDifficulty != null) {
        final exerciseDifficultyIndex = DifficultyLevel.values.indexOf(
          exercise.difficulty,
        );
        final maxDifficultyIndex = DifficultyLevel.values.indexOf(
          maxDifficulty,
        );
        if (exerciseDifficultyIndex > maxDifficultyIndex) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  @override
  Stream<List<Exercise>> watchAllExercises() {
    return _firestore
        .collection(FirebaseConstants.exercises)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => ExerciseHelper.fromFirestore(doc.id, doc.data()))
              .toList();
        })
        .handleError((Object error, StackTrace stackTrace) {
          AppLogger.error('Error watching all exercises', error, stackTrace);
          // Return cached exercises on error
          return Stream.value(_getCachedExercises());
        });
  }

  @override
  Stream<List<Exercise>> watchExercisesByCategory(ExerciseCategory category) {
    return _firestore
        .collection(FirebaseConstants.exercises)
        .where('category', isEqualTo: category.name)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => ExerciseHelper.fromFirestore(doc.id, doc.data()))
              .toList();
        })
        .handleError((Object error, StackTrace stackTrace) {
          AppLogger.error(
            'Error watching exercises by category',
            error,
            stackTrace,
          );
          // Return cached exercises filtered by category on error
          final cachedExercises = _getCachedExercises();
          return Stream.value(
            cachedExercises
                .where((exercise) => exercise.category == category)
                .toList(),
          );
        });
  }

  @override
  Future<bool> isAvailableOffline() async {
    final cache = _safeExerciseCache;
    return cache?.isNotEmpty ?? false;
  }

  @override
  Future<void> refreshFromRemote() async {
    if (!await _isOnline()) {
      throw Exception('Cannot refresh from remote while offline');
    }

    try {
      final exercises = await _fetchExercisesFromFirestore();
      await _cacheExercises(exercises);
      AppLogger.info(
        'Successfully refreshed ${exercises.length} exercises from remote',
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error refreshing exercises from remote', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getCacheStatus() async {
    final cache = _safeExerciseCache;
    final cacheSize = cache?.length ?? 0;
    final oldestCacheEntry = cache?.values
        .map((cached) => cached.cachedAt)
        .fold<DateTime?>(null, (oldest, current) {
          if (oldest == null || current.isBefore(oldest)) {
            return current;
          }
          return oldest;
        });

    final newestCacheEntry = cache?.values
        .map((cached) => cached.cachedAt)
        .fold<DateTime?>(null, (newest, current) {
          if (newest == null || current.isAfter(newest)) {
            return current;
          }
          return newest;
        });

    return {
      'cacheSize': cacheSize,
      'isStale': _isCacheStale(),
      'oldestEntry': oldestCacheEntry?.toIso8601String(),
      'newestEntry': newestCacheEntry?.toIso8601String(),
      'isOnline': await _isOnline(),
    };
  }

  // Private helper methods

  Future<List<Exercise>> _fetchExercisesFromFirestore() async {
    final snapshot =
        await _firestore.collection(FirebaseConstants.exercises).get();

    return snapshot.docs
        .map((doc) => ExerciseHelper.fromFirestore(doc.id, doc.data()))
        .toList();
  }

  List<Exercise> _getCachedExercises() {
    final cache = _safeExerciseCache;
    return cache?.values.map((cached) => cached.exercise).toList() ?? [];
  }

  Future<void> _cacheExercises(List<Exercise> exercises) async {
    for (final exercise in exercises) {
      await _cacheExercise(exercise);
    }
  }

  Future<void> _cacheExercise(Exercise exercise) async {
    final cache = _safeExerciseCache;
    if (cache != null) {
      final cachedExercise = CachedExercise.fromExercise(exercise);
      await cache.put(exercise.id, cachedExercise);
    }
  }

  bool _isCacheStale() {
    final cache = _safeExerciseCache;
    if (cache == null || cache.isEmpty) return true;

    final oldestEntry = cache.values
        .map((cached) => cached.cachedAt)
        .fold<DateTime?>(null, (oldest, current) {
          if (oldest == null || current.isBefore(oldest)) {
            return current;
          }
          return oldest;
        });

    if (oldestEntry == null) return true;

    return DateTime.now().difference(oldestEntry) > _cacheValidityDuration;
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

  /// Get default exercises when no data is available
  List<Exercise> _getDefaultExercises() {
    return [
      Exercise(
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
      Exercise(
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
      Exercise(
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
      Exercise(
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
        tips: [
          'Don\'t let your hips sag or pike up',
          'Engage your core muscles',
        ],
        metadata: {'calories_per_minute': 4, 'type': 'isometric'},
      ),
      Exercise(
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
    ];
  }
}
