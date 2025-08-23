import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fitness_training_app/core/utils/logger.dart';

import 'package:fitness_training_app/shared/domain/entities/exercise.dart';

/// Service for learning and adapting to user exercise preferences
class UserPreferenceLearningService {
  UserPreferenceLearningService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  /// Learn from user's exercise interactions and update preferences
  Future<void> learnFromInteraction({
    required String userId,
    required String exerciseId,
    required ExerciseInteractionType interactionType,
    required Exercise exercise,
    Map<String, dynamic>? context,
  }) async {
    try {
      // Record the interaction
      await _recordInteraction(
        userId: userId,
        exerciseId: exerciseId,
        interactionType: interactionType,
        exercise: exercise,
        context: context,
      );

      // Update user preferences based on the interaction
      await _updatePreferencesFromInteraction(
        userId: userId,
        exercise: exercise,
        interactionType: interactionType,
        context: context,
      );

      AppLogger.info(
        'Learned from user interaction: $interactionType for exercise $exerciseId',
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error learning from user interaction', e, stackTrace);
    }
  }

  /// Get personalized exercise recommendations based on learned preferences
  Future<List<ExerciseRecommendation>> getPersonalizedRecommendations({
    required String userId,
    required List<Exercise> availableExercises,
    int limit = 10,
    ExerciseCategory? preferredCategory,
    DifficultyLevel? maxDifficulty,
  }) async {
    try {
      final preferences = await _getUserPreferences(userId);
      final interactionHistory = await _getRecentInteractions(
        userId,
        limit: 50,
      );

      final recommendations = <ExerciseRecommendation>[];

      for (final exercise in availableExercises) {
        final score = _calculateRecommendationScore(
          exercise: exercise,
          preferences: preferences,
          interactionHistory: interactionHistory,
          preferredCategory: preferredCategory,
          maxDifficulty: maxDifficulty,
        );

        if (score > 0) {
          recommendations.add(
            ExerciseRecommendation(
              exercise: exercise,
              score: score,
              reasons: _getRecommendationReasons(
                exercise,
                preferences,
                interactionHistory,
              ),
            ),
          );
        }
      }

      // Sort by score and return top recommendations
      recommendations.sort((a, b) => b.score.compareTo(a.score));
      return recommendations.take(limit).toList();
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error getting personalized recommendations',
        e,
        stackTrace,
      );
      return [];
    }
  }

  /// Get user's exercise preferences summary
  Future<UserPreferenceSummary> getPreferenceSummary(String userId) async {
    try {
      final preferences = await _getUserPreferences(userId);
      final interactions = await _getRecentInteractions(userId, limit: 100);

      final completedExercises =
          interactions
              .where(
                (i) => i.interactionType == ExerciseInteractionType.completed,
              )
              .length;

      final skippedExercises =
          interactions
              .where(
                (i) => i.interactionType == ExerciseInteractionType.skipped,
              )
              .length;

      final swipedExercises =
          interactions
              .where((i) => i.interactionType == ExerciseInteractionType.swiped)
              .length;

      // Calculate favorite categories
      final categoryCount = <ExerciseCategory, int>{};
      for (final interaction in interactions) {
        if (interaction.interactionType == ExerciseInteractionType.completed) {
          final category = interaction.exercise.category;
          categoryCount[category] = (categoryCount[category] ?? 0) + 1;
        }
      }

      final favoriteCategories =
          categoryCount.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));

      // Calculate preferred difficulty
      final difficultyCount = <DifficultyLevel, int>{};
      for (final interaction in interactions) {
        if (interaction.interactionType == ExerciseInteractionType.completed) {
          final difficulty = interaction.exercise.difficulty;
          difficultyCount[difficulty] = (difficultyCount[difficulty] ?? 0) + 1;
        }
      }

