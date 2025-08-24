import 'dart:math' as math;

import 'package:fitness_training_app/core/utils/logger.dart';
import 'package:fitness_training_app/shared/data/services/exercise_animation_service.dart';
import 'package:fitness_training_app/shared/domain/entities/exercise.dart';
import 'package:fitness_training_app/shared/domain/entities/workout_session.dart';

/// Service for managing celebration content and achievements
class CelebrationService {
  CelebrationService();

  /// Generate celebration data based on exercise completion
  Map<String, dynamic> generateCelebrationData({
    required Exercise exercise,
    required WorkoutSession session,
    Map<String, dynamic>? userStats,
  }) {
    try {
      final celebrationData = <String, dynamic>{};

      // Determine celebration type
      final celebrationType = _determineCelebrationType(
        exercise: exercise,
        session: session,
        userStats: userStats,
      );

      celebrationData['type'] = celebrationType;
      celebrationData['exercise'] = exercise;

      // Add achievement-specific data
      switch (celebrationType) {
        case CelebrationType.exerciseComplete:
          celebrationData.addAll(_generateExerciseCompleteData(exercise));

        case CelebrationType.workoutComplete:
          celebrationData.addAll(_generateWorkoutCompleteData(session));

        case CelebrationType.personalRecord:
          celebrationData.addAll(
            _generatePersonalRecordData(exercise, userStats),
          );

        case CelebrationType.streakAchieved:
          celebrationData.addAll(_generateStreakData(userStats));

        case CelebrationType.goalReached:
          celebrationData.addAll(_generateGoalData(userStats));
      }

      // Add motivational messages
      celebrationData['messages'] = _generateMotivationalMessages(
        celebrationType,
      );

      // Add score calculation
      celebrationData['score'] = _calculateScore(
        celebrationType,
        celebrationData,
      );

      AppLogger.info('Generated celebration data for ${celebrationType.name}');
      return celebrationData;
    } catch (e, stackTrace) {
      AppLogger.error('Error generating celebration data', e, stackTrace);
      return _getDefaultCelebrationData(exercise);
    }
  }

  /// Determine the appropriate celebration type
  CelebrationType _determineCelebrationType({
    required Exercise exercise,
    required WorkoutSession session,
    Map<String, dynamic>? userStats,
  }) {
    // Check for goal achievement
    if (userStats != null && _isGoalReached(userStats)) {
      return CelebrationType.goalReached;
    }

    // Check for personal record
    if (userStats != null && _isPersonalRecord(exercise, userStats)) {
      return CelebrationType.personalRecord;
    }

    // Check for streak achievement
    if (userStats != null && _isStreakAchievement(userStats)) {
      return CelebrationType.streakAchieved;
    }

    // Check if workout is complete
    if (_isWorkoutComplete(session)) {
      return CelebrationType.workoutComplete;
    }

    // Default to exercise complete
    return CelebrationType.exerciseComplete;
  }

  /// Generate data for exercise completion
  Map<String, dynamic> _generateExerciseCompleteData(Exercise exercise) {
    return {
      'title': 'Exercise Complete!',
      'subtitle': 'Great job completing ${exercise.name}!',
      'baseScore': 10,
      'difficultyBonus': _getDifficultyBonus(exercise.difficulty),
    };
  }

  /// Generate data for workout completion
  Map<String, dynamic> _generateWorkoutCompleteData(WorkoutSession session) {
    final completedCount = session.completedExercisesCount;
    final totalExercises = session.totalExercisesCount;
    final completionRate = completedCount / totalExercises;

    return {
      'title': 'Workout Complete!',
      'subtitle':
          'You completed $completedCount out of $totalExercises exercises!',
      'completedExercises': completedCount,
      'totalExercises': totalExercises,
      'completionRate': completionRate,
      'baseScore': 50,
      'completionBonus': (completionRate * 25).round(),
    };
  }

