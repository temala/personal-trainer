import 'dart:math' as math;

import 'package:fitness_training_app/core/utils/logger.dart';
import 'package:fitness_training_app/shared/domain/entities/exercise.dart';
import 'package:fitness_training_app/shared/domain/entities/user_profile.dart';
import 'package:fitness_training_app/shared/presentation/widgets/recovery_timer_widget.dart';

/// Service for managing adaptive recovery times
class RecoveryTimerService {
  RecoveryTimerService();

  /// Calculate adaptive recovery time based on exercise and user profile
  Duration calculateRecoveryTime({
    required Exercise exercise,
    UserProfile? userProfile,
    Map<String, dynamic>? sessionData,
  }) {
    try {
      // Base recovery time based on exercise type
      final baseDuration = _getBaseRecoveryTime(exercise);

      // Calculate multipliers
      final intensityMultiplier = _getIntensityMultiplier(exercise);
      final difficultyMultiplier = _getDifficultyMultiplier(
        exercise.difficulty,
      );
      final userFitnessMultiplier = _getUserFitnessMultiplier(userProfile);
      final sessionMultiplier = _getSessionMultiplier(sessionData);

      // Create configuration
      final config = RecoveryTimerConfig(
        baseDuration: baseDuration,
        intensityMultiplier: intensityMultiplier,
        difficultyMultiplier: difficultyMultiplier,
        userFitnessMultiplier: userFitnessMultiplier * sessionMultiplier,
      );

      final recoveryTime = config.calculateRecoveryTime();

      AppLogger.info(
        'Calculated recovery time for ${exercise.name}: ${recoveryTime.inSeconds}s',
      );

      return recoveryTime;
    } catch (e, stackTrace) {
      AppLogger.error('Error calculating recovery time', e, stackTrace);
      return const Duration(seconds: 30); // Default fallback
    }
  }

  /// Get base recovery time based on exercise category
  Duration _getBaseRecoveryTime(Exercise exercise) {
    switch (exercise.category) {
      case ExerciseCategory.cardio:
        return const Duration(seconds: 45);
      case ExerciseCategory.strength:
        return const Duration(seconds: 60);
      case ExerciseCategory.flexibility:
        return const Duration(seconds: 20);
      case ExerciseCategory.balance:
        return const Duration(seconds: 25);
      case ExerciseCategory.sports:
        return const Duration(seconds: 60);
      case ExerciseCategory.rehabilitation:
        return const Duration(seconds: 40);
    }
  }

  /// Get intensity multiplier based on exercise characteristics
  double _getIntensityMultiplier(Exercise exercise) {
    var multiplier = 1.0;

    // Adjust based on estimated duration
    if (exercise.estimatedDurationSeconds > 300) {
      // > 5 minutes
      multiplier += 0.3;
    } else if (exercise.estimatedDurationSeconds > 180) {
      // > 3 minutes
      multiplier += 0.2;
    } else if (exercise.estimatedDurationSeconds < 60) {
      // < 1 minute
      multiplier -= 0.2;
    }

    // Adjust based on equipment requirements
    if (exercise.equipment.isNotEmpty) {
      multiplier += 0.1;
    }

    // Adjust based on exercise category intensity
    switch (exercise.category) {
      case ExerciseCategory.strength:
        multiplier += 0.3;
      case ExerciseCategory.cardio:
        multiplier += 0.2;
      case ExerciseCategory.sports:
        multiplier += 0.4;
      case ExerciseCategory.flexibility:
        multiplier -= 0.3;
      case ExerciseCategory.balance:
        multiplier -= 0.1;
      case ExerciseCategory.rehabilitation:
        multiplier -= 0.2;
    }

    return math.max(0.3, multiplier); // Minimum 30% of base time
  }

  /// Get difficulty multiplier
  double _getDifficultyMultiplier(DifficultyLevel difficulty) {
    switch (difficulty) {
      case DifficultyLevel.beginner:
        return 0.8;
      case DifficultyLevel.intermediate:
        return 1.0;
      case DifficultyLevel.advanced:
        return 1.3;
      case DifficultyLevel.expert:
        return 1.6;
    }
  }

  /// Get user fitness level multiplier
  double _getUserFitnessMultiplier(UserProfile? userProfile) {
    if (userProfile == null) return 1;

    // Calculate fitness level based on user data
    final fitnessLevel = _calculateUserFitnessLevel(userProfile);

    switch (fitnessLevel) {
      case UserFitnessLevel.beginner:
        return 1.4; // Longer recovery for beginners
      case UserFitnessLevel.intermediate:
        return 1;
      case UserFitnessLevel.advanced:
        return 0.8;
      case UserFitnessLevel.expert:
        return 0.6; // Shorter recovery for experts
    }
  }