      final preferredDifficulties =
          difficultyCount.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));

      return UserPreferenceSummary(
        userId: userId,
        totalInteractions: interactions.length,
        completedExercises: completedExercises,
        skippedExercises: skippedExercises,
        swipedExercises: swipedExercises,
        completionRate:
            interactions.isNotEmpty
                ? completedExercises / interactions.length
                : 0.0,
        favoriteCategories:
            favoriteCategories.take(3).map((e) => e.key).toList(),
        preferredDifficulties:
            preferredDifficulties.take(2).map((e) => e.key).toList(),
        dislikedExercises: preferences.dislikedExercises,
        preferredEquipment: preferences.preferredEquipment,
        lastUpdated: DateTime.now(),
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error getting preference summary', e, stackTrace);
      return UserPreferenceSummary(
        userId: userId,
        totalInteractions: 0,
        completedExercises: 0,
        skippedExercises: 0,
        swipedExercises: 0,
        completionRate: 0.0,
        favoriteCategories: [],
        preferredDifficulties: [],
        dislikedExercises: [],
        preferredEquipment: [],
        lastUpdated: DateTime.now(),
      );
    }
  }

  /// Predict if user will like a specific exercise
  Future<ExerciseLikelihoodPrediction> predictExerciseLikelihood({
    required String userId,
    required Exercise exercise,
  }) async {
    try {
      final preferences = await _getUserPreferences(userId);
      final interactions = await _getRecentInteractions(userId, limit: 50);

      final likelihoodScore = _calculateLikelihoodScore(
        exercise: exercise,
        preferences: preferences,
        interactions: interactions,
      );

      final confidence = _calculatePredictionConfidence(interactions.length);

      return ExerciseLikelihoodPrediction(
        exercise: exercise,
        likelihoodScore: likelihoodScore,
        confidence: confidence,
        factors: _getLikelihoodFactors(exercise, preferences, interactions),
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error predicting exercise likelihood', e, stackTrace);
      return ExerciseLikelihoodPrediction(
        exercise: exercise,
        likelihoodScore: 0.5, // Neutral
        confidence: 0.0,
        factors: [],
      );
    }
  }

  // Private helper methods

  Future<void> _recordInteraction({
    required String userId,
    required String exerciseId,
    required ExerciseInteractionType interactionType,
    required Exercise exercise,
    Map<String, dynamic>? context,
  }) async {
    await _firestore.collection('user_exercise_interactions').add({
      'userId': userId,
      'exerciseId': exerciseId,
      'interactionType': interactionType.name,
      'exercise': exercise.toJson(),
      'context': context ?? {},
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> _updatePreferencesFromInteraction({
    required String userId,
    required Exercise exercise,
    required ExerciseInteractionType interactionType,
    Map<String, dynamic>? context,
  }) async {
    final preferencesRef = _firestore
        .collection('user_exercise_preferences')
        .doc(userId);

    final doc = await preferencesRef.get();
    final currentPreferences =
        doc.exists
            ? UserPreferences.fromMap(doc.data()!)
            : UserPreferences.empty(userId);

    final updatedPreferences = _applyInteractionToPreferences(
      currentPreferences,
      exercise,
      interactionType,
      context,
    );

    await preferencesRef.set(
      updatedPreferences.toMap(),
      SetOptions(merge: true),
    );
  }

  UserPreferences _applyInteractionToPreferences(
    UserPreferences current,
    Exercise exercise,
    ExerciseInteractionType interactionType,
    Map<String, dynamic>? context,
  ) {
    final updated = current.copyWith();

    switch (interactionType) {
      case ExerciseInteractionType.completed:
        // Increase preference for this category and difficulty
        updated.categoryPreferences[exercise.category] =
            (updated.categoryPreferences[exercise.category] ?? 0.5) + 0.1;
        updated.difficultyPreferences[exercise.difficulty] =
            (updated.difficultyPreferences[exercise.difficulty] ?? 0.5) + 0.05;

        // Increase preference for muscle groups
        for (final muscle in exercise.targetMuscles) {
          updated.muscleGroupPreferences[muscle] =
              (updated.muscleGroupPreferences[muscle] ?? 0.5) + 0.05;
        }

        // Increase preference for equipment (or lack thereof)
        if (exercise.equipment.isEmpty) {
          updated.equipmentPreferences['none'] =
              (updated.equipmentPreferences['none'] ?? 0.5) + 0.1;
        } else {
          for (final equipment in exercise.equipment) {
            updated.equipmentPreferences[equipment] =
                (updated.equipmentPreferences[equipment] ?? 0.5) + 0.05;
          }
        }
        break;

      case ExerciseInteractionType.skipped:
        // Slightly decrease preference for this category
        updated.categoryPreferences[exercise.category] =
            (updated.categoryPreferences[exercise.category] ?? 0.5) - 0.05;
        break;

      case ExerciseInteractionType.swiped:
        // Add to disliked exercises
        if (!updated.dislikedExercises.contains(exercise.id)) {
          updated.dislikedExercises.add(exercise.id);
        }

        // Decrease preference for this category
        updated.categoryPreferences[exercise.category] =
            (updated.categoryPreferences[exercise.category] ?? 0.5) - 0.1;
        break;

      case ExerciseInteractionType.liked:
        // Increase preferences significantly
        updated.categoryPreferences[exercise.category] =
            (updated.categoryPreferences[exercise.category] ?? 0.5) + 0.15;
        updated.difficultyPreferences[exercise.difficulty] =
            (updated.difficultyPreferences[exercise.difficulty] ?? 0.5) + 0.1;
        break;
    }

    // Clamp all preference values between 0 and 1
    updated.categoryPreferences.updateAll(
      (key, value) => value.clamp(0.0, 1.0),
    );
    updated.difficultyPreferences.updateAll(
      (key, value) => value.clamp(0.0, 1.0),
    );
    updated.muscleGroupPreferences.updateAll(
      (key, value) => value.clamp(0.0, 1.0),
    );
    updated.equipmentPreferences.updateAll(
      (key, value) => value.clamp(0.0, 1.0),
    );

    return updated;
  }

  Future<UserPreferences> _getUserPreferences(String userId) async {
    try {
      final doc =
          await _firestore
              .collection('user_exercise_preferences')
              .doc(userId)
              .get();

      if (doc.exists) {
        return UserPreferences.fromMap(doc.data()!);
      }
      return UserPreferences.empty(userId);
    } catch (e) {
      AppLogger.warning('Could not load user preferences: $e');
      return UserPreferences.empty(userId);
    }
  }

  Future<List<ExerciseInteraction>> _getRecentInteractions(
    String userId, {
    int limit = 50,
  }) async {
    try {
      final snapshot =
          await _firestore
              .collection('user_exercise_interactions')
              .where('userId', isEqualTo: userId)
              .orderBy('timestamp', descending: true)
              .limit(limit)
              .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return ExerciseInteraction(
          userId: data['userId'] as String,
          exerciseId: data['exerciseId'] as String,
          interactionType: ExerciseInteractionType.values.firstWhere(
            (type) => type.name == data['interactionType'],
            orElse: () => ExerciseInteractionType.completed,
          ),
          exercise: Exercise.fromJson(data['exercise'] as Map<String, dynamic>),
          context: Map<String, dynamic>.from(data['context'] as Map),
          timestamp: (data['timestamp'] as Timestamp).toDate(),
        );
      }).toList();
    } catch (e) {
      AppLogger.warning('Could not load user interactions: $e');
      return [];
    }
  }

  double _calculateRecommendationScore({
    required Exercise exercise,
    required UserPreferences preferences,
    required List<ExerciseInteraction> interactionHistory,
    ExerciseCategory? preferredCategory,
    DifficultyLevel? maxDifficulty,
  }) {
    double score = 0.5; // Base score

    // Category preference
    final categoryPref =
        preferences.categoryPreferences[exercise.category] ?? 0.5;
    score += (categoryPref - 0.5) * 0.3;

    // Difficulty preference
    final difficultyPref =
        preferences.difficultyPreferences[exercise.difficulty] ?? 0.5;
    score += (difficultyPref - 0.5) * 0.2;

    // Muscle group preferences
    double muscleScore = 0;
    for (final muscle in exercise.targetMuscles) {
      muscleScore += preferences.muscleGroupPreferences[muscle] ?? 0.5;
    }
    if (exercise.targetMuscles.isNotEmpty) {
      muscleScore /= exercise.targetMuscles.length;
      score += (muscleScore - 0.5) * 0.2;
    }

    // Equipment preferences
    if (exercise.equipment.isEmpty) {
      final noEquipmentPref = preferences.equipmentPreferences['none'] ?? 0.5;
      score += (noEquipmentPref - 0.5) * 0.1;
    } else {
      double equipmentScore = 0;
      for (final equipment in exercise.equipment) {
        equipmentScore += preferences.equipmentPreferences[equipment] ?? 0.5;
      }
      equipmentScore /= exercise.equipment.length;
      score += (equipmentScore - 0.5) * 0.1;
    }

    // Penalize disliked exercises
    if (preferences.dislikedExercises.contains(exercise.id)) {
      score -= 0.5;
    }

    // Recent interaction penalty (avoid repetition)
    final recentInteractions = interactionHistory.take(10);
    final recentExerciseIds =
        recentInteractions.map((i) => i.exerciseId).toSet();
    if (recentExerciseIds.contains(exercise.id)) {
      score -= 0.2;
    }

    // Apply filters
    if (preferredCategory != null && exercise.category != preferredCategory) {
      score -= 0.3;
    }

    if (maxDifficulty != null) {
      final exerciseDifficultyIndex = DifficultyLevel.values.indexOf(
        exercise.difficulty,
      );
      final maxDifficultyIndex = DifficultyLevel.values.indexOf(maxDifficulty);
      if (exerciseDifficultyIndex > maxDifficultyIndex) {
        score -= 0.4;
      }
    }

    return score.clamp(0.0, 1.0);
  }

  List<String> _getRecommendationReasons(
    Exercise exercise,
    UserPreferences preferences,
    List<ExerciseInteraction> interactionHistory,
  ) {
    final reasons = <String>[];

    // Category preference
    final categoryPref =
        preferences.categoryPreferences[exercise.category] ?? 0.5;
    if (categoryPref > 0.7) {
      reasons.add('You enjoy ${exercise.category.name} exercises');
    }

    // Difficulty preference
    final difficultyPref =
        preferences.difficultyPreferences[exercise.difficulty] ?? 0.5;
    if (difficultyPref > 0.7) {
      reasons.add('Matches your preferred difficulty level');
    }

    // Equipment preference
    if (exercise.equipment.isEmpty) {
      final noEquipmentPref = preferences.equipmentPreferences['none'] ?? 0.5;
      if (noEquipmentPref > 0.7) {
        reasons.add('No equipment needed');
      }
    }

    // Muscle group preference
    for (final muscle in exercise.targetMuscles) {
      final musclePref = preferences.muscleGroupPreferences[muscle] ?? 0.5;
      if (musclePref > 0.7) {
        reasons.add('Targets your preferred muscle groups');
        break;
      }
    }

    if (reasons.isEmpty) {
      reasons.add('Recommended based on your activity');
    }

    return reasons;
  }

  double _calculateLikelihoodScore({
    required Exercise exercise,
    required UserPreferences preferences,
    required List<ExerciseInteraction> interactions,
  }) {
    // Similar to recommendation score but focused on likelihood
    return _calculateRecommendationScore(
      exercise: exercise,
      preferences: preferences,
      interactionHistory: interactions,
    );
  }

  double _calculatePredictionConfidence(int interactionCount) {
    // Confidence increases with more interactions
    return min(1.0, interactionCount / 50.0);
  }

  List<String> _getLikelihoodFactors(
    Exercise exercise,
    UserPreferences preferences,
    List<ExerciseInteraction> interactions,
  ) {
    return _getRecommendationReasons(exercise, preferences, interactions);
  }
}

// Data classes

enum ExerciseInteractionType { completed, skipped, swiped, liked }

class ExerciseInteraction {
  const ExerciseInteraction({
    required this.userId,
    required this.exerciseId,
    required this.interactionType,
    required this.exercise,
    required this.context,
    required this.timestamp,
  });

  final String userId;
  final String exerciseId;
  final ExerciseInteractionType interactionType;
  final Exercise exercise;
  final Map<String, dynamic> context;
  final DateTime timestamp;
}

class UserPreferences {
  UserPreferences({
    required this.userId,
    required this.categoryPreferences,
    required this.difficultyPreferences,
    required this.muscleGroupPreferences,
    required this.equipmentPreferences,
    required this.dislikedExercises,
    required this.preferredEquipment,
    required this.lastUpdated,
  });

  factory UserPreferences.empty(String userId) {
    return UserPreferences(
      userId: userId,
      categoryPreferences: {},
      difficultyPreferences: {},
      muscleGroupPreferences: {},
      equipmentPreferences: {},
      dislikedExercises: [],
      preferredEquipment: [],
      lastUpdated: DateTime.now(),
    );
  }

  factory UserPreferences.fromMap(Map<String, dynamic> map) {
    return UserPreferences(
      userId: map['userId'] as String,
      categoryPreferences: Map<ExerciseCategory, double>.from(
        (map['categoryPreferences'] as Map<String, dynamic>? ?? {}).map(
          (key, value) => MapEntry(
            ExerciseCategory.values.firstWhere((c) => c.name == key),
            (value as num).toDouble(),
          ),
        ),
      ),
      difficultyPreferences: Map<DifficultyLevel, double>.from(
        (map['difficultyPreferences'] as Map<String, dynamic>? ?? {}).map(
          (key, value) => MapEntry(
            DifficultyLevel.values.firstWhere((d) => d.name == key),
            (value as num).toDouble(),
          ),
        ),
      ),
      muscleGroupPreferences: Map<MuscleGroup, double>.from(
        (map['muscleGroupPreferences'] as Map<String, dynamic>? ?? {}).map(
          (key, value) => MapEntry(
            MuscleGroup.values.firstWhere((m) => m.name == key),
            (value as num).toDouble(),
          ),
        ),
      ),
      equipmentPreferences: Map<String, double>.from(
        map['equipmentPreferences'] as Map<String, dynamic>? ?? {},
      ),
      dislikedExercises: List<String>.from(
        map['dislikedExercises'] as List<dynamic>? ?? [],
      ),
      preferredEquipment: List<String>.from(
        map['preferredEquipment'] as List<dynamic>? ?? [],
      ),
      lastUpdated: DateTime.parse(map['lastUpdated'] as String),
    );
  }

  final String userId;
  final Map<ExerciseCategory, double> categoryPreferences;
  final Map<DifficultyLevel, double> difficultyPreferences;
  final Map<MuscleGroup, double> muscleGroupPreferences;
  final Map<String, double> equipmentPreferences;
  final List<String> dislikedExercises;
  final List<String> preferredEquipment;
  final DateTime lastUpdated;

  UserPreferences copyWith() {
    return UserPreferences(
      userId: userId,
      categoryPreferences: Map.from(categoryPreferences),
      difficultyPreferences: Map.from(difficultyPreferences),
      muscleGroupPreferences: Map.from(muscleGroupPreferences),
      equipmentPreferences: Map.from(equipmentPreferences),
      dislikedExercises: List.from(dislikedExercises),
      preferredEquipment: List.from(preferredEquipment),
      lastUpdated: lastUpdated,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'categoryPreferences': categoryPreferences.map(
        (key, value) => MapEntry(key.name, value),
      ),
      'difficultyPreferences': difficultyPreferences.map(
        (key, value) => MapEntry(key.name, value),
      ),
      'muscleGroupPreferences': muscleGroupPreferences.map(
        (key, value) => MapEntry(key.name, value),
      ),
      'equipmentPreferences': equipmentPreferences,
      'dislikedExercises': dislikedExercises,
      'preferredEquipment': preferredEquipment,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}

class ExerciseRecommendation {
  const ExerciseRecommendation({
    required this.exercise,
    required this.score,
    required this.reasons,
  });

  final Exercise exercise;
  final double score;
  final List<String> reasons;
}

class UserPreferenceSummary {
  const UserPreferenceSummary({
    required this.userId,
    required this.totalInteractions,
    required this.completedExercises,
    required this.skippedExercises,
    required this.swipedExercises,
    required this.completionRate,
    required this.favoriteCategories,
    required this.preferredDifficulties,
    required this.dislikedExercises,
    required this.preferredEquipment,
    required this.lastUpdated,
  });

  final String userId;
  final int totalInteractions;
  final int completedExercises;
  final int skippedExercises;
  final int swipedExercises;
  final double completionRate;
  final List<ExerciseCategory> favoriteCategories;
  final List<DifficultyLevel> preferredDifficulties;
  final List<String> dislikedExercises;
  final List<String> preferredEquipment;
  final DateTime lastUpdated;
}

class ExerciseLikelihoodPrediction {
  const ExerciseLikelihoodPrediction({
    required this.exercise,
    required this.likelihoodScore,
    required this.confidence,
    required this.factors,
  });

  final Exercise exercise;
  final double likelihoodScore; // 0.0 to 1.0
  final double confidence; // 0.0 to 1.0
  final List<String> factors;
}
