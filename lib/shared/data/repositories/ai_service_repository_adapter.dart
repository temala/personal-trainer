import 'package:fitness_training_app/shared/data/repositories/ai_provider_manager.dart';
import 'package:fitness_training_app/shared/domain/entities/ai_provider_config.dart';
import 'package:fitness_training_app/shared/domain/entities/ai_request.dart';
import 'package:fitness_training_app/shared/domain/entities/ai_response.dart';
import 'package:fitness_training_app/shared/domain/entities/exercise.dart';
import 'package:fitness_training_app/shared/domain/entities/user_profile.dart';
import 'package:fitness_training_app/shared/domain/entities/workout_plan.dart';
import 'package:fitness_training_app/shared/domain/repositories/ai_service_repository.dart';

/// Adapter to make AIProviderManager compatible with AIServiceRepository interface
class AIServiceRepositoryAdapter implements AIServiceRepository {
  AIServiceRepositoryAdapter(this._providerManager);

  final AIProviderManager _providerManager;

  @override
  Future<WorkoutPlan> generateWeeklyPlan(
    UserProfile profile,
    List<Exercise> availableExercises, {
    Map<String, dynamic>? preferences,
    Map<String, dynamic>? constraints,
  }) async {
    final request = AIRequest(
      requestId: 'workout_plan_${DateTime.now().millisecondsSinceEpoch}',
      type: AIRequestType.generateWorkoutPlan,
      payload: {
        'userProfile': profile.toJson(),
        'availableExercises':
            availableExercises.map((e) => e.toJson()).toList(),
        'preferences': preferences,
        'constraints': constraints,
      },
      timestamp: DateTime.now(),
      userId: profile.id,
    );

    final response = await _providerManager.processRequest(request);

    if (!response.success) {
      throw Exception('Failed to generate workout plan: ${response.error}');
    }

    // Parse the response data into a WorkoutPlan
    final workoutPlanData =
        response.data['workout_plan'] as Map<String, dynamic>?;
    if (workoutPlanData == null) {
      throw Exception('Invalid workout plan response format');
    }

    return WorkoutPlan.fromJson(workoutPlanData);
  }

  @override
  Future<Exercise?> getAlternativeExercise(
    String currentExerciseId,
    AlternativeType type,
    List<Exercise> availableExercises, {
    String? userId,
    Map<String, dynamic>? userContext,
    List<String>? excludeExerciseIds,
  }) async {
    final request = AIRequest(
      requestId: 'alternative_${DateTime.now().millisecondsSinceEpoch}',
      type: AIRequestType.getAlternativeExercise,
      payload: {
        'currentExerciseId': currentExerciseId,
        'alternativeType': type.name,
        'availableExercises':
            availableExercises.map((e) => e.toJson()).toList(),
        'userContext': userContext,
        'excludeExerciseIds': excludeExerciseIds,
      },
      timestamp: DateTime.now(),
      userId: userId ?? 'unknown',
    );

    final response = await _providerManager.processRequest(request);

    if (!response.success) {
      return null; // Return null for graceful fallback
    }

    // Parse the response data into an Exercise
    final alternativeData =
        response.data['alternative_exercise'] as Map<String, dynamic>?;
    if (alternativeData == null) {
      return null;
    }

    // Find the exercise in the available exercises list
    final exerciseId = alternativeData['exerciseId'] as String?;
    if (exerciseId == null) {
      return null;
    }

    return availableExercises.firstWhere(
      (e) => e.id == exerciseId,
      orElse:
          () =>
              throw Exception(
                'Alternative exercise not found in available exercises',
              ),
    );
  }

  @override
  Future<String> generateNotificationMessage(
    Map<String, dynamic> userContext,
  ) async {
    final request = AIRequest(
      requestId: 'notification_${DateTime.now().millisecondsSinceEpoch}',
      type: AIRequestType.generateNotification,
      payload: {'userContext': userContext},
      timestamp: DateTime.now(),
      userId: userContext['userId'] as String? ?? 'unknown',
    );

    final response = await _providerManager.processRequest(request);

    if (!response.success) {
      // Return default message on failure
      return 'Time for your workout! Stay consistent and reach your goals.';
    }

    final notification = response.data['notification'] as Map<String, dynamic>?;
    return notification != null
        ? notification['message'] as String? ?? 'Keep up the great work!'
        : 'Keep up the great work!';
  }

  @override
  Future<Map<String, dynamic>> generateUserAvatar(
    String userPhotoPath, {
    Map<String, dynamic>? stylePreferences,
  }) async {
    final request = AIRequest(
      requestId: 'avatar_${DateTime.now().millisecondsSinceEpoch}',
      type: AIRequestType.createAvatar,
      payload: {
        'userPhotoPath': userPhotoPath,
        'stylePreferences': stylePreferences,
      },
      timestamp: DateTime.now(),
      userId: 'unknown',
    );

    final response = await _providerManager.processRequest(request);

    if (!response.success) {
      return {}; // Return empty result on failure
    }

    return response.data;
  }

  @override
  Future<Map<String, dynamic>> analyzeProgress(
    String userId,
    Map<String, dynamic> progressData,
  ) async {
    final request = AIRequest(
      requestId: 'progress_${DateTime.now().millisecondsSinceEpoch}',
      type: AIRequestType.analyzeProgress,
      payload: progressData,
      timestamp: DateTime.now(),
      userId: userId,
    );

    final response = await _providerManager.processRequest(request);

    if (!response.success) {
      return {}; // Return empty result on failure
    }

    return response.data['analysis'] as Map<String, dynamic>? ?? {};
  }

  @override
  Future<bool> testConnection() async {
    try {
      final testRequest = AIRequest(
        requestId: 'test_${DateTime.now().millisecondsSinceEpoch}',
        type: AIRequestType.generateNotification,
        payload: {
          'userContext': {'name': 'Test User'},
        },
        timestamp: DateTime.now(),
        userId: 'test-user',
      );

      final response = await _providerManager.processRequest(testRequest);
      return response.success;
    } catch (e) {
      return false;
    }
  }

  @override
  bool get isConfigured => _providerManager.configuredProviders.isNotEmpty;

  @override
  String get providerName => 'AI Provider Manager';

  @override
  AIProviderType get providerType => AIProviderType.chatgpt;

  @override
  Future<AIResponse> processRequest(AIRequest request) async {
    return _providerManager.processRequest(request);
  }
}
