import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fitness_training_app/core/utils/logger.dart';
import 'package:fitness_training_app/shared/domain/entities/exercise.dart';
import 'package:fitness_training_app/shared/domain/repositories/exercise_repository.dart';

/// Advanced search and filtering service for exercises
class ExerciseSearchService {
  ExerciseSearchService({
    required ExerciseRepository exerciseRepository,
    FirebaseFirestore? firestore,
  }) : _exerciseRepository = exerciseRepository,
       _firestore = firestore ?? FirebaseFirestore.instance;

  final ExerciseRepository _exerciseRepository;
  final FirebaseFirestore _firestore;

  /// Search exercises with advanced filtering options
  Future<ExerciseSearchResult> searchExercises({
    String? query,
    List<ExerciseCategory>? categories,
    List<DifficultyLevel>? difficulties,
    List<MuscleGroup>? targetMuscles,
    List<String>? equipment,
    bool? requiresNoEquipment,
    int? maxDurationSeconds,
    int? minDurationSeconds,
    List<String>? excludeExerciseIds,
    ExerciseSortBy sortBy = ExerciseSortBy.name,
    bool ascending = true,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      AppLogger.info('Searching exercises with query: "$query"');

      // Start with all exercises
      List<Exercise> exercises = await _exerciseRepository.getAllExercises();

      // Apply text search filter
      if (query != null && query.trim().isNotEmpty) {
        exercises = _applyTextSearch(exercises, query.trim());
      }

      // Apply category filter
      if (categories != null && categories.isNotEmpty) {
        exercises =
            exercises
                .where((exercise) => categories.contains(exercise.category))
                .toList();
      }

      // Apply difficulty filter
      if (difficulties != null && difficulties.isNotEmpty) {
        exercises =
            exercises
                .where((exercise) => difficulties.contains(exercise.difficulty))
                .toList();
      }

      // Apply muscle group filter
      if (targetMuscles != null && targetMuscles.isNotEmpty) {
        exercises =
            exercises
                .where(
                  (exercise) => exercise.targetMuscles.any(
                    (muscle) => targetMuscles.contains(muscle),
                  ),
                )
                .toList();
      }

      // Apply equipment filter
      if (equipment != null && equipment.isNotEmpty) {
        exercises =
            exercises
                .where(
                  (exercise) =>
                      exercise.equipment.any((eq) => equipment.contains(eq)),
                )
                .toList();
      }

      // Apply no equipment filter
      if (requiresNoEquipment == true) {
        exercises =
            exercises.where((exercise) => exercise.equipment.isEmpty).toList();
      }

      // Apply duration filters
      if (maxDurationSeconds != null) {
        exercises =
            exercises
                .where(
                  (exercise) =>
                      exercise.estimatedDurationSeconds <= maxDurationSeconds,
                )
                .toList();
      }

      if (minDurationSeconds != null) {
        exercises =
            exercises
                .where(
                  (exercise) =>
                      exercise.estimatedDurationSeconds >= minDurationSeconds,
                )
                .toList();
      }

      // Apply exclusion filter
      if (excludeExerciseIds != null && excludeExerciseIds.isNotEmpty) {
        exercises =
            exercises
                .where((exercise) => !excludeExerciseIds.contains(exercise.id))
                .toList();
      }

      // Apply sorting
      exercises = _applySorting(exercises, sortBy, ascending);

      // Calculate total count before pagination
      final totalCount = exercises.length;

      // Apply pagination
      final startIndex = offset.clamp(0, exercises.length);
      final endIndex = (offset + limit).clamp(0, exercises.length);
      final paginatedExercises = exercises.sublist(startIndex, endIndex);

      return ExerciseSearchResult(
        exercises: paginatedExercises,
        totalCount: totalCount,
        hasMore: endIndex < exercises.length,
        query: query,
        appliedFilters: ExerciseSearchFilters(
          categories: categories,
          difficulties: difficulties,
          targetMuscles: targetMuscles,
          equipment: equipment,
          requiresNoEquipment: requiresNoEquipment,
          maxDurationSeconds: maxDurationSeconds,
          minDurationSeconds: minDurationSeconds,
          excludeExerciseIds: excludeExerciseIds,
        ),
        sortBy: sortBy,
        ascending: ascending,
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error searching exercises', e, stackTrace);
      rethrow;
    }
  }

  /// Get exercise suggestions based on user preferences and history
  Future<List<Exercise>> getExerciseSuggestions({
    required String userId,
    List<String>? preferredCategories,
    List<String>? dislikedExercises,
    List<String>? recentExercises,
    DifficultyLevel? userLevel,
    int limit = 10,
  }) async {
    try {
      // Get user's exercise history and preferences
      final userPreferences = await _getUserPreferences(userId);

      // Combine provided preferences with stored preferences
      final combinedPreferences = _combinePreferences(
        userPreferences,
        preferredCategories,
        dislikedExercises,
        userLevel,
      );

      // Search for suitable exercises
      final searchResult = await searchExercises(
        categories: combinedPreferences.preferredCategories,
        difficulties: combinedPreferences.suitableDifficulties,
        excludeExerciseIds: [
          ...?dislikedExercises,
          ...?recentExercises,
          ...combinedPreferences.dislikedExercises,
        ],
        sortBy: ExerciseSortBy.popularity,
        ascending: false,
        limit: limit * 2, // Get more to allow for filtering
      );

      // Apply intelligent filtering based on user behavior
      final suggestions = _applyIntelligentFiltering(
        searchResult.exercises,
        combinedPreferences,
        limit,
      );

      AppLogger.info(
        'Generated ${suggestions.length} exercise suggestions for user $userId',
      );
      return suggestions;
    } catch (e, stackTrace) {
      AppLogger.error('Error getting exercise suggestions', e, stackTrace);
      return [];
    }
  }

  /// Get alternative exercises for a given exercise
  Future<List<Exercise>> getSmartAlternatives({
    required String exerciseId,
    required String userId,
    AlternativeType type = AlternativeType.similar,
    int limit = 5,
  }) async {
    try {
      final originalExercise = await _exerciseRepository.getExerciseById(
        exerciseId,
      );
      if (originalExercise == null) {
        return [];
      }

      // Get predefined alternatives first
      final predefinedAlternatives = await _exerciseRepository
          .getAlternativeExercises(exerciseId);

      // If we have enough predefined alternatives, return them
      if (predefinedAlternatives.length >= limit) {
        return predefinedAlternatives.take(limit).toList();
      }

      // Generate smart alternatives based on exercise characteristics
      final smartAlternatives = await _generateSmartAlternatives(
        originalExercise,
        type,
        limit - predefinedAlternatives.length,
      );

      // Combine and deduplicate
      final allAlternatives = <Exercise>[
        ...predefinedAlternatives,
        ...smartAlternatives,
      ];

      // Remove duplicates and the original exercise
      final uniqueAlternatives =
          allAlternatives
              .where((exercise) => exercise.id != exerciseId)
              .toSet()
              .toList();

      return uniqueAlternatives.take(limit).toList();
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error getting smart alternatives for $exerciseId',
        e,
        stackTrace,
      );
      return [];
    }
  }

