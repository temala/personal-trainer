/// Fitness goal enumeration
enum FitnessGoal { weightLoss, muscleGain, endurance, strength, flexibility }

/// Activity level enumeration
enum ActivityLevel {
  sedentary,
  lightlyActive,
  moderatelyActive,
  veryActive,
  extremelyActive,
}

/// Extensions for FitnessGoal
extension FitnessGoalExtension on FitnessGoal {
  String get displayName {
    switch (this) {
      case FitnessGoal.weightLoss:
        return 'Weight Loss';
      case FitnessGoal.muscleGain:
        return 'Muscle Gain';
      case FitnessGoal.endurance:
        return 'Endurance';
      case FitnessGoal.strength:
        return 'Strength';
      case FitnessGoal.flexibility:
        return 'Flexibility';
    }
  }

  String get description {
    switch (this) {
      case FitnessGoal.weightLoss:
        return 'Focus on burning calories and losing weight';
      case FitnessGoal.muscleGain:
        return 'Build muscle mass and strength';
      case FitnessGoal.endurance:
        return 'Improve cardiovascular fitness and stamina';
      case FitnessGoal.strength:
        return 'Increase overall strength and power';
      case FitnessGoal.flexibility:
        return 'Improve flexibility and mobility';
    }
  }
}

/// Extensions for ActivityLevel
extension ActivityLevelExtension on ActivityLevel {
  String get displayName {
    switch (this) {
      case ActivityLevel.sedentary:
        return 'Sedentary';
      case ActivityLevel.lightlyActive:
        return 'Lightly Active';
      case ActivityLevel.moderatelyActive:
        return 'Moderately Active';
      case ActivityLevel.veryActive:
        return 'Very Active';
      case ActivityLevel.extremelyActive:
        return 'Extremely Active';
    }
  }

  String get description {
    switch (this) {
      case ActivityLevel.sedentary:
        return 'Little or no exercise';
      case ActivityLevel.lightlyActive:
        return 'Light exercise 1-3 days/week';
      case ActivityLevel.moderatelyActive:
        return 'Moderate exercise 3-5 days/week';
      case ActivityLevel.veryActive:
        return 'Hard exercise 6-7 days/week';
      case ActivityLevel.extremelyActive:
        return 'Very hard exercise, physical job';
    }
  }

  double get multiplier {
    switch (this) {
      case ActivityLevel.sedentary:
        return 1.2;
      case ActivityLevel.lightlyActive:
        return 1.375;
      case ActivityLevel.moderatelyActive:
        return 1.55;
      case ActivityLevel.veryActive:
        return 1.725;
      case ActivityLevel.extremelyActive:
        return 1.9;
    }
  }
}
