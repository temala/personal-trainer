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
      // Safe null check for response data
      final content = response.data?['content'] as String?;
      if (content == null || content.isEmpty) {
        return createErrorResponse(
          request.requestId,
          'Empty response content from ChatGPT',
          errorCode: 'EMPTY_RESPONSE',
        );
      }

      final workoutPlan = _parseWorkoutPlanResponse(content);
      return createSuccessResponse(request.requestId, {
        'workoutPlan': workoutPlan,
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
      final content = response.data?['content'] as String?;
      if (content == null || content.isEmpty) {
        return createErrorResponse(
          request.requestId,
          'Empty response content from ChatGPT',
          errorCode: 'EMPTY_RESPONSE',
        );
      }

      final alternative = _parseAlternativeExerciseResponse(content);
      return createSuccessResponse(request.requestId, {
        'alternativeExercise': alternative,
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
      final content = response.data?['content'] as String?;
      if (content == null || content.isEmpty) {
        return createErrorResponse(
          request.requestId,
          'Empty response content from ChatGPT',
          errorCode: 'EMPTY_RESPONSE',
        );
      }

      final notification = _parseNotificationResponse(content);
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
      final content = response.data?['content'] as String?;
      if (content == null || content.isEmpty) {
        return createErrorResponse(
          request.requestId,
          'Empty response content from ChatGPT',
          errorCode: 'EMPTY_RESPONSE',
        );
      }

      final analysis = _parseProgressAnalysisResponse(content);
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
          'model': config.additionalConfig?['model'] ?? 'gpt-4',
          'messages': [
            {
              'role': 'system',
              'content':
                  'You are a fitness AI assistant that provides structured JSON responses for workout planning and fitness guidance.',
            },
            {'role': 'user', 'content': prompt},
          ],
          'max_tokens': config.additionalConfig?['max_tokens'] ?? 2000,
          'temperature': config.additionalConfig?['temperature'] ?? 0.7,
        },
      );

      // Improved null safety for response parsing
      final responseData = response.data;
      if (responseData == null) {
        return createErrorResponse(
          requestId,
          'Null response from ChatGPT API',
          errorCode: 'NULL_RESPONSE',
        );
      }

      final choices = responseData['choices'] as List?;
      if (choices == null || choices.isEmpty) {
        return createErrorResponse(
          requestId,
          'No choices in ChatGPT response',
          errorCode: 'NO_CHOICES',
        );
      }

      final choice = choices[0] as Map<String, dynamic>?;
      if (choice == null) {
        return createErrorResponse(
          requestId,
          'Invalid choice structure in ChatGPT response',
          errorCode: 'INVALID_CHOICE',
        );
      }

      final message = choice['message'] as Map<String, dynamic>?;
      if (message == null) {
        return createErrorResponse(
          requestId,
          'Invalid message structure in ChatGPT response',
          errorCode: 'INVALID_MESSAGE',
        );
      }

      final content = message['content'] as String?;
      if (content == null || content.isEmpty) {
        return createErrorResponse(
          requestId,
          'No content in ChatGPT response message',
          errorCode: 'NO_CONTENT',
        );
      }

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
    } catch (e) {
      _logger.e('Unexpected error in _callChatGPT: $e');
      return createErrorResponse(
        requestId,
        'Unexpected error: $e',
        errorCode: 'UNEXPECTED_ERROR',
      );
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
    try {
      // First try to parse the entire content as JSON
      Map<String, dynamic> decoded;
      try {
        final parsedJson = jsonDecode(content);
        decoded = Map<String, dynamic>.from(parsedJson as Map);
      } catch (e) {
        // If that fails, try to extract JSON from the response
        final jsonMatch = RegExp(r'\{.*\}', dotAll: true).firstMatch(content);
        if (jsonMatch != null) {
          final jsonString = jsonMatch.group(0);
          if (jsonString != null) {
            final parsedJson = jsonDecode(jsonString);
            decoded = Map<String, dynamic>.from(parsedJson as Map);
          } else {
            throw const FormatException('No valid JSON found in response');
          }
        } else {
          throw const FormatException('No valid JSON found in response');
        }
      }

      // Transform ChatGPT response to WorkoutPlan format
      final weeklyPlan = decoded['weeklyPlan'] as List?;
      if (weeklyPlan == null || weeklyPlan.isEmpty) {
        throw const FormatException('No weeklyPlan found in response');
      }

      // Collect all exercises from all days
      final allExercises = <Map<String, dynamic>>[];
      var exerciseOrder = 0;

      for (final day in weeklyPlan) {
        final dayData = Map<String, dynamic>.from(day as Map);
        final exercises = dayData['exercises'] as List?;
        final isRestDay = dayData['restDay'] as bool? ?? false;

        if (!isRestDay && exercises != null) {
          for (final exercise in exercises) {
            final exerciseData = Map<String, dynamic>.from(exercise as Map);

            // Transform to WorkoutExercise format
            allExercises.add({
              'exerciseId':
                  exerciseData['id']?.toString() ?? 'unknown_$exerciseOrder',
              'order': exerciseOrder++,
              'sets': (exerciseData['sets'] as num?)?.toInt() ?? 1,
              'repsPerSet': (exerciseData['reps'] as num?)?.toInt() ?? 10,
              'restBetweenSetsSeconds':
                  (exerciseData['duration'] as num?)?.toInt() ?? 60,
              'exerciseName':
                  exerciseData['name']?.toString() ?? 'Unknown Exercise',
              'exerciseDescription':
                  exerciseData['description']?.toString() ?? '',
              'exerciseMetadata': <String, dynamic>{},
              'customInstructions': <String, dynamic>{},
              'alternativeExerciseIds': <String>[],
            });
          }
        }
      }

      // Create WorkoutPlan structure
      return {
        'id': 'ai_generated_${DateTime.now().millisecondsSinceEpoch}',
        'name': 'AI Generated Workout',
        'description': 'Personalized workout plan generated by AI',
        'exercises': allExercises,
        'type': 'strength_training', // Default type
        'difficulty': 'beginner', // Default difficulty
        'estimatedDurationMinutes': 30,
        'targetMuscleGroups': ['full_body'],
        'metadata': <String, dynamic>{
          'generatedBy': 'ChatGPT',
          'originalResponse': decoded,
        },
        'userId': null,
        'aiGeneratedBy': 'ChatGPT',
        'aiGenerationContext': <String, dynamic>{
          'timestamp': DateTime.now().toIso8601String(),
          'provider': 'ChatGPT',
        },
        'isTemplate': false,
        'isActive': true,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      _logger.e('Failed to parse workout plan response: $e');
      throw FormatException('Failed to parse workout plan: $e');
    }
  }

  Map<String, dynamic> _parseAlternativeExerciseResponse(String content) {
    try {
      final decoded = jsonDecode(content);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } catch (e) {
      final jsonMatch = RegExp(r'\{.*\}', dotAll: true).firstMatch(content);
      if (jsonMatch != null) {
        final jsonString = jsonMatch.group(0);
        if (jsonString != null) {
          try {
            final decoded = jsonDecode(jsonString);
            if (decoded is Map<String, dynamic>) {
              return decoded;
            }
          } catch (e) {
            _logger.w('Failed to parse extracted JSON: $e');
          }
        }
      }
    }
    throw const FormatException('No valid JSON found in response');
  }

  Map<String, dynamic> _parseNotificationResponse(String content) {
    try {
      final decoded = jsonDecode(content);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } catch (e) {
      final jsonMatch = RegExp(r'\{.*\}', dotAll: true).firstMatch(content);
      if (jsonMatch != null) {
        final jsonString = jsonMatch.group(0);
        if (jsonString != null) {
          try {
            final decoded = jsonDecode(jsonString);
            if (decoded is Map<String, dynamic>) {
              return decoded;
            }
          } catch (e) {
            _logger.w('Failed to parse extracted JSON: $e');
          }
        }
      }
    }
    throw const FormatException('No valid JSON found in response');
  }

  Map<String, dynamic> _parseProgressAnalysisResponse(String content) {
    try {
      final decoded = jsonDecode(content);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } catch (e) {
      final jsonMatch = RegExp(r'\{.*\}', dotAll: true).firstMatch(content);
      if (jsonMatch != null) {
        final jsonString = jsonMatch.group(0);
        if (jsonString != null) {
          try {
            final decoded = jsonDecode(jsonString);
            if (decoded is Map<String, dynamic>) {
              return decoded;
            }
          } catch (e) {
            _logger.w('Failed to parse extracted JSON: $e');
          }
        }
      }
    }
    throw const FormatException('No valid JSON found in response');
  }

  @override
  Future<bool> testConnection() async {
    try {
      _logger.i('Testing ChatGPT connection...');
      _logger.i('API Key configured: ${config.apiKey.isNotEmpty}');
      _logger.i('Base URL: ${config.baseUrl}');

      if (!isConfigured) {
        _logger.w('ChatGPT provider not configured - API key missing');
        return false;
      }

      // For now, just return true if configured
      // Real connection testing can be done when making actual requests
      _logger.i('ChatGPT provider is configured and ready');
      return true;
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
    // Check if provider is configured first
    if (!isConfigured) {
      return ProviderStatus(
        type: AIProviderType.chatgpt,
        isAvailable: false,
        lastChecked: DateTime.now(),
        errorMessage: 'API key not configured',
      );
    }

    // For now, consider the provider available if it's configured
    // The actual connection test will happen when making real requests
    return ProviderStatus(
      type: AIProviderType.chatgpt,
      isAvailable: true,
      lastChecked: DateTime.now(),
      errorMessage: null,
    );
  }
}
