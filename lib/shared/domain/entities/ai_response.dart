import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_response.freezed.dart';
part 'ai_response.g.dart';

/// Base AI response model that all AI providers will return
@freezed
class AIResponse with _$AIResponse {
  const factory AIResponse({
    required String requestId,
    required bool success,
    required Map<String, dynamic> data,
    required DateTime timestamp,
    required String providerId,
    String? error,
    String? errorCode,
    Map<String, dynamic>? metadata,
  }) = _AIResponse;

  factory AIResponse.fromJson(Map<String, dynamic> json) =>
      _$AIResponseFromJson(json);

  /// Factory for successful responses
  factory AIResponse.success({
    required String requestId,
    required Map<String, dynamic> data,
    required String providerId,
    Map<String, dynamic>? metadata,
  }) => AIResponse(
    requestId: requestId,
    success: true,
    data: data,
    timestamp: DateTime.now(),
    providerId: providerId,
    metadata: metadata,
  );

  /// Factory for error responses
  factory AIResponse.error({
    required String requestId,
    required String error,
    required String providerId,
    String? errorCode,
    Map<String, dynamic>? metadata,
  }) => AIResponse(
    requestId: requestId,
    success: false,
    data: {},
    error: error,
    errorCode: errorCode,
    timestamp: DateTime.now(),
    providerId: providerId,
    metadata: metadata,
  );
}

/// Specific response for workout plan generation
@freezed
class WorkoutPlanResponse with _$WorkoutPlanResponse {
  const factory WorkoutPlanResponse({
    required List<Map<String, dynamic>> weeklyPlan,
    String? planId,
    Map<String, dynamic>? metadata,
    List<String>? recommendations,
  }) = _WorkoutPlanResponse;

  factory WorkoutPlanResponse.fromJson(Map<String, dynamic> json) =>
      _$WorkoutPlanResponseFromJson(json);
}

/// Specific response for alternative exercise selection
@freezed
class AlternativeExerciseResponse with _$AlternativeExerciseResponse {
  const factory AlternativeExerciseResponse({
    required Map<String, dynamic> alternativeExercise,
    String? reason,
    double? confidenceScore,
  }) = _AlternativeExerciseResponse;

  factory AlternativeExerciseResponse.fromJson(Map<String, dynamic> json) =>
      _$AlternativeExerciseResponseFromJson(json);
}

/// Specific response for notification generation
@freezed
class NotificationResponse with _$NotificationResponse {
  const factory NotificationResponse({
    required String message,
    String? title,
    String? category,
    Map<String, dynamic>? customData,
  }) = _NotificationResponse;

  factory NotificationResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationResponseFromJson(json);
}

/// Response wrapper for N8N workflow execution
@freezed
class N8NWorkflowResponse with _$N8NWorkflowResponse {
  const factory N8NWorkflowResponse({
    required String workflowId,
    required Map<String, dynamic> result,
    String? executionId,
    String? status,
    Map<String, dynamic>? executionData,
  }) = _N8NWorkflowResponse;

  factory N8NWorkflowResponse.fromJson(Map<String, dynamic> json) =>
      _$N8NWorkflowResponseFromJson(json);
}
