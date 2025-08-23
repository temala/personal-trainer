import 'package:logger/logger.dart';

import 'package:fitness_training_app/shared/data/repositories/ai_provider_manager.dart';
import 'package:fitness_training_app/shared/data/repositories/ai_service_repository_impl.dart';
import 'package:fitness_training_app/shared/domain/repositories/ai_service_repository.dart';
import 'package:fitness_training_app/core/config/ai_config_service.dart';

/// Service to initialize AI providers for the app
class AIServiceInitializer {
  static final _logger = Logger();
  static AIProviderManager? _providerManager;
  static AIServiceRepository? _aiService;

  /// Initialize AI services with configuration
  static Future<bool> initialize() async {
    try {
      _logger.i('Initializing AI services...');

      // Get configuration from environment or secure storage
      final config = await AIConfigService.getConfiguration();

      if (config == null) {
        _logger.w('No AI configuration found. AI features will be disabled.');
        return false;
      }

      // Initialize provider manager
      _providerManager = AIProviderManager(config, logger: _logger);

      // Test connections
      final connectionResults = await _providerManager!.testAllConnections();
      final hasWorkingProvider = connectionResults.values.any(
        (result) => result,
      );

      if (!hasWorkingProvider) {
        _logger.w('No AI providers are working. Check your configuration.');
        return false;
      }

      // Initialize high-level AI service
      _aiService = AIServiceRepositoryImpl(_providerManager!, logger: _logger);

      _logger.i('AI services initialized successfully');
      _logger.i(
        'Working providers: ${connectionResults.entries.where((e) => e.value).map((e) => e.key).toList()}',
      );

      return true;
    } catch (e) {
      _logger.e('Failed to initialize AI services: $e');
      return false;
    }
  }

  /// Get the AI provider manager instance
  static AIProviderManager? get providerManager => _providerManager;

  /// Get the AI service repository instance
  static AIServiceRepository? get aiService => _aiService;

  /// Check if AI services are available
  static bool get isAvailable => _aiService != null;

  /// Get AI service status
  static Future<Map<String, dynamic>> getStatus() async {
    if (_providerManager == null) {
      return {'initialized': false, 'available': false};
    }

    try {
      final statuses = await _providerManager!.getAllProviderStatuses();
      return {
        'initialized': true,
        'available': statuses.values.any((status) => status.isAvailable),
        'providers': statuses.map(
          (type, status) => MapEntry(type.toString(), {
            'available': status.isAvailable,
            'lastChecked': status.lastChecked.toIso8601String(),
            'error': status.errorMessage,
          }),
        ),
      };
    } catch (e) {
      return {'initialized': true, 'available': false, 'error': e.toString()};
    }
  }

  /// Dispose AI services
  static void dispose() {
    _providerManager?.dispose();
    _providerManager = null;
    _aiService = null;
    _logger.i('AI services disposed');
  }
}
