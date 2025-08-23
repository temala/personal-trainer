/// Environment configuration for the fitness training app
class EnvConfig {
  /// ChatGPT API key from environment variables
  static const String chatgptApiKey = String.fromEnvironment('CHATGPT_API_KEY');

  /// N8N webhook URL from environment variables
  static const String n8nWebhookUrl = String.fromEnvironment('N8N_WEBHOOK_URL');

  /// Check if ChatGPT API key is configured
  static bool get isChatGptConfigured => chatgptApiKey.isNotEmpty;

  /// Check if N8N webhook is configured
  static bool get isN8nConfigured => n8nWebhookUrl.isNotEmpty;

  /// Check if any AI provider is configured
  static bool get isAnyProviderConfigured =>
      isChatGptConfigured || isN8nConfigured;

  /// Get configuration summary for debugging
  static Map<String, dynamic> get configSummary => {
    'chatgpt_configured': isChatGptConfigured,
    'n8n_configured': isN8nConfigured,
    'any_provider_configured': isAnyProviderConfigured,
  };
}
