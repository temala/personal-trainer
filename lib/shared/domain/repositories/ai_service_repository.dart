import '../entities/ai_request.dart';
import '../entities/workout_plan.dart';
import '../entities/exercise.dart';
import '../entities/user_profile.dart';

abstract class AIServiceRepository {
  /// Generate a weekly workout plan based on user profile and available exercises
  Future<WorkoutPlan> generateWeeklyPlan(
    UserProfile profile,
    List<Exercise> availableExercises, {
    Map<String, dynamic>? preferences,
    Map<String, dynamic>? constraints,
  });

  /// Get an alternative exercise based on user feedback
  Future<Exercise?> getAlternativeExercise(
    String currentExerciseId,
    AlternativeType type,
    List<Exercise> availableExercises, {
    String? userId,
    Map<String, dynamic>? userContext,
    List<String>? excludeExerciseIds,
  });

  /// Generate personalized notification message
  Future<String> generateNotificationMessage(Map<String, dynamic> userContext);

  /// Generate user avatar from photo (premium feature)
  Future<Map<String, dynamic>> generateUserAvatar(
    String userPhotoPath, {
    Map<String, dynamic>? stylePreferences,
  });

  /// Analyze user progress and provide insights
  Future<Map<String, dynamic>> analyzeProgress(
    String userId,
    Map<String, dynamic> progressData,
  );

  /// Test provider connection and configuration
  Future<bool> testConnection();

  /// Get provider configuration status
  bool get isConfigured;

  /// Get provider name/identifier
  String get providerName;

  /// Get provider type
  AIProviderType get providerType;
}

enum AIProviderType { chatgpt, n8nWorkflow, claude, gemini, custom }