  /// Get popular exercises based on usage statistics
  Future<List<Exercise>> getPopularExercises({
    ExerciseCategory? category,
    DifficultyLevel? difficulty,
    int limit = 20,
  }) async {
    try {
      // In a real implementation, this would query usage statistics
      // For now, we'll use a simple heuristic based on exercise characteristics

      final searchResult = await searchExercises(
        categories: category != null ? [category] : null,
        difficulties: difficulty != null ? [difficulty] : null,
        sortBy: ExerciseSortBy.popularity,
        ascending: false,
        limit: limit,
      );

      return searchResult.exercises;
    } catch (e, stackTrace) {
      AppLogger.error('Error getting popular exercises', e, stackTrace);
      return [];
    }
  }

  /// Get exercises suitable for quick workouts
  Future<List<Exercise>> getQuickWorkoutExercises({
    int maxDurationSeconds = 60,
    bool requiresNoEquipment = true,
    int limit = 15,
  }) async {
    final searchResult = await searchExercises(
      maxDurationSeconds: maxDurationSeconds,
      requiresNoEquipment: requiresNoEquipment,
      sortBy: ExerciseSortBy.duration,
      ascending: true,
      limit: limit,
    );

    return searchResult.exercises;
  }

  // Private helper methods

  List<Exercise> _applyTextSearch(List<Exercise> exercises, String query) {
    final lowercaseQuery = query.toLowerCase();
    final queryWords =
        lowercaseQuery.split(' ').where((word) => word.isNotEmpty).toList();

    return exercises.where((exercise) {
      final searchableText =
          [
            exercise.name,
            exercise.description,
            ...exercise.instructions,
            ...exercise.tips,
            exercise.category.name,
            exercise.difficulty.name,
            ...exercise.targetMuscles.map((m) => m.name),
            ...exercise.equipment,
          ].join(' ').toLowerCase();

      // Check if all query words are present
      return queryWords.every((word) => searchableText.contains(word));
    }).toList();
  }

