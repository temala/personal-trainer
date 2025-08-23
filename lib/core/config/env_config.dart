/// Environment configuration for the fitness training app
class EnvConfig {
  /// OpenAI API key from environment variables
  static const String openAIApiKey = String.fromEnvironment('OPENAI_API_KEY');

  /// ChatGPT API key from environment variables (legacy support)
  static const String chatgptApiKey = String.fromEnvironment('CHATGPT_API_KEY');

  /// N8N webhook URL from environment variables
  static const String n8nWebhookUrl = String.fromEnvironment('N8N_WEBHOOK_URL');

  /// Claude API key from environment variables
  static const String claudeApiKey = String.fromEnvironment('CLAUDE_API_KEY');

  /// Gemini API key from environment variables
  static const String geminiApiKey = String.fromEnvironment('GEMINI_API_KEY');

  /// Get the primary OpenAI API key (prefer OPENAI_API_KEY over CHATGPT_API_KEY)
  static String? get primaryOpenAIKey =>
      openAIApiKey.isNotEmpty
          ? openAIApiKey
          : chatgptApiKey.isNotEmpty
          ? chatgptApiKey
          : null;

  /// Check if OpenAI/ChatGPT API key is configured
  static bool get isOpenAIConfigured => primaryOpenAIKey != null;

  /// Check if ChatGPT is configured (for backward compatibility)
  static bool get isChatGptConfigured => isOpenAIConfigured;

  /// Check if N8N webhook is configured
  static bool get isN8nConfigured => n8nWebhookUrl.isNotEmpty;

  /// Check if Claude API key is configured
  static bool get isClaudeConfigured => claudeApiKey.isNotEmpty;

  /// Check if Gemini API key is configured
  static bool get isGeminiConfigured => geminiApiKey.isNotEmpty;

  /// Check if any AI provider is configured
  static bool get isAnyProviderConfigured =>
      isOpenAIConfigured ||
      isN8nConfigured ||
      isClaudeConfigured ||
      isGeminiConfigured;

  /// Get configuration summary for debugging
  static Map<String, dynamic> get configSummary => {
    'openai_configured': isOpenAIConfigured,
    'n8n_configured': isN8nConfigured,
    'claude_configured': isClaudeConfigured,
    'gemini_configured': isGeminiConfigured,
    'any_provider_configured': isAnyProviderConfigured,
  };
}
