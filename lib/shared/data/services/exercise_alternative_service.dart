import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fitness_training_app/core/utils/logger.dart';
import 'package:fitness_training_app/shared/data/services/exercise_search_service.dart';
import 'package:fitness_training_app/shared/domain/entities/exercise.dart';
import 'package:fitness_training_app/shared/domain/repositories/exercise_repository.dart';

/// Service for managing exercise alternatives and user preferences
class ExerciseAlternativeService {
  ExerciseAlternativeService({
    required ExerciseRepository exerciseRepository,
    required ExerciseSearchService searchService,
    FirebaseFirestore? firestore,
  }) : _exerciseRepository = exerciseRepository,
       _searchService = searchService,
       _firestore = firestore ?? FirebaseFirestore.instance;

  final ExerciseRepository _exerciseRepository;
  final ExerciseSearchService _searchService;
  final FirebaseFirestore _firestore;

  /// Handle user swipe gesture for exercise alternatives
  Future<ExerciseAlternativeResult> handleExerciseSwipe({
    required String userId,
    required String exerciseId,
    required SwipeDirection direction,
    required String sessionId,
  }) async {
    try {
      AppLogger.info(
        'Handling exercise swipe: $exerciseId, direction: ${direction.name}',
      );

      // Record user preference
      await _recordUserPreference(userId, exerciseId, direction);

      // Get alternative exercise based on swipe direction
      final alternative = await _getAlternativeForSwipe(
        userId: userId,
        exerciseId: exerciseId,
        direction: direction,
      );

      // Log the interaction for analytics
      await _logExerciseInteraction(
        userId: userId,
        exerciseId: exerciseId,
        sessionId: sessionId,
        action: ExerciseAction.swiped,
        direction: direction,
        alternativeId: alternative?.id,
      );

      return ExerciseAlternativeResult(
        originalExerciseId: exerciseId,
        alternative: alternative,
        reason: _getAlternativeReason(direction),
        swipeDirection: direction,
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error handling exercise swipe', e, stackTrace);
      return ExerciseAlternativeResult(
        originalExerciseId: exerciseId,
        alternative: null,
        reason: 'Error occurred while finding alternative',
        swipeDirection: direction,
      );
    }
  }

  /// Get smart alternative for an exercise based on user context
  Future<Exercise?> getSmartAlternative({
    required String userId,
    required String exerciseId,
    AlternativeType type = AlternativeType.similar,
    String? reason,
  }) async {
    try {
      final originalExercise = await _exerciseRepository.getExerciseById(
        exerciseId,
      );
      if (originalExercise == null) {
        AppLogger.warning('Original exercise $exerciseId not found');
        return null;
      }

      // Get user's exercise history and preferences
      final userPreferences = await _getUserExercisePreferences(userId);
      final recentExercises = await _getRecentExercises(userId);

      // Get alternatives using search service
      final alternatives = await _searchService.getSmartAlternatives(
        exerciseId: exerciseId,
        userId: userId,
        type: type,
        limit: 10,
      );

      // Filter out exercises the user has recently done or dislikes
      final filteredAlternatives =
          alternatives.where((exercise) {
            return !userPreferences.dislikedExercises.contains(exercise.id) &&
                !recentExercises.contains(exercise.id);
          }).toList();

      if (filteredAlternatives.isEmpty) {
        AppLogger.warning('No suitable alternatives found for $exerciseId');
        return null;
      }

      // Select the best alternative based on user preferences
      final bestAlternative = _selectBestAlternative(
        filteredAlternatives,
        originalExercise,
        userPreferences,
        type,
      );

      // Log the alternative selection
      await _logExerciseInteraction(
        userId: userId,
        exerciseId: exerciseId,
        sessionId: 'alternative_request',
        action: ExerciseAction.alternativeRequested,
        alternativeId: bestAlternative.id,
        metadata: {'type': type.name, 'reason': reason},
      );

      return bestAlternative;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error getting smart alternative for $exerciseId',
        e,
        stackTrace,
      );
      return null;
    }
  }

