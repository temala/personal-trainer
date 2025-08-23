import 'package:fitness_training_app/shared/domain/entities/ai_request.dart';
import 'package:fitness_training_app/shared/domain/entities/ai_response.dart';
import 'package:fitness_training_app/shared/domain/entities/ai_provider_config.dart';

/// Abstract repository interface for AI providers
abstract class AIProviderRepository {
  /// Process an AI request and return a response
  Future<AIResponse> processRequest(AIRequest request);

  /// Check if the provider is properly configured
  bool get isConfigured;

  /// Get the provider name/identifier
  String get providerName;

  /// Get the provider type
  AIProviderType get providerType;

  /// Test the connection to the AI provider
  Future<bool> testConnection();

  /// Get the current configuration
  ProviderConfig get config;

  /// Update the provider configuration
  Future<void> updateConfig(ProviderConfig newConfig);

  /// Get provider status information
  Future<ProviderStatus> getStatus();
}

/// Abstract base class for AI providers with common functionality
abstract class BaseAIProvider implements AIProviderRepository {
  BaseAIProvider(this._config);
  final ProviderConfig _config;

  @override
  ProviderConfig get config => _config;

  @override
  bool get isConfigured => _config.apiKey.isNotEmpty;

  @override
  AIProviderType get providerType => _config.type;

  /// Validate the request before processing
  bool validateRequest(AIRequest request) {
    if (request.requestId.isEmpty) return false;
    if (request.userId.isEmpty) return false;
    if (request.payload.isEmpty) return false;
    return true;
  }

  /// Create a standardized error response
  AIResponse createErrorResponse(
    String requestId,
    String error, {
    String? errorCode,
  }) {
    return AIResponse.error(
      requestId: requestId,
      error: error,
      providerId: providerName,
      errorCode: errorCode,
    );
  }

  /// Create a standardized success response
  AIResponse createSuccessResponse(
    String requestId,
    Map<String, dynamic> data, {
    Map<String, dynamic>? metadata,
  }) {
    return AIResponse.success(
      requestId: requestId,
      data: data,
      providerId: providerName,
      metadata: metadata,
    );
  }
}
