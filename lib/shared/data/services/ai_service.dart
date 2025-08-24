import 'package:logger/logger.dart';

import 'package:fitness_training_app/core/errors/ai_service_error.dart';
import 'package:fitness_training_app/shared/data/repositories/ai_provider_manager.dart';
import 'package:fitness_training_app/shared/domain/entities/ai_provider_config.dart';
import 'package:fitness_training_app/shared/domain/entities/ai_request.dart';
import 'package:fitness_training_app/shared/domain/entities/exercise.dart';
import 'package:fitness_training_app/shared/domain/entities/user_profile.dart';
import 'package:fitness_training_app/shared/domain/entities/workout_plan.dart';

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

      final response = await _providerManager.generateWorkoutPlan(
        userId: userProfile.id,
        userProfile: userProfile.toJson(),
        availableExercises: availableExercises.map((e) => e.toJson()).toList(),
        preferences: preferences,
        excludedExercises: constraints?['excludedExercises'] as List<String>?,
      );

      if (!response.success) {
        throw AIServiceError(
          response.error ?? 'Failed to generate workout plan',
        );
      }

      // Parse the response data into a WorkoutPlan
      final planData = response.data['workoutPlan'] as Map<String, dynamic>?;
      if (planData == null) {
        throw AIServiceError('Invalid workout plan response format');
      }

      final plan = WorkoutPlan.fromJson(planData);

      _logger.i(
        'Successfully generated workout plan with ${plan.exercises.length} exercises',
      );
      return plan;
    } catch (e) {
      _logger.e('Failed to generate workout plan: $e');
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

      final response = await _providerManager.getAlternativeExercise(
        userId: userId ?? 'anonymous',
        currentExerciseId: currentExerciseId,
        alternativeType: alternativeType,
        availableExercises: availableExercises.map((e) => e.toJson()).toList(),
        userContext: {...?userContext, 'excludeExerciseIds': excludeList},
      );

      if (!response.success) {
        _logger.w('Alternative exercise request failed: ${response.error}');
        return null;
      }

      final exerciseData =
          response.data['alternativeExercise'] as Map<String, dynamic>?;
      if (exerciseData == null) {
        _logger.w('No alternative exercise found');
        return null;
      }

      final alternative = Exercise.fromJson(exerciseData);
      _logger.i('Found alternative exercise: ${alternative.name}');
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

      final response = await _providerManager.generateNotification(
        userId: userId,
        userContext: enhancedContext,
      );

      if (!response.success) {
        throw AIServiceError(
          response.error ?? 'Failed to generate notification',
        );
      }

      final message =
          response.data['message'] as String? ?? 'Keep up the great work!';
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

      // Create a custom AI request for progress analysis
      final request = AIRequest(
        requestId: 'progress-analysis-${DateTime.now().millisecondsSinceEpoch}',
        type: AIRequestType.analyzeProgress,
        payload: {'userId': userId, 'progressData': progressData},
        timestamp: DateTime.now(),
        userId: userId,
      );

      final response = await _providerManager.processRequest(request);

      if (!response.success) {
        throw AIServiceError(response.error ?? 'Failed to analyze progress');
      }

      return ProgressAnalysis.fromJson(response.data);
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

      final config = ProviderConfig(
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
  Future<Map<AIProviderType, ProviderStatus>> getProviderStatus() async {
    return _providerManager.getAllProviderStatuses();
  }

  /// Check if any provider is configured and available
  Future<bool> get hasAvailableProvider async {
    final status = await getProviderStatus();
    return status.values.any((providerStatus) => providerStatus.isAvailable);
  }

  /// Get available providers
  List<AIProviderType> get availableProviders {
    return _providerManager.availableProviders;
  }
}

/// Progress analysis result model
class ProgressAnalysis {
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

  final int overallScore;
  final String commitmentLevel;
  final List<String> strengths;
  final List<String> areasForImprovement;
  final List<String> recommendations;
  final String motivationalMessage;

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
