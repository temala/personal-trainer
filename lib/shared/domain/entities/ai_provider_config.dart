import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_provider_config.freezed.dart';
part 'ai_provider_config.g.dart';

/// Enum defining different AI provider types
enum AIProviderType {
  @JsonValue('chatgpt')
  chatgpt,
  @JsonValue('n8n_workflow')
  n8nWorkflow,
  @JsonValue('claude')
  claude,
  @JsonValue('gemini')
  gemini,
  @JsonValue('custom')
  custom,
}

/// Configuration for individual AI providers
@freezed
class ProviderConfig with _$ProviderConfig {
  const factory ProviderConfig({
    required AIProviderType type,
    required String apiKey,
    required Map<String, dynamic> additionalConfig,
    @Default(true) bool isEnabled,
    @Default(1) int priority,
    String? baseUrl,
    @Default(30) int timeoutSeconds,
  }) = _ProviderConfig;

  factory ProviderConfig.fromJson(Map<String, dynamic> json) =>
      _$ProviderConfigFromJson(json);

  /// Factory for ChatGPT configuration
  factory ProviderConfig.chatgpt({
    required String apiKey,
    String model = 'gpt-4',
    String baseUrl = 'https://api.openai.com/v1',
    bool isEnabled = true,
    int priority = 1,
    int timeoutSeconds = 30,
  }) => ProviderConfig(
    type: AIProviderType.chatgpt,
    apiKey: apiKey,
    baseUrl: baseUrl,
    additionalConfig: {'model': model, 'max_tokens': 2000, 'temperature': 0.7},
    isEnabled: isEnabled,
    priority: priority,
    timeoutSeconds: timeoutSeconds,
  );

  /// Factory for N8N workflow configuration
  factory ProviderConfig.n8nWorkflow({
    required String webhookUrl,
    String? apiKey,
    String? workflowId,
    bool isEnabled = true,
    int priority = 2,
    int timeoutSeconds = 60,
  }) => ProviderConfig(
    type: AIProviderType.n8nWorkflow,
    apiKey: apiKey ?? '',
    baseUrl: webhookUrl,
    additionalConfig: {'webhook_url': webhookUrl, 'workflow_id': workflowId},
    isEnabled: isEnabled,
    priority: priority,
    timeoutSeconds: timeoutSeconds,
  );

  /// Factory for Claude configuration
  factory ProviderConfig.claude({
    required String apiKey,
    String model = 'claude-3-sonnet-20240229',
    String baseUrl = 'https://api.anthropic.com/v1',
    bool isEnabled = true,
    int priority = 3,
    int timeoutSeconds = 30,
  }) => ProviderConfig(
    type: AIProviderType.claude,
    apiKey: apiKey,
    baseUrl: baseUrl,
    additionalConfig: {'model': model, 'max_tokens': 2000},
    isEnabled: isEnabled,
    priority: priority,
    timeoutSeconds: timeoutSeconds,
  );
}

/// Overall AI configuration managing multiple providers
@freezed
class AIConfiguration with _$AIConfiguration {
  /// Default configuration with ChatGPT as primary
  factory AIConfiguration.defaultConfig({
    required String chatgptApiKey,
    String? n8nWebhookUrl,
  }) {
    final providers = <AIProviderType, ProviderConfig>{
      AIProviderType.chatgpt: ProviderConfig.chatgpt(apiKey: chatgptApiKey),
    };

    if (n8nWebhookUrl != null) {
      providers[AIProviderType.n8nWorkflow] = ProviderConfig.n8nWorkflow(
        webhookUrl: n8nWebhookUrl,
      );
    }

    return AIConfiguration(
      providers: providers,
      primaryProvider: AIProviderType.chatgpt,
      fallbackProviders:
          n8nWebhookUrl != null ? [AIProviderType.n8nWorkflow] : [],
    );
  }
  const factory AIConfiguration({
    required Map<AIProviderType, ProviderConfig> providers,
    required AIProviderType primaryProvider,
    @Default([]) List<AIProviderType> fallbackProviders,
    @Default(true) bool enableFallback,
    @Default(3) int maxRetries,
  }) = _AIConfiguration;

  factory AIConfiguration.fromJson(Map<String, dynamic> json) =>
      _$AIConfigurationFromJson(json);

  /// Required fields for each provider type
  static const Map<AIProviderType, List<String>> requiredFields = {
    AIProviderType.chatgpt: ['apiKey', 'model'],
    AIProviderType.n8nWorkflow: ['webhookUrl'],
    AIProviderType.claude: ['apiKey'],
    AIProviderType.gemini: ['apiKey'],
    AIProviderType.custom: ['apiKey', 'baseUrl'],
  };
}

/// Provider status information
@freezed
class ProviderStatus with _$ProviderStatus {
  const factory ProviderStatus({
    required AIProviderType type,
    required bool isAvailable,
    required DateTime lastChecked,
    String? errorMessage,
    double? responseTime,
    int? successRate,
  }) = _ProviderStatus;

  factory ProviderStatus.fromJson(Map<String, dynamic> json) =>
      _$ProviderStatusFromJson(json);
}
