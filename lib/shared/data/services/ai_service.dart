import 'package:logger/logger.dart';

import 'package:fitness_training_app/core/errors/ai_service_error.dart';
import 'package:fitness_training_app/shared/data/models/ai_provider_config.dart';
import 'package:fitness_training_app/shared/data/services/ai_provider_manager.dart';
import 'package:fitness_training_app/shared/domain/entities/ai_request.dart';
import 'package:fitness_training_app/shared/domain/entities/exercise.dart';
import 'package:fitness_training_app/shared/domain/entities/user_profile.dart';
import 'package:fitness_training_app/shared/domain/entities/workout_plan.dart';
import 'package:fitness_training_app/shared/domain/repositories/ai_service_repository.dart'
    show AIProviderType;

class AIService {
  AIService({required AIProviderManager providerManager, Logger? logger})
    : _providerManager = providerManager,
      _logger = logger ?? Logger();

  final AIProviderManager _providerManager;
  final Logger _logger;

  /// Generate a personalized weekly workout plan
  Future<WorkoutPlan> generateWeeklyWorkoutPlan({
    required UserProfile userProfile,
    required List<Exercise> availableExercises,
    Map<String, dynamic>? preferences,
    Map<String, dynamic>? constraints,
  }) async {
    try {
      _logger.i('Generating weekly workout plan for user ${userProfile.id}');

      // Validate inputs
      if (availableExercises.isEmpty) {
        throw AIServiceError(
          'No exercises available for workout plan generation',
        );
      }

      // Add user-specific constraints
      final enhancedConstraints = <String, dynamic>{
        ...?constraints,
        'userAge': userProfile.age,
        'fitnessGoal': userProfile.fitnessGoal.name,
        'activityLevel': userProfile.activityLevel.name,
        'availableTime':
            preferences?['availableTime'] ?? 30, // minutes per session
        'workoutDaysPerWeek': preferences?['workoutDaysPerWeek'] ?? 3,
      };

      final plan = await _providerManager.generateWeeklyPlan(
        userProfile,
        availableExercises,
        preferences: preferences,
        constraints: enhancedConstraints,
      );

      _logger.i(
        'Successfully generated workout plan with ${plan.exercises.length} exercises',
      );
      return plan;
    } catch (e) {
      _logger.i('Failed to generate workout plan: $e');
      rethrow;
    }
  }

  /// Get an alternative exercise based on user feedback
  Future<Exercise?> getAlternativeExercise({
    required String currentExerciseId,
    required AlternativeType alternativeType,
    required List<Exercise> availableExercises,
    String? userId,
    Map<String, dynamic>? userContext,
    List<String>? previouslyRejectedExercises,
  }) async {
    try {
      _logger.i(
        'Getting alternative for exercise $currentExerciseId, reason: ${alternativeType.name}',
      );

      // Build exclude list from previously rejected exercises
      final excludeList = <String>[
        currentExerciseId,
        ...?previouslyRejectedExercises,
      ];

      final alternative = await _providerManager.getAlternativeExercise(
        currentExerciseId,
        alternativeType,
        availableExercises,
        userId: userId,
        userContext: userContext,
        excludeExerciseIds: excludeList,
      );

      if (alternative != null) {
        _logger.i('Found alternative exercise: ${alternative.name}');
      } else {
        _logger.w('No alternative exercise found');
      }

      return alternative;
    } catch (e) {
      _logger.e('Failed to get alternative exercise: $e');
      return null; // Return null to allow graceful fallback
    }
  }

  /// Generate personalized notification message
  Future<String> generateMotivationalNotification({
    required String userId,
    required Map<String, dynamic> userContext,
  }) async {
    try {
      _logger.i('Generating notification for user $userId');

      // Enhance user context with additional data
      final enhancedContext = <String, dynamic>{
        ...userContext,
        'timestamp': DateTime.now().toIso8601String(),
        'userId': userId,
      };

      final message = await _providerManager.generateNotificationMessage(
        enhancedContext,
      );

      _logger.i('Generated notification message');
      return message;
    } catch (e) {
      _logger.e('Failed to generate notification: $e');
      rethrow;
    }
  }

  /// Analyze user progress and provide insights
  Future<ProgressAnalysis> analyzeUserProgress({
    required String userId,
    required Map<String, dynamic> progressData,
  }) async {
    try {
      _logger.i('Analyzing progress for user $userId');

      final analysis = await _providerManager.analyzeProgress(
        userId,
        progressData,
      );

      return ProgressAnalysis.fromJson(analysis);
    } catch (e) {
      _logger.e('Failed to analyze progress: $e');
      rethrow;
    }
  }

  /// Test AI provider connections
  Future<Map<AIProviderType, bool>> testProviderConnections() async {
    try {
      _logger.i('Testing AI provider connections');

      final results = await _providerManager.testAllConnections();

      _logger.i('Connection test results: $results');
      return results;
    } catch (e) {
      _logger.e('Failed to test provider connections: $e');
      rethrow;
    }
  }

  /// Configure AI provider
  Future<void> configureProvider({
    required AIProviderType type,
    required String apiKey,
    Map<String, dynamic>? additionalConfig,
  }) async {
    try {
      _logger.i('Configuring AI provider: $type');

      final config = AIProviderConfig(
        type: type,
        apiKey: apiKey,
        additionalConfig: additionalConfig ?? {},
      );

      await _providerManager.configureProvider(type, config);

      _logger.i('Successfully configured AI provider: $type');
    } catch (e) {
      _logger.e('Failed to configure AI provider: $e');
      rethrow;
    }
  }

  /// Get provider status
  Map<AIProviderType, bool> getProviderStatus() {
    return _providerManager.getProviderStatus();
  }

  /// Check if any provider is configured and available
  bool get hasAvailableProvider {
    final status = getProviderStatus();
    return status.values.any((isConfigured) => isConfigured);
  }

  /// Get primary provider name
  String? get primaryProviderName {
    return _providerManager.primaryProvider?.providerName;
  }
}

/// Progress analysis result model
class ProgressAnalysis {
  final int overallScore;
  final String commitmentLevel;
  final List<String> strengths;
  final List<String> areasForImprovement;
  final List<String> recommendations;
  final String motivationalMessage;

  const ProgressAnalysis({
    required this.overallScore,
    required this.commitmentLevel,
    required this.strengths,
    required this.areasForImprovement,
    required this.recommendations,
    required this.motivationalMessage,
  });

  factory ProgressAnalysis.fromJson(Map<String, dynamic> json) {
    return ProgressAnalysis(
      overallScore: json['overallScore'] as int? ?? 0,
      commitmentLevel: json['commitmentLevel'] as String? ?? 'unknown',
      strengths: (json['strengths'] as List?)?.cast<String>() ?? [],
      areasForImprovement:
          (json['areasForImprovement'] as List?)?.cast<String>() ?? [],
      recommendations: (json['recommendations'] as List?)?.cast<String>() ?? [],
      motivationalMessage:
          json['motivationalMessage'] as String? ?? 'Keep going!',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'overallScore': overallScore,
      'commitmentLevel': commitmentLevel,
      'strengths': strengths,
      'areasForImprovement': areasForImprovement,
      'recommendations': recommendations,
      'motivationalMessage': motivationalMessage,
    };
  }
}
