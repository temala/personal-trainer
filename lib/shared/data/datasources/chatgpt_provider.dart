import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fitness_training_app/shared/domain/entities/ai_provider_config.dart';
import 'package:fitness_training_app/shared/domain/entities/ai_request.dart';
import 'package:fitness_training_app/shared/domain/entities/ai_response.dart';
import 'package:fitness_training_app/shared/domain/repositories/ai_provider_repository.dart';
import 'package:logger/logger.dart';

/// ChatGPT API provider implementation
class ChatGPTProvider extends BaseAIProvider {
  ChatGPTProvider(super.config, {Dio? dio, Logger? logger})
    : _dio = dio ?? Dio(),
      _logger = logger ?? Logger() {
    _setupDio();
  }
  final Dio _dio;
  final Logger _logger;

  void _setupDio() {
    _dio.options = BaseOptions(
      baseUrl: config.baseUrl ?? 'https://api.openai.com/v1',
      connectTimeout: Duration(seconds: config.timeoutSeconds),
      receiveTimeout: Duration(seconds: config.timeoutSeconds),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${config.apiKey}',
      },
    );

    // Add logging interceptor in debug mode
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: _logger.d,
      ),
    );
  }

  @override
  String get providerName => 'ChatGPT';

  @override
  Future<AIResponse> processRequest(AIRequest request) async {
    if (!validateRequest(request)) {
      return createErrorResponse(
        request.requestId,
        'Invalid request parameters',
        errorCode: 'INVALID_REQUEST',
      );
    }

    if (!isConfigured) {
      return createErrorResponse(
        request.requestId,
        'ChatGPT provider not configured',
        errorCode: 'NOT_CONFIGURED',
      );
    }

    try {
      switch (request.type) {
        case AIRequestType.generateWorkoutPlan:
          return await _generateWorkoutPlan(request);
        case AIRequestType.getAlternativeExercise:
          return await _getAlternativeExercise(request);
        case AIRequestType.generateNotification:
          return await _generateNotification(request);
        case AIRequestType.analyzeProgress:
          return await _analyzeProgress(request);
        case AIRequestType.createAvatar:
        case AIRequestType.customWorkflow:
        case AIRequestType.evaluateCommitment:
        case AIRequestType.generateAdvice:
          return createErrorResponse(
            request.requestId,
            'Unsupported request type: ${request.type}',
            errorCode: 'UNSUPPORTED_TYPE',
          );
      }
    } catch (e) {
      _logger.e('ChatGPT API error: $e');
      return createErrorResponse(
        request.requestId,
        'ChatGPT API error: $e',
        errorCode: 'API_ERROR',
      );
    }
  }

  Future<AIResponse> _generateWorkoutPlan(AIRequest request) async {
    final prompt = _buildWorkoutPlanPrompt(request.payload);
    final response = await _callChatGPT(prompt, request.requestId);

    if (!response.success) return response;

    try {
      final workoutPlan = _parseWorkoutPlanResponse(
        response.data['content'] as String,
      );
      return createSuccessResponse(request.requestId, {
        'workout_plan': workoutPlan,
        'generated_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      return createErrorResponse(
        request.requestId,
        'Failed to parse workout plan response: $e',
        errorCode: 'PARSE_ERROR',
      );
    }
  }

  Future<AIResponse> _getAlternativeExercise(AIRequest request) async {
    final prompt = _buildAlternativeExercisePrompt(request.payload);
    final response = await _callChatGPT(prompt, request.requestId);

    if (!response.success) return response;

    try {
      final alternative = _parseAlternativeExerciseResponse(
        response.data['content'] as String,
      );
      return createSuccessResponse(request.requestId, {
        'alternative_exercise': alternative,
        'reason': request.payload['alternativeType'],
      });
    } catch (e) {
      return createErrorResponse(
        request.requestId,
        'Failed to parse alternative exercise response: $e',
        errorCode: 'PARSE_ERROR',
      );
    }
  }

  Future<AIResponse> _generateNotification(AIRequest request) async {
    final prompt = _buildNotificationPrompt(request.payload);
    final response = await _callChatGPT(prompt, request.requestId);

    if (!response.success) return response;

    try {
      final notification = _parseNotificationResponse(
        response.data['content'] as String,
      );
      return createSuccessResponse(request.requestId, {
        'notification': notification,
        'generated_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      return createErrorResponse(
        request.requestId,
        'Failed to parse notification response: $e',
        errorCode: 'PARSE_ERROR',
      );
    }
  }

  Future<AIResponse> _analyzeProgress(AIRequest request) async {
    final prompt = _buildProgressAnalysisPrompt(request.payload);
    final response = await _callChatGPT(prompt, request.requestId);

    if (!response.success) return response;

    try {
      final analysis = _parseProgressAnalysisResponse(
        response.data['content'] as String,
      );
      return createSuccessResponse(request.requestId, {
        'analysis': analysis,
        'analyzed_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      return createErrorResponse(
        request.requestId,
        'Failed to parse progress analysis response: $e',
        errorCode: 'PARSE_ERROR',
      );
    }
  }

  Future<AIResponse> _callChatGPT(String prompt, String requestId) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/chat/completions',
        data: {
          'model': config.additionalConfig['model'] ?? 'gpt-4',
          'messages': [
            {
              'role': 'system',
              'content':
                  'You are a fitness AI assistant that provides structured JSON responses for workout planning and fitness guidance.',
            },
            {'role': 'user', 'content': prompt},
          ],
          'max_tokens': config.additionalConfig['max_tokens'] ?? 2000,
          'temperature': config.additionalConfig['temperature'] ?? 0.7,
        },
      );

      final responseData = response.data!;
      final choices = responseData['choices'] as List;
      final message = choices[0] as Map<String, dynamic>;
      final content = message['content'] as String;
      return createSuccessResponse(requestId, {'content': content});
    } on DioException catch (e) {
      var errorMessage = 'ChatGPT API request failed';
      String? errorCode;

      if (e.response != null) {
        final statusCode = e.response!.statusCode;
        errorCode = 'HTTP_$statusCode';

        switch (statusCode) {
          case 401:
            errorMessage = 'Invalid API key';
          case 429:
            errorMessage = 'Rate limit exceeded';
          case 500:
            errorMessage = 'ChatGPT server error';
          default:
            errorMessage = 'HTTP error: $statusCode';
        }
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'Connection timeout';
        errorCode = 'TIMEOUT';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Response timeout';
        errorCode = 'TIMEOUT';
      }

      return createErrorResponse(requestId, errorMessage, errorCode: errorCode);
    }
  }

  String _buildWorkoutPlanPrompt(Map<String, dynamic> payload) {
    return '''
Create a personalized weekly workout plan based on the following user profile and available exercises.

User Profile:
${jsonEncode(payload['userProfile'] ?? {})}

Available Exercises:
${jsonEncode(payload['availableExercises'] ?? [])}

${payload['preferences'] != null ? 'User Preferences:\n${jsonEncode(payload['preferences'])}' : ''}

${payload['excludedExercises'] != null ? 'Excluded Exercises:\n${(payload['excludedExercises'] as List).join(', ')}' : ''}

Please respond with a JSON object containing a "weeklyPlan" array with 7 days, where each day contains:
- "day": day name (Monday, Tuesday, etc.)
- "exercises": array of exercise objects with "id", "name", "sets", "reps", "duration"
- "restDay": boolean indicating if it's a rest day

Only use exercises from the provided available exercises list.
''';
  }

  String _buildAlternativeExercisePrompt(Map<String, dynamic> payload) {
    return '''
Find an alternative exercise for the current exercise based on user feedback.

Current Exercise ID: ${payload['currentExerciseId']}
Alternative Type: ${payload['alternativeType']}
User Context: ${jsonEncode(payload['userContext'] ?? {})}

Available Exercises:
${jsonEncode(payload['availableExercises'] ?? [])}

Please respond with a JSON object containing:
- "exerciseId": ID of the alternative exercise
- "name": name of the alternative exercise
- "reason": brief explanation for the selection

Only select from the provided available exercises list.
''';
  }

  String _buildNotificationPrompt(Map<String, dynamic> payload) {
    return '''
Generate a personalized fitness notification message based on user context.

User Context:
${jsonEncode(payload['userContext'] ?? {})}

${payload['notificationType'] != null ? 'Notification Type: ${payload['notificationType']}' : ''}

Please respond with a JSON object containing:
- "message": the notification message (keep it motivational and personal)
- "title": optional notification title
- "category": notification category (motivation, reminder, achievement, etc.)

Keep the message under 100 characters and make it engaging and personal.
''';
  }

  String _buildProgressAnalysisPrompt(Map<String, dynamic> payload) {
    return '''
Analyze the user's fitness progress and provide insights and recommendations.

Progress Data:
${jsonEncode(payload)}

Please respond with a JSON object containing:
- "overallScore": number between 0-100 representing overall progress
- "commitmentLevel": string (low, medium, high)
- "insights": array of key insights about the user's progress
- "recommendations": array of specific recommendations for improvement
- "achievements": array of notable achievements or milestones

Focus on being encouraging while providing actionable advice.
''';
  }

  Map<String, dynamic> _parseWorkoutPlanResponse(String content) {
    // Try to extract JSON from the response
    final jsonMatch = RegExp(r'\{.*\}', dotAll: true).firstMatch(content);
    if (jsonMatch != null) {
      final decoded = jsonDecode(jsonMatch.group(0)!);
      return decoded as Map<String, dynamic>;
    }
    throw const FormatException('No valid JSON found in response');
  }

  Map<String, dynamic> _parseAlternativeExerciseResponse(String content) {
    final jsonMatch = RegExp(r'\{.*\}', dotAll: true).firstMatch(content);
    if (jsonMatch != null) {
      final decoded = jsonDecode(jsonMatch.group(0)!);
      return decoded as Map<String, dynamic>;
    }
    throw const FormatException('No valid JSON found in response');
  }

  Map<String, dynamic> _parseNotificationResponse(String content) {
    final jsonMatch = RegExp(r'\{.*\}', dotAll: true).firstMatch(content);
    if (jsonMatch != null) {
      final decoded = jsonDecode(jsonMatch.group(0)!);
      return decoded as Map<String, dynamic>;
    }
    throw const FormatException('No valid JSON found in response');
  }

  Map<String, dynamic> _parseProgressAnalysisResponse(String content) {
    final jsonMatch = RegExp(r'\{.*\}', dotAll: true).firstMatch(content);
    if (jsonMatch != null) {
      final decoded = jsonDecode(jsonMatch.group(0)!);
      return decoded as Map<String, dynamic>;
    }
    throw const FormatException('No valid JSON found in response');
  }

  @override
  Future<bool> testConnection() async {
    try {
      final testRequest = AIRequest(
        requestId: 'test-${DateTime.now().millisecondsSinceEpoch}',
        type: AIRequestType.generateNotification,
        payload: {
          'userContext': {'name': 'Test User'},
          'notificationType': 'test',
        },
        timestamp: DateTime.now(),
        userId: 'test-user',
      );

      final response = await processRequest(testRequest);
      return response.success;
    } catch (e) {
      _logger.e('ChatGPT connection test failed: $e');
      return false;
    }
  }

  @override
  Future<void> updateConfig(ProviderConfig newConfig) async {
    if (newConfig.type != AIProviderType.chatgpt) {
      throw ArgumentError('Invalid config type for ChatGPT provider');
    }

    // Update the internal config and reinitialize Dio
    // Note: In a real implementation, you'd want to update the stored config
    _setupDio();
  }

  @override
  Future<ProviderStatus> getStatus() async {
    final isAvailable = await testConnection();

    return ProviderStatus(
      type: AIProviderType.chatgpt,
      isAvailable: isAvailable,
      lastChecked: DateTime.now(),
      errorMessage: isAvailable ? null : 'Connection test failed',
    );
  }
}
