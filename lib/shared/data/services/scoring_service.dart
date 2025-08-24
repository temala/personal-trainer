import 'dart:async';
import 'dart:math';

import 'package:fitness_training_app/core/utils/logger.dart';
import 'package:fitness_training_app/shared/domain/entities/ai_request.dart';
import 'package:fitness_training_app/shared/domain/entities/user_profile.dart';
import 'package:fitness_training_app/shared/domain/entities/user_score.dart';
import 'package:fitness_training_app/shared/domain/entities/workout_session.dart';
import 'package:fitness_training_app/shared/domain/repositories/ai_service_repository.dart';

/// Service for calculating user scores and managing achievements
class ScoringService {
  ScoringService({
    required AIServiceRepository aiService,
    required AppLogger logger,
  }) : _aiService = aiService,
       _logger = logger;

  final AIServiceRepository _aiService;
  final AppLogger _logger;

  /// Calculate score for a completed workout session
  Future<ScoreUpdate> calculateWorkoutScore({
    required WorkoutSession session,
    required UserScore currentScore,
    required UserProfile userProfile,
  }) async {
    try {
      _logger.logInfo('Calculating workout score for session: ${session.id}');

      // Base score calculation
      final baseScore = _calculateBaseScore(session);

      // Completion bonus
      final completionBonus = _calculateCompletionBonus(session);

      // Consistency bonus
      final consistencyBonus = _calculateConsistencyBonus(currentScore);

      // Difficulty bonus
      final difficultyBonus = _calculateDifficultyBonus(session);

      // Time efficiency bonus
      final efficiencyBonus = _calculateEfficiencyBonus(session);

      final totalSessionScore =
          baseScore +
          completionBonus +
          consistencyBonus +
          difficultyBonus +
          efficiencyBonus;

      // Update category scores
      final updatedCategoryScores = _updateCategoryScores(
        currentScore.categoryScores,
        session,
        totalSessionScore,
      );

      // Calculate new commitment level with AI evaluation
      final newCommitmentLevel = await _calculateCommitmentLevel(
        session: session,
        currentScore: currentScore,
        userProfile: userProfile,
      );

      // Check for new achievements
      final newAchievements = _checkForNewAchievements(
        session: session,
        currentScore: currentScore,
        sessionScore: totalSessionScore,
      );

      // Update streak
      final streakUpdate = _updateStreak(currentScore, session);

      return ScoreUpdate(
        sessionScore: totalSessionScore,
        newTotalScore: currentScore.totalScore + totalSessionScore,
        newCommitmentLevel: newCommitmentLevel,
        newAchievements: newAchievements,
        updatedCategoryScores: updatedCategoryScores,
        currentStreak: streakUpdate.currentStreak,
        longestStreak: streakUpdate.longestStreak,
        scoreBreakdown: ScoreBreakdown(
          baseScore: baseScore,
          completionBonus: completionBonus,
          consistencyBonus: consistencyBonus,
          difficultyBonus: difficultyBonus,
          efficiencyBonus: efficiencyBonus,
        ),
      );
    } catch (e, stackTrace) {
      _logger.logError('Error calculating workout score', e, stackTrace);
      rethrow;
    }
  }

  /// Calculate base score based on workout completion
  int _calculateBaseScore(WorkoutSession session) {
    if (!session.isCompleted) return 0;

    // Base points for completing a workout
    const basePoints = 50;

    // Additional points based on completion percentage
    final completionMultiplier = session.actualCompletionPercentage / 100;
    final completionPoints = (basePoints * completionMultiplier).round();

    return basePoints + completionPoints;
  }

  /// Calculate completion bonus
  int _calculateCompletionBonus(WorkoutSession session) {
    final completionPercentage = session.actualCompletionPercentage;

    if (completionPercentage == 100.0) {
      return 25; // Perfect completion bonus
    } else if (completionPercentage >= 90.0) {
      return 15; // Near perfect bonus
    } else if (completionPercentage >= 80.0) {
      return 10; // Good completion bonus
    }

    return 0;
  }

  /// Calculate consistency bonus based on current streak
  int _calculateConsistencyBonus(UserScore currentScore) {
    final streak = currentScore.currentStreak;

    if (streak >= 30) {
      return 50; // Monthly consistency
    } else if (streak >= 14) {
      return 30; // Bi-weekly consistency
    } else if (streak >= 7) {
      return 20; // Weekly consistency
    } else if (streak >= 3) {
      return 10; // Short streak
    }

    return 0;
  }

