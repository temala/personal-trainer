import 'package:fitness_training_app/shared/domain/entities/user_score.dart';

/// Repository interface for user score management
abstract class UserScoreRepository {
  /// Get user score by user ID
  Future<UserScore?> getUserScore(String userId);

  /// Create or update user score
  Future<void> saveUserScore(UserScore userScore);

  /// Update user score with new data
  Future<void> updateUserScore(String userId, Map<String, dynamic> updates);

  /// Delete user score
  Future<void> deleteUserScore(String userId);

  /// Get user scores for leaderboard (top N users)
  Future<List<UserScore>> getTopScores({int limit = 10});

  /// Get user's rank among all users
  Future<int> getUserRank(String userId);

  /// Get users with similar scores for comparison
  Future<List<UserScore>> getSimilarScores(String userId, {int limit = 5});

  /// Stream user score changes
  Stream<UserScore?> watchUserScore(String userId);

  /// Batch update multiple user scores
  Future<void> batchUpdateScores(Map<String, Map<String, dynamic>> updates);

  /// Get achievement statistics
  Future<Map<String, int>> getAchievementStatistics();

  /// Get users who achieved specific achievement
  Future<List<UserScore>> getUsersWithAchievement(String achievementId);

  /// Update user's weekly/monthly scores
  Future<void> updatePeriodicScores(
    String userId, {
    int? weeklyScore,
    int? monthlyScore,
  });

  /// Reset user scores (for testing or admin purposes)
  Future<void> resetUserScore(String userId);
}
