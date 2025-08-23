// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AIResponseImpl _$$AIResponseImplFromJson(Map<String, dynamic> json) =>
    _$AIResponseImpl(
      requestId: json['requestId'] as String,
      success: json['success'] as bool,
      data: json['data'] as Map<String, dynamic>,
      timestamp: DateTime.parse(json['timestamp'] as String),
      providerId: json['providerId'] as String,
      error: json['error'] as String?,
      errorCode: json['errorCode'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$AIResponseImplToJson(_$AIResponseImpl instance) =>
    <String, dynamic>{
      'requestId': instance.requestId,
      'success': instance.success,
      'data': instance.data,
      'timestamp': instance.timestamp.toIso8601String(),
      'providerId': instance.providerId,
      'error': instance.error,
      'errorCode': instance.errorCode,
      'metadata': instance.metadata,
    };

_$WorkoutPlanResponseImpl _$$WorkoutPlanResponseImplFromJson(
  Map<String, dynamic> json,
) => _$WorkoutPlanResponseImpl(
  weeklyPlan:
      (json['weeklyPlan'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
  planId: json['planId'] as String?,
  metadata: json['metadata'] as Map<String, dynamic>?,
  recommendations:
      (json['recommendations'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
);

Map<String, dynamic> _$$WorkoutPlanResponseImplToJson(
  _$WorkoutPlanResponseImpl instance,
) => <String, dynamic>{
  'weeklyPlan': instance.weeklyPlan,
  'planId': instance.planId,
  'metadata': instance.metadata,
  'recommendations': instance.recommendations,
};

_$AlternativeExerciseResponseImpl _$$AlternativeExerciseResponseImplFromJson(
  Map<String, dynamic> json,
) => _$AlternativeExerciseResponseImpl(
  alternativeExercise: json['alternativeExercise'] as Map<String, dynamic>,
  reason: json['reason'] as String?,
  confidenceScore: (json['confidenceScore'] as num?)?.toDouble(),
);

Map<String, dynamic> _$$AlternativeExerciseResponseImplToJson(
  _$AlternativeExerciseResponseImpl instance,
) => <String, dynamic>{
  'alternativeExercise': instance.alternativeExercise,
  'reason': instance.reason,
  'confidenceScore': instance.confidenceScore,
};

_$NotificationResponseImpl _$$NotificationResponseImplFromJson(
  Map<String, dynamic> json,
) => _$NotificationResponseImpl(
  message: json['message'] as String,
  title: json['title'] as String?,
  category: json['category'] as String?,
  customData: json['customData'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$$NotificationResponseImplToJson(
  _$NotificationResponseImpl instance,
) => <String, dynamic>{
  'message': instance.message,
  'title': instance.title,
  'category': instance.category,
  'customData': instance.customData,
};

_$N8NWorkflowResponseImpl _$$N8NWorkflowResponseImplFromJson(
  Map<String, dynamic> json,
) => _$N8NWorkflowResponseImpl(
  workflowId: json['workflowId'] as String,
  result: json['result'] as Map<String, dynamic>,
  executionId: json['executionId'] as String?,
  status: json['status'] as String?,
  executionData: json['executionData'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$$N8NWorkflowResponseImplToJson(
  _$N8NWorkflowResponseImpl instance,
) => <String, dynamic>{
  'workflowId': instance.workflowId,
  'result': instance.result,
  'executionId': instance.executionId,
  'status': instance.status,
  'executionData': instance.executionData,
};