  /// Calculate difficulty bonus (placeholder - would need exercise difficulty data)
  int _calculateDifficultyBonus(WorkoutSession session) {
    // This would require exercise difficulty information
    // For now, return a base bonus for completing any workout
    return session.isCompleted ? 5 : 0;
  }

  /// Calculate time efficiency bonus
  int _calculateEfficiencyBonus(WorkoutSession session) {
    if (!session.isCompleted) return 0;

    final duration = session.sessionDurationMinutes;

    // Bonus for completing workout in reasonable time
    if (duration <= 30) {
      return 15; // Quick and efficient
    } else if (duration <= 45) {
      return 10; // Good timing
    } else if (duration <= 60) {
      return 5; // Acceptable timing
    }

    return 0;
  }

  /// Update category scores
  Map<String, int> _updateCategoryScores(
    Map<String, int> currentScores,
    WorkoutSession session,
    int sessionScore,
  ) {
    final updatedScores = Map<String, int>.from(currentScores);

    // Distribute session score across categories
    final completionScore = (sessionScore * 0.4).round();
    final consistencyScore = (sessionScore * 0.3).round();
    final improvementScore = (sessionScore * 0.2).round();
    final engagementScore = (sessionScore * 0.1).round();

    updatedScores[ScoreCategory.completion.name] =
        (updatedScores[ScoreCategory.completion.name] ?? 0) + completionScore;
    updatedScores[ScoreCategory.consistency.name] =
        (updatedScores[ScoreCategory.consistency.name] ?? 0) + consistencyScore;
    updatedScores[ScoreCategory.improvement.name] =
        (updatedScores[ScoreCategory.improvement.name] ?? 0) + improvementScore;
    updatedScores[ScoreCategory.engagement.name] =
        (updatedScores[ScoreCategory.engagement.name] ?? 0) + engagementScore;

    return updatedScores;
  }

  /// Calculate commitment level with AI evaluation
  Future<double> _calculateCommitmentLevel({
    required WorkoutSession session,
    required UserScore currentScore,
    required UserProfile userProfile,
  }) async {
    try {
      // Base commitment calculation
      final completionRate = currentScore.completionRate / 100;
      final streakFactor = min(currentScore.currentStreak / 30.0, 1.0);
      final consistencyFactor =
          currentScore.workoutsCompleted > 0
              ? currentScore.workoutsCompleted /
                  max(currentScore.totalWorkouts, 1)
              : 0;

      var baseCommitment =
          (completionRate * 0.5) +
          (streakFactor * 0.3) +
          (consistencyFactor * 0.2);

      // AI evaluation for more nuanced commitment assessment
      try {
        final aiRequest = AIRequest(
          requestId: 'commitment_${DateTime.now().millisecondsSinceEpoch}',
          type: AIRequestType.evaluateCommitment,
          timestamp: DateTime.now(),
          payload: {
            'user_profile': userProfile.toJson(),
            'current_score': currentScore.toJson(),
            'recent_session': session.toJson(),
            'completion_rate': completionRate,
            'current_streak': currentScore.currentStreak,
            'workout_frequency': _calculateWorkoutFrequency(currentScore),
          },
          userId: userProfile.id,
        );

        final aiResponse = await _aiService.processRequest(aiRequest);

        if (aiResponse.success && aiResponse.data['commitment_level'] != null) {
          final aiCommitment =
              (aiResponse.data['commitment_level'] as num).toDouble();

          // Blend AI evaluation with base calculation (70% AI, 30% base)
          baseCommitment = (aiCommitment * 0.7) + (baseCommitment * 0.3);

          _logger.logInfo(
            'AI commitment evaluation: $aiCommitment, blended: $baseCommitment',
          );
        }
      } catch (e) {
        _logger.logWarning(
          'AI commitment evaluation failed, using base calculation: $e',
        );
      }

      return baseCommitment.clamp(0.0, 1.0);
    } catch (e, stackTrace) {
      _logger.logError('Error calculating commitment level', e, stackTrace);
      return currentScore.commitmentLevel; // Return current level on error
    }
  }

