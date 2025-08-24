// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      displayName: json['displayName'] as String?,
      name: json['name'] as String?,
      photoUrl: json['photoUrl'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      dateOfBirth:
          json['dateOfBirth'] == null
              ? null
              : DateTime.parse(json['dateOfBirth'] as String),
      age: (json['age'] as num?)?.toInt(),
      gender: json['gender'] as String?,
      height: (json['height'] as num?)?.toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
      targetWeight: (json['targetWeight'] as num?)?.toDouble(),
      fitnessLevel: json['fitnessLevel'] as String?,
      fitnessGoal: $enumDecodeNullable(
        _$FitnessGoalEnumMap,
        json['fitnessGoal'],
      ),
      activityLevel: $enumDecodeNullable(
        _$ActivityLevelEnumMap,
        json['activityLevel'],
      ),
      fitnessGoals:
          (json['fitnessGoals'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
      preferredExerciseTypes:
          (json['preferredExerciseTypes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
      dislikedExercises:
          (json['dislikedExercises'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
      preferences: json['preferences'] as Map<String, dynamic>?,
      aiProviderConfig: json['aiProviderConfig'] as Map<String, dynamic>?,
      isEmailVerified: json['isEmailVerified'] as bool?,
      isActive: json['isActive'] as bool?,
      isActivePremium: json['isActivePremium'] as bool?,
      updatedAt:
          json['updatedAt'] == null
              ? null
              : DateTime.parse(json['updatedAt'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastUpdated': instance.lastUpdated.toIso8601String(),
      'displayName': instance.displayName,
      'name': instance.name,
      'photoUrl': instance.photoUrl,
      'phoneNumber': instance.phoneNumber,
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
      'age': instance.age,
      'gender': instance.gender,
      'height': instance.height,
      'weight': instance.weight,
      'targetWeight': instance.targetWeight,
      'fitnessLevel': instance.fitnessLevel,
      'fitnessGoal': _$FitnessGoalEnumMap[instance.fitnessGoal],
      'activityLevel': _$ActivityLevelEnumMap[instance.activityLevel],
      'fitnessGoals': instance.fitnessGoals,
      'preferredExerciseTypes': instance.preferredExerciseTypes,
      'dislikedExercises': instance.dislikedExercises,
      'preferences': instance.preferences,
      'aiProviderConfig': instance.aiProviderConfig,
      'isEmailVerified': instance.isEmailVerified,
      'isActive': instance.isActive,
      'isActivePremium': instance.isActivePremium,
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'metadata': instance.metadata,
    };

const _$FitnessGoalEnumMap = {
  FitnessGoal.weightLoss: 'weightLoss',
  FitnessGoal.muscleGain: 'muscleGain',
  FitnessGoal.endurance: 'endurance',
  FitnessGoal.strength: 'strength',
  FitnessGoal.flexibility: 'flexibility',
};

const _$ActivityLevelEnumMap = {
  ActivityLevel.sedentary: 'sedentary',
  ActivityLevel.lightlyActive: 'lightlyActive',
  ActivityLevel.moderatelyActive: 'moderatelyActive',
  ActivityLevel.veryActive: 'veryActive',
  ActivityLevel.extremelyActive: 'extremelyActive',
};
