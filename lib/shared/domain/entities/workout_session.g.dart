// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkoutSessionImpl _$$WorkoutSessionImplFromJson(Map<String, dynamic> json) =>
    _$WorkoutSessionImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      workoutPlanId: json['workoutPlanId'] as String,
      status: $enumDecode(_$SessionStatusEnumMap, json['status']),
      startedAt: DateTime.parse(json['startedAt'] as String),
      exerciseExecutions:
          (json['exerciseExecutions'] as List<dynamic>)
              .map((e) => ExerciseExecution.fromJson(e as Map<String, dynamic>))
              .toList(),
      metadata: json['metadata'] as Map<String, dynamic>,
      workoutPlanName: json['workoutPlanName'] as String?,
      completedAt:
          json['completedAt'] == null
              ? null
              : DateTime.parse(json['completedAt'] as String),
      pausedAt:
          json['pausedAt'] == null
              ? null
              : DateTime.parse(json['pausedAt'] as String),
      totalDurationSeconds: (json['totalDurationSeconds'] as num?)?.toInt(),
      completionPercentage: (json['completionPercentage'] as num?)?.toDouble(),
      totalCaloriesBurned: (json['totalCaloriesBurned'] as num?)?.toInt(),
      aiEvaluation: json['aiEvaluation'] as Map<String, dynamic>?,
      userNotes: json['userNotes'] as String?,
      skippedExerciseIds:
          (json['skippedExerciseIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
      sessionData: json['sessionData'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$WorkoutSessionImplToJson(
  _$WorkoutSessionImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'workoutPlanId': instance.workoutPlanId,
  'status': _$SessionStatusEnumMap[instance.status]!,
  'startedAt': instance.startedAt.toIso8601String(),
  'exerciseExecutions': instance.exerciseExecutions,
  'metadata': instance.metadata,
  'workoutPlanName': instance.workoutPlanName,
  'completedAt': instance.completedAt?.toIso8601String(),
  'pausedAt': instance.pausedAt?.toIso8601String(),
  'totalDurationSeconds': instance.totalDurationSeconds,
  'completionPercentage': instance.completionPercentage,
  'totalCaloriesBurned': instance.totalCaloriesBurned,
  'aiEvaluation': instance.aiEvaluation,
  'userNotes': instance.userNotes,
  'skippedExerciseIds': instance.skippedExerciseIds,
  'sessionData': instance.sessionData,
};

const _$SessionStatusEnumMap = {
  SessionStatus.notStarted: 'not_started',
  SessionStatus.inProgress: 'in_progress',
  SessionStatus.paused: 'paused',
  SessionStatus.completed: 'completed',
  SessionStatus.abandoned: 'abandoned',
  SessionStatus.cancelled: 'cancelled',
};

_$ExerciseExecutionImpl _$$ExerciseExecutionImplFromJson(
  Map<String, dynamic> json,
) => _$ExerciseExecutionImpl(
  exerciseId: json['exerciseId'] as String,
  order: (json['order'] as num).toInt(),
  status: $enumDecode(_$ExecutionStatusEnumMap, json['status']),
  startedAt: DateTime.parse(json['startedAt'] as String),
  setExecutions:
      (json['setExecutions'] as List<dynamic>)
          .map((e) => SetExecution.fromJson(e as Map<String, dynamic>))
          .toList(),
  exerciseName: json['exerciseName'] as String?,
  completedAt:
      json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
  skippedAt:
      json['skippedAt'] == null
          ? null
          : DateTime.parse(json['skippedAt'] as String),
  totalDurationSeconds: (json['totalDurationSeconds'] as num?)?.toInt(),
  skipReason: json['skipReason'] as String?,
  alternativeExerciseId: json['alternativeExerciseId'] as String?,
  executionData: json['executionData'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$$ExerciseExecutionImplToJson(
  _$ExerciseExecutionImpl instance,
) => <String, dynamic>{
  'exerciseId': instance.exerciseId,
  'order': instance.order,
  'status': _$ExecutionStatusEnumMap[instance.status]!,
  'startedAt': instance.startedAt.toIso8601String(),
  'setExecutions': instance.setExecutions,
  'exerciseName': instance.exerciseName,
  'completedAt': instance.completedAt?.toIso8601String(),
  'skippedAt': instance.skippedAt?.toIso8601String(),
  'totalDurationSeconds': instance.totalDurationSeconds,
  'skipReason': instance.skipReason,
  'alternativeExerciseId': instance.alternativeExerciseId,
  'executionData': instance.executionData,
};

const _$ExecutionStatusEnumMap = {
  ExecutionStatus.notStarted: 'not_started',
  ExecutionStatus.inProgress: 'in_progress',
  ExecutionStatus.completed: 'completed',
  ExecutionStatus.skipped: 'skipped',
  ExecutionStatus.alternativeUsed: 'alternative_used',
};

_$SetExecutionImpl _$$SetExecutionImplFromJson(Map<String, dynamic> json) =>
    _$SetExecutionImpl(
      setNumber: (json['setNumber'] as num).toInt(),
      status: $enumDecode(_$SetStatusEnumMap, json['status']),
      startedAt: DateTime.parse(json['startedAt'] as String),
      completedAt:
          json['completedAt'] == null
              ? null
              : DateTime.parse(json['completedAt'] as String),
      actualReps: (json['actualReps'] as num?)?.toInt(),
      plannedReps: (json['plannedReps'] as num?)?.toInt(),
      weight: (json['weight'] as num?)?.toDouble(),
      durationSeconds: (json['durationSeconds'] as num?)?.toInt(),
      restDurationSeconds: (json['restDurationSeconds'] as num?)?.toInt(),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$SetExecutionImplToJson(_$SetExecutionImpl instance) =>
    <String, dynamic>{
      'setNumber': instance.setNumber,
      'status': _$SetStatusEnumMap[instance.status]!,
      'startedAt': instance.startedAt.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'actualReps': instance.actualReps,
      'plannedReps': instance.plannedReps,
      'weight': instance.weight,
      'durationSeconds': instance.durationSeconds,
      'restDurationSeconds': instance.restDurationSeconds,
      'notes': instance.notes,
    };

const _$SetStatusEnumMap = {
  SetStatus.notStarted: 'not_started',
  SetStatus.inProgress: 'in_progress',
  SetStatus.completed: 'completed',
  SetStatus.skipped: 'skipped',
};
