import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_score.freezed.dart';
part 'user_score.g.dart';

/// User scoring and achievement entity
@freezed
class UserScore with _$UserScore {
  const factory UserScore({
    required String id,
    required String userId,
    required int totalScore,
    required double commitmentLevel,
    required int workoutsCompleted,
    required int totalWorkouts,
    required int currentStreak,
    required int longestStreak,
    required List<Achievement> achievements,
    required Map<String, int> categoryScores,
    required DateTime lastUpdated,
    required DateTime createdAt,
    int? weeklyScore,
    int? monthlyScore,
    double? averageWorkoutCompletion,
    int? totalExercisesCompleted,
    int? totalWorkoutMinutes,
    Map<String, dynamic>? aiEvaluation,
    List<String>? recentAchievements,
    Map<String, dynamic>? progressMetrics,
  }) = _UserScore;

  factory UserScore.fromJson(Map<String, dynamic> json) =>
      _$UserScoreFromJson(json);
}

/// Achievement entity
@freezed
class Achievement with _$Achievement {
  const factory Achievement({
    required String id,
    required String name,
    required String description,
    required AchievementType type,
    required AchievementTier tier,
    required int pointsAwarded,
    required DateTime unlockedAt,
    String? iconUrl,
    Map<String, dynamic>? metadata,
  }) = _Achievement;

  factory Achievement.fromJson(Map<String, dynamic> json) =>
      _$AchievementFromJson(json);
}

/// Achievement types
enum AchievementType {
  @JsonValue('workout_completion')
  workoutCompletion,
  @JsonValue('streak')
  streak,
  @JsonValue('consistency')
  consistency,
  @JsonValue('improvement')
  improvement,
  @JsonValue('milestone')
  milestone,
  @JsonValue('special')
  special,
}

/// Achievement tiers
enum AchievementTier {
  @JsonValue('bronze')
  bronze,
  @JsonValue('silver')
  silver,
  @JsonValue('gold')
  gold,
  @JsonValue('platinum')
  platinum,
  @JsonValue('diamond')
  diamond,
}

/// Scoring categories
enum ScoreCategory {
  @JsonValue('consistency')
  consistency,
  @JsonValue('completion')
  completion,
  @JsonValue('improvement')
  improvement,
  @JsonValue('engagement')
  engagement,
  @JsonValue('challenge')
  challenge,
}

/// Extension methods for UserScore
extension UserScoreExtension on UserScore {
  /// Get completion rate as percentage
  double get completionRate {
    if (totalWorkouts == 0) return 0.0;
    return (workoutsCompleted / totalWorkouts) * 100;
  }

  /// Get commitment level as percentage
  double get commitmentPercentage => commitmentLevel * 100;

  /// Check if user is highly committed (>= 80%)
  bool get isHighlyCommitted => commitmentLevel >= 0.8;