  /// Generate data for personal record
  Map<String, dynamic> _generatePersonalRecordData(
    Exercise exercise,
    Map<String, dynamic>? userStats,
  ) {
    final previousBest = userStats?['previousBest'] ?? 0;
    final currentPerformance = userStats?['currentPerformance'] ?? 0;
    final improvement = (currentPerformance as num) - (previousBest as num);

    return {
      'title': 'New Personal Record!',
      'subtitle': 'You improved by $improvement on ${exercise.name}!',
      'previousBest': previousBest,
      'currentPerformance': currentPerformance,
      'improvement': improvement,
      'personalRecord': true,
      'baseScore': 30,
      'recordBonus': math.min(improvement * 2, 50).round(),
    };
  }

  /// Generate data for streak achievement
  Map<String, dynamic> _generateStreakData(Map<String, dynamic>? userStats) {
    final streak = userStats?['currentStreak'] ?? 1;
    final streakMilestone = _getStreakMilestone((streak as num).toInt());

    return {
      'title': 'Streak Achievement!',
      'subtitle': "You've maintained a $streak day streak!",
      'streak': streak,
      'milestone': streakMilestone,
      'baseScore': 20,
      'streakBonus': (streak as num).toInt() * 2,
    };
  }

  /// Generate data for goal achievement
  Map<String, dynamic> _generateGoalData(Map<String, dynamic>? userStats) {
    final goalType = userStats?['goalType'] ?? 'fitness';
    final goalProgress = userStats?['goalProgress'] ?? 100;

    return {
      'title': 'Goal Achieved!',
      'subtitle': "You've reached your $goalType goal!",
      'goalType': goalType,
      'progress': goalProgress,
      'baseScore': 100,
      'goalBonus': 50,
    };
  }

  /// Generate motivational messages based on celebration type
  List<String> _generateMotivationalMessages(CelebrationType type) {
    final messages = <String>[];

    switch (type) {
      case CelebrationType.exerciseComplete:
        messages.addAll([
          'Every rep counts!',
          "You're getting stronger!",
          'Keep up the great work!',
          'One step closer to your goals!',
        ]);

      case CelebrationType.workoutComplete:
        messages.addAll([
          'Amazing dedication!',
          'You crushed that workout!',
          'Your consistency is paying off!',
          "You're unstoppable!",
        ]);

      case CelebrationType.personalRecord:
        messages.addAll([
          "You're breaking barriers!",
          'New limits unlocked!',
          'Your hard work is showing!',
          'Record breaker!',
        ]);

      case CelebrationType.streakAchieved:
        messages.addAll([
          'Consistency is key!',
          "You're on fire!",
          'Building healthy habits!',
          'Streak master!',
        ]);

      case CelebrationType.goalReached:
        messages.addAll([
          'Dreams become reality!',
          'Goal crusher!',
          'You did it!',
          'Success achieved!',
        ]);
    }

    // Shuffle and return a subset
    messages.shuffle();
    return messages.take(2).toList();
  }

  /// Calculate score based on celebration type and data
  int _calculateScore(CelebrationType type, Map<String, dynamic> data) {
    var score = data['baseScore'] as int? ?? 10;

    // Add type-specific bonuses
    switch (type) {
      case CelebrationType.exerciseComplete:
        score += data['difficultyBonus'] as int? ?? 0;

      case CelebrationType.workoutComplete:
        score += data['completionBonus'] as int? ?? 0;

      case CelebrationType.personalRecord:
        score += data['recordBonus'] as int? ?? 0;

      case CelebrationType.streakAchieved:
        score += data['streakBonus'] as int? ?? 0;

      case CelebrationType.goalReached:
        score += data['goalBonus'] as int? ?? 0;
    }

    return score;
  }

  /// Get difficulty bonus for exercise
  int _getDifficultyBonus(DifficultyLevel difficulty) {
    switch (difficulty) {
      case DifficultyLevel.beginner:
        return 2;
      case DifficultyLevel.intermediate:
        return 5;
      case DifficultyLevel.advanced:
        return 8;
      case DifficultyLevel.expert:
        return 12;
    }
  }

  /// Check if goal is reached
  bool _isGoalReached(Map<String, dynamic> userStats) {
    final goalProgress = userStats['goalProgress'] as double? ?? 0;
    return goalProgress >= 100;
  }

