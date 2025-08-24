import 'package:fitness_training_app/shared/data/repositories/ai_provider_manager.dart';
import 'package:fitness_training_app/shared/domain/entities/ai_provider_config.dart';
import 'package:fitness_training_app/shared/domain/entities/ai_request.dart';
import 'package:fitness_training_app/shared/domain/entities/ai_response.dart';
import 'package:fitness_training_app/shared/domain/entities/exercise.dart';
import 'package:fitness_training_app/shared/domain/entities/user_profile.dart';
import 'package:fitness_training_app/shared/domain/entities/workout_plan.dart';
import 'package:fitness_training_app/shared/domain/repositories/ai_service_repository.dart';
import 'package:logger/logger.dart';

/// Simplified implementation of AIServiceRepository using AIProviderManager
class AIServiceRepositoryImpl implements AIServiceRepository {
  AIServiceRepositoryImpl(this._providerManager, {Logger? logger})
    : _logger = logger ?? Logger();
  final AIProviderManager _providerManager;
  final Logger _logger;

  @override
  Future<WorkoutPlan> generateWeeklyPlan(
    UserProfile profile,
    List<Exercise> availableExercises, {
    Map<String, dynamic>? preferences,
    Map<String, dynamic>? constraints,
  }) async {
    try {
      final response = await _providerManager.generateWorkoutPlan(
        userId: profile.id,
        userProfile: profile.toJson(),
        availableExercises: availableExercises.map((e) => e.toJson()).toList(),
        preferences: preferences,
        excludedExercises: constraints?['excludedExercises'] as List<String>?,
      );

      if (response.success && response.data.containsKey('weeklyPlan')) {
        // Parse the AI response and convert to WorkoutPlan
        final planData = response.data['weeklyPlan'] as Map<String, dynamic>;
        return WorkoutPlan.fromJson(planData);
      } else {
        _logger.w(
          'AI response unsuccessful or missing data: ${response.error}',
        );
        return _createSimpleWorkoutPlan(profile.id);
      }
    } catch (e) {
      _logger.e('Error generating workout plan: $e');
      return _createSimpleWorkoutPlan(profile.id);
    }
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
    try {
      if (userId == null) {
        // Return first available exercise as a simple fallback
        return availableExercises.isNotEmpty ? availableExercises.first : null;
      }

      final response = await _providerManager.getAlternativeExercise(
        userId: userId,
        currentExerciseId: currentExerciseId,
        alternativeType: type,
        availableExercises: availableExercises.map((e) => e.toJson()).toList(),
        userContext: userContext,
      );

      if (response.success &&
          response.data.containsKey('alternativeExercise')) {
        final exerciseData =
            response.data['alternativeExercise'] as Map<String, dynamic>;
        return Exercise.fromJson(exerciseData);
      } else {
        _logger.w(
          'AI response unsuccessful for alternative exercise: ${response.error}',
        );
        // Return first available exercise as fallback
        return availableExercises.isNotEmpty ? availableExercises.first : null;
      }
    } catch (e) {
      _logger.e('Error getting alternative exercise: $e');
      // Return first available exercise as fallback
      return availableExercises.isNotEmpty ? availableExercises.first : null;
    }
  }

  @override
  Future<String> generateNotificationMessage(
    Map<String, dynamic> userContext,
  ) async {
    try {
      final userId = userContext['userId'] as String? ?? 'anonymous';
      final response = await _providerManager.generateNotification(
        userId: userId,
        userContext: userContext,
      );

      if (response.success && response.data.containsKey('message')) {
        return response.data['message'] as String;
      } else {
        _logger.w(
          'AI response unsuccessful for notification: ${response.error}',
        );
        return "Time for your workout! Let's get moving! 💪";
      }
    } catch (e) {
      _logger.e('Error generating notification: $e');
      return "Time for your workout! Let's get moving! 💪";
    }
  }

  @override
  Future<Map<String, dynamic>> analyzeProgress(
    String userId,
    Map<String, dynamic> progressData,
  ) async {
    // Return a simple placeholder for now
    return {
      'overallScore': 75,
      'commitmentLevel': 'medium',
      'insights': ['Making good progress'],
      'recommendations': ['Keep it up!'],
    };
  }

  @override
  Future<Map<String, dynamic>> generateUserAvatar(
    String userPhotoPath, {
    Map<String, dynamic>? stylePreferences,
  }) async {
    // Placeholder implementation
    return {
      'avatarUrl': 'placeholder_avatar.png',
      'style': stylePreferences ?? {},
    };
  }

  @override
  Future<bool> testConnection() async {
    try {
      final results = await _providerManager.testAllConnections();
      return results.values.any((isAvailable) => isAvailable);
    } catch (e) {
      return false;
    }
  }

  @override
  bool get isConfigured {
    try {
      return _providerManager.configuredProviders.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  String get providerName => 'AIServiceRepository';

  @override
  AIProviderType get providerType => AIProviderType.custom;

  @override
  Future<AIResponse> processRequest(AIRequest request) async {
    try {
      return await _providerManager.processRequest(request);
    } catch (e) {
      _logger.e('Error processing AI request: $e');
      return AIResponse.error(
        requestId: request.requestId,
        error: e.toString(),
        providerId: providerName,
        errorCode: 'PROCESSING_ERROR',
      );
    }
  }

  WorkoutPlan _createSimpleWorkoutPlan(String userId) {
    // Create a minimal workout plan that satisfies the interface
    return WorkoutPlan(
      id: 'simple-plan-${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      name: 'Simple Workout Plan',
      description: 'A basic workout plan',
      difficulty: DifficultyLevel.beginner,
      estimatedDurationMinutes: 30,
      targetMuscleGroups: ['fullBody'],
      type: WorkoutType.cardio,
      exercises: <WorkoutExercise>[],
      metadata: const {},
      createdAt: DateTime.now(),
    );
  }
}