  List<Exercise> _applySorting(
    List<Exercise> exercises,
    ExerciseSortBy sortBy,
    bool ascending,
  ) {
    exercises.sort((a, b) {
      int comparison;

      switch (sortBy) {
        case ExerciseSortBy.name:
          comparison = a.name.compareTo(b.name);
          break;
        case ExerciseSortBy.difficulty:
          comparison = DifficultyLevel.values
              .indexOf(a.difficulty)
              .compareTo(DifficultyLevel.values.indexOf(b.difficulty));
          break;
        case ExerciseSortBy.duration:
          comparison = a.estimatedDurationSeconds.compareTo(
            b.estimatedDurationSeconds,
          );
          break;
        case ExerciseSortBy.category:
          comparison = a.category.name.compareTo(b.category.name);
          break;
        case ExerciseSortBy.popularity:
          // For now, use a simple heuristic based on equipment requirements
          // In a real app, this would be based on actual usage statistics
          final aScore = _calculatePopularityScore(a);
          final bScore = _calculatePopularityScore(b);
          comparison = aScore.compareTo(bScore);
          break;
        case ExerciseSortBy.recent:
          comparison = (a.updatedAt ?? a.createdAt ?? DateTime.now()).compareTo(
            b.updatedAt ?? b.createdAt ?? DateTime.now(),
          );
          break;
      }

      return ascending ? comparison : -comparison;
    });

    return exercises;
  }

  int _calculatePopularityScore(Exercise exercise) {
    int score = 0;

    // Prefer exercises that don't require equipment
    if (exercise.equipment.isEmpty) score += 10;

    // Prefer beginner-friendly exercises
    switch (exercise.difficulty) {
      case DifficultyLevel.beginner:
        score += 8;
        break;
      case DifficultyLevel.intermediate:
        score += 5;
        break;
      case DifficultyLevel.advanced:
        score += 3;
        break;
      case DifficultyLevel.expert:
        score += 1;
        break;
    }

    // Prefer shorter exercises
    if (exercise.estimatedDurationSeconds <= 30)
      score += 5;
    else if (exercise.estimatedDurationSeconds <= 60)
      score += 3;

    // Prefer full-body exercises
    if (exercise.targetMuscles.contains(MuscleGroup.fullBody)) score += 5;

    return score;
  }

  Future<UserExercisePreferences> _getUserPreferences(String userId) async {
    try {
      // In a real implementation, this would fetch from user's profile/history
      // For now, return default preferences
      return UserExercisePreferences(
        preferredCategories: [
          ExerciseCategory.cardio,
          ExerciseCategory.strength,
        ],
        suitableDifficulties: [
          DifficultyLevel.beginner,
          DifficultyLevel.intermediate,
        ],
        dislikedExercises: [],
        preferredDuration: 60,
      );
    } catch (e) {
      AppLogger.warning('Could not fetch user preferences for $userId: $e');
      return UserExercisePreferences(
        preferredCategories: [],
        suitableDifficulties: [DifficultyLevel.beginner],
        dislikedExercises: [],
        preferredDuration: 30,
      );
    }
  }

  UserExercisePreferences _combinePreferences(
    UserExercisePreferences stored,
    List<String>? preferredCategories,
    List<String>? dislikedExercises,
    DifficultyLevel? userLevel,
  ) {
    final categories = <ExerciseCategory>[];
    if (preferredCategories != null) {
      for (final categoryName in preferredCategories) {
        try {
          final category = ExerciseCategory.values.firstWhere(
            (c) => c.name == categoryName,
          );
          categories.add(category);
        } catch (e) {
          // Ignore invalid category names
        }
      }
    }

    final difficulties = <DifficultyLevel>[];
    if (userLevel != null) {
      final userLevelIndex = DifficultyLevel.values.indexOf(userLevel);
      // Include current level and one level below/above
      for (
        int i = (userLevelIndex - 1).clamp(
          0,
          DifficultyLevel.values.length - 1,
        );
        i <= (userLevelIndex + 1).clamp(0, DifficultyLevel.values.length - 1);
        i++
      ) {
        difficulties.add(DifficultyLevel.values[i]);
      }
    }

    return UserExercisePreferences(
      preferredCategories:
          categories.isNotEmpty ? categories : stored.preferredCategories,
      suitableDifficulties:
          difficulties.isNotEmpty ? difficulties : stored.suitableDifficulties,
      dislikedExercises: [...stored.dislikedExercises, ...?dislikedExercises],
      preferredDuration: stored.preferredDuration,
    );
  }

