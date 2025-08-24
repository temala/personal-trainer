import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import 'package:fitness_training_app/shared/domain/entities/ai_provider_config.dart';
import 'package:fitness_training_app/shared/domain/entities/ai_request.dart';
import 'package:fitness_training_app/shared/domain/entities/ai_response.dart';
import 'package:fitness_training_app/shared/domain/repositories/ai_provider_repository.dart';

/// N8N workflow provider implementation
class N8NProvider extends BaseAIProvider {
  N8NProvider(super.config, {Dio? dio, Logger? logger})
    : _dio = dio ?? Dio(),
      _logger = logger ?? Logger() {
    _setupDio();
  }
  final Dio _dio;
  final Logger _logger;

  void _setupDio() {
    _dio.options = BaseOptions(
      connectTimeout: Duration(seconds: config.timeoutSeconds),
      receiveTimeout: Duration(seconds: config.timeoutSeconds),
      headers: {
        'Content-Type': 'application/json',
        if (config.apiKey.isNotEmpty)
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
  String get providerName => 'N8N Workflow';

  @override
  bool get isConfigured =>
      config.additionalConfig.containsKey('webhook_url') &&
      (config.additionalConfig['webhook_url']?.toString().isNotEmpty ?? false);

  String get webhookUrl =>
      config.additionalConfig['webhook_url']?.toString() ??
      config.baseUrl ??
      '';

  String? get workflowId => config.additionalConfig['workflow_id']?.toString();

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
        'N8N provider not configured - webhook URL required',
        errorCode: 'NOT_CONFIGURED',
      );
    }

    try {
      switch (request.type) {
        case AIRequestType.generateWorkoutPlan:
          return await _executeWorkflow(request, 'workout-plan-generation');
        case AIRequestType.getAlternativeExercise:
          return await _executeWorkflow(
            request,
            'alternative-exercise-selection',
          );
        case AIRequestType.generateNotification:
          return await _executeWorkflow(request, 'notification-generation');
        case AIRequestType.createAvatar:
          return await _executeWorkflow(request, 'avatar-creation');
        case AIRequestType.analyzeProgress:
          return await _executeWorkflow(request, 'progress-analysis');
        case AIRequestType.evaluateCommitment:
          return await _executeWorkflow(request, 'commitment-evaluation');
        case AIRequestType.generateAdvice:
          return await _executeWorkflow(request, 'advice-generation');
        case AIRequestType.customWorkflow:
          return await _executeCustomWorkflow(request);
      }
    } catch (e) {
      _logger.e('N8N workflow error: $e');
      return createErrorResponse(
        request.requestId,
        'N8N workflow error: $e',
        errorCode: 'WORKFLOW_ERROR',
      );
    }
  }

  Future<AIResponse> _executeWorkflow(
    AIRequest request,
    String workflowType,
  ) async {
    final workflowData = _prepareWorkflowData(request, workflowType);
    return _callN8NWebhook(workflowData, request.requestId);
  }

  Future<AIResponse> _executeCustomWorkflow(AIRequest request) async {
    final n8nRequest = N8NWorkflowRequest.fromJson(request.payload);

    final workflowData = {
      'workflowId': n8nRequest.workflowId,
      'requestId': request.requestId,
      'userId': request.userId,
      'timestamp': request.timestamp.toIso8601String(),
      'inputData': n8nRequest.inputData,
    };

    final customWebhookUrl =
        n8nRequest.metadata['webhookUrl']?.toString() ?? webhookUrl;
    final customHeaders =
        n8nRequest.metadata['headers'] as Map<String, String>?;
    return _callN8NWebhook(
      workflowData,
      request.requestId,
      customUrl: customWebhookUrl,
      customHeaders: customHeaders,
    );
  }

  Map<String, dynamic> _prepareWorkflowData(
    AIRequest request,
    String workflowType,
  ) {
    return {
      'workflowType': workflowType,
      'requestId': request.requestId,
      'userId': request.userId,
      'timestamp': request.timestamp.toIso8601String(),
      'requestType': request.type.toString(),
      'payload': request.payload,
      'workflowId': workflowId,
    };
  }