  /// Get session-based multiplier
  double _getSessionMultiplier(Map<String, dynamic>? sessionData) {
    if (sessionData == null) return 1;

    var multiplier = 1.0;

    // Adjust based on exercises completed in session
    final exercisesCompleted = sessionData['exercisesCompleted'] as int? ?? 0;
    if (exercisesCompleted > 10) {
      multiplier += 0.3; // Longer recovery as session progresses
    } else if (exercisesCompleted > 5) {
      multiplier += 0.2;
    }

    // Adjust based on session duration
    final sessionDuration = sessionData['sessionDuration'] as Duration?;
    if (sessionDuration != null) {
      if (sessionDuration.inMinutes > 45) {
        multiplier += 0.2;
      } else if (sessionDuration.inMinutes > 30) {
        multiplier += 0.1;
      }
    }

    // Adjust based on user's recent performance
    final recentPerformance = sessionData['recentPerformance'] as double? ?? 1;
    if (recentPerformance < 0.7) {
      multiplier += 0.3; // Longer recovery if struggling
    } else if (recentPerformance > 1.2) {
      multiplier -= 0.2; // Shorter recovery if performing well
    }

    return math.max(0.5, multiplier);
  }

  /// Calculate user fitness level based on profile
  UserFitnessLevel _calculateUserFitnessLevel(UserProfile userProfile) {
    // This is a simplified calculation
    // In a real app, this would consider workout history, performance metrics, etc.

    final age = userProfile.age;
    final height = userProfile.height;
    final weight = userProfile.weight;

    // Check if we have required data
    if (age == null || height == null || weight == null) {
      return UserFitnessLevel.intermediate; // Default level
    }

    final bmi = _calculateBMI(height, weight);

    // Simple scoring system
    var score = 0;

    // Age factor
    if (age < 25) {
      score += 2;
    } else if (age < 35) {
      score += 1;
    } else if (age > 50) {
      score -= 1;
    }

    // BMI factor
    if (bmi >= 18.5 && bmi <= 24.9) {
      score += 2;
    } else if (bmi >= 25 && bmi <= 29.9) {
      score += 1;
    } else {
      score -= 1;
    }

    // Fitness level factor based on user's self-reported fitness level
    final fitnessLevel = userProfile.fitnessLevel;
    if (fitnessLevel != null) {
      switch (fitnessLevel.toLowerCase()) {
        case 'expert':
          score += 3;
        case 'advanced':
          score += 2;
        case 'intermediate':
          score += 1;
        case 'beginner':
        default:
          // No additional score for beginner
          break;
      }
    }

    // Convert score to fitness level
    if (score >= 4) return UserFitnessLevel.expert;
    if (score >= 2) return UserFitnessLevel.advanced;
    if (score >= 0) return UserFitnessLevel.intermediate;
    return UserFitnessLevel.beginner;
  }

  /// Calculate BMI
  double _calculateBMI(double heightCm, double weightKg) {
    final heightM = heightCm / 100;
    return weightKg / (heightM * heightM);
  }

  /// Get recommended recovery activities
  List<String> getRecoveryActivities(Exercise exercise) {
    final activities = <String>[];

    switch (exercise.category) {
      case ExerciseCategory.cardio:
        activities.addAll([
          'Take deep breaths to lower your heart rate',
          'Walk around slowly to cool down',
          'Hydrate with small sips of water',
          'Stretch your legs gently',
        ]);

      case ExerciseCategory.strength:
        activities.addAll([
          'Stretch the muscles you just worked',
          'Shake out your arms and legs',
          'Take deep breaths',
          'Prepare for the next exercise mentally',
        ]);

      case ExerciseCategory.flexibility:
        activities.addAll([
          'Hold your final stretch position',
          'Focus on your breathing',
          'Relax your mind and body',
          'Prepare for the next movement',
        ]);

      case ExerciseCategory.balance:
        activities.addAll([
          'Stand still and center yourself',
          'Take a few deep breaths',
          'Focus on your posture',
          'Prepare your balance for the next exercise',
        ]);

      case ExerciseCategory.sports:
        activities.addAll([
          'Maintain light movement',
          'Control your breathing',
          'Stay hydrated',
          'Monitor how you feel',
        ]);

      case ExerciseCategory.rehabilitation:
        activities.addAll([
          'Focus on gentle movements',
          'Breathe deeply and slowly',
          'Listen to your body',
          'Take your time to recover',
        ]);
    }

    return activities;
  }

  /// Get recovery tips based on difficulty level
  List<String> getRecoveryTips(DifficultyLevel difficulty) {
    switch (difficulty) {
      case DifficultyLevel.beginner:
        return [
          "Don't rush - take the full recovery time",
          'Listen to your body and rest as needed',
          'Focus on breathing deeply',
          "It's okay to take longer if you need it",
        ];

      case DifficultyLevel.intermediate:
        return [
          'Use this time to prepare mentally',
          'Stay hydrated during rest',
          'Gentle movement can help recovery',
          'Focus on form for the next exercise',
        ];

      case DifficultyLevel.advanced:
        return [
          'Active recovery can be beneficial',
          'Visualize your next exercise',
          'Monitor your heart rate',
          'Stay focused and ready',
        ];

      case DifficultyLevel.expert:
        return [
          'Optimize your recovery time',
          'Use breathing techniques',
          'Stay mentally engaged',
          'Prepare for high intensity',
        ];
    }
  }
}

/// User fitness levels for recovery calculation
enum UserFitnessLevel { beginner, intermediate, advanced, expert }
