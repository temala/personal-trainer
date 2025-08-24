import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitness_training_app/shared/data/models/offline/offline_models.dart';
import 'package:fitness_training_app/shared/data/repositories/firebase_exercise_repository.dart';
import 'package:fitness_training_app/shared/data/services/exercise_animation_service.dart';
import 'package:fitness_training_app/shared/data/services/exercise_alternative_service.dart';
import 'package:fitness_training_app/shared/data/services/exercise_database_service.dart';
import 'package:fitness_training_app/shared/data/services/exercise_search_service.dart';
import 'package:fitness_training_app/shared/domain/entities/exercise.dart';
import 'package:fitness_training_app/shared/domain/repositories/exercise_repository.dart';

/// Exercise repository provider
final exerciseRepositoryProvider = Provider<ExerciseRepository>((ref) {
  return FirebaseExerciseRepository();
});

/// Exercise database service provider
final exerciseDatabaseServiceProvider = Provider<ExerciseDatabaseService>((
  ref,
) {
  return ExerciseDatabaseService();
});

/// Exercise search service provider
final exerciseSearchServiceProvider = Provider<ExerciseSearchService>((ref) {
  final exerciseRepository = ref.watch(exerciseRepositoryProvider);
  return ExerciseSearchService(exerciseRepository: exerciseRepository);
});

/// Exercise alternative service provider
final exerciseAlternativeServiceProvider = Provider<ExerciseAlternativeService>(
  (ref) {
    final exerciseRepository = ref.watch(exerciseRepositoryProvider);
    final searchService = ref.watch(exerciseSearchServiceProvider);
    return ExerciseAlternativeService(
      exerciseRepository: exerciseRepository,
      searchService: searchService,
    );
  },
);

/// Exercise animation service provider
final exerciseAnimationServiceProvider = Provider<ExerciseAnimationService>((
  ref,
) {
  return ExerciseAnimationService();
});

/// All exercises provider
final allExercisesProvider = FutureProvider<List<Exercise>>((ref) async {
  final repository = ref.watch(exerciseRepositoryProvider);
  return repository.getAllExercises();
});

/// Exercises by category provider
final exercisesByCategoryProvider =
    FutureProvider.family<List<Exercise>, ExerciseCategory>((
      ref,
      category,
    ) async {
      final repository = ref.watch(exerciseRepositoryProvider);
      return repository.getExercisesByCategory(category);
    });

/// Exercises by difficulty provider
final exercisesByDifficultyProvider =
    FutureProvider.family<List<Exercise>, DifficultyLevel>((
      ref,
      difficulty,
    ) async {
      final repository = ref.watch(exerciseRepositoryProvider);
      return repository.getExercisesByDifficulty(difficulty);
    });

/// Exercise by ID provider
final exerciseByIdProvider = FutureProvider.family<Exercise?, String>((
  ref,
  exerciseId,
) async {
  final repository = ref.watch(exerciseRepositoryProvider);
  return repository.getExerciseById(exerciseId);
});

/// Exercise search provider
final exerciseSearchProvider =
    FutureProvider.family<ExerciseSearchResult, ExerciseSearchParams>((
      ref,
      params,
    ) async {
      final searchService = ref.watch(exerciseSearchServiceProvider);
      return searchService.searchExercises(
        query: params.query,
        categories: params.categories,
        difficulties: params.difficulties,
        targetMuscles: params.targetMuscles,
        equipment: params.equipment,
        requiresNoEquipment: params.requiresNoEquipment,
        maxDurationSeconds: params.maxDurationSeconds,
        minDurationSeconds: params.minDurationSeconds,
        excludeExerciseIds: params.excludeExerciseIds,
        sortBy: params.sortBy,
        ascending: params.ascending,
        limit: params.limit,
        offset: params.offset,
      );
    });

/// Exercise suggestions provider
final exerciseSuggestionsProvider =
    FutureProvider.family<List<Exercise>, ExerciseSuggestionParams>((
      ref,
      params,
    ) async {
      final searchService = ref.watch(exerciseSearchServiceProvider);
      return searchService.getExerciseSuggestions(
        userId: params.userId,
        preferredCategories: params.preferredCategories,
        dislikedExercises: params.dislikedExercises,
        recentExercises: params.recentExercises,
        userLevel: params.userLevel,
        limit: params.limit,
      );
    });

/// Popular exercises provider
final popularExercisesProvider =
    FutureProvider.family<List<Exercise>, PopularExercisesParams>((
      ref,
      params,
    ) async {
      final searchService = ref.watch(exerciseSearchServiceProvider);
      return searchService.getPopularExercises(
        category: params.category,
        difficulty: params.difficulty,
        limit: params.limit,
      );
    });