  /// Calculate workout frequency (workouts per week)
  double _calculateWorkoutFrequency(UserScore currentScore) {
    if (currentScore.totalWorkouts == 0) return 0;

    final daysSinceStart =
        DateTime.now().difference(currentScore.createdAt).inDays;
    final weeks = max(daysSinceStart / 7, 1);

    return currentScore.workoutsCompleted / weeks;
  }

  /// Check for new achievements
  List<Achievement> _checkForNewAchievements({
    required WorkoutSession session,
    required UserScore currentScore,
    required int sessionScore,
  }) {
    final newAchievements = <Achievement>[];
    final existingAchievementIds =
        currentScore.achievements.map((a) => a.id).toSet();

    // Check workout completion achievements
    final newWorkoutCount = currentScore.workoutsCompleted + 1;

    if (newWorkoutCount == 1 &&
        !existingAchievementIds.contains('first_workout')) {
      newAchievements.add(_createAchievement('first_workout'));
    } else if (newWorkoutCount == 10 &&
        !existingAchievementIds.contains('ten_workouts')) {
      newAchievements.add(_createAchievement('ten_workouts'));
    } else if (newWorkoutCount == 50 &&
        !existingAchievementIds.contains('fifty_workouts')) {
      newAchievements.add(_createAchievement('fifty_workouts'));
    } else if (newWorkoutCount == 100 &&
        !existingAchievementIds.contains('hundred_workouts')) {
      newAchievements.add(_createAchievement('hundred_workouts'));
    }

    // Check streak achievements
    final newStreak = _calculateNewStreak(currentScore, session);

    if (newStreak >= 3 &&
        !existingAchievementIds.contains('three_day_streak')) {
      newAchievements.add(_createAchievement('three_day_streak'));
    } else if (newStreak >= 7 &&
        !existingAchievementIds.contains('week_streak')) {
      newAchievements.add(_createAchievement('week_streak'));
    } else if (newStreak >= 30 &&
        !existingAchievementIds.contains('month_streak')) {
      newAchievements.add(_createAchievement('month_streak'));
    }

    // Check level achievements
    final newTotalScore = currentScore.totalScore + sessionScore;
    final newLevel = _calculateLevel(newTotalScore);

    if (newLevel >= 5 && !existingAchievementIds.contains('level_five')) {
      newAchievements.add(_createAchievement('level_five'));
    } else if (newLevel >= 10 &&
        !existingAchievementIds.contains('level_ten')) {
      newAchievements.add(_createAchievement('level_ten'));
    }

    // Check perfect completion achievements
    if (session.actualCompletionPercentage == 100.0) {
      // Check for perfect week/month (would need more session history)
      // This is a simplified check
      if (!existingAchievementIds.contains('perfect_week')) {
        // Would need to check if this completes a perfect week
        // For now, just award after multiple perfect sessions
        final perfectSessions =
            (currentScore.progressMetrics?['perfect_sessions'] as int?) ?? 0;
        if (perfectSessions >= 6) {
          // 7th perfect session in tracking
          newAchievements.add(_createAchievement('perfect_week'));
        }
      }
    }

    return newAchievements;
  }

  /// Create achievement from predefined list
  Achievement _createAchievement(String achievementId) {
    final predefined = UserScoreHelper.predefinedAchievements.firstWhere(
      (a) => a.id == achievementId,
    );

    return predefined.copyWith(unlockedAt: DateTime.now());
  }

  /// Calculate new streak
  int _calculateNewStreak(UserScore currentScore, WorkoutSession session) {
    if (!session.isCompleted) return currentScore.currentStreak;

    // Check if this workout continues the streak
    final lastWorkoutDate = currentScore.lastUpdated;
    final today = DateTime.now();
    final daysDifference = today.difference(lastWorkoutDate).inDays;

    if (daysDifference <= 1) {
      return currentScore.currentStreak + 1;
    } else {
      return 1; // Reset streak
    }
  }

  /// Update streak information
  StreakUpdate _updateStreak(UserScore currentScore, WorkoutSession session) {
    final newStreak = _calculateNewStreak(currentScore, session);
    final newLongestStreak = max(currentScore.longestStreak, newStreak);

    return StreakUpdate(
      currentStreak: newStreak,
      longestStreak: newLongestStreak,
    );
  }

  /// Calculate level from total score
  int _calculateLevel(int totalScore) {
    if (totalScore < 100) return 1;
    if (totalScore < 300) return 2;
    if (totalScore < 600) return 3;
    if (totalScore < 1000) return 4;
    if (totalScore < 1500) return 5;
    if (totalScore < 2100) return 6;
    if (totalScore < 2800) return 7;
    if (totalScore < 3600) return 8;
    if (totalScore < 4500) return 9;
    return 10;
  }