  /// Get current level based on total score
  int get currentLevel {
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

  /// Get points needed for next level
  int get pointsToNextLevel {
    final nextLevelThreshold = _getLevelThreshold(currentLevel + 1);
    return nextLevelThreshold - totalScore;
  }

  /// Get progress to next level as percentage
  double get progressToNextLevel {
    final currentLevelThreshold = _getLevelThreshold(currentLevel);
    final nextLevelThreshold = _getLevelThreshold(currentLevel + 1);
    final levelRange = nextLevelThreshold - currentLevelThreshold;
    final currentProgress = totalScore - currentLevelThreshold;
    return (currentProgress / levelRange) * 100;
  }

  /// Get recent achievements (last 7 days)
  List<Achievement> get recentAchievementsList {
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    return achievements
        .where((achievement) => achievement.unlockedAt.isAfter(sevenDaysAgo))
        .toList()
      ..sort((a, b) => b.unlockedAt.compareTo(a.unlockedAt));
  }

  /// Get achievements by type
  List<Achievement> getAchievementsByType(AchievementType type) {
    return achievements
        .where((achievement) => achievement.type == type)
        .toList();
  }

  /// Get achievements by tier
  List<Achievement> getAchievementsByTier(AchievementTier tier) {
    return achievements
        .where((achievement) => achievement.tier == tier)
        .toList();
  }

  /// Calculate weekly average score
  double get weeklyAverageScore {
    if (weeklyScore == null) return 0.0;
    return weeklyScore! / 7.0;
  }

  /// Calculate monthly average score
  double get monthlyAverageScore {
    if (monthlyScore == null) return 0.0;
    return monthlyScore! / 30.0;
  }

  /// Get score category breakdown
  Map<ScoreCategory, double> get scoreCategoryBreakdown {
    final breakdown = <ScoreCategory, double>{};
    for (final category in ScoreCategory.values) {
      final categoryKey = category.name;
      final score = categoryScores[categoryKey] ?? 0;
      breakdown[category] = totalScore > 0 ? (score / totalScore) * 100 : 0.0;
    }
    return breakdown;
  }

  /// Helper method to get level threshold
  int _getLevelThreshold(int level) {
    switch (level) {
      case 1:
        return 0;
      case 2:
        return 100;
      case 3:
        return 300;
      case 4:
        return 600;
      case 5:
        return 1000;
      case 6:
        return 1500;
      case 7:
        return 2100;
      case 8:
        return 2800;
      case 9:
        return 3600;
      case 10:
        return 4500;
      default:
        return 4500 + ((level - 10) * 1000);
    }
  }

  /// Validate user score data
  List<String> validate() {
    final errors = <String>[];

    if (userId.trim().isEmpty) {
      errors.add('User ID cannot be empty');
    }

    if (totalScore < 0) {
      errors.add('Total score cannot be negative');
    }

    if (commitmentLevel < 0.0 || commitmentLevel > 1.0) {
      errors.add('Commitment level must be between 0.0 and 1.0');
    }

    if (workoutsCompleted < 0) {
      errors.add('Workouts completed cannot be negative');
    }

    if (totalWorkouts < 0) {
      errors.add('Total workouts cannot be negative');
    }

    if (workoutsCompleted > totalWorkouts) {
      errors.add('Workouts completed cannot exceed total workouts');
    }

    if (currentStreak < 0) {
      errors.add('Current streak cannot be negative');
    }

    if (longestStreak < 0) {
      errors.add('Longest streak cannot be negative');
    }

    if (currentStreak > longestStreak) {
      errors.add('Current streak cannot exceed longest streak');
    }

    return errors;
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return toJson()..remove('id'); // Firestore document ID is separate
  }
}

/// Extension methods for Achievement
extension AchievementExtension on Achievement {
  /// Get tier color
  String get tierColor {
    switch (tier) {
      case AchievementTier.bronze:
        return '#CD7F32';
      case AchievementTier.silver:
        return '#C0C0C0';
      case AchievementTier.gold:
        return '#FFD700';
      case AchievementTier.platinum:
        return '#E5E4E2';
      case AchievementTier.diamond:
        return '#B9F2FF';
    }
  }

  /// Get tier display name
  String get tierDisplayName {
    switch (tier) {
      case AchievementTier.bronze:
        return 'Bronze';
      case AchievementTier.silver:
        return 'Silver';
      case AchievementTier.gold:
        return 'Gold';
      case AchievementTier.platinum:
        return 'Platinum';
      case AchievementTier.diamond:
        return 'Diamond';
    }
  }

  /// Get type display name
  String get typeDisplayName {
    switch (type) {
      case AchievementType.workoutCompletion:
        return 'Workout Completion';
      case AchievementType.streak:
        return 'Streak';
      case AchievementType.consistency:
        return 'Consistency';
      case AchievementType.improvement:
        return 'Improvement';
      case AchievementType.milestone:
        return 'Milestone';
      case AchievementType.special:
        return 'Special';
    }
  }

  /// Check if achievement was unlocked recently (last 24 hours)
  bool get isRecentlyUnlocked {
    final twentyFourHoursAgo = DateTime.now().subtract(
      const Duration(hours: 24),
    );
    return unlockedAt.isAfter(twentyFourHoursAgo);
  }
}

/// Helper methods for UserScore
class UserScoreHelper {
  /// Create UserScore from Firestore document
  static UserScore fromFirestore(String id, Map<String, dynamic> data) {
    return UserScore.fromJson({'id': id, ...data});
  }

  /// Create initial user score
  static UserScore createInitial({required String userId}) {
    return UserScore(
      id: '', // Will be set by repository
      userId: userId,
      totalScore: 0,
      commitmentLevel: 0.0,
      workoutsCompleted: 0,
      totalWorkouts: 0,
      currentStreak: 0,
      longestStreak: 0,
      achievements: [],
      categoryScores: {
        for (final category in ScoreCategory.values) category.name: 0,
      },
      lastUpdated: DateTime.now(),
      createdAt: DateTime.now(),
      weeklyScore: 0,
      monthlyScore: 0,
      averageWorkoutCompletion: 0.0,
      totalExercisesCompleted: 0,
      totalWorkoutMinutes: 0,
      recentAchievements: [],
      progressMetrics: {},
    );
  }