/// Quick workout exercises provider
final quickWorkoutExercisesProvider =
    FutureProvider.family<List<Exercise>, QuickWorkoutParams>((
      ref,
      params,
    ) async {
      final searchService = ref.watch(exerciseSearchServiceProvider);
      return searchService.getQuickWorkoutExercises(
        maxDurationSeconds: params.maxDurationSeconds,
        requiresNoEquipment: params.requiresNoEquipment,
        limit: params.limit,
      );
    });

/// Exercise alternatives provider
final exerciseAlternativesProvider =
    FutureProvider.family<List<Exercise>, String>((ref, exerciseId) async {
      final repository = ref.watch(exerciseRepositoryProvider);
      return repository.getAlternativeExercises(exerciseId);
    });

/// Smart exercise alternatives provider
final smartExerciseAlternativesProvider =
    FutureProvider.family<List<Exercise>, SmartAlternativesParams>((
      ref,
      params,
    ) async {
      final searchService = ref.watch(exerciseSearchServiceProvider);
      return searchService.getSmartAlternatives(
        exerciseId: params.exerciseId,
        userId: params.userId,
        type: params.type,
        limit: params.limit,
      );
    });

/// Exercise animation provider
final exerciseAnimationProvider =
    FutureProvider.family<ExerciseAnimationData?, String>((
      ref,
      exerciseId,
    ) async {
      final animationService = ref.watch(exerciseAnimationServiceProvider);
      return animationService.getExerciseAnimation(exerciseId);
    });

/// User avatar animation provider
final userAvatarAnimationProvider =
    FutureProvider.family<ExerciseAnimationData?, UserAvatarAnimationParams>((
      ref,
      params,
    ) async {
      final animationService = ref.watch(exerciseAnimationServiceProvider);
      return animationService.getUserAvatarAnimation(
        exerciseId: params.exerciseId,
        userId: params.userId,
        avatarData: params.avatarData,
      );
    });

/// Celebration animation provider
final celebrationAnimationProvider =
    FutureProvider.family<ExerciseAnimationData?, CelebrationType>((
      ref,
      type,
    ) async {
      final animationService = ref.watch(exerciseAnimationServiceProvider);
      return animationService.getCelebrationAnimation(type: type);
    });

/// Exercise analytics provider
final exerciseAnalyticsProvider =
    FutureProvider.family<ExerciseAnalytics, String>((ref, userId) async {
      final alternativeService = ref.watch(exerciseAlternativeServiceProvider);
      return alternativeService.getExerciseAnalytics(userId);
    });

/// User exercise preferences provider
final userExercisePreferencesProvider =
    FutureProvider.family<UserExercisePreferences, String>((ref, userId) async {
      final alternativeService = ref.watch(exerciseAlternativeServiceProvider);
      return alternativeService.getUserExercisePreferences(userId);
    });

/// Exercise database initialization provider
final exerciseDatabaseInitializationProvider = FutureProvider<void>((
  ref,
) async {
  final databaseService = ref.watch(exerciseDatabaseServiceProvider);
  await databaseService.initializeDatabase();
});

/// Exercise cache status provider
final exerciseCacheStatusProvider = FutureProvider<Map<String, dynamic>>((
  ref,
) async {
  final repository = ref.watch(exerciseRepositoryProvider);
  return repository.getCacheStatus();
});

/// Animation cache status provider
final animationCacheStatusProvider = FutureProvider<Map<String, dynamic>>((
  ref,
) async {
  final animationService = ref.watch(exerciseAnimationServiceProvider);
  return animationService.getCacheStatus();
});

// Parameter classes for providers

/// Parameters for exercise search
class ExerciseSearchParams {
  const ExerciseSearchParams({
    this.query,
    this.categories,
    this.difficulties,
    this.targetMuscles,
    this.equipment,
    this.requiresNoEquipment,
    this.maxDurationSeconds,
    this.minDurationSeconds,
    this.excludeExerciseIds,
    this.sortBy = ExerciseSortBy.name,
    this.ascending = true,
    this.limit = 50,
    this.offset = 0,
  });

