import 'dart:async';
import 'dart:math';

import 'package:logger/logger.dart';

import 'package:fitness_training_app/core/errors/ai_service_error.dart';
import 'package:fitness_training_app/shared/data/models/ai_provider_config.dart';
import 'package:fitness_training_app/shared/data/services/ai_providers/chatgpt_provider.dart';
import 'package:fitness_training_app/shared/domain/entities/ai_request.dart';
import 'package:fitness_training_app/shared/domain/entities/exercise.dart';
import 'package:fitness_training_app/shared/domain/entities/user_profile.dart';
import 'package:fitness_training_app/shared/domain/entities/workout_plan.dart';
import 'package:fitness_training_app/shared/domain/repositories/ai_service_repository.dart';

class AIProviderManager {
  AIProviderManager({required AIConfiguration configuration, Logger? logger})
    : _configuration = configuration,
      _logger = logger ?? Logger() {
    _initializeProviders();
  }

  final Map<AIProviderType, AIServiceRepository> _providers = {};
  final AIConfiguration _configuration;
  final Logger _logger;

  void _initializeProviders() {
    for (final entry in _configuration.providers.entries) {
      final type = entry.key;
      final config = entry.value;

      if (!config.isEnabled) continue;

      try {
        final provider = _createProvider(type, config);
        if (provider != null) {
          _providers[type] = provider;
          _logger.i('Initialized AI provider: ${provider.providerName}');
        }
      } catch (e) {
        _logger.e('Failed to initialize provider $type: $e');
      }
    }
  }

  AIServiceRepository? _createProvider(
    AIProviderType type,
    AIProviderConfig config,
  ) {
    switch (type) {
      case AIProviderType.chatgpt:
        return ChatGPTProvider(config: config, logger: _logger);
      case AIProviderType.n8nWorkflow:
        // TODO(dev): Implement N8NWorkflowProvider
        _logger.w('N8N Workflow provider not yet implemented');
        return null;
      case AIProviderType.claude:
        // TODO(dev): Implement ClaudeProvider
        _logger.w('Claude provider not yet implemented');
        return null;
      case AIProviderType.gemini:
        // TODO(dev): Implement GeminiProvider
        _logger.w('Gemini provider not yet implemented');
        return null;
      case AIProviderType.custom:
        // TODO(dev): Implement CustomProvider
        _logger.w('Custom provider not yet implemented');
        return null;
    }
  }

  /// Get the primary configured provider
  AIServiceRepository? get primaryProvider {
    return _providers[_configuration.primaryProvider];
  }

  /// Get all available providers sorted by priority
  List<AIServiceRepository> get availableProviders {
    final providers = <AIServiceRepository>[];

    // Add primary provider first
    final primary = primaryProvider;
    if (primary != null) {
      providers.add(primary);
    }

    // Add fallback providers in priority order
    for (final fallbackType in _configuration.fallbackProviders) {
      final provider = _providers[fallbackType];
      if (provider != null && provider != primary) {
        providers.add(provider);
      }
    }

    return providers;
  }

  /// Generate workout plan with fallback support
  Future<WorkoutPlan> generateWeeklyPlan(
    UserProfile profile,
    List<Exercise> availableExercises, {
    Map<String, dynamic>? preferences,
    Map<String, dynamic>? constraints,
  }) async {
    final providers = availableProviders;
    if (providers.isEmpty) {
      throw AIServiceError('No AI providers configured');
    }

    AIServiceError? lastError;

    for (final provider in providers) {
      try {
        _logger.i(
          'Attempting workout plan generation with ${provider.providerName}',
        );

        final plan = await provider.generateWeeklyPlan(
          profile,
          availableExercises,
          preferences: preferences,
          constraints: constraints,
        );

        _logger.i(
          'Successfully generated workout plan with ${provider.providerName}',
        );
        return plan;
      } catch (e) {
        lastError = e is AIServiceError ? e : AIServiceError(e.toString());
        _logger.w('Provider ${provider.providerName} failed: $e');

        if (!_configuration.enableFallback) break;
      }
    }

    throw lastError ?? AIServiceError('All AI providers failed');
  }