  /// Learn from user's exercise completion patterns
  Future<void> recordExerciseCompletion({
    required String userId,
    required String exerciseId,
    required String sessionId,
    required Duration timeSpent,
    required bool completed,
    int? userRating,
    String? feedback,
  }) async {
    try {
      await _logExerciseInteraction(
        userId: userId,
        exerciseId: exerciseId,
        sessionId: sessionId,
        action: completed ? ExerciseAction.completed : ExerciseAction.skipped,
        metadata: {
          'timeSpent': timeSpent.inSeconds,
          'userRating': userRating,
          'feedback': feedback,
          'completed': completed,
        },
      );

      // Update user preferences based on completion
      if (completed && userRating != null && userRating >= 4) {
        await _updateUserPreference(userId, exerciseId, PreferenceType.liked);
      } else if (!completed || (userRating != null && userRating <= 2)) {
        await _updateUserPreference(
          userId,
          exerciseId,
          PreferenceType.disliked,
        );
      }

      AppLogger.info(
        'Recorded exercise completion: $exerciseId, completed: $completed',
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error recording exercise completion', e, stackTrace);
    }
  }

  /// Get user's exercise preferences and learning data
  Future<UserExercisePreferences> getUserExercisePreferences(
    String userId,
  ) async {
    return _getUserExercisePreferences(userId);
  }

  /// Update user's exercise preferences
  Future<void> updateUserPreferences({
    required String userId,
    List<ExerciseCategory>? preferredCategories,
    List<DifficultyLevel>? suitableDifficulties,
    List<String>? dislikedExercises,
    List<String>? likedExercises,
    int? preferredDuration,
  }) async {
    try {
      final preferencesRef = _firestore
          .collection('user_exercise_preferences')
          .doc(userId);

      final updateData = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (preferredCategories != null) {
        updateData['preferredCategories'] =
            preferredCategories.map((c) => c.name).toList();
      }

      if (suitableDifficulties != null) {
        updateData['suitableDifficulties'] =
            suitableDifficulties.map((d) => d.name).toList();
      }

      if (dislikedExercises != null) {
        updateData['dislikedExercises'] = dislikedExercises;
      }

      if (likedExercises != null) {
        updateData['likedExercises'] = likedExercises;
      }

      if (preferredDuration != null) {
        updateData['preferredDuration'] = preferredDuration;
      }

      await preferencesRef.set(updateData, SetOptions(merge: true));
      AppLogger.info('Updated user exercise preferences for $userId');
    } catch (e, stackTrace) {
      AppLogger.error('Error updating user preferences', e, stackTrace);
    }
  }

  /// Get exercise analytics for a user
  Future<ExerciseAnalytics> getExerciseAnalytics(String userId) async {
    try {
      final interactions =
          await _firestore
              .collection('exercise_interactions')
              .where('userId', isEqualTo: userId)
              .orderBy('timestamp', descending: true)
              .limit(100)
              .get();

      final completedCount =
          interactions.docs
              .where(
                (doc) => doc.data()['action'] == ExerciseAction.completed.name,
              )
              .length;

      final skippedCount =
          interactions.docs
              .where(
                (doc) => doc.data()['action'] == ExerciseAction.skipped.name,
              )
              .length;

      final swipedCount =
          interactions.docs
              .where(
                (doc) => doc.data()['action'] == ExerciseAction.swiped.name,
              )
              .length;

      final totalInteractions = interactions.docs.length;
      final completionRate =
          totalInteractions > 0 ? completedCount / totalInteractions : 0.0;

      // Calculate favorite categories
      final categoryCount = <String, int>{};
      for (final doc in interactions.docs) {
        final exerciseId = doc.data()['exerciseId'] as String?;
        if (exerciseId != null) {
          final exercise = await _exerciseRepository.getExerciseById(
            exerciseId,
          );
          if (exercise != null) {
            final category = exercise.category.name;
            categoryCount[category] = (categoryCount[category] ?? 0) + 1;
          }
        }
      }

      final favoriteCategories =
          categoryCount.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));

      return ExerciseAnalytics(
        totalExercisesCompleted: completedCount,
        totalExercisesSkipped: skippedCount,
        totalSwipes: swipedCount,
        completionRate: completionRate,
        favoriteCategories:
            favoriteCategories.take(3).map((e) => e.key).toList(),
        totalInteractions: totalInteractions,
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error getting exercise analytics', e, stackTrace);
      return const ExerciseAnalytics(
        totalExercisesCompleted: 0,
        totalExercisesSkipped: 0,
        totalSwipes: 0,
        completionRate: 0,
        favoriteCategories: [],
        totalInteractions: 0,
      );
    }
  }

  // Private helper methods

  Future<Exercise?> _getAlternativeForSwipe({
    required String userId,
    required String exerciseId,
    required SwipeDirection direction,
  }) async {
    AlternativeType type;

    switch (direction) {
      case SwipeDirection.left: // Don't like
        type = AlternativeType.similar;
      case SwipeDirection.right: // Can't do now
        type = AlternativeType.easier;
      case SwipeDirection.up: // Want harder
        type = AlternativeType.harder;
      case SwipeDirection.down: // Want no equipment
        type = AlternativeType.noEquipment;
    }

    return getSmartAlternative(
      userId: userId,
      exerciseId: exerciseId,
      type: type,
      reason: _getSwipeReason(direction),
    );
  }

