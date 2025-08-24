import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

import 'package:fitness_training_app/core/config/env_config.dart';
import 'package:fitness_training_app/shared/domain/entities/ai_provider_config.dart';

/// Service for managing AI configuration from various sources
class AIConfigService {
  static const _secureStorage = FlutterSecureStorage();
  static final _logger = Logger();

  // Storage keys
  static const String _chatgptApiKeyKey = 'chatgpt_api_key';
  static const String _n8nWebhookUrlKey = 'n8n_webhook_url';

  /// Get AI configuration from environment variables or secure storage
  static Future<AIConfiguration?> getConfiguration() async {
    try {
      // Try environment variables first
      var chatgptApiKey =
          EnvConfig.chatgptApiKey.isNotEmpty ? EnvConfig.chatgptApiKey : null;

      var n8nWebhookUrl =
          EnvConfig.n8nWebhookUrl.isNotEmpty ? EnvConfig.n8nWebhookUrl : null;

      // Fallback to secure storage if environment variables are not set
      chatgptApiKey ??= await _secureStorage.read(key: _chatgptApiKeyKey);
      n8nWebhookUrl ??= await _secureStorage.read(key: _n8nWebhookUrlKey);

      // Check if we have at least one provider configured
      if (chatgptApiKey == null || chatgptApiKey.isEmpty) {
        _logger.w('No ChatGPT API key found in environment or secure storage');
        return null;
      }

      final providers = <AIProviderType, ProviderConfig>{
        AIProviderType.chatgpt: ProviderConfig.chatgpt(apiKey: chatgptApiKey),
      };

      if (n8nWebhookUrl != null && n8nWebhookUrl.isNotEmpty) {
        providers[AIProviderType.n8nWorkflow] = ProviderConfig.n8nWorkflow(
          webhookUrl: n8nWebhookUrl,
        );
      }

      return AIConfiguration(
        providers: providers,
        primaryProvider: AIProviderType.chatgpt,
        fallbackProviders:
            n8nWebhookUrl != null && n8nWebhookUrl.isNotEmpty
                ? [AIProviderType.n8nWorkflow]
                : [],
      );
    } catch (e) {
      _logger.e('Error loading AI configuration: $e');
      return null;
    }
  }

  /// Store ChatGPT API key securely
  static Future<void> storeChatGptApiKey(String apiKey) async {
    try {
      await _secureStorage.write(key: _chatgptApiKeyKey, value: apiKey);
      _logger.i('ChatGPT API key stored securely');
    } catch (e) {
      _logger.e('Error storing ChatGPT API key: $e');
      rethrow;
    }
  }

  /// Store N8N webhook URL securely
  static Future<void> storeN8nWebhookUrl(String webhookUrl) async {
    try {
      await _secureStorage.write(key: _n8nWebhookUrlKey, value: webhookUrl);
      _logger.i('N8N webhook URL stored securely');
    } catch (e) {
      _logger.e('Error storing N8N webhook URL: $e');
      rethrow;
    }
  }

  /// Remove all stored API keys (for logout/reset)
  static Future<void> clearStoredKeys() async {
    try {
      await _secureStorage.delete(key: _chatgptApiKeyKey);
      await _secureStorage.delete(key: _n8nWebhookUrlKey);
      _logger.i('All stored API keys cleared');
    } catch (e) {
      _logger.e('Error clearing stored keys: $e');
      rethrow;
    }
  }

  /// Check if API keys are stored
  static Future<bool> hasStoredChatGptKey() async {
    try {
      final key = await _secureStorage.read(key: _chatgptApiKeyKey);
      return key != null && key.isNotEmpty;
    } catch (e) {
      _logger.e('Error checking stored ChatGPT key: $e');
      return false;
    }
  }

  /// Check if N8N webhook URL is stored
  static Future<bool> hasStoredN8nUrl() async {
    try {
      final url = await _secureStorage.read(key: _n8nWebhookUrlKey);
      return url != null && url.isNotEmpty;
    } catch (e) {
      _logger.e('Error checking stored N8N URL: $e');
      return false;
    }
  }

  /// Get configuration status for debugging
  static Future<Map<String, dynamic>> getConfigurationStatus() async {
    return {
      'env_chatgpt_configured': EnvConfig.isChatGptConfigured,
      'env_n8n_configured': EnvConfig.isN8nConfigured,
      'stored_chatgpt_key': await hasStoredChatGptKey(),
      'stored_n8n_url': await hasStoredN8nUrl(),
    };
  }
}
