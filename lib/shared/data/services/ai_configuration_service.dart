import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitness_training_app/shared/domain/entities/ai_provider_config.dart';
import 'package:fitness_training_app/shared/domain/repositories/ai_service_repository.dart';
import 'package:logger/logger.dart';

/// Service for managing AI provider configurations
class AIConfigurationService {
  static const String _configKey = 'ai_configuration';
  static const String _apiKeysPrefix = 'ai_api_key_';

  final SharedPreferences _prefs;
  final FlutterSecureStorage _secureStorage;
  final Logger _logger = Logger();
  AIConfigurationService({
    required SharedPreferences prefs,
    required FlutterSecureStorage secureStorage,
  }) : _prefs = prefs,
       _secureStorage = secureStorage;

  /// Load AI configuration from storage
  Future<AIConfiguration> loadConfiguration() async {
    try {
      final configJson = _prefs.getString(_configKey);
      if (configJson == null) {
        return _getDefaultConfiguration();
      }

      final configData = json.decode(configJson) as Map<String, dynamic>;

      // Load API keys from secure storage
      final providers = <AIProviderType, ProviderConfig>{};
      for (final entry
          in (configData['providers'] as Map<String, dynamic>).entries) {
        final type = AIProviderType.values.firstWhere(
          (t) => t.name == entry.key,
          orElse: () => AIProviderType.custom,
        );

        final providerData = entry.value as Map<String, dynamic>;
        final apiKey =
            await _secureStorage.read(key: '$_apiKeysPrefix${type.name}') ?? '';

        providers[type] = ProviderConfig.fromJson({
          ...providerData,
          'apiKey': apiKey,
        });
      }

      return AIConfiguration(
        providers: providers,
        primaryProvider: AIProviderType.values.firstWhere(
          (t) => t.name == configData['primaryProvider'],
          orElse: () => AIProviderType.chatgpt,
        ),
        fallbackProviders:
            (configData['fallbackProviders'] as List?)
                ?.map(
                  (name) => AIProviderType.values.firstWhere(
                    (t) => t.name == name,
                    orElse: () => AIProviderType.chatgpt,
                  ),
                )
                .toList() ??
            [],
        enableFallback: configData['enableFallback'] as bool? ?? true,
        maxRetries: configData['maxRetries'] as int? ?? 3,
      );
    } catch (e) {
      _logger.e('Failed to load AI configuration', error: e);
      return _getDefaultConfiguration();
    }
  }

  /// Save AI configuration to storage
  Future<void> saveConfiguration(AIConfiguration configuration) async {
    try {
      // Save API keys to secure storage
      for (final entry in configuration.providers.entries) {
        final type = entry.key;
        final config = entry.value;

        if (config.apiKey.isNotEmpty) {
          await _secureStorage.write(
            key: '$_apiKeysPrefix${type.name}',
            value: config.apiKey,
          );
        }
      }

      // Save configuration (without API keys) to shared preferences
      final configData = {
        'providers': configuration.providers.map(
          (type, config) =>
              MapEntry(type.name, config.copyWith(apiKey: '').toJson()),
        ),
        'primaryProvider': configuration.primaryProvider.name,
        'fallbackProviders':
            configuration.fallbackProviders.map((t) => t.name).toList(),
        'enableFallback': configuration.enableFallback,
        'maxRetries': configuration.maxRetries,
      };

      await _prefs.setString(_configKey, json.encode(configData));
      _logger.i('AI configuration saved successfully');
    } catch (e) {
      _logger.e('Failed to save AI configuration', error: e);
      rethrow;
    }
  }

  /// Configure a specific provider
  Future<void> configureProvider({
    required AIProviderType type,
    required String apiKey,
    Map<String, dynamic>? additionalConfig,
    String? baseUrl,
    String? model,
    bool? isEnabled,
  }) async {
    try {
      final currentConfig = await loadConfiguration();

      final config = Map<String, dynamic>.from(additionalConfig ?? {});
      if (model != null) {
        config['model'] = model;
      }

      final providerConfig = ProviderConfig(
        type: type,
        apiKey: apiKey,
        additionalConfig: config,
        baseUrl: baseUrl,
        isEnabled: isEnabled ?? true,
      );

      final updatedProviders = Map<AIProviderType, ProviderConfig>.from(
        currentConfig.providers,
      );
      updatedProviders[type] = providerConfig;

      final updatedConfig = currentConfig.copyWith(providers: updatedProviders);
      await saveConfiguration(updatedConfig);

      _logger.i('Provider $type configured successfully');
    } catch (e) {
      _logger.e('Failed to configure provider $type', error: e);
      rethrow;
    }
  }

  /// Remove a provider configuration
  Future<void> removeProvider(AIProviderType type) async {
    try {
      final currentConfig = await loadConfiguration();

      final updatedProviders = Map<AIProviderType, ProviderConfig>.from(
        currentConfig.providers,
      );
      updatedProviders.remove(type);

      // Remove API key from secure storage
      await _secureStorage.delete(key: '$_apiKeysPrefix${type.name}');

      final updatedConfig = currentConfig.copyWith(providers: updatedProviders);
      await saveConfiguration(updatedConfig);

      _logger.i('Provider $type removed successfully');
    } catch (e) {
      _logger.e('Failed to remove provider $type', error: e);
      rethrow;
    }
  }

