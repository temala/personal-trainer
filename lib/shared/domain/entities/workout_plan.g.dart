// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkoutPlanImpl _$$WorkoutPlanImplFromJson(Map<String, dynamic> json) =>
    _$WorkoutPlanImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      exercises:
          (json['exercises'] as List<dynamic>)
              .map((e) => WorkoutExercise.fromJson(e as Map<String, dynamic>))
              .toList(),
      type: $enumDecode(_$WorkoutTypeEnumMap, json['type']),
      difficulty: $enumDecode(_$DifficultyLevelEnumMap, json['difficulty']),
      estimatedDurationMinutes:
          (json['estimatedDurationMinutes'] as num).toInt(),
      targetMuscleGroups:
          (json['targetMuscleGroups'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
      metadata: json['metadata'] as Map<String, dynamic>,
      userId: json['userId'] as String?,
      aiGeneratedBy: json['aiGeneratedBy'] as String?,
      aiGenerationContext: json['aiGenerationContext'] as Map<String, dynamic>?,
      isTemplate: json['isTemplate'] as bool?,
      isActive: json['isActive'] as bool?,
      createdAt:
          json['createdAt'] == null
              ? null
              : DateTime.parse(json['createdAt'] as String),
      updatedAt:
          json['updatedAt'] == null
              ? null
              : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$WorkoutPlanImplToJson(_$WorkoutPlanImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'exercises': instance.exercises,
      'type': _$WorkoutTypeEnumMap[instance.type]!,
      'difficulty': _$DifficultyLevelEnumMap[instance.difficulty]!,
      'estimatedDurationMinutes': instance.estimatedDurationMinutes,
      'targetMuscleGroups': instance.targetMuscleGroups,
      'metadata': instance.metadata,
      'userId': instance.userId,
      'aiGeneratedBy': instance.aiGeneratedBy,
      'aiGenerationContext': instance.aiGenerationContext,
      'isTemplate': instance.isTemplate,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$WorkoutTypeEnumMap = {
  WorkoutType.strengthTraining: 'strength_training',
  WorkoutType.cardio: 'cardio',
  WorkoutType.hiit: 'hiit',
  WorkoutType.yoga: 'yoga',
  WorkoutType.pilates: 'pilates',
  WorkoutType.stretching: 'stretching',
  WorkoutType.mixed: 'mixed',
  WorkoutType.custom: 'custom',
};

const _$DifficultyLevelEnumMap = {
  DifficultyLevel.beginner: 'beginner',
  DifficultyLevel.intermediate: 'intermediate',
  DifficultyLevel.advanced: 'advanced',
  DifficultyLevel.expert: 'expert',
};

_$WorkoutExerciseImpl _$$WorkoutExerciseImplFromJson(
  Map<String, dynamic> json,
) => _$WorkoutExerciseImpl(
  exerciseId: json['exerciseId'] as String,
  order: (json['order'] as num).toInt(),
  sets: (json['sets'] as num).toInt(),
  repsPerSet: (json['repsPerSet'] as num).toInt(),
  restBetweenSetsSeconds: (json['restBetweenSetsSeconds'] as num).toInt(),
  exerciseName: json['exerciseName'] as String?,
  exerciseDescription: json['exerciseDescription'] as String?,
  exerciseMetadata: json['exerciseMetadata'] as Map<String, dynamic>?,
  customInstructions: json['customInstructions'] as Map<String, dynamic>?,
  alternativeExerciseIds:
      (json['alternativeExerciseIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
);

Map<String, dynamic> _$$WorkoutExerciseImplToJson(
  _$WorkoutExerciseImpl instance,
) => <String, dynamic>{
  'exerciseId': instance.exerciseId,
  'order': instance.order,
  'sets': instance.sets,
  'repsPerSet': instance.repsPerSet,
  'restBetweenSetsSeconds': instance.restBetweenSetsSeconds,
  'exerciseName': instance.exerciseName,
  'exerciseDescription': instance.exerciseDescription,
  'exerciseMetadata': instance.exerciseMetadata,
  'customInstructions': instance.customInstructions,
  'alternativeExerciseIds': instance.alternativeExerciseIds,
};
