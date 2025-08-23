// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExerciseImpl _$$ExerciseImplFromJson(
  Map<String, dynamic> json,
) => _$ExerciseImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  category: $enumDecode(_$ExerciseCategoryEnumMap, json['category']),
  difficulty: $enumDecode(_$DifficultyLevelEnumMap, json['difficulty']),
  targetMuscles:
      (json['targetMuscles'] as List<dynamic>)
          .map((e) => $enumDecode(_$MuscleGroupEnumMap, e))
          .toList(),
  equipment:
      (json['equipment'] as List<dynamic>).map((e) => e as String).toList(),
  estimatedDurationSeconds: (json['estimatedDurationSeconds'] as num).toInt(),
  instructions:
      (json['instructions'] as List<dynamic>).map((e) => e as String).toList(),
  tips: (json['tips'] as List<dynamic>).map((e) => e as String).toList(),
  metadata: json['metadata'] as Map<String, dynamic>,
  animationUrl: json['animationUrl'] as String?,
  thumbnailUrl: json['thumbnailUrl'] as String?,
  alternativeExerciseIds:
      (json['alternativeExerciseIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
  customData: json['customData'] as Map<String, dynamic>?,
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

Map<String, dynamic> _$$ExerciseImplToJson(_$ExerciseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'category': _$ExerciseCategoryEnumMap[instance.category]!,
      'difficulty': _$DifficultyLevelEnumMap[instance.difficulty]!,
      'targetMuscles':
          instance.targetMuscles.map((e) => _$MuscleGroupEnumMap[e]!).toList(),
      'equipment': instance.equipment,
      'estimatedDurationSeconds': instance.estimatedDurationSeconds,
      'instructions': instance.instructions,
      'tips': instance.tips,
      'metadata': instance.metadata,
      'animationUrl': instance.animationUrl,
      'thumbnailUrl': instance.thumbnailUrl,
      'alternativeExerciseIds': instance.alternativeExerciseIds,
      'customData': instance.customData,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$ExerciseCategoryEnumMap = {
  ExerciseCategory.cardio: 'cardio',
  ExerciseCategory.strength: 'strength',
  ExerciseCategory.flexibility: 'flexibility',
  ExerciseCategory.balance: 'balance',
  ExerciseCategory.sports: 'sports',
  ExerciseCategory.rehabilitation: 'rehabilitation',
};

const _$DifficultyLevelEnumMap = {
  DifficultyLevel.beginner: 'beginner',
  DifficultyLevel.intermediate: 'intermediate',
  DifficultyLevel.advanced: 'advanced',
  DifficultyLevel.expert: 'expert',
};

const _$MuscleGroupEnumMap = {
  MuscleGroup.chest: 'chest',
  MuscleGroup.back: 'back',
  MuscleGroup.shoulders: 'shoulders',
  MuscleGroup.arms: 'arms',
  MuscleGroup.core: 'core',
  MuscleGroup.legs: 'legs',
  MuscleGroup.glutes: 'glutes',
  MuscleGroup.fullBody: 'full_body',
};
