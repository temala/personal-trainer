import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';

import 'package:fitness_training_app/core/constants/firebase_constants.dart';
import 'package:fitness_training_app/core/utils/logger.dart';
import 'package:fitness_training_app/shared/data/models/offline/offline_models.dart';
import 'package:fitness_training_app/shared/domain/entities/exercise.dart';
import 'package:fitness_training_app/shared/domain/repositories/exercise_repository.dart';

/// Firebase implementation of ExerciseRepository with offline caching
class FirebaseExerciseRepository implements ExerciseRepository {
  final FirebaseFirestore _firestore;
  final Box<CachedExercise> _exerciseCache;
  final Connectivity _connectivity;

  static const String _cacheBoxName = 'exercises_cache';
  static const Duration _cacheValidityDuration = Duration(days: 7);

  FirebaseExerciseRepository({
    FirebaseFirestore? firestore,
    Box<CachedExercise>? exerciseCache,
    Connectivity? connectivity,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _exerciseCache =
           exerciseCache ?? Hive.box<CachedExercise>(_cacheBoxName),
       _connectivity = connectivity ?? Connectivity();

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

      // No data available
      AppLogger.error('No exercise data available offline or online');
      return [];
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
      final cachedExercise = _exerciseCache.get(id);
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
      final cachedExercise = _exerciseCache.get(id);
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
    return _exerciseCache.isNotEmpty;
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
    final cacheSize = _exerciseCache.length;
    final oldestCacheEntry = _exerciseCache.values
        .map((cached) => cached.cachedAt)
        .fold<DateTime?>(null, (oldest, current) {
          if (oldest == null || current.isBefore(oldest)) {
            return current;
          }
          return oldest;
        });

    final newestCacheEntry = _exerciseCache.values
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
    return _exerciseCache.values.map((cached) => cached.exercise).toList();
  }

  Future<void> _cacheExercises(List<Exercise> exercises) async {
    for (final exercise in exercises) {
      await _cacheExercise(exercise);
    }
  }

  Future<void> _cacheExercise(Exercise exercise) async {
    final cachedExercise = CachedExercise.fromExercise(exercise);
    await _exerciseCache.put(exercise.id, cachedExercise);
  }

  bool _isCacheStale() {
    if (_exerciseCache.isEmpty) return true;

    final oldestEntry = _exerciseCache.values
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
}