  final String? query;
  final List<ExerciseCategory>? categories;
  final List<DifficultyLevel>? difficulties;
  final List<MuscleGroup>? targetMuscles;
  final List<String>? equipment;
  final bool? requiresNoEquipment;
  final int? maxDurationSeconds;
  final int? minDurationSeconds;
  final List<String>? excludeExerciseIds;
  final ExerciseSortBy sortBy;
  final bool ascending;
  final int limit;
  final int offset;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseSearchParams &&
          runtimeType == other.runtimeType &&
          query == other.query &&
          _listEquals(categories, other.categories) &&
          _listEquals(difficulties, other.difficulties) &&
          _listEquals(targetMuscles, other.targetMuscles) &&
          _listEquals(equipment, other.equipment) &&
          requiresNoEquipment == other.requiresNoEquipment &&
          maxDurationSeconds == other.maxDurationSeconds &&
          minDurationSeconds == other.minDurationSeconds &&
          _listEquals(excludeExerciseIds, other.excludeExerciseIds) &&
          sortBy == other.sortBy &&
          ascending == other.ascending &&
          limit == other.limit &&
          offset == other.offset;

  @override
  int get hashCode => Object.hash(
    query,
    categories,
    difficulties,
    targetMuscles,
    equipment,
    requiresNoEquipment,
    maxDurationSeconds,
    minDurationSeconds,
    excludeExerciseIds,
    sortBy,
    ascending,
    limit,
    offset,
  );

  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (int index = 0; index < a.length; index += 1) {
      if (a[index] != b[index]) return false;
    }
    return true;
  }
}

/// Parameters for exercise suggestions
class ExerciseSuggestionParams {
  const ExerciseSuggestionParams({
    required this.userId,
    this.preferredCategories,
    this.dislikedExercises,
    this.recentExercises,
    this.userLevel,
    this.limit = 10,
  });

  final String userId;
  final List<String>? preferredCategories;
  final List<String>? dislikedExercises;
  final List<String>? recentExercises;
  final DifficultyLevel? userLevel;
  final int limit;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseSuggestionParams &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          _listEquals(preferredCategories, other.preferredCategories) &&
          _listEquals(dislikedExercises, other.dislikedExercises) &&
          _listEquals(recentExercises, other.recentExercises) &&
          userLevel == other.userLevel &&
          limit == other.limit;

  @override
  int get hashCode => Object.hash(
    userId,
    preferredCategories,
    dislikedExercises,
    recentExercises,
    userLevel,
    limit,
  );

  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (int index = 0; index < a.length; index += 1) {
      if (a[index] != b[index]) return false;
    }
    return true;
  }
}

/// Parameters for popular exercises
class PopularExercisesParams {
  const PopularExercisesParams({
    this.category,
    this.difficulty,
    this.limit = 20,
  });

  final ExerciseCategory? category;
  final DifficultyLevel? difficulty;
  final int limit;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PopularExercisesParams &&
          runtimeType == other.runtimeType &&
          category == other.category &&
          difficulty == other.difficulty &&
          limit == other.limit;

  @override
  int get hashCode => Object.hash(category, difficulty, limit);
}

/// Parameters for quick workout exercises
class QuickWorkoutParams {
  const QuickWorkoutParams({
    this.maxDurationSeconds = 60,
    this.requiresNoEquipment = true,
    this.limit = 15,
  });

  final int maxDurationSeconds;
  final bool requiresNoEquipment;
  final int limit;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuickWorkoutParams &&
          runtimeType == other.runtimeType &&
          maxDurationSeconds == other.maxDurationSeconds &&
          requiresNoEquipment == other.requiresNoEquipment &&
          limit == other.limit;

  @override
  int get hashCode =>
      Object.hash(maxDurationSeconds, requiresNoEquipment, limit);
}

/// Parameters for smart alternatives
class SmartAlternativesParams {
  const SmartAlternativesParams({
    required this.exerciseId,
    required this.userId,
    this.type = AlternativeType.similar,
    this.limit = 5,
  });

  final String exerciseId;
  final String userId;
  final AlternativeType type;
  final int limit;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SmartAlternativesParams &&
          runtimeType == other.runtimeType &&
          exerciseId == other.exerciseId &&
          userId == other.userId &&
          type == other.type &&
          limit == other.limit;

  @override
  int get hashCode => Object.hash(exerciseId, userId, type, limit);
}

/// Parameters for user avatar animation
class UserAvatarAnimationParams {
  const UserAvatarAnimationParams({
    required this.exerciseId,
    required this.userId,
    required this.avatarData,
  });

  final String exerciseId;
  final String userId;
  final AvatarData avatarData;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAvatarAnimationParams &&
          runtimeType == other.runtimeType &&
          exerciseId == other.exerciseId &&
          userId == other.userId &&
          avatarData == other.avatarData;

  @override
  int get hashCode => Object.hash(exerciseId, userId, avatarData);
}
