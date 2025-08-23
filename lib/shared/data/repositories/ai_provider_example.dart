import 'package:logger/logger.dart';

import 'package:fitness_training_app/shared/domain/entities/ai_entities.dart';
import 'package:fitness_training_app/shared/data/repositories/ai_provider_manager.dart';

/// Example usage of the AI provider system
class AIProviderExample {
  static Future<void> demonstrateUsage() async {
    final logger = Logger();

    // 1. Create AI configuration
    final config = AIConfiguration.defaultConfig(
      chatgptApiKey: 'your-chatgpt-api-key-here',
      n8nWebhookUrl: 'https://your-n8n-instance.com/webhook/workout-plan',
    );

    // 2. Initialize AI provider manager
    final providerManager = AIProviderManager(config, logger: logger);

    // 3. Test service availability
    final results = await providerManager.testAllConnections();
    logger.i('Connection test results: $results');

    // 4. Example: Generate notification message
    try {
      final response = await providerManager.generateNotification(
        userId: 'example-user',
        userContext: {
          'name': 'John',
          'age': 30,
          'lastWorkout':
              DateTime.now()
                  .subtract(const Duration(days: 2))
                  .toIso8601String(),
          'streak': 5,
          'preferredTime': 'morning',
        },
      );

      if (response.success) {
        logger.i('Generated notification: ${response.data}');
      } else {
        logger.e('Failed to generate notification: ${response.error}');
      }
    } catch (e) {
      logger.e('Exception generating notification: $e');
    }

    // 5. Get service status
    final statuses = await providerManager.getAllProviderStatuses();
    logger.i('Provider statuses: $statuses');

    // 6. Test specific provider
    final chatgptAvailable = await providerManager.testProviderConnection(
      AIProviderType.chatgpt,
    );
    logger.i('ChatGPT available: $chatgptAvailable');

    // 7. Cleanup
    providerManager.dispose();
  }
}

/// Example of how to configure different AI providers
class AIProviderConfigurationExamples {
  /// ChatGPT configuration example
  static ProviderConfig createChatGPTConfig({
    required String apiKey,
    String model = 'gpt-4',
  }) {
    return ProviderConfig.chatgpt(apiKey: apiKey, model: model);
  }

  /// N8N workflow configuration example
  static ProviderConfig createN8NConfig({
    required String webhookUrl,
    String? apiKey,
    String? workflowId,
  }) {
    return ProviderConfig.n8nWorkflow(
      webhookUrl: webhookUrl,
      apiKey: apiKey,
      workflowId: workflowId,
    );
  }

  /// Complete AI configuration with multiple providers
  static AIConfiguration createCompleteConfig({
    required String chatgptApiKey,
    required String n8nWebhookUrl,
    String? n8nApiKey,
  }) {
    return AIConfiguration(
      providers: {
        AIProviderType.chatgpt: createChatGPTConfig(apiKey: chatgptApiKey),
        AIProviderType.n8nWorkflow: createN8NConfig(
          webhookUrl: n8nWebhookUrl,
          apiKey: n8nApiKey,
        ),
      },
      primaryProvider: AIProviderType.chatgpt,
      fallbackProviders: [AIProviderType.n8nWorkflow],
    );
  }
}
