import 'package:logger/logger.dart';

import 'package:fitness_training_app/shared/data/services/ai_provider_manager.dart';
import 'package:fitness_training_app/shared/domain/entities/ai_request.dart';
import 'package:fitness_training_app/shared/domain/entities/exercise.dart';
import 'package:fitness_training_app/shared/domain/entities/user_profile.dart';
import 'package:fitness_training_app/shared/domain/entities/workout_plan.dart';
import 'package:fitness_training_app/shared/domain/repositories/ai_service_repository.dart';

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
      final workoutPlan = await _providerManager.generateWeeklyPlan(
        profile,
        availableExercises,
        preferences: preferences,
        constraints: constraints,
      );

      return workoutPlan;
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
    // Return first available exercise as a simple fallback
    return availableExercises.isNotEmpty ? availableExercises.first : null;
  }

  @override
  Future<String> generateNotificationMessage(
    Map<String, dynamic> userContext,
  ) async {
    try {
      final message = await _providerManager.generateNotificationMessage(
        userContext,
      );

      return message;
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
  bool get isConfigured =>
      _providerManager.getProviderStatus().values.any((status) => status);

  @override
  String get providerName => 'AIServiceRepository';

  @override
  AIProviderType get providerType => AIProviderType.custom;

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