  Future<AIResponse> _callN8NWebhook(
    Map<String, dynamic> data,
    String requestId, {
    String? customUrl,
    Map<String, String>? customHeaders,
  }) async {
    try {
      final url = customUrl ?? webhookUrl;
      final headers = <String, String>{
        'Content-Type': 'application/json',
        if (config.apiKey.isNotEmpty)
          'Authorization': 'Bearer ${config.apiKey}',
        ...?customHeaders,
      };

      final response = await _dio.post<Map<String, dynamic>>(
        url,
        data: data,
        options: Options(headers: headers),
      );

      // N8N workflows can return various response formats
      final responseData = response.data;

      if (responseData is Map<String, dynamic>) {
        // Check if the workflow indicates success/failure
        final success = responseData['success'] as bool? ?? true;
        final error = responseData['error']?.toString();

        if (!success && error != null) {
          return createErrorResponse(
            requestId,
            error,
            errorCode: 'WORKFLOW_FAILED',
          );
        }

        return createSuccessResponse(
          requestId,
          responseData,
          metadata: {
            'workflow_execution_time':
                response.headers['x-execution-time']?.first,
            'workflow_id': workflowId,
          },
        );
      } else {
        // Handle non-JSON responses
        return createSuccessResponse(requestId, {'result': responseData});
      }
    } on DioException catch (e) {
      var errorMessage = 'N8N webhook request failed';
      String? errorCode;

      if (e.response != null) {
        final statusCode = e.response!.statusCode;
        errorCode = 'HTTP_$statusCode';

        switch (statusCode) {
          case 400:
            errorMessage = 'Invalid workflow request';
          case 401:
            errorMessage = 'Unauthorized - check API key';
          case 404:
            errorMessage = 'Workflow not found';
          case 500:
            errorMessage = 'N8N server error';
          default:
            errorMessage = 'HTTP error: $statusCode';
        }

        // Try to extract error details from response
        if (e.response!.data is Map<String, dynamic>) {
          final responseData = e.response!.data as Map<String, dynamic>;
          final errorDetails = responseData['error']?.toString();
          if (errorDetails != null) {
            errorMessage = '$errorMessage - $errorDetails';
          }
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

  @override
  Future<bool> testConnection() async {
    try {
      final testData = {
        'workflowType': 'connection-test',
        'requestId': 'test-${DateTime.now().millisecondsSinceEpoch}',
        'userId': 'test-user',
        'timestamp': DateTime.now().toIso8601String(),
        'payload': {'test': true},
      };

      final response = await _callN8NWebhook(testData, 'test-connection');
      return response.success;
    } catch (e) {
      _logger.e('N8N connection test failed: $e');
      return false;
    }
  }

  @override
  Future<void> updateConfig(ProviderConfig newConfig) async {
    if (newConfig.type != AIProviderType.n8nWorkflow) {
      throw ArgumentError('Invalid config type for N8N provider');
    }

    // Update the internal config and reinitialize Dio
    // Note: In a real implementation, you'd want to update the stored config
    _setupDio();
  }

  @override
  Future<ProviderStatus> getStatus() async {
    final isAvailable = await testConnection();

    return ProviderStatus(
      type: AIProviderType.n8nWorkflow,
      isAvailable: isAvailable,
      lastChecked: DateTime.now(),
      errorMessage: isAvailable ? null : 'Connection test failed',
    );
  }

  /// Execute a specific N8N workflow by ID
  Future<AIResponse> executeWorkflowById(
    String workflowId,
    Map<String, dynamic> inputData,
    String requestId, {
    String? customWebhookUrl,
  }) async {
    final workflowRequest = N8NWorkflowRequest(
      workflowId: workflowId,
      inputData: inputData,
      metadata:
          customWebhookUrl != null ? {'webhookUrl': customWebhookUrl} : {},
    );

    final aiRequest = AIRequest(
      requestId: requestId,
      type: AIRequestType.customWorkflow,
      payload: workflowRequest.toJson(),
      timestamp: DateTime.now(),
      userId: 'system',
    );

    return processRequest(aiRequest);
  }

  /// Get workflow execution status (if supported by N8N instance)
  Future<Map<String, dynamic>?> getWorkflowExecutionStatus(
    String executionId,
  ) async {
    try {
      // This would require N8N API access, not just webhook
      // Implementation depends on N8N instance configuration
      final response = await _dio.get<Map<String, dynamic>>(
        '/api/v1/executions/$executionId',
        options: Options(
          headers: {
            if (config.apiKey.isNotEmpty)
              'Authorization': 'Bearer ${config.apiKey}',
          },
        ),
      );

      return response.data!;
    } catch (e) {
      _logger.w('Failed to get workflow execution status: $e');
      return null;
    }
  }
}
