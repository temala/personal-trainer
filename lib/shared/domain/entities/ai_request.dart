import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_request.freezed.dart';
part 'ai_request.g.dart';

@freezed
class AIRequest with _$AIRequest {
  const factory AIRequest({
    required String requestId,
    required AIRequestType type,
    required Map<String, dynamic> payload,
    required DateTime timestamp,
    required String userId,
    @Default({}) Map<String, String> headers,
    @Default(30) int timeoutSeconds,
  }) = _AIRequest;

  factory AIRequest.fromJson(Map<String, dynamic> json) =>
      _$AIRequestFromJson(json);
}

enum AIRequestType {
  generateWorkoutPlan,
  getAlternativeExercise,
  generateNotification,
  createAvatar,
  analyzeProgress,
  customWorkflow,
}

@freezed
class WorkoutPlanRequest with _$WorkoutPlanRequest {
  const factory WorkoutPlanRequest({
    required String userId,
    required Map<String, dynamic> userProfile,
    required List<Map<String, dynamic>> availableExercises,
    @Default({}) Map<String, dynamic> preferences,
    @Default({}) Map<String, dynamic> constraints,
  }) = _WorkoutPlanRequest;

  factory WorkoutPlanRequest.fromJson(Map<String, dynamic> json) =>
      _$WorkoutPlanRequestFromJson(json);
}

@freezed
class AlternativeExerciseRequest with _$AlternativeExerciseRequest {
  const factory AlternativeExerciseRequest({
    required String userId,
    required String currentExerciseId,
    required AlternativeType alternativeType,
    required List<Map<String, dynamic>> availableExercises,
    @Default({}) Map<String, dynamic> userContext,
    @Default([]) List<String> excludeExerciseIds,
  }) = _AlternativeExerciseRequest;

  factory AlternativeExerciseRequest.fromJson(Map<String, dynamic> json) =>
      _$AlternativeExerciseRequestFromJson(json);
}

enum AlternativeType { dontLike, notPossibleNow, tooEasy, tooHard, noEquipment }

@freezed
class NotificationRequest with _$NotificationRequest {
  const factory NotificationRequest({
    required String userId,
    required Map<String, dynamic> userContext,
    String? notificationType,
    @Default({}) Map<String, dynamic> additionalData,
  }) = _NotificationRequest;

  factory NotificationRequest.fromJson(Map<String, dynamic> json) =>
      _$NotificationRequestFromJson(json);
}

@freezed
class N8NWorkflowRequest with _$N8NWorkflowRequest {
  const factory N8NWorkflowRequest({
    required String workflowId,
    required Map<String, dynamic> inputData,
    @Default({}) Map<String, dynamic> metadata,
  }) = _N8NWorkflowRequest;

  factory N8NWorkflowRequest.fromJson(Map<String, dynamic> json) =>
      _$N8NWorkflowRequestFromJson(json);
}
