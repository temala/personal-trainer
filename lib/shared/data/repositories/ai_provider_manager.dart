import 'package:logger/logger.dart';

import 'package:fitness_training_app/shared/domain/entities/ai_request.dart';
import 'package:fitness_training_app/shared/domain/entities/ai_response.dart';
import 'package:fitness_training_app/shared/domain/entities/ai_provider_config.dart';
import 'package:fitness_training_app/shared/domain/repositories/ai_provider_repository.dart';
import 'package:fitness_training_app/shared/data/datasources/chatgpt_provider.dart';
import 'package:fitness_training_app/shared/data/datasources/n8n_provider.dart';

/// Exception thrown when no AI providers are available
class NoProvidersAvailableException implements Exception {
  const NoProvidersAvailableException(this.message);
  final String message;

  @override
  String toString() => 'NoProvidersAvailableException: $message';
}

/// Exception thrown when a provider is not found
class ProviderNotFoundException implements Exception {
  const ProviderNotFoundException(this.providerType);
  final String providerType;

  @override
  String toString() =>
      'ProviderNotFoundException: Provider $providerType not found';
}

/// Manager class that coordinates multiple AI providers
class AIProviderManager {
  AIProviderManager(this._configuration, {Logger? logger})
    : _logger = logger ?? Logger() {
    _initializeProviders();
  }
  final Map<AIProviderType, AIProviderRepository> _providers = {};
  final AIConfiguration _configuration;
  final Logger _logger;

  /// Initialize providers based on configuration
  void _initializeProviders() {
    for (final entry in _configuration.providers.entries) {
      final type = entry.key;
      final config = entry.value;

      if (!config.isEnabled) continue;

      try {
        final provider = _createProvider(type, config);
        _providers[type] = provider;
        _logger.i('Initialized AI provider: ${provider.providerName}');
      } catch (e) {
        _logger.e('Failed to initialize provider $type: $e');
      }
    }
  }

  /// Create a provider instance based on type and configuration
  AIProviderRepository _createProvider(
    AIProviderType type,
    ProviderConfig config,
  ) {
    switch (type) {
      case AIProviderType.chatgpt:
        return ChatGPTProvider(config, logger: _logger);
      case AIProviderType.n8nWorkflow:
        return N8NProvider(config, logger: _logger);
      case AIProviderType.claude:
        // TODO: Implement Claude provider
        throw UnimplementedError('Claude provider not yet implemented');
      case AIProviderType.gemini:
        // TODO: Implement Gemini provider
        throw UnimplementedError('Gemini provider not yet implemented');
      case AIProviderType.custom:
        // TODO: Implement custom provider interface
        throw UnimplementedError('Custom provider not yet implemented');
    }
  }

  /// Process an AI request using the configured provider strategy
  Future<AIResponse> processRequest(AIRequest request) async {
    if (_providers.isEmpty) {
      throw const NoProvidersAvailableException('No AI providers configured');
    }

    // Try primary provider first
    final primaryProvider = _providers[_configuration.primaryProvider];
    if (primaryProvider != null && primaryProvider.isConfigured) {
      try {
        final response = await primaryProvider.processRequest(request);
        if (response.success) {
          return response;
        }

        _logger.w(
          'Primary provider ${primaryProvider.providerName} failed: ${response.error}',
        );
      } catch (e) {
        _logger.e('Primary provider ${primaryProvider.providerName} error: $e');
      }
    }

    // Try fallback providers if enabled
    if (_configuration.enableFallback) {
      for (final fallbackType in _configuration.fallbackProviders) {
        final fallbackProvider = _providers[fallbackType];
        if (fallbackProvider != null && fallbackProvider.isConfigured) {
          try {
            _logger.i(
              'Trying fallback provider: ${fallbackProvider.providerName}',
            );
            final response = await fallbackProvider.processRequest(request);
            if (response.success) {
              return response;
            }

            _logger.w(
              'Fallback provider ${fallbackProvider.providerName} failed: ${response.error}',
            );
          } catch (e) {
            _logger.e(
              'Fallback provider ${fallbackProvider.providerName} error: $e',
            );
          }
        }
      }
    }

    // All providers failed
    return AIResponse.error(
      requestId: request.requestId,
      error: 'All configured AI providers failed',
      providerId: 'AIProviderManager',
      errorCode: 'ALL_PROVIDERS_FAILED',
    );
  }

  /// Process request with a specific provider
  Future<AIResponse> processRequestWithProvider(
    AIRequest request,
    AIProviderType providerType,
  ) async {
    final provider = _providers[providerType];
    if (provider == null) {
      throw ProviderNotFoundException(providerType.toString());
    }

    return provider.processRequest(request);
  }

  /// Test connection for a specific provider
  Future<bool> testProviderConnection(AIProviderType providerType) async {
    final provider = _providers[providerType];
    if (provider == null) return false;

    try {
      return await provider.testConnection();
    } catch (e) {
      _logger.e('Provider connection test failed for $providerType: $e');
      return false;
    }
  }

