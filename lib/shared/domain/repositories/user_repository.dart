import 'package:fitness_training_app/shared/domain/entities/user_profile.dart';

/// Repository interface for user profile management
abstract class UserRepository {
  /// Get user profile by ID
  Future<UserProfile?> getUserProfile(String userId);

  /// Create new user profile
  Future<UserProfile> createUserProfile(UserProfile profile);

  /// Update user profile
  Future<UserProfile> updateUserProfile(UserProfile profile);

  /// Delete user profile
  Future<void> deleteUserProfile(String userId);

  /// Update user preferences
  Future<void> updateUserPreferences(
    String userId,
    Map<String, dynamic> preferences,
  );

  /// Update user fitness metrics
  Future<void> updateFitnessMetrics({
    required String userId,
    double? weight,
    double? targetWeight,
    double? height,
  });

  /// Update premium status
  Future<void> updatePremiumStatus({
    required String userId,
    required bool isPremium,
    DateTime? expiresAt,
  });

  /// Update FCM token for notifications
  Future<void> updateFCMToken(String userId, String? fcmToken);

  /// Update AI provider configuration
  Future<void> updateAIProviderConfig(
    String userId,
    Map<String, dynamic> config,
  );

  /// Stream user profile changes
  Stream<UserProfile?> watchUserProfile(String userId);

  /// Check if user profile exists
  Future<bool> userExists(String userId);

  /// Get user's exercise preferences and history
  Future<Map<String, dynamic>> getUserExercisePreferences(String userId);

  /// Update user's exercise preferences
  Future<void> updateExercisePreferences(
    String userId,
    Map<String, dynamic> preferences,
  );

  /// Check if user profile is available offline
  Future<bool> isAvailableOffline(String userId);

  /// Force refresh user profile from remote
  Future<void> refreshFromRemote(String userId);

  /// Get cache status for user profile
  Future<Map<String, dynamic>> getCacheStatus(String userId);
}
