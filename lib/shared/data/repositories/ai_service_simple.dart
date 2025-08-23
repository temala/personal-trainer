import 'package:logger/logger.dart';

import 'package:fitness_training_app/shared/domain/entities/ai_entities.dart';
import 'package:fitness_training_app/shared/data/repositories/ai_provider_manager.dart';

/// Simplified AI service for demonstration purposes
class SimpleAIService {
  SimpleAIService(this._providerManager, {Logger? logger})
    : _logger = logger ?? Logger();
  final AIProviderManager _providerManager;
  final Logger _logger;

  /// Generate a simple notification message
  Future<String> generateNotificationMessage({
    required String userId,
    required String userName,
    required int age,
    Map<String, dynamic>? additionalContext,
  }) async {
    try {
      final response = await _providerManager.generateNotification(
        userId: userId,
        userContext: {'name': userName, 'age': age, ...?additionalContext},
      );

      if (!response.success) {
        _logger.w('Failed to generate notification: ${response.error}');
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

  /// Generate a simple workout plan
  Future<Map<String, dynamic>> generateWorkoutPlan({
    required String userId,
    required String userName,
    required int age,
    List<String>? availableExercises,
  }) async {
    try {
      final response = await _providerManager.generateWorkoutPlan(
        userId: userId,
        userProfile: {'name': userName, 'age': age, 'fitnessLevel': 'beginner'},
        availableExercises:
            (availableExercises ?? _getDefaultExercises())
                .map(
                  (name) => {
                    'id': name.toLowerCase().replaceAll(' ', '_'),
                    'name': name,
                  },
                )
                .toList(),
      );

      if (!response.success) {
        _logger.w('Failed to generate workout plan: ${response.error}');
        return _getDefaultWorkoutPlan();
      }

      final workoutPlan = response.data['workout_plan'] ?? response.data;
      return workoutPlan as Map<String, dynamic>;
    } catch (e) {
      _logger.e('Error generating workout plan: $e');
      return _getDefaultWorkoutPlan();
    }
  }

  /// Get alternative exercise
  Future<String?> getAlternativeExercise({
    required String userId,
    required String currentExercise,
    required String reason, // 'dislike' or 'not_possible'
    List<String>? availableExercises,
  }) async {
    try {
      final response = await _providerManager.getAlternativeExercise(
        userId: userId,
        currentExerciseId: currentExercise,
        alternativeType: reason,
        availableExercises:
            (availableExercises ?? _getDefaultExercises())
                .map(
                  (name) => {
                    'id': name.toLowerCase().replaceAll(' ', '_'),
                    'name': name,
                  },
                )
                .toList(),
      );

      if (!response.success) {
        _logger.w('Failed to get alternative exercise: ${response.error}');
        return null;
      }

      final alternativeData =
          response.data['alternative_exercise'] ?? response.data;
      return alternativeData['name']?.toString();
    } catch (e) {
      _logger.e('Error getting alternative exercise: $e');
      return null;
    }
  }

  /// Test if AI services are available
  Future<bool> isServiceAvailable() async {
    try {
      final results = await _providerManager.testAllConnections();
      return results.values.any((isAvailable) => isAvailable);
    } catch (e) {
      _logger.e('Error checking service availability: $e');
      return false;
    }
  }

  /// Get service status
  Future<Map<String, dynamic>> getServiceStatus() async {
    try {
      final statuses = await _providerManager.getAllProviderStatuses();

      return {
        'providers': statuses.map(
          (type, status) => MapEntry(type.toString(), {
            'available': status.isAvailable,
            'lastChecked': status.lastChecked.toIso8601String(),
            'error': status.errorMessage,
          }),
        ),
        'primaryProvider':
            _providerManager.configuration.primaryProvider.toString(),
        'fallbackEnabled': _providerManager.configuration.enableFallback,
      };
    } catch (e) {
      _logger.e('Error getting service status: $e');
      return {
        'error': e.toString(),
        'providers': <String, dynamic>{},
        'primaryProvider': null,
        'fallbackEnabled': false,
      };
    }
  }

  List<String> _getDefaultExercises() => [
    'Push-ups',
    'Squats',
    'Lunges',
    'Plank',
    'Jumping Jacks',
    'Burpees',
    'Mountain Climbers',
    'High Knees',
    'Sit-ups',
    'Wall Sit',
  ];

  Map<String, dynamic> _getDefaultWorkoutPlan() => {
    'weeklyPlan': [
      {
        'day': 'Monday',
        'exercises': [
          {'id': 'push_ups', 'name': 'Push-ups', 'sets': 3, 'reps': 10},
          {'id': 'squats', 'name': 'Squats', 'sets': 3, 'reps': 15},
        ],
        'restDay': false,
      },
      {'day': 'Tuesday', 'exercises': <dynamic>[], 'restDay': true},
      // ... more days
    ],
  };
}
