// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_score.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserScoreImpl _$$UserScoreImplFromJson(Map<String, dynamic> json) =>
    _$UserScoreImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      totalScore: (json['totalScore'] as num).toInt(),
      commitmentLevel: (json['commitmentLevel'] as num).toDouble(),
      workoutsCompleted: (json['workoutsCompleted'] as num).toInt(),
      totalWorkouts: (json['totalWorkouts'] as num).toInt(),
      currentStreak: (json['currentStreak'] as num).toInt(),
      longestStreak: (json['longestStreak'] as num).toInt(),
      achievements:
          (json['achievements'] as List<dynamic>)
              .map((e) => Achievement.fromJson(e as Map<String, dynamic>))
              .toList(),
      categoryScores: Map<String, int>.from(json['categoryScores'] as Map),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      weeklyScore: (json['weeklyScore'] as num?)?.toInt(),
      monthlyScore: (json['monthlyScore'] as num?)?.toInt(),
      averageWorkoutCompletion:
          (json['averageWorkoutCompletion'] as num?)?.toDouble(),
      totalExercisesCompleted:
          (json['totalExercisesCompleted'] as num?)?.toInt(),
      totalWorkoutMinutes: (json['totalWorkoutMinutes'] as num?)?.toInt(),
      aiEvaluation: json['aiEvaluation'] as Map<String, dynamic>?,
      recentAchievements:
          (json['recentAchievements'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
      progressMetrics: json['progressMetrics'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$UserScoreImplToJson(_$UserScoreImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'totalScore': instance.totalScore,
      'commitmentLevel': instance.commitmentLevel,
      'workoutsCompleted': instance.workoutsCompleted,
      'totalWorkouts': instance.totalWorkouts,
      'currentStreak': instance.currentStreak,
      'longestStreak': instance.longestStreak,
      'achievements': instance.achievements,
      'categoryScores': instance.categoryScores,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'weeklyScore': instance.weeklyScore,
      'monthlyScore': instance.monthlyScore,
      'averageWorkoutCompletion': instance.averageWorkoutCompletion,
      'totalExercisesCompleted': instance.totalExercisesCompleted,
      'totalWorkoutMinutes': instance.totalWorkoutMinutes,
      'aiEvaluation': instance.aiEvaluation,
      'recentAchievements': instance.recentAchievements,
      'progressMetrics': instance.progressMetrics,
    };

_$AchievementImpl _$$AchievementImplFromJson(Map<String, dynamic> json) =>
    _$AchievementImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      type: $enumDecode(_$AchievementTypeEnumMap, json['type']),
      tier: $enumDecode(_$AchievementTierEnumMap, json['tier']),
      pointsAwarded: (json['pointsAwarded'] as num).toInt(),
      unlockedAt: DateTime.parse(json['unlockedAt'] as String),
      iconUrl: json['iconUrl'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$AchievementImplToJson(_$AchievementImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'type': _$AchievementTypeEnumMap[instance.type]!,
      'tier': _$AchievementTierEnumMap[instance.tier]!,
      'pointsAwarded': instance.pointsAwarded,
      'unlockedAt': instance.unlockedAt.toIso8601String(),
      'iconUrl': instance.iconUrl,
      'metadata': instance.metadata,
    };

const _$AchievementTypeEnumMap = {
  AchievementType.workoutCompletion: 'workout_completion',
  AchievementType.streak: 'streak',
  AchievementType.consistency: 'consistency',
  AchievementType.improvement: 'improvement',
  AchievementType.milestone: 'milestone',
  AchievementType.special: 'special',
};

const _$AchievementTierEnumMap = {
  AchievementTier.bronze: 'bronze',
  AchievementTier.silver: 'silver',
  AchievementTier.gold: 'gold',
  AchievementTier.platinum: 'platinum',
  AchievementTier.diamond: 'diamond',
};
