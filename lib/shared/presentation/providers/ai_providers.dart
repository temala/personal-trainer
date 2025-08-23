import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitness_training_app/shared/data/services/ai_service.dart';
import 'package:fitness_training_app/shared/data/services/ai_provider_manager.dart';
import 'package:fitness_training_app/shared/data/services/ai_configuration_service.dart';
import 'package:fitness_training_app/shared/data/models/ai_provider_config.dart';
import 'package:fitness_training_app/shared/domain/repositories/ai_service_repository.dart';
import 'package:fitness_training_app/shared/domain/entities/workout_plan.dart';
import 'package:fitness_training_app/shared/domain/entities/exercise.dart';
import 'package:fitness_training_app/shared/domain/entities/user_profile.dart';
import 'package:fitness_training_app/shared/domain/entities/ai_request.dart';
import 'package:fitness_training_app/core/config/env_config.dart';
import 'package:fitness_training_app/core/utils/logger.dart';
import 'package:logger/logger.dart';

// AI Configuration Provider
final aiConfigurationProvider = StateProvider<AIConfiguration>((ref) {
  // Default configuration - can be overridden by user settings
  final chatGptConfig = AIProviderConfig(
    type: AIProviderType.chatgpt,
    apiKey: EnvConfig.primaryOpenAIKey ?? '',
    model: 'gpt-4',
    baseUrl: 'https://api.openai.com/v1',
    additionalConfig: {'maxTokens': 2000, 'temperature': 0.7},
  );

  return AIConfiguration(
    providers: {AIProviderType.chatgpt: chatGptConfig},
    primaryProvider: AIProviderType.chatgpt,
    fallbackProviders: [],
    enableFallback: true,
  );
});

// AI Provider Manager Provider
final aiProviderManagerProvider = Provider<AIProviderManager>((ref) {
  final configuration = ref.watch(aiConfigurationProvider);
  final logger = ref.watch(loggerProvider);

  return AIProviderManager(configuration: configuration, logger: logger);
});

// AI Service Provider
final aiServiceProvider = Provider<AIService>((ref) {
  final providerManager = ref.watch(aiProviderManagerProvider);
  final logger = ref.watch(loggerProvider);

  return AIService(providerManager: providerManager, logger: logger);
});

// Provider Status Provider
final aiProviderStatusProvider = FutureProvider<Map<AIProviderType, bool>>((
  ref,
) async {
  final aiService = ref.watch(aiServiceProvider);
  return aiService.getProviderStatus();
});

// Connection Test Provider
final aiConnectionTestProvider = FutureProvider<Map<AIProviderType, bool>>((
  ref,
) async {
  final aiService = ref.watch(aiServiceProvider);
  return await aiService.testProviderConnections();
});

// Provider Configuration State
class AIProviderConfigState {
  final Map<AIProviderType, AIProviderConfig> providers;
  final bool isLoading;
  final String? error;

  const AIProviderConfigState({
    this.providers = const {},
    this.isLoading = false,
    this.error,
  });

