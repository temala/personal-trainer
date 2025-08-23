// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      age: (json['age'] as num).toInt(),
      height: (json['height'] as num).toDouble(),
      weight: (json['weight'] as num).toDouble(),
      targetWeight: (json['targetWeight'] as num).toDouble(),
      fitnessGoal: $enumDecode(_$FitnessGoalEnumMap, json['fitnessGoal']),
      activityLevel: $enumDecode(_$ActivityLevelEnumMap, json['activityLevel']),
      preferredExerciseTypes:
          (json['preferredExerciseTypes'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
      dislikedExercises:
          (json['dislikedExercises'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
      preferences: json['preferences'] as Map<String, dynamic>,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      avatarUrl: json['avatarUrl'] as String?,
      isPremium: json['isPremium'] as bool?,
      premiumExpiresAt:
          json['premiumExpiresAt'] == null
              ? null
              : DateTime.parse(json['premiumExpiresAt'] as String),
      fcmToken: json['fcmToken'] as String?,
      aiProviderConfig: json['aiProviderConfig'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'age': instance.age,
      'height': instance.height,
      'weight': instance.weight,
      'targetWeight': instance.targetWeight,
      'fitnessGoal': _$FitnessGoalEnumMap[instance.fitnessGoal]!,
      'activityLevel': _$ActivityLevelEnumMap[instance.activityLevel]!,
      'preferredExerciseTypes': instance.preferredExerciseTypes,
      'dislikedExercises': instance.dislikedExercises,
      'preferences': instance.preferences,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'avatarUrl': instance.avatarUrl,
      'isPremium': instance.isPremium,
      'premiumExpiresAt': instance.premiumExpiresAt?.toIso8601String(),
      'fcmToken': instance.fcmToken,
      'aiProviderConfig': instance.aiProviderConfig,
    };

const _$FitnessGoalEnumMap = {
  FitnessGoal.loseWeight: 'lose_weight',
  FitnessGoal.gainMuscle: 'gain_muscle',
  FitnessGoal.maintainFitness: 'maintain_fitness',
  FitnessGoal.improveEndurance: 'improve_endurance',
  FitnessGoal.generalHealth: 'general_health',
};

const _$ActivityLevelEnumMap = {
  ActivityLevel.sedentary: 'sedentary',
  ActivityLevel.lightlyActive: 'lightly_active',
  ActivityLevel.moderatelyActive: 'moderately_active',
  ActivityLevel.veryActive: 'very_active',
  ActivityLevel.extremelyActive: 'extremely_active',
};
