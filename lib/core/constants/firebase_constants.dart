/// Firebase configuration constants
class FirebaseConstants {
  // Firestore Collections
  static const String users = 'users';
  static const String exercises = 'exercises';
  static const String workoutPlans = 'workout_plans';
  static const String workoutSessions = 'workout_sessions';
  static const String userProgress = 'user_progress';
  static const String subscriptions = 'subscriptions';
  static const String notifications = 'notifications';
  static const String aiProviderConfigs = 'ai_provider_configs';

  // Storage Paths
  static const String userAvatarsPath = 'user_avatars';
  static const String exerciseAnimationsPath = 'exercise_animations';
  static const String userPhotosPath = 'user_photos';

  // FCM Topics
  static const String allUsersTopic = 'all_users';
  static const String premiumUsersTopic = 'premium_users';
  static const String workoutRemindersTopic = 'workout_reminders';

  // Analytics Events
  static const String workoutStarted = 'workout_started';
  static const String workoutCompleted = 'workout_completed';
  static const String exerciseCompleted = 'exercise_completed';
  static const String exerciseSkipped = 'exercise_skipped';
  static const String subscriptionPurchased = 'subscription_purchased';
  static const String avatarCreated = 'avatar_created';

  // Remote Config Keys
  static const String aiProviderConfig = 'ai_provider_config';
  static const String featureFlags = 'feature_flags';
  static const String appConfig = 'app_config';
}