  AIProviderConfigState copyWith({
    Map<AIProviderType, AIProviderConfig>? providers,
    bool? isLoading,
    String? error,
  }) {
    return AIProviderConfigState(
      providers: providers ?? this.providers,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Provider Configuration Notifier
class AIProviderConfigNotifier extends StateNotifier<AIProviderConfigState> {
  final AIService _aiService;
  final Ref _ref;

  AIProviderConfigNotifier(this._aiService, this._ref)
    : super(const AIProviderConfigState()) {
    _loadCurrentConfiguration();
  }

  void _loadCurrentConfiguration() {
    final configuration = _ref.read(aiConfigurationProvider);
    state = state.copyWith(providers: configuration.providers);
  }

  Future<void> configureProvider({
    required AIProviderType type,
    required String apiKey,
    Map<String, dynamic>? additionalConfig,
    String? baseUrl,
    String? model,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final config = AIProviderConfig(
        type: type,
        apiKey: apiKey,
        additionalConfig: additionalConfig ?? {},
        baseUrl: baseUrl,
        model: model,
      );

      await _aiService.configureProvider(
        type: type,
        apiKey: apiKey,
        additionalConfig: additionalConfig,
      );

      // Update local state
      final updatedProviders = Map<AIProviderType, AIProviderConfig>.from(
        state.providers,
      );
      updatedProviders[type] = config;

      state = state.copyWith(providers: updatedProviders, isLoading: false);

      // Update global configuration
      final currentConfig = _ref.read(aiConfigurationProvider);
      final updatedConfig = currentConfig.copyWith(providers: updatedProviders);
      _ref.read(aiConfigurationProvider.notifier).state = updatedConfig;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> testProvider(AIProviderType type) async {
    try {
      final results = await _aiService.testProviderConnections();
      return results[type] ?? false;
    } catch (e) {
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void removeProvider(AIProviderType type) {
    final updatedProviders = Map<AIProviderType, AIProviderConfig>.from(
      state.providers,
    );
    updatedProviders.remove(type);

    state = state.copyWith(providers: updatedProviders);

    // Update global configuration
    final currentConfig = _ref.read(aiConfigurationProvider);
    final updatedConfig = currentConfig.copyWith(providers: updatedProviders);
    _ref.read(aiConfigurationProvider.notifier).state = updatedConfig;
  }
}

// Provider Configuration State Provider
final aiProviderConfigProvider =
    StateNotifierProvider<AIProviderConfigNotifier, AIProviderConfigState>((
      ref,
    ) {
      final aiService = ref.watch(aiServiceProvider);
      return AIProviderConfigNotifier(aiService, ref);
    });

// Workout Plan Generation Provider
final workoutPlanGenerationProvider =
    FutureProvider.family<WorkoutPlan?, WorkoutPlanGenerationParams>((
      ref,
      params,
    ) async {
      final aiService = ref.watch(aiServiceProvider);

      if (!aiService.hasAvailableProvider) {
        throw Exception('No AI provider configured');
      }

      return await aiService.generateWeeklyWorkoutPlan(
        userProfile: params.userProfile,
        availableExercises: params.availableExercises,
        preferences: params.preferences,
        constraints: params.constraints,
      );
    });

// Alternative Exercise Provider
final alternativeExerciseProvider =
    FutureProvider.family<Exercise?, AlternativeExerciseParams>((
      ref,
      params,
    ) async {
      final aiService = ref.watch(aiServiceProvider);

      return await aiService.getAlternativeExercise(
        currentExerciseId: params.currentExerciseId,
        alternativeType: params.alternativeType,
        availableExercises: params.availableExercises,
        userId: params.userId,
        userContext: params.userContext,
        previouslyRejectedExercises: params.previouslyRejectedExercises,
      );
    });

// Progress Analysis Provider
final progressAnalysisProvider =
    FutureProvider.family<ProgressAnalysis?, ProgressAnalysisParams>((
      ref,
      params,
    ) async {
      final aiService = ref.watch(aiServiceProvider);

      if (!aiService.hasAvailableProvider) {
        return null;
      }

      return await aiService.analyzeUserProgress(
        userId: params.userId,
        progressData: params.progressData,
      );
    });

// Parameter classes for providers
class WorkoutPlanGenerationParams {
  final UserProfile userProfile;
  final List<Exercise> availableExercises;
  final Map<String, dynamic>? preferences;
  final Map<String, dynamic>? constraints;

  const WorkoutPlanGenerationParams({
    required this.userProfile,
    required this.availableExercises,
    this.preferences,
    this.constraints,
  });
}

class AlternativeExerciseParams {
  final String currentExerciseId;
  final AlternativeType alternativeType;
  final List<Exercise> availableExercises;
  final String? userId;
  final Map<String, dynamic>? userContext;
  final List<String>? previouslyRejectedExercises;

  const AlternativeExerciseParams({
    required this.currentExerciseId,
    required this.alternativeType,
    required this.availableExercises,
    this.userId,
    this.userContext,
    this.previouslyRejectedExercises,
  });
}

class ProgressAnalysisParams {
  final String userId;
  final Map<String, dynamic> progressData;

  const ProgressAnalysisParams({
    required this.userId,
    required this.progressData,
  });
}

// Configuration Service Provider
final aiConfigurationServiceProvider = Provider<AIConfigurationService>((ref) {
  throw UnimplementedError(
    'AIConfigurationService must be overridden with actual dependencies',
  );
});

// Logger Provider
final loggerProvider = Provider<Logger>((ref) => Logger());