  /// Get alternative exercise with fallback support
  Future<Exercise?> getAlternativeExercise(
    String currentExerciseId,
    AlternativeType type,
    List<Exercise> availableExercises, {
    String? userId,
    Map<String, dynamic>? userContext,
    List<String>? excludeExerciseIds,
  }) async {
    final providers = availableProviders;
    if (providers.isEmpty) {
      _logger.w('No AI providers configured for alternative exercise');
      return _getFallbackAlternative(
        currentExerciseId,
        type,
        availableExercises,
        excludeExerciseIds,
      );
    }

    for (final provider in providers) {
      try {
        _logger.i(
          'Attempting alternative exercise with ${provider.providerName}',
        );

        final alternative = await provider.getAlternativeExercise(
          currentExerciseId,
          type,
          availableExercises,
          userId: userId,
          userContext: userContext,
          excludeExerciseIds: excludeExerciseIds,
        );

        if (alternative != null) {
          _logger.i(
            'Successfully got alternative exercise with ${provider.providerName}',
          );
          return alternative;
        }
      } catch (e) {
        _logger.w(
          'Provider ${provider.providerName} failed for alternative: $e',
        );

        if (!_configuration.enableFallback) break;
      }
    }

    // Fallback to simple rule-based alternative selection
    _logger.i('Using fallback alternative selection');
    return _getFallbackAlternative(
      currentExerciseId,
      type,
      availableExercises,
      excludeExerciseIds,
    );
  }

  /// Generate notification message with fallback
  Future<String> generateNotificationMessage(
    Map<String, dynamic> userContext,
  ) async {
    final providers = availableProviders;
    if (providers.isEmpty) {
      return _getFallbackNotificationMessage(userContext);
    }

    for (final provider in providers) {
      try {
        _logger.i(
          'Attempting notification generation with ${provider.providerName}',
        );

        final message = await provider.generateNotificationMessage(userContext);

        _logger.i(
          'Successfully generated notification with ${provider.providerName}',
        );
        return message;
      } catch (e) {
        _logger.w(
          'Provider ${provider.providerName} failed for notification: $e',
        );

        if (!_configuration.enableFallback) break;
      }
    }

    return _getFallbackNotificationMessage(userContext);
  }

  /// Analyze progress with fallback
  Future<Map<String, dynamic>> analyzeProgress(
    String userId,
    Map<String, dynamic> progressData,
  ) async {
    final providers = availableProviders;
    if (providers.isEmpty) {
      return _getFallbackProgressAnalysis(progressData);
    }

    for (final provider in providers) {
      try {
        _logger.i('Attempting progress analysis with ${provider.providerName}');

        final analysis = await provider.analyzeProgress(userId, progressData);

        _logger.i(
          'Successfully analyzed progress with ${provider.providerName}',
        );
        return analysis;
      } catch (e) {
        _logger.w(
          'Provider ${provider.providerName} failed for progress analysis: $e',
        );

        if (!_configuration.enableFallback) break;
      }
    }

    return _getFallbackProgressAnalysis(progressData);
  }

  /// Test all provider connections
  Future<Map<AIProviderType, bool>> testAllConnections() async {
    final results = <AIProviderType, bool>{};

    for (final entry in _providers.entries) {
      final type = entry.key;
      final provider = entry.value;

      try {
        _logger.i('Testing connection for ${provider.providerName}');
        results[type] = await provider.testConnection();
      } catch (e) {
        _logger.e('Connection test failed for ${provider.providerName}: $e');
        results[type] = false;
      }
    }

    return results;
  }

  /// Configure a specific provider
  Future<void> configureProvider(
    AIProviderType type,
    AIProviderConfig config,
  ) async {
    try {
      final provider = _createProvider(type, config);
      if (provider != null) {
        _providers[type] = provider;
        _logger.i('Configured AI provider: ${provider.providerName}');
      }
    } catch (e) {
      _logger.e('Failed to configure provider $type: $e');
      throw AIServiceError('Failed to configure provider: $e');
    }
  }

  /// Remove a provider
  void removeProvider(AIProviderType type) {
    _providers.remove(type);
    _logger.i('Removed AI provider: $type');
  }