  String _getSwipeReason(SwipeDirection direction) {
    switch (direction) {
      case SwipeDirection.left:
        return 'User dislikes this exercise';
      case SwipeDirection.right:
        return 'User cannot do this exercise right now';
      case SwipeDirection.up:
        return 'User wants a more challenging exercise';
      case SwipeDirection.down:
        return 'User wants an exercise without equipment';
    }
  }

  String _getAlternativeReason(SwipeDirection direction) {
    switch (direction) {
      case SwipeDirection.left:
        return 'Found a similar exercise you might prefer';
      case SwipeDirection.right:
        return 'Found an easier alternative you can do now';
      case SwipeDirection.up:
        return 'Found a more challenging exercise for you';
      case SwipeDirection.down:
        return 'Found an exercise that requires no equipment';
    }
  }

  Future<void> _recordUserPreference(
    String userId,
    String exerciseId,
    SwipeDirection direction,
  ) async {
    PreferenceType preferenceType;

    switch (direction) {
      case SwipeDirection.left:
        preferenceType = PreferenceType.disliked;
      case SwipeDirection.right:
        preferenceType = PreferenceType.cannotDo;
      case SwipeDirection.up:
        preferenceType = PreferenceType.wantsHarder;
      case SwipeDirection.down:
        preferenceType = PreferenceType.wantsNoEquipment;
    }

    await _updateUserPreference(userId, exerciseId, preferenceType);
  }

