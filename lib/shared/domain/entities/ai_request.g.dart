// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AIRequestImpl _$$AIRequestImplFromJson(Map<String, dynamic> json) =>
    _$AIRequestImpl(
      requestId: json['requestId'] as String,
      type: $enumDecode(_$AIRequestTypeEnumMap, json['type']),
      payload: json['payload'] as Map<String, dynamic>,
      timestamp: DateTime.parse(json['timestamp'] as String),
      userId: json['userId'] as String,
      headers:
          (json['headers'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
      timeoutSeconds: (json['timeoutSeconds'] as num?)?.toInt() ?? 30,
    );

Map<String, dynamic> _$$AIRequestImplToJson(_$AIRequestImpl instance) =>
    <String, dynamic>{
      'requestId': instance.requestId,
      'type': _$AIRequestTypeEnumMap[instance.type]!,
      'payload': instance.payload,
      'timestamp': instance.timestamp.toIso8601String(),
      'userId': instance.userId,
      'headers': instance.headers,
      'timeoutSeconds': instance.timeoutSeconds,
    };

const _$AIRequestTypeEnumMap = {
  AIRequestType.generateWorkoutPlan: 'generateWorkoutPlan',
  AIRequestType.getAlternativeExercise: 'getAlternativeExercise',
  AIRequestType.generateNotification: 'generateNotification',
  AIRequestType.createAvatar: 'createAvatar',
  AIRequestType.analyzeProgress: 'analyzeProgress',
  AIRequestType.customWorkflow: 'customWorkflow',
  AIRequestType.evaluateCommitment: 'evaluateCommitment',
  AIRequestType.generateAdvice: 'generateAdvice',
};

_$WorkoutPlanRequestImpl _$$WorkoutPlanRequestImplFromJson(
  Map<String, dynamic> json,
) => _$WorkoutPlanRequestImpl(
  userId: json['userId'] as String,
  userProfile: json['userProfile'] as Map<String, dynamic>,
  availableExercises:
      (json['availableExercises'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
  preferences: json['preferences'] as Map<String, dynamic>? ?? const {},
  constraints: json['constraints'] as Map<String, dynamic>? ?? const {},
);

Map<String, dynamic> _$$WorkoutPlanRequestImplToJson(
  _$WorkoutPlanRequestImpl instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'userProfile': instance.userProfile,
  'availableExercises': instance.availableExercises,
  'preferences': instance.preferences,
  'constraints': instance.constraints,
};

_$AlternativeExerciseRequestImpl _$$AlternativeExerciseRequestImplFromJson(
  Map<String, dynamic> json,
) => _$AlternativeExerciseRequestImpl(
  userId: json['userId'] as String,
  currentExerciseId: json['currentExerciseId'] as String,
  alternativeType: $enumDecode(
    _$AlternativeTypeEnumMap,
    json['alternativeType'],
  ),
  availableExercises:
      (json['availableExercises'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
  userContext: json['userContext'] as Map<String, dynamic>? ?? const {},
  excludeExerciseIds:
      (json['excludeExerciseIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$$AlternativeExerciseRequestImplToJson(
  _$AlternativeExerciseRequestImpl instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'currentExerciseId': instance.currentExerciseId,
  'alternativeType': _$AlternativeTypeEnumMap[instance.alternativeType]!,
  'availableExercises': instance.availableExercises,
  'userContext': instance.userContext,
  'excludeExerciseIds': instance.excludeExerciseIds,
};

const _$AlternativeTypeEnumMap = {
  AlternativeType.dontLike: 'dontLike',
  AlternativeType.notPossibleNow: 'notPossibleNow',
  AlternativeType.tooEasy: 'tooEasy',
  AlternativeType.tooHard: 'tooHard',
  AlternativeType.noEquipment: 'noEquipment',
};

_$NotificationRequestImpl _$$NotificationRequestImplFromJson(
  Map<String, dynamic> json,
) => _$NotificationRequestImpl(
  userId: json['userId'] as String,
  userContext: json['userContext'] as Map<String, dynamic>,
  notificationType: json['notificationType'] as String?,
  additionalData: json['additionalData'] as Map<String, dynamic>? ?? const {},
);

Map<String, dynamic> _$$NotificationRequestImplToJson(
  _$NotificationRequestImpl instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'userContext': instance.userContext,
  'notificationType': instance.notificationType,
  'additionalData': instance.additionalData,
};

_$N8NWorkflowRequestImpl _$$N8NWorkflowRequestImplFromJson(
  Map<String, dynamic> json,
) => _$N8NWorkflowRequestImpl(
  workflowId: json['workflowId'] as String,
  inputData: json['inputData'] as Map<String, dynamic>,
  metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
);

Map<String, dynamic> _$$N8NWorkflowRequestImplToJson(
  _$N8NWorkflowRequestImpl instance,
) => <String, dynamic>{
  'workflowId': instance.workflowId,
  'inputData': instance.inputData,
  'metadata': instance.metadata,
};