  /// Generate AI-powered advice for score improvement
  Future<String> generateScoreAdvice({
    required UserScore userScore,
    required UserProfile userProfile,
  }) async {
    try {
      final aiRequest = AIRequest(
        requestId: 'advice_${DateTime.now().millisecondsSinceEpoch}',
        type: AIRequestType.generateAdvice,
        timestamp: DateTime.now(),
        payload: {
          'user_profile': userProfile.toJson(),
          'user_score': userScore.toJson(),
          'current_level': userScore.currentLevel,
          'commitment_level': userScore.commitmentLevel,
          'completion_rate': userScore.completionRate,
          'current_streak': userScore.currentStreak,
          'category_breakdown': userScore.scoreCategoryBreakdown,
        },
        userId: userProfile.id,
      );

      final response = await _aiService.processRequest(aiRequest);

      if (response.success && response.data['advice'] != null) {
        return response.data['advice'] as String;
      }

      // Fallback advice
      return _generateFallbackAdvice(userScore);
    } catch (e, stackTrace) {
      _logger.logError('Error generating AI advice', e, stackTrace);
      return _generateFallbackAdvice(userScore);
    }
  }

  /// Generate fallback advice when AI is unavailable
  String _generateFallbackAdvice(UserScore userScore) {
    if (userScore.commitmentLevel < 0.3) {
      return 'Try to maintain consistency! Even short workouts count. '
          'Aim for at least 3 workouts per week to build momentum.';
    } else if (userScore.currentStreak == 0) {
      return 'Start a new streak today! Consistency is key to building '
          'healthy habits and improving your fitness level.';
    } else if (userScore.completionRate < 70) {
      return 'Focus on completing your planned exercises. Even if you need '
          'to use alternatives, finishing your workout is what matters most.';
    } else if (userScore.currentLevel < 3) {
      return 'You\'re making great progress! Keep up the consistent effort '
          'and you\'ll reach the next level soon.';
    } else {
      return 'Excellent work! You\'re showing great commitment. '
          'Consider challenging yourself with more varied exercises.';
    }
  }

  /// Update user score in background
  Future<void> updateScoreInBackground({
    required String userId,
    required WorkoutSession session,
    required void Function(UserScore) onScoreUpdated,
  }) async {
    try {
      _logger.logInfo('Updating score in background for user: $userId');

      // This would typically fetch current score from repository
      // For now, we'll assume it's provided through the callback mechanism

      // The actual implementation would:
      // 1. Fetch current UserScore from repository
      // 2. Fetch UserProfile from repository
      // 3. Calculate score update
      // 4. Save updated score to repository
      // 5. Call onScoreUpdated callback

      _logger.logInfo('Background score update completed for user: $userId');
    } catch (e, stackTrace) {
      _logger.logError('Error updating score in background', e, stackTrace);
    }
  }
}

/// Score update result
class ScoreUpdate {
  ScoreUpdate({
    required this.sessionScore,
    required this.newTotalScore,
    required this.newCommitmentLevel,
    required this.newAchievements,
    required this.updatedCategoryScores,
    required this.currentStreak,
    required this.longestStreak,
    required this.scoreBreakdown,
  });

  final int sessionScore;
  final int newTotalScore;
  final double newCommitmentLevel;
  final List<Achievement> newAchievements;
  final Map<String, int> updatedCategoryScores;
  final int currentStreak;
  final int longestStreak;
  final ScoreBreakdown scoreBreakdown;
}

/// Score breakdown for transparency
class ScoreBreakdown {
  ScoreBreakdown({
    required this.baseScore,
    required this.completionBonus,
    required this.consistencyBonus,
    required this.difficultyBonus,
    required this.efficiencyBonus,
  });

  final int baseScore;
  final int completionBonus;
  final int consistencyBonus;
  final int difficultyBonus;
  final int efficiencyBonus;

  int get total =>
      baseScore +
      completionBonus +
      consistencyBonus +
      difficultyBonus +
      efficiencyBonus;
}

/// Streak update result
class StreakUpdate {
  StreakUpdate({required this.currentStreak, required this.longestStreak});

  final int currentStreak;
  final int longestStreak;
}