  /// Get provider status
  Map<AIProviderType, bool> getProviderStatus() {
    final status = <AIProviderType, bool>{};

    for (final entry in _configuration.providers.entries) {
      final type = entry.key;
      final provider = _providers[type];
      status[type] = provider?.isConfigured ?? false;
    }

    return status;
  }

  // Fallback methods for when AI providers are unavailable

  Exercise? _getFallbackAlternative(
    String currentExerciseId,
    AlternativeType type,
    List<Exercise> availableExercises,
    List<String>? excludeExerciseIds,
  ) {
    final currentExercise = availableExercises.firstWhere(
      (e) => e.id == currentExerciseId,
      orElse: () => throw ArgumentError('Current exercise not found'),
    );

    final candidates =
        availableExercises
            .where((e) => e.id != currentExerciseId)
            .where((e) => !(excludeExerciseIds?.contains(e.id) ?? false))
            .where((e) => e.category == currentExercise.category)
            .toList();

    if (candidates.isEmpty) {
      // Expand search to all exercises if no same-category alternatives
      candidates
        ..clear()
        ..addAll(
          availableExercises
              .where((e) => e.id != currentExerciseId)
              .where((e) => !(excludeExerciseIds?.contains(e.id) ?? false)),
        );
    }

    if (candidates.isEmpty) return null;

    // Simple rule-based selection
    switch (type) {
      case AlternativeType.tooEasy:
        // Find harder exercise
        candidates.sort(
          (a, b) => b.difficulty.index.compareTo(a.difficulty.index),
        );
        break;
      case AlternativeType.tooHard:
        // Find easier exercise
        candidates.sort(
          (a, b) => a.difficulty.index.compareTo(b.difficulty.index),
        );
        break;
      case AlternativeType.noEquipment:
        // Find bodyweight exercises
        final bodyweightCandidates =
            candidates
                .where(
                  (e) =>
                      e.equipment.isEmpty ||
                      e.equipment.every(
                        (String eq) => eq.toLowerCase() == 'none',
                      ),
                )
                .toList();
        if (bodyweightCandidates.isNotEmpty) {
          candidates.clear();
          candidates.addAll(bodyweightCandidates);
        }
        break;
      default:
        // Random selection for other types
        candidates.shuffle();
    }

    return candidates.isNotEmpty ? candidates.first : null;
  }

  String _getFallbackNotificationMessage(Map<String, dynamic> userContext) {
    final messages = [
      "Time to get moving! Your fitness journey awaits! 💪",
      "Ready for today's workout? Let's make it count! 🔥",
      "Your body will thank you for this workout! Let's go! ⭐",
      "Consistency is key! Time for your next session! 🎯",
      "Every workout brings you closer to your goals! 🚀",
    ];

    final random = Random();
    return messages[random.nextInt(messages.length)];
  }

  Map<String, dynamic> _getFallbackProgressAnalysis(
    Map<String, dynamic> progressData,
  ) {
    // Simple rule-based progress analysis
    final completedSessions = progressData['completedSessions'] as int? ?? 0;
    final totalSessions = progressData['totalSessions'] as int? ?? 1;
    final completionRate = completedSessions / totalSessions;

    String commitmentLevel;
    List<String> recommendations = [];

    if (completionRate >= 0.8) {
      commitmentLevel = 'high';
      recommendations.add(
        'Excellent consistency! Consider increasing workout intensity.',
      );
    } else if (completionRate >= 0.6) {
      commitmentLevel = 'medium';
      recommendations.add(
        'Good progress! Try to maintain regular workout schedule.',
      );
    } else {
      commitmentLevel = 'low';
      recommendations.add(
        'Focus on building a consistent routine. Start with shorter sessions.',
      );
    }

    return {
      'overallScore': (completionRate * 100).round(),
      'commitmentLevel': commitmentLevel,
      'strengths': completionRate > 0.5 ? ['showing up'] : [],
      'areasForImprovement': completionRate < 0.8 ? ['consistency'] : [],
      'recommendations': recommendations,
      'motivationalMessage':
          completionRate > 0.5
              ? 'Keep up the great work!'
              : 'Every step counts - you\'ve got this!',
    };
  }
}