  List<Exercise> _applyIntelligentFiltering(
    List<Exercise> exercises,
    UserExercisePreferences preferences,
    int limit,
  ) {
    // Score exercises based on user preferences
    final scoredExercises =
        exercises.map((exercise) {
          int score = 0;

          // Prefer exercises in preferred categories
          if (preferences.preferredCategories.contains(exercise.category)) {
            score += 10;
          }

          // Prefer exercises at suitable difficulty
          if (preferences.suitableDifficulties.contains(exercise.difficulty)) {
            score += 8;
          }

          // Prefer exercises close to preferred duration
          final durationDiff =
              (exercise.estimatedDurationSeconds -
                      preferences.preferredDuration)
                  .abs();
          if (durationDiff <= 15)
            score += 5;
          else if (durationDiff <= 30)
            score += 3;

          return ScoredExercise(exercise, score);
        }).toList();

    // Sort by score and return top exercises
    scoredExercises.sort((a, b) => b.score.compareTo(a.score));
    return scoredExercises
        .take(limit)
        .map((scored) => scored.exercise)
        .toList();
  }

  Future<List<Exercise>> _generateSmartAlternatives(
    Exercise originalExercise,
    AlternativeType type,
    int limit,
  ) async {
    final searchResult = await searchExercises(
      categories: [originalExercise.category],
      targetMuscles: originalExercise.targetMuscles,
      excludeExerciseIds: [originalExercise.id],
      sortBy: ExerciseSortBy.popularity,
      limit: limit * 2,
    );

    // Filter based on alternative type
    List<Exercise> alternatives = searchResult.exercises;

    switch (type) {
      case AlternativeType.easier:
        final originalDifficultyIndex = DifficultyLevel.values.indexOf(
          originalExercise.difficulty,
        );
        alternatives =
            alternatives.where((exercise) {
              final exerciseDifficultyIndex = DifficultyLevel.values.indexOf(
                exercise.difficulty,
              );
              return exerciseDifficultyIndex < originalDifficultyIndex;
            }).toList();
        break;
      case AlternativeType.harder:
        final originalDifficultyIndex = DifficultyLevel.values.indexOf(
          originalExercise.difficulty,
        );
        alternatives =
            alternatives.where((exercise) {
              final exerciseDifficultyIndex = DifficultyLevel.values.indexOf(
                exercise.difficulty,
              );
              return exerciseDifficultyIndex > originalDifficultyIndex;
            }).toList();
        break;
      case AlternativeType.noEquipment:
        alternatives =
            alternatives
                .where((exercise) => exercise.equipment.isEmpty)
                .toList();
        break;
      case AlternativeType.similar:
        // Already filtered by category and muscle groups
        break;
    }

    return alternatives.take(limit).toList();
  }
}

/// Search result containing exercises and metadata
class ExerciseSearchResult {
  const ExerciseSearchResult({
    required this.exercises,
    required this.totalCount,
    required this.hasMore,
    this.query,
    this.appliedFilters,
    this.sortBy = ExerciseSortBy.name,
    this.ascending = true,
  });

  final List<Exercise> exercises;
  final int totalCount;
  final bool hasMore;
  final String? query;
  final ExerciseSearchFilters? appliedFilters;
  final ExerciseSortBy sortBy;
  final bool ascending;
}

/// Search filters applied to exercise search
class ExerciseSearchFilters {
  const ExerciseSearchFilters({
    this.categories,
    this.difficulties,
    this.targetMuscles,
    this.equipment,
    this.requiresNoEquipment,
    this.maxDurationSeconds,
    this.minDurationSeconds,
    this.excludeExerciseIds,
  });

  final List<ExerciseCategory>? categories;
  final List<DifficultyLevel>? difficulties;
  final List<MuscleGroup>? targetMuscles;
  final List<String>? equipment;
  final bool? requiresNoEquipment;
  final int? maxDurationSeconds;
  final int? minDurationSeconds;
  final List<String>? excludeExerciseIds;
}

/// Sort options for exercise search
enum ExerciseSortBy { name, difficulty, duration, category, popularity, recent }

/// Alternative exercise types
enum AlternativeType { similar, easier, harder, noEquipment }

/// User exercise preferences
class UserExercisePreferences {
  const UserExercisePreferences({
    required this.preferredCategories,
    required this.suitableDifficulties,
    required this.dislikedExercises,
    required this.preferredDuration,
  });

  final List<ExerciseCategory> preferredCategories;
  final List<DifficultyLevel> suitableDifficulties;
  final List<String> dislikedExercises;
  final int preferredDuration;
}

/// Exercise with score for intelligent filtering
class ScoredExercise {
  const ScoredExercise(this.exercise, this.score);

  final Exercise exercise;
  final int score;
}