  /// Set primary provider
  Future<void> setPrimaryProvider(AIProviderType type) async {
    try {
      final currentConfig = await loadConfiguration();

      if (!currentConfig.providers.containsKey(type)) {
        throw ArgumentError('Provider $type is not configured');
      }

      final updatedConfig = currentConfig.copyWith(primaryProvider: type);
      await saveConfiguration(updatedConfig);

      _logger.i('Primary provider set to $type');
    } catch (e) {
      _logger.e('Failed to set primary provider', error: e);
      rethrow;
    }
  }

  /// Update fallback providers
  Future<void> setFallbackProviders(
    List<AIProviderType> fallbackProviders,
  ) async {
    try {
      final currentConfig = await loadConfiguration();

      // Validate that all fallback providers are configured
      for (final type in fallbackProviders) {
        if (!currentConfig.providers.containsKey(type)) {
          throw ArgumentError('Fallback provider $type is not configured');
        }
      }

      final updatedConfig = currentConfig.copyWith(
        fallbackProviders: fallbackProviders,
      );
      await saveConfiguration(updatedConfig);

      _logger.i('Fallback providers updated');
    } catch (e) {
      _logger.e('Failed to update fallback providers', error: e);
      rethrow;
    }
  }

  /// Enable or disable fallback mechanism
  Future<void> setFallbackEnabled(bool enabled) async {
    try {
      final currentConfig = await loadConfiguration();
      final updatedConfig = currentConfig.copyWith(enableFallback: enabled);
      await saveConfiguration(updatedConfig);

      _logger.i('Fallback mechanism ${enabled ? 'enabled' : 'disabled'}');
    } catch (e) {
      _logger.e('Failed to update fallback setting', error: e);
      rethrow;
    }
  }

  /// Get API key for a specific provider
  Future<String?> getApiKey(AIProviderType type) async {
    try {
      return await _secureStorage.read(key: '$_apiKeysPrefix${type.name}');
    } catch (e) {
      _logger.e('Failed to get API key for $type', error: e);
      return null;
    }
  }

  /// Check if a provider is configured
  Future<bool> isProviderConfigured(AIProviderType type) async {
    try {
      final config = await loadConfiguration();
      final providerConfig = config.providers[type];
      if (providerConfig == null || !providerConfig.isEnabled) return false;

      final apiKey = await getApiKey(type);
      return apiKey != null && apiKey.isNotEmpty;
    } catch (e) {
      _logger.e('Failed to check provider configuration', error: e);
      return false;
    }
  }

  /// Get default configuration
  AIConfiguration _getDefaultConfiguration() {
    return AIConfiguration(
      providers: {AIProviderType.chatgpt: ProviderConfig.chatgpt(apiKey: '')},
      primaryProvider: AIProviderType.chatgpt,
      fallbackProviders: [],
      enableFallback: true,
      maxRetries: 3,
    );
  }

  /// Clear all configuration
  Future<void> clearConfiguration() async {
    try {
      await _prefs.remove(_configKey);

      // Clear all API keys
      for (final type in AIProviderType.values) {
        await _secureStorage.delete(key: '$_apiKeysPrefix${type.name}');
      }

      _logger.i('AI configuration cleared');
    } catch (e) {
      _logger.e('Failed to clear configuration', error: e);
      rethrow;
    }
  }

  /// Export configuration (without API keys) for backup
  Future<Map<String, dynamic>> exportConfiguration() async {
    try {
      final config = await loadConfiguration();
      return {
        'providers': config.providers.map(
          (type, providerConfig) =>
              MapEntry(type.name, providerConfig.copyWith(apiKey: '').toJson()),
        ),
        'primaryProvider': config.primaryProvider.name,
        'fallbackProviders':
            config.fallbackProviders.map((t) => t.name).toList(),
        'enableFallback': config.enableFallback,
        'maxRetries': config.maxRetries,
        'exportedAt': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      _logger.e('Failed to export configuration', error: e);
      rethrow;
    }
  }

  /// Import configuration (API keys must be set separately)
  Future<void> importConfiguration(Map<String, dynamic> configData) async {
    try {
      final providers = <AIProviderType, ProviderConfig>{};

      for (final entry
          in (configData['providers'] as Map<String, dynamic>).entries) {
        final type = AIProviderType.values.firstWhere(
          (t) => t.name == entry.key,
          orElse: () => AIProviderType.custom,
        );

        providers[type] = ProviderConfig.fromJson(
          entry.value as Map<String, dynamic>,
        );
      }

      final configuration = AIConfiguration(
        providers: providers,
        primaryProvider: AIProviderType.values.firstWhere(
          (t) => t.name == configData['primaryProvider'],
          orElse: () => AIProviderType.chatgpt,
        ),
        fallbackProviders:
            (configData['fallbackProviders'] as List?)
                ?.map(
                  (name) => AIProviderType.values.firstWhere(
                    (t) => t.name == name,
                    orElse: () => AIProviderType.chatgpt,
                  ),
                )
                .toList() ??
            [],
        enableFallback: configData['enableFallback'] as bool? ?? true,
        maxRetries: configData['maxRetries'] as int? ?? 3,
      );

      await saveConfiguration(configuration);
      _logger.i('Configuration imported successfully');
    } catch (e) {
      _logger.e('Failed to import configuration', error: e);
      rethrow;
    }
  }
}