  /// Predefined achievements
  static List<Achievement> get predefinedAchievements => [
    // Workout Completion Achievements
    Achievement(
      id: 'first_workout',
      name: 'First Steps',
      description: 'Complete your first workout',
      type: AchievementType.workoutCompletion,
      tier: AchievementTier.bronze,
      pointsAwarded: 50,
      unlockedAt: DateTime.now(),
    ),
    Achievement(
      id: 'ten_workouts',
      name: 'Getting Started',
      description: 'Complete 10 workouts',
      type: AchievementType.workoutCompletion,
      tier: AchievementTier.silver,
      pointsAwarded: 100,
      unlockedAt: DateTime.now(),
    ),
    Achievement(
      id: 'fifty_workouts',
      name: 'Dedicated Trainer',
      description: 'Complete 50 workouts',
      type: AchievementType.workoutCompletion,
      tier: AchievementTier.gold,
      pointsAwarded: 250,
      unlockedAt: DateTime.now(),
    ),
    Achievement(
      id: 'hundred_workouts',
      name: 'Fitness Champion',
      description: 'Complete 100 workouts',
      type: AchievementType.workoutCompletion,
      tier: AchievementTier.platinum,
      pointsAwarded: 500,
      unlockedAt: DateTime.now(),
    ),

    // Streak Achievements
    Achievement(
      id: 'three_day_streak',
      name: 'On a Roll',
      description: 'Complete workouts for 3 consecutive days',
      type: AchievementType.streak,
      tier: AchievementTier.bronze,
      pointsAwarded: 75,
      unlockedAt: DateTime.now(),
    ),
    Achievement(
      id: 'week_streak',
      name: 'Weekly Warrior',
      description: 'Complete workouts for 7 consecutive days',
      type: AchievementType.streak,
      tier: AchievementTier.silver,
      pointsAwarded: 150,
      unlockedAt: DateTime.now(),
    ),
    Achievement(
      id: 'month_streak',
      name: 'Unstoppable',
      description: 'Complete workouts for 30 consecutive days',
      type: AchievementType.streak,
      tier: AchievementTier.gold,
      pointsAwarded: 500,
      unlockedAt: DateTime.now(),
    ),

    // Consistency Achievements
    Achievement(
      id: 'perfect_week',
      name: 'Perfect Week',
      description: 'Complete all planned workouts in a week',
      type: AchievementType.consistency,
      tier: AchievementTier.silver,
      pointsAwarded: 200,
      unlockedAt: DateTime.now(),
    ),
    Achievement(
      id: 'perfect_month',
      name: 'Perfect Month',
      description: 'Complete all planned workouts in a month',
      type: AchievementType.consistency,
      tier: AchievementTier.gold,
      pointsAwarded: 750,
      unlockedAt: DateTime.now(),
    ),

    // Improvement Achievements
    Achievement(
      id: 'commitment_boost',
      name: 'Commitment Boost',
      description: 'Increase your commitment level by 20%',
      type: AchievementType.improvement,
      tier: AchievementTier.silver,
      pointsAwarded: 150,
      unlockedAt: DateTime.now(),
    ),
    Achievement(
      id: 'highly_committed',
      name: 'Highly Committed',
      description: 'Reach 80% commitment level',
      type: AchievementType.improvement,
      tier: AchievementTier.gold,
      pointsAwarded: 300,
      unlockedAt: DateTime.now(),
    ),

    // Milestone Achievements
    Achievement(
      id: 'level_five',
      name: 'Level 5 Achiever',
      description: 'Reach level 5',
      type: AchievementType.milestone,
      tier: AchievementTier.gold,
      pointsAwarded: 250,
      unlockedAt: DateTime.now(),
    ),
    Achievement(
      id: 'level_ten',
      name: 'Master Trainer',
      description: 'Reach level 10',
      type: AchievementType.milestone,
      tier: AchievementTier.diamond,
      pointsAwarded: 1000,
      unlockedAt: DateTime.now(),
    ),
  ];
}
