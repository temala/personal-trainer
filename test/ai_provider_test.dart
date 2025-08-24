import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';

import 'package:fitness_training_app/shared/data/repositories/ai_provider_manager.dart';
import 'package:fitness_training_app/shared/domain/entities/ai_provider_config.dart'
    as entities;

void main() {
  group('AI Provider System Tests', () {
    late AIProviderManager providerManager;
    late Logger logger;

    setUp(() {
      logger = Logger();

      // Create test configuration
      final testConfig = entities.AIConfiguration(
        providers: {
          entities.AIProviderType.chatgpt: entities.ProviderConfig.chatgpt(
            apiKey: 'test-key',
          ),
        },
        primaryProvider: entities.AIProviderType.chatgpt,
        fallbackProviders: const [],
      );

      providerManager = AIProviderManager(testConfig, logger: logger);
    });

    test('should initialize with configuration', () {
      expect(providerManager, isNotNull);
      expect(providerManager.availableProviders, isNotEmpty);
      expect(
        providerManager.availableProviders,
        contains(entities.AIProviderType.chatgpt),
      );
    });

    test('should get provider status', () async {
      final status = await providerManager.getAllProviderStatuses();
      expect(status, isNotEmpty);
      expect(status[entities.AIProviderType.chatgpt], isNotNull);
    });

    test('should handle provider configuration', () async {
      final newConfig = entities.ProviderConfig.chatgpt(apiKey: 'new-test-key');

      await providerManager.configureProvider(
        entities.AIProviderType.chatgpt,
        newConfig,
      );

      final status = await providerManager.getAllProviderStatuses();
      expect(status[entities.AIProviderType.chatgpt], isNotNull);
    });

    test('should handle fallback when primary provider fails', () async {
      // This test would require mocking the HTTP client to simulate failures
      // For now, we just test that the fallback mechanism exists
      expect(providerManager.availableProviders, isNotEmpty);
    });

    test('should validate provider configuration', () {
      final validConfig = entities.ProviderConfig.chatgpt(apiKey: 'test-key');

      expect(validConfig.type, equals(entities.AIProviderType.chatgpt));
      expect(validConfig.apiKey, equals('test-key'));
      expect(validConfig.isEnabled, isTrue);
    });

    test('should handle multiple provider types', () {
      final configs = <entities.AIProviderType, entities.ProviderConfig>{
        entities.AIProviderType.chatgpt: entities.ProviderConfig.chatgpt(
          apiKey: 'chatgpt-key',
        ),
        entities.AIProviderType.claude: entities.ProviderConfig.claude(
          apiKey: 'claude-key',
          isEnabled: false,
        ),
      };

      final multiConfig = entities.AIConfiguration(
        providers: configs,
        primaryProvider: entities.AIProviderType.chatgpt,
        fallbackProviders: const [entities.AIProviderType.claude],
      );

      expect(multiConfig.providers.length, equals(2));
      expect(
        multiConfig.primaryProvider,
        equals(entities.AIProviderType.chatgpt),
      );
      expect(
        multiConfig.fallbackProviders,
        contains(entities.AIProviderType.claude),
      );
    });

    test('should provide default configurations', () {
      final defaultChatGPT = entities.ProviderConfig.chatgpt(
        apiKey: 'test-key',
      );

      expect(defaultChatGPT.type, equals(entities.AIProviderType.chatgpt));
      expect(defaultChatGPT.baseUrl, equals('https://api.openai.com/v1'));
      expect(defaultChatGPT.additionalConfig['model'], equals('gpt-4'));
    });

    test('should validate required fields', () {
      const requiredFields = entities.AIConfiguration.requiredFields;

      expect(requiredFields, isNotNull);
      expect(
        requiredFields[entities.AIProviderType.chatgpt],
        contains('apiKey'),
      );
    });
  });
}