  /// Check if this is a personal record
  bool _isPersonalRecord(Exercise exercise, Map<String, dynamic> userStats) {
    final previousBest = userStats['previousBest'] as int? ?? 0;
    final currentPerformance = userStats['currentPerformance'] as int? ?? 0;
    return currentPerformance > previousBest;
  }

  /// Check if this is a streak achievement
  bool _isStreakAchievement(Map<String, dynamic> userStats) {
    final streak = userStats['currentStreak'] as int? ?? 0;
    final milestones = [3, 7, 14, 30, 60, 100];
    return milestones.contains(streak);
  }

  /// Check if workout is complete
  bool _isWorkoutComplete(WorkoutSession session) {
    return session.status == SessionStatus.completed;
  }

  /// Get streak milestone description
  String _getStreakMilestone(int streak) {
    if (streak >= 100) return 'Century Club!';
    if (streak >= 60) return 'Two Month Warrior!';
    if (streak >= 30) return 'Monthly Master!';
    if (streak >= 14) return 'Two Week Champion!';
    if (streak >= 7) return 'Week Warrior!';
    if (streak >= 3) return 'Three Day Hero!';
    return 'Getting Started!';
  }

  /// Get default celebration data as fallback
  Map<String, dynamic> _getDefaultCelebrationData(Exercise exercise) {
    return {
      'type': CelebrationType.exerciseComplete,
      'exercise': exercise,
      'title': 'Exercise Complete!',
      'subtitle': 'Great job completing ${exercise.name}!',
      'messages': ['Keep up the great work!', "You're getting stronger!"],
      'score': 10,
      'baseScore': 10,
      'difficultyBonus': 0,
    };
  }

  /// Generate random celebration effects
  Map<String, dynamic> generateCelebrationEffects(CelebrationType type) {
    final random = math.Random();

    return {
      'confettiCount': _getConfettiCount(type),
      'confettiColors': _getConfettiColors(type),
      'animationDuration': _getAnimationDuration(type),
      'particleSize': random.nextDouble() * 3 + 2,
      'sparkleIntensity': _getSparkleIntensity(type),
    };
  }

  int _getConfettiCount(CelebrationType type) {
    switch (type) {
      case CelebrationType.exerciseComplete:
        return 30;
      case CelebrationType.workoutComplete:
        return 50;
      case CelebrationType.personalRecord:
        return 60;
      case CelebrationType.streakAchieved:
        return 40;
      case CelebrationType.goalReached:
        return 80;
    }
  }

  List<int> _getConfettiColors(CelebrationType type) {
    // Return color values as integers
    switch (type) {
      case CelebrationType.exerciseComplete:
        return [0xFF6C63FF, 0xFFFF6B9D, 0xFF4ECDC4];
      case CelebrationType.workoutComplete:
        return [0xFFFFD700, 0xFFFF6B9D, 0xFF4ECDC4];
      case CelebrationType.personalRecord:
        return [0xFFFFD700, 0xFFFF4500, 0xFFFF1493];
      case CelebrationType.streakAchieved:
        return [0xFFFF4500, 0xFFFF6347, 0xFFFFD700];
      case CelebrationType.goalReached:
        return [0xFF32CD32, 0xFFFFD700, 0xFF4ECDC4];
    }
  }

  int _getAnimationDuration(CelebrationType type) {
    switch (type) {
      case CelebrationType.exerciseComplete:
        return 2000;
      case CelebrationType.workoutComplete:
        return 3000;
      case CelebrationType.personalRecord:
        return 3500;
      case CelebrationType.streakAchieved:
        return 2500;
      case CelebrationType.goalReached:
        return 4000;
    }
  }

  double _getSparkleIntensity(CelebrationType type) {
    switch (type) {
      case CelebrationType.exerciseComplete:
        return 0.6;
      case CelebrationType.workoutComplete:
        return 0.8;
      case CelebrationType.personalRecord:
        return 1;
      case CelebrationType.streakAchieved:
        return 0.7;
      case CelebrationType.goalReached:
        return 1;
    }
  }
}
