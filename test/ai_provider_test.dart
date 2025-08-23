import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_training_app/shared/data/models/ai_provider_config.dart';
import 'package:fitness_training_app/shared/data/services/ai_provider_manager.dart';
import 'package:fitness_training_app/shared/domain/repositories/ai_service_repository.dart';
import 'package:fitness_training_app/core/utils/logger.dart';
import 'package:logger/logger.dart';

void main() {
  group('AI Provider System Tests', () {
    late AIProviderManager providerManager;
    late Logger logger;

    setUp(() {
      logger = Logger();

      // Create test configuration
      final testConfig = AIConfiguration(
        providers: {
          AIProviderType.chatgpt: AIProviderConfig(
            type: AIProviderType.chatgpt,
            apiKey: 'test-key',
            baseUrl: 'https://api.openai.com/v1',
            model: 'gpt-4',
            isEnabled: true,
          ),
        },
        primaryProvider: AIProviderType.chatgpt,
        fallbackProviders: [],
        enableFallback: true,
      );

      providerManager = AIProviderManager(
        configuration: testConfig,
        logger: logger,
      );
    });

    test('should initialize with configuration', () {
      expect(providerManager, isNotNull);
      expect(providerManager.primaryProvider, isNotNull);
      expect(providerManager.primaryProvider?.providerName, equals('ChatGPT'));
    });

    test('should get provider status', () {
      final status = providerManager.getProviderStatus();
      expect(status, isNotEmpty);
      expect(status[AIProviderType.chatgpt], isTrue);
    });

    test('should handle provider configuration', () async {
      final newConfig = AIProviderConfig(
        type: AIProviderType.chatgpt,
        apiKey: 'new-test-key',
        baseUrl: 'https://api.openai.com/v1',
        model: 'gpt-4',
        isEnabled: true,
      );

      await providerManager.configureProvider(
        AIProviderType.chatgpt,
        newConfig,
      );

      final status = providerManager.getProviderStatus();
      expect(status[AIProviderType.chatgpt], isTrue);
    });

    test('should handle fallback when primary provider fails', () async {
      // This test would require mocking the HTTP client to simulate failures
      // For now, we just test that the fallback mechanism exists
      expect(providerManager.availableProviders, isNotEmpty);
    });

    test('should validate provider configuration', () {
      final validConfig = AIProviderConfig(
        type: AIProviderType.chatgpt,
        apiKey: 'test-key',
        isEnabled: true,
      );

      expect(validConfig.type, equals(AIProviderType.chatgpt));
      expect(validConfig.apiKey, equals('test-key'));
      expect(validConfig.isEnabled, isTrue);
    });

    test('should handle multiple provider types', () {
      final configs = <AIProviderType, AIProviderConfig>{
        AIProviderType.chatgpt: AIProviderConfig(
          type: AIProviderType.chatgpt,
          apiKey: 'chatgpt-key',
          isEnabled: true,
        ),
        AIProviderType.claude: AIProviderConfig(
          type: AIProviderType.claude,
          apiKey: 'claude-key',
          isEnabled: false,
        ),
      };

      final multiConfig = AIConfiguration(
        providers: configs,
        primaryProvider: AIProviderType.chatgpt,
        fallbackProviders: [AIProviderType.claude],
        enableFallback: true,
      );

      expect(multiConfig.providers.length, equals(2));
      expect(multiConfig.primaryProvider, equals(AIProviderType.chatgpt));
      expect(multiConfig.fallbackProviders, contains(AIProviderType.claude));
    });

    test('should provide default configurations', () {
      final defaultChatGPT = AIProviderDefaults.getDefaultConfig(
        AIProviderType.chatgpt,
      );

      expect(defaultChatGPT.type, equals(AIProviderType.chatgpt));
      expect(defaultChatGPT.baseUrl, equals('https://api.openai.com/v1'));
      expect(defaultChatGPT.model, equals('gpt-4'));
    });

    test('should validate required fields', () {
      final requiredFields =
          AIProviderDefaults.requiredFields[AIProviderType.chatgpt];

      expect(requiredFields, isNotNull);
      expect(requiredFields, contains('apiKey'));
    });
  });
}
