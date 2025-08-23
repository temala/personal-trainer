/// Application-wide constants
class AppConstants {
  // App Information
  static const String appName = 'Fitness Training App';
  static const String appVersion = '1.0.0';

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String exercisesCollection = 'exercises';
  static const String workoutPlansCollection = 'workout_plans';
  static const String workoutSessionsCollection = 'workout_sessions';
  static const String userProgressCollection = 'user_progress';
  static const String subscriptionsCollection = 'subscriptions';
  static const String notificationsCollection = 'notifications';

  // Local Storage Keys
  static const String userProfileKey = 'user_profile';
  static const String workoutSessionKey = 'current_workout_session';
  static const String exerciseDatabaseKey = 'exercise_database';
  static const String offlineDataKey = 'offline_data';
  static const String aiProviderConfigKey = 'ai_provider_config';

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 300);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 500);
  static const Duration longAnimationDuration = Duration(milliseconds: 800);

  // Workout Constants
  static const int defaultRecoveryTimeSeconds = 30;
  static const int maxExercisesPerSession = 15;
  static const int minExercisesPerSession = 5;

  // AI Provider Constants
  static const String chatGptBaseUrl = 'https://api.openai.com/v1';
  static const int aiRequestTimeoutSeconds = 30;
  static const int maxRetryAttempts = 3;

  // Subscription Constants
  static const String premiumSubscriptionId = 'premium_monthly';
  static const String premiumYearlySubscriptionId = 'premium_yearly';

  // Notification Constants
  static const String workoutReminderChannelId = 'workout_reminders';
  static const String achievementChannelId = 'achievements';
  static const String generalChannelId = 'general';
}