  Future<void> _updateUserPreference(
    String userId,
    String exerciseId,
    PreferenceType preferenceType,
  ) async {
    try {
      final preferencesRef = _firestore
          .collection('user_exercise_preferences')
          .doc(userId);

      final doc = await preferencesRef.get();
      final data = doc.data() ?? <String, dynamic>{};

      switch (preferenceType) {
        case PreferenceType.liked:
          final liked = List<String>.from(
            (data['likedExercises'] as List<dynamic>?) ?? [],
          );
          if (!liked.contains(exerciseId)) {
            liked.add(exerciseId);
            await preferencesRef.set({
              'likedExercises': liked,
            }, SetOptions(merge: true));
          }
        case PreferenceType.disliked:
          final disliked = List<String>.from(
            (data['dislikedExercises'] as List<dynamic>?) ?? [],
          );
          if (!disliked.contains(exerciseId)) {
            disliked.add(exerciseId);
            await preferencesRef.set({
              'dislikedExercises': disliked,
            }, SetOptions(merge: true));
          }
        case PreferenceType.cannotDo:
          final cannotDo = List<String>.from(
            (data['cannotDoExercises'] as List<dynamic>?) ?? [],
          );
          if (!cannotDo.contains(exerciseId)) {
            cannotDo.add(exerciseId);
            await preferencesRef.set({
              'cannotDoExercises': cannotDo,
            }, SetOptions(merge: true));
          }
        case PreferenceType.wantsHarder:
        case PreferenceType.wantsNoEquipment:
        // These are contextual preferences, not permanent
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error updating user preference', e, stackTrace);
    }
  }

  Future<UserExercisePreferences> _getUserExercisePreferences(
    String userId,
  ) async {
    try {
      final doc =
          await _firestore
              .collection('user_exercise_preferences')
              .doc(userId)
              .get();

      if (!doc.exists) {
        return const UserExercisePreferences(
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
      }

      final data = doc.data()!;

      final preferredCategories =
          (data['preferredCategories'] as List<dynamic>?)
              ?.map(
                (name) => ExerciseCategory.values.firstWhere(
                  (c) => c.name == name,
                  orElse: () => ExerciseCategory.cardio,
                ),
              )
              .toList() ??
          [ExerciseCategory.cardio, ExerciseCategory.strength];

      final suitableDifficulties =
          (data['suitableDifficulties'] as List<dynamic>?)
              ?.map(
                (name) => DifficultyLevel.values.firstWhere(
                  (d) => d.name == name,
                  orElse: () => DifficultyLevel.beginner,
                ),
              )
              .toList() ??
          [DifficultyLevel.beginner, DifficultyLevel.intermediate];

      final dislikedExercises = List<String>.from(
        (data['dislikedExercises'] as List<dynamic>?) ?? [],
      );
      final preferredDuration = data['preferredDuration'] as int? ?? 60;

      return UserExercisePreferences(
        preferredCategories: preferredCategories,
        suitableDifficulties: suitableDifficulties,
        dislikedExercises: dislikedExercises,
        preferredDuration: preferredDuration,
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error getting user exercise preferences', e, stackTrace);
      return const UserExercisePreferences(
        preferredCategories: [ExerciseCategory.cardio],
        suitableDifficulties: [DifficultyLevel.beginner],
        dislikedExercises: [],
        preferredDuration: 30,
      );
    }
  }

  Future<List<String>> _getRecentExercises(String userId) async {
    try {
      final interactions =
          await _firestore
              .collection('exercise_interactions')
              .where('userId', isEqualTo: userId)
              .where('action', isEqualTo: ExerciseAction.completed.name)
              .orderBy('timestamp', descending: true)
              .limit(10)
              .get();

      return interactions.docs
          .map((doc) => doc.data()['exerciseId'] as String)
          .toList();
    } catch (e) {
      AppLogger.warning('Could not fetch recent exercises for $userId: $e');
      return [];
    }
  }

  Exercise _selectBestAlternative(
    List<Exercise> alternatives,
    Exercise originalExercise,
    UserExercisePreferences preferences,
    AlternativeType type,
  ) {
    // Score alternatives based on user preferences and type
    final scoredAlternatives =
        alternatives.map((exercise) {
          int score = 0;

          // Prefer exercises in user's preferred categories
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
          if (durationDiff <= 15) {
            score += 5;
          } else if (durationDiff <= 30) {
            score += 3;
          }

          // Type-specific scoring
          switch (type) {
            case AlternativeType.easier:
              final originalDifficultyIndex = DifficultyLevel.values.indexOf(
                originalExercise.difficulty,
              );
              final exerciseDifficultyIndex = DifficultyLevel.values.indexOf(
                exercise.difficulty,
              );
              if (exerciseDifficultyIndex < originalDifficultyIndex) {
                score += 15;
              }
            case AlternativeType.harder:
              final originalDifficultyIndex = DifficultyLevel.values.indexOf(
                originalExercise.difficulty,
              );
              final exerciseDifficultyIndex = DifficultyLevel.values.indexOf(
                exercise.difficulty,
              );
              if (exerciseDifficultyIndex > originalDifficultyIndex) {
                score += 15;
              }
            case AlternativeType.noEquipment:
              if (exercise.equipment.isEmpty) {
                score += 20;
              }
            case AlternativeType.similar:
              // Prefer exercises targeting similar muscle groups
              final commonMuscles =
                  exercise.targetMuscles
                      .where(
                        (muscle) =>
                            originalExercise.targetMuscles.contains(muscle),
                      )
                      .length;
              score += commonMuscles * 3;
          }

          return ScoredExercise(exercise, score);
        }).toList();

    // Sort by score and return the best alternative
    scoredAlternatives.sort((a, b) => b.score.compareTo(a.score));
    return scoredAlternatives.first.exercise;
  }

  Future<void> _logExerciseInteraction({
    required String userId,
    required String exerciseId,
    required String sessionId,
    required ExerciseAction action,
    SwipeDirection? direction,
    String? alternativeId,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      await _firestore.collection('exercise_interactions').add({
        'userId': userId,
        'exerciseId': exerciseId,
        'sessionId': sessionId,
        'action': action.name,
        'direction': direction?.name,
        'alternativeId': alternativeId,
        'metadata': metadata ?? {},
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e, stackTrace) {
      AppLogger.error('Error logging exercise interaction', e, stackTrace);
    }
  }
}

/// Result of exercise alternative request
class ExerciseAlternativeResult {
  const ExerciseAlternativeResult({
    required this.originalExerciseId,
    required this.alternative,
    required this.reason,
    required this.swipeDirection,
  });

  final String originalExerciseId;
  final Exercise? alternative;
  final String reason;
  final SwipeDirection swipeDirection;
}

/// Swipe directions for exercise alternatives
enum SwipeDirection {
  left, // Don't like this exercise
  right, // Can't do this exercise right now
  up, // Want a harder exercise
  down, // Want an exercise without equipment
}

/// Exercise actions for analytics
enum ExerciseAction { completed, skipped, swiped, alternativeRequested }

/// User preference types
enum PreferenceType { liked, disliked, cannotDo, wantsHarder, wantsNoEquipment }

/// Exercise analytics data
class ExerciseAnalytics {
  const ExerciseAnalytics({
    required this.totalExercisesCompleted,
    required this.totalExercisesSkipped,
    required this.totalSwipes,
    required this.completionRate,
    required this.favoriteCategories,
    required this.totalInteractions,
  });

  final int totalExercisesCompleted;
  final int totalExercisesSkipped;
  final int totalSwipes;
  final double completionRate;
  final List<String> favoriteCategories;
  final int totalInteractions;
}
