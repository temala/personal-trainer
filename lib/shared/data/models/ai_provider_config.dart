import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/repositories/ai_service_repository.dart';

part 'ai_provider_config.freezed.dart';
part 'ai_provider_config.g.dart';

@freezed
class AIProviderConfig with _$AIProviderConfig {
  const factory AIProviderConfig({
    required AIProviderType type,
    required String apiKey,
    @Default({}) Map<String, dynamic> additionalConfig,
    @Default(true) bool isEnabled,
    @Default(1) int priority,
    @Default(30) int timeoutSeconds,
    @Default(3) int maxRetries,
    String? baseUrl,
    String? model,
    String? webhookUrl,
    String? workflowId,
  }) = _AIProviderConfig;

  factory AIProviderConfig.fromJson(Map<String, dynamic> json) =>
      _$AIProviderConfigFromJson(json);
}

@freezed
class AIConfiguration with _$AIConfiguration {
  const factory AIConfiguration({
    required Map<AIProviderType, AIProviderConfig> providers,
    required AIProviderType primaryProvider,
    @Default([]) List<AIProviderType> fallbackProviders,
    @Default(true) bool enableFallback,
    @Default(10) int requestTimeoutSeconds,
  }) = _AIConfiguration;

  factory AIConfiguration.fromJson(Map<String, dynamic> json) =>
      _$AIConfigurationFromJson(json);
}

class AIProviderDefaults {
  static const Map<AIProviderType, List<String>> requiredFields = {
    AIProviderType.chatgpt: ['apiKey'],
    AIProviderType.n8nWorkflow: ['webhookUrl'],
    AIProviderType.claude: ['apiKey'],
    AIProviderType.gemini: ['apiKey'],
    AIProviderType.custom: ['apiKey', 'baseUrl'],
  };

  static const Map<AIProviderType, Map<String, dynamic>> defaultConfig = {
    AIProviderType.chatgpt: {
      'baseUrl': 'https://api.openai.com/v1',
      'model': 'gpt-4',
      'maxTokens': 2000,
      'temperature': 0.7,
    },
    AIProviderType.claude: {
      'baseUrl': 'https://api.anthropic.com/v1',
      'model': 'claude-3-sonnet-20240229',
      'maxTokens': 2000,
    },
    AIProviderType.gemini: {
      'baseUrl': 'https://generativelanguage.googleapis.com/v1',
      'model': 'gemini-pro',
    },
  };

  static AIProviderConfig getDefaultConfig(AIProviderType type) {
    final defaults = defaultConfig[type] ?? {};
    return AIProviderConfig(
      type: type,
      apiKey: '',
      additionalConfig: defaults,
      baseUrl: defaults['baseUrl'] as String?,
      model: defaults['model'] as String?,
    );
  }
}