  /// Test connections for all configured providers
  Future<Map<AIProviderType, bool>> testAllConnections() async {
    final results = <AIProviderType, bool>{};

    for (final entry in _providers.entries) {
      final type = entry.key;
      final provider = entry.value;

      try {
        results[type] = await provider.testConnection();
      } catch (e) {
        _logger.e('Connection test failed for $type: $e');
        results[type] = false;
      }
    }

    return results;
  }

  /// Get status for all providers
  Future<Map<AIProviderType, ProviderStatus>> getAllProviderStatuses() async {
    final statuses = <AIProviderType, ProviderStatus>{};

    for (final entry in _providers.entries) {
      final type = entry.key;
      final provider = entry.value;

      try {
        statuses[type] = await provider.getStatus();
      } catch (e) {
        _logger.e('Failed to get status for $type: $e');
        statuses[type] = ProviderStatus(
          type: type,
          isAvailable: false,
          lastChecked: DateTime.now(),
          errorMessage: e.toString(),
        );
      }
    }

    return statuses;
  }

  /// Add or update a provider configuration
  Future<void> configureProvider(
    AIProviderType type,
    ProviderConfig config,
  ) async {
    try {
      final provider = _createProvider(type, config);
      _providers[type] = provider;

      // Test the new configuration
      final isWorking = await provider.testConnection();
      if (!isWorking) {
        _logger.w('Provider $type configured but connection test failed');
      }

      _logger.i('Provider $type configured successfully');
    } catch (e) {
      _logger.e('Failed to configure provider $type: $e');
      rethrow;
    }
  }

  /// Remove a provider
  void removeProvider(AIProviderType type) {
    _providers.remove(type);
    _logger.i('Provider $type removed');
  }

  /// Get list of available provider types
  List<AIProviderType> get availableProviders => _providers.keys.toList();

  /// Get list of configured provider types
  List<AIProviderType> get configuredProviders =>
      _providers.entries
          .where((entry) => entry.value.isConfigured)
          .map((entry) => entry.key)
          .toList();

  /// Check if a specific provider is available and configured
  bool isProviderAvailable(AIProviderType type) {
    final provider = _providers[type];
    return provider != null && provider.isConfigured;
  }

  /// Get the current configuration
  AIConfiguration get configuration => _configuration;

  /// Get a specific provider instance (for advanced usage)
  AIProviderRepository? getProvider(AIProviderType type) => _providers[type];

  /// Execute a workout plan generation request
  Future<AIResponse> generateWorkoutPlan({
    required String userId,
    required Map<String, dynamic> userProfile,
    required List<Map<String, dynamic>> availableExercises,
    Map<String, dynamic>? preferences,
    List<String>? excludedExercises,
  }) async {
    final request = AIRequest(
      requestId: 'workout-plan-${DateTime.now().millisecondsSinceEpoch}',
      type: AIRequestType.generateWorkoutPlan,
      payload:
          WorkoutPlanRequest(
            userId: userId,
            userProfile: userProfile ?? {},
            availableExercises: availableExercises,
            preferences: preferences ?? {},
            constraints:
                excludedExercises != null
                    ? {'excludedExercises': excludedExercises}
                    : {},
          ).toJson(),
      timestamp: DateTime.now(),
      userId: userId,
    );

    return processRequest(request);
  }

  /// Execute an alternative exercise request
  Future<AIResponse> getAlternativeExercise({
    required String userId,
    required String currentExerciseId,
    required AlternativeType alternativeType,
    required List<Map<String, dynamic>> availableExercises,
    Map<String, dynamic>? userContext,
  }) async {
    final request = AIRequest(
      requestId: 'alt-exercise-${DateTime.now().millisecondsSinceEpoch}',
      type: AIRequestType.getAlternativeExercise,
      payload:
          AlternativeExerciseRequest(
            userId: userId,
            currentExerciseId: currentExerciseId,
            alternativeType: alternativeType,
            availableExercises: availableExercises,
            userContext: userContext ?? {},
          ).toJson(),
      timestamp: DateTime.now(),
      userId: userId,
    );

    return processRequest(request);
  }

  /// Execute a notification generation request
  Future<AIResponse> generateNotification({
    required String userId,
    required Map<String, dynamic> userContext,
    String? notificationType,
    Map<String, dynamic>? additionalData,
  }) async {
    final request = AIRequest(
      requestId: 'notification-${DateTime.now().millisecondsSinceEpoch}',
      type: AIRequestType.generateNotification,
      payload:
          NotificationRequest(
            userId: userId,
            userContext: userContext ?? {},
            notificationType: notificationType,
            additionalData: additionalData ?? {},
          ).toJson(),
      timestamp: DateTime.now(),
      userId: userId,
    );

    return processRequest(request);
  }

  /// Dispose resources
  void dispose() {
    _providers.clear();
    _logger.i('AIProviderManager disposed');
  }
}
