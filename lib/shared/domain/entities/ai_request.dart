import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_request.freezed.dart';
part 'ai_request.g.dart';

/// Enum defining different types of AI requests
enum AIRequestType {
  @JsonValue('generate_workout_plan')
  generateWorkoutPlan,
  @JsonValue('get_alternative_exercise')
  getAlternativeExercise,
  @JsonValue('generate_notification')
  generateNotification,
  @JsonValue('create_avatar')
  createAvatar,
  @JsonValue('analyze_progress')
  analyzeProgress,
  @JsonValue('custom_workflow')
  customWorkflow,
}

/// Base AI request model that all AI providers will use
@freezed
class AIRequest with _$AIRequest {
  const factory AIRequest({
    required String requestId,
    required AIRequestType type,
    required Map<String, dynamic> payload,
    required DateTime timestamp,
    required String userId,
    Map<String, String>? headers,
    int? timeoutSeconds,
  }) = _AIRequest;

  factory AIRequest.fromJson(Map<String, dynamic> json) =>
      _$AIRequestFromJson(json);
}

/// Specific request for workout plan generation
@freezed
class WorkoutPlanRequest with _$WorkoutPlanRequest {
  const factory WorkoutPlanRequest({
    required String userId,
    required Map<String, dynamic> userProfile,
    required List<Map<String, dynamic>> availableExercises,
    Map<String, dynamic>? preferences,
    List<String>? excludedExercises,
  }) = _WorkoutPlanRequest;

  factory WorkoutPlanRequest.fromJson(Map<String, dynamic> json) =>
      _$WorkoutPlanRequestFromJson(json);
}

/// Specific request for alternative exercise selection
@freezed
class AlternativeExerciseRequest with _$AlternativeExerciseRequest {
  const factory AlternativeExerciseRequest({
    required String userId,
    required String currentExerciseId,
    required String alternativeType, // 'dislike' or 'not_possible'
    required List<Map<String, dynamic>> availableExercises,
    Map<String, dynamic>? userContext,
  }) = _AlternativeExerciseRequest;

  factory AlternativeExerciseRequest.fromJson(Map<String, dynamic> json) =>
      _$AlternativeExerciseRequestFromJson(json);
}

/// Specific request for notification generation
@freezed
class NotificationRequest with _$NotificationRequest {
  const factory NotificationRequest({
    required String userId,
    required Map<String, dynamic> userContext,
    String? notificationType,
    Map<String, dynamic>? additionalData,
  }) = _NotificationRequest;

  factory NotificationRequest.fromJson(Map<String, dynamic> json) =>
      _$NotificationRequestFromJson(json);
}

/// Specific request for N8N workflow execution
@freezed
class N8NWorkflowRequest with _$N8NWorkflowRequest {
  const factory N8NWorkflowRequest({
    required String workflowId,
    required Map<String, dynamic> inputData,
    String? webhookUrl,
    Map<String, String>? headers,
  }) = _N8NWorkflowRequest;

  factory N8NWorkflowRequest.fromJson(Map<String, dynamic> json) =>
      _$N8NWorkflowRequestFromJson(json);
}
