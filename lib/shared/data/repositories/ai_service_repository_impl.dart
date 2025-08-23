import 'package:logger/logger.dart';

import 'package:fitness_training_app/shared/domain/entities/exercise.dart';
import 'package:fitness_training_app/shared/domain/entities/user_profile.dart';
import 'package:fitness_training_app/shared/domain/entities/workout_plan.dart';
import 'package:fitness_training_app/shared/domain/repositories/ai_service_repository.dart';
import 'package:fitness_training_app/shared/data/repositories/ai_provider_manager.dart';

/// Simplified implementation of AIServiceRepository using AIProviderManager
class AIServiceRepositoryImpl implements AIServiceRepository {
  AIServiceRepositoryImpl(this._providerManager, {Logger? logger})
    : _logger = logger ?? Logger();
  final AIProviderManager _providerManager;
  final Logger _logger;

  @override
  Future<WorkoutPlan> generateWeeklyPlan(
    UserProfile profile,
    List<Exercise> availableExercises,
  ) async {
    try {
      final response = await _providerManager.generateWorkoutPlan(
        userId: profile.id,
        userProfile: {
          'id': profile.id,
          'name': profile.name,
          'age': profile.age,
        },
        availableExercises:
            availableExercises
                .map(
                  (e) => {
                    'id': e.id,
                    'name': e.name,
                    'description': e.description,
                  },
                )
                .toList(),
      );

      if (!response.success) {
        throw Exception('Failed to generate workout plan: ${response.error}');
      }

      // Return a simple default workout plan for now
      return _createSimpleWorkoutPlan(profile.id);
    } catch (e) {
      _logger.e('Error generating workout plan: $e');
      return _createSimpleWorkoutPlan(profile.id);
    }
  }

  @override
  Future<Exercise?> getAlternativeExercise(
    String currentExerciseId,
    AlternativeType type,
    List<Exercise> availableExercises,
    UserProfile userProfile,
  ) async {
    // Return first available exercise as a simple fallback
    return availableExercises.isNotEmpty ? availableExercises.first : null;
  }

  @override
  Future<String> generateNotificationMessage(
    UserProfile userProfile,
    Map<String, dynamic> context,
  ) async {
    try {
      final response = await _providerManager.generateNotification(
        userId: userProfile.id,
        userContext: {
          'name': userProfile.name,
          'age': userProfile.age,
          ...context,
        },
      );

      if (!response.success) {
        return "Time for your workout! Let's get moving! 💪";
      }

      final notificationData = response.data['notification'] ?? response.data;
      return notificationData['message']?.toString() ??
          "Time for your workout! Let's get moving! 💪";
    } catch (e) {
      _logger.e('Error generating notification: $e');
      return "Time for your workout! Let's get moving! 💪";
    }
  }

  @override
  Future<Map<String, dynamic>> analyzeProgress(
    UserProfile userProfile,
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
  Future<bool> isServiceAvailable() async {
    try {
      final results = await _providerManager.testAllConnections();
      return results.values.any((isAvailable) => isAvailable);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>> getServiceStatus() async {
    try {
      final statuses = await _providerManager.getAllProviderStatuses();
      return {
        'available': statuses.values.any((s) => s.isAvailable),
        'providers': statuses.length,
      };
    } catch (e) {
      return {'available': false, 'providers': 0};
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
