// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_score.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserScore _$UserScoreFromJson(Map<String, dynamic> json) {
  return _UserScore.fromJson(json);
}

/// @nodoc
mixin _$UserScore {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  int get totalScore => throw _privateConstructorUsedError;
  double get commitmentLevel => throw _privateConstructorUsedError;
  int get workoutsCompleted => throw _privateConstructorUsedError;
  int get totalWorkouts => throw _privateConstructorUsedError;
  int get currentStreak => throw _privateConstructorUsedError;
  int get longestStreak => throw _privateConstructorUsedError;
  List<Achievement> get achievements => throw _privateConstructorUsedError;
  Map<String, int> get categoryScores => throw _privateConstructorUsedError;
  DateTime get lastUpdated => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  int? get weeklyScore => throw _privateConstructorUsedError;
  int? get monthlyScore => throw _privateConstructorUsedError;
  double? get averageWorkoutCompletion => throw _privateConstructorUsedError;
  int? get totalExercisesCompleted => throw _privateConstructorUsedError;
  int? get totalWorkoutMinutes => throw _privateConstructorUsedError;
  Map<String, dynamic>? get aiEvaluation => throw _privateConstructorUsedError;
  List<String>? get recentAchievements => throw _privateConstructorUsedError;
  Map<String, dynamic>? get progressMetrics =>
      throw _privateConstructorUsedError;

  /// Serializes this UserScore to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserScore
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserScoreCopyWith<UserScore> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserScoreCopyWith<$Res> {
  factory $UserScoreCopyWith(UserScore value, $Res Function(UserScore) then) =
      _$UserScoreCopyWithImpl<$Res, UserScore>;
  @useResult
  $Res call({
    String id,
    String userId,
    int totalScore,
    double commitmentLevel,
    int workoutsCompleted,
    int totalWorkouts,
    int currentStreak,
    int longestStreak,
    List<Achievement> achievements,
    Map<String, int> categoryScores,
    DateTime lastUpdated,
    DateTime createdAt,
    int? weeklyScore,
    int? monthlyScore,
    double? averageWorkoutCompletion,
    int? totalExercisesCompleted,
    int? totalWorkoutMinutes,
    Map<String, dynamic>? aiEvaluation,
    List<String>? recentAchievements,
    Map<String, dynamic>? progressMetrics,
  });
}

/// @nodoc
class _$UserScoreCopyWithImpl<$Res, $Val extends UserScore>
    implements $UserScoreCopyWith<$Res> {
  _$UserScoreCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserScore
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? totalScore = null,
    Object? commitmentLevel = null,
    Object? workoutsCompleted = null,
    Object? totalWorkouts = null,
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? achievements = null,
    Object? categoryScores = null,
    Object? lastUpdated = null,
    Object? createdAt = null,
    Object? weeklyScore = freezed,
    Object? monthlyScore = freezed,
    Object? averageWorkoutCompletion = freezed,
    Object? totalExercisesCompleted = freezed,
    Object? totalWorkoutMinutes = freezed,
    Object? aiEvaluation = freezed,
    Object? recentAchievements = freezed,
    Object? progressMetrics = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            userId:
                null == userId
                    ? _value.userId
                    : userId // ignore: cast_nullable_to_non_nullable
                        as String,
            totalScore:
                null == totalScore
                    ? _value.totalScore
                    : totalScore // ignore: cast_nullable_to_non_nullable
                        as int,
            commitmentLevel:
                null == commitmentLevel
                    ? _value.commitmentLevel
                    : commitmentLevel // ignore: cast_nullable_to_non_nullable
                        as double,
            workoutsCompleted:
                null == workoutsCompleted
                    ? _value.workoutsCompleted
                    : workoutsCompleted // ignore: cast_nullable_to_non_nullable
                        as int,
            totalWorkouts:
                null == totalWorkouts
                    ? _value.totalWorkouts
                    : totalWorkouts // ignore: cast_nullable_to_non_nullable
                        as int,
            currentStreak:
                null == currentStreak
                    ? _value.currentStreak
                    : currentStreak // ignore: cast_nullable_to_non_nullable
                        as int,
            longestStreak:
                null == longestStreak
                    ? _value.longestStreak
                    : longestStreak // ignore: cast_nullable_to_non_nullable
                        as int,
            achievements:
                null == achievements
                    ? _value.achievements
                    : achievements // ignore: cast_nullable_to_non_nullable
                        as List<Achievement>,
            categoryScores:
                null == categoryScores
                    ? _value.categoryScores
                    : categoryScores // ignore: cast_nullable_to_non_nullable
                        as Map<String, int>,
            lastUpdated:
                null == lastUpdated
                    ? _value.lastUpdated
                    : lastUpdated // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            createdAt:
                null == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            weeklyScore:
                freezed == weeklyScore
                    ? _value.weeklyScore
                    : weeklyScore // ignore: cast_nullable_to_non_nullable
                        as int?,
            monthlyScore:
                freezed == monthlyScore
                    ? _value.monthlyScore
                    : monthlyScore // ignore: cast_nullable_to_non_nullable
                        as int?,
            averageWorkoutCompletion:
                freezed == averageWorkoutCompletion
                    ? _value.averageWorkoutCompletion
                    : averageWorkoutCompletion // ignore: cast_nullable_to_non_nullable
                        as double?,
            totalExercisesCompleted:
                freezed == totalExercisesCompleted
                    ? _value.totalExercisesCompleted
                    : totalExercisesCompleted // ignore: cast_nullable_to_non_nullable
                        as int?,
            totalWorkoutMinutes:
                freezed == totalWorkoutMinutes
                    ? _value.totalWorkoutMinutes
                    : totalWorkoutMinutes // ignore: cast_nullable_to_non_nullable
                        as int?,
            aiEvaluation:
                freezed == aiEvaluation
                    ? _value.aiEvaluation
                    : aiEvaluation // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>?,
            recentAchievements:
                freezed == recentAchievements
                    ? _value.recentAchievements
                    : recentAchievements // ignore: cast_nullable_to_non_nullable
                        as List<String>?,
            progressMetrics:
                freezed == progressMetrics
                    ? _value.progressMetrics
                    : progressMetrics // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserScoreImplCopyWith<$Res>
    implements $UserScoreCopyWith<$Res> {
  factory _$$UserScoreImplCopyWith(
    _$UserScoreImpl value,
    $Res Function(_$UserScoreImpl) then,
  ) = __$$UserScoreImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    int totalScore,
    double commitmentLevel,
    int workoutsCompleted,
    int totalWorkouts,
    int currentStreak,
    int longestStreak,
    List<Achievement> achievements,
    Map<String, int> categoryScores,
    DateTime lastUpdated,
    DateTime createdAt,
    int? weeklyScore,
    int? monthlyScore,
    double? averageWorkoutCompletion,
    int? totalExercisesCompleted,
    int? totalWorkoutMinutes,
    Map<String, dynamic>? aiEvaluation,
    List<String>? recentAchievements,
    Map<String, dynamic>? progressMetrics,
  });
}

/// @nodoc
class __$$UserScoreImplCopyWithImpl<$Res>
    extends _$UserScoreCopyWithImpl<$Res, _$UserScoreImpl>
    implements _$$UserScoreImplCopyWith<$Res> {
  __$$UserScoreImplCopyWithImpl(
    _$UserScoreImpl _value,
    $Res Function(_$UserScoreImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserScore
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? totalScore = null,
    Object? commitmentLevel = null,
    Object? workoutsCompleted = null,
    Object? totalWorkouts = null,
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? achievements = null,
    Object? categoryScores = null,
    Object? lastUpdated = null,
    Object? createdAt = null,
    Object? weeklyScore = freezed,
    Object? monthlyScore = freezed,
    Object? averageWorkoutCompletion = freezed,
    Object? totalExercisesCompleted = freezed,
    Object? totalWorkoutMinutes = freezed,
    Object? aiEvaluation = freezed,
    Object? recentAchievements = freezed,
    Object? progressMetrics = freezed,
  }) {
    return _then(
      _$UserScoreImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        userId:
            null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                    as String,
        totalScore:
            null == totalScore
                ? _value.totalScore
                : totalScore // ignore: cast_nullable_to_non_nullable
                    as int,
        commitmentLevel:
            null == commitmentLevel
                ? _value.commitmentLevel
                : commitmentLevel // ignore: cast_nullable_to_non_nullable
                    as double,
        workoutsCompleted:
            null == workoutsCompleted
                ? _value.workoutsCompleted
                : workoutsCompleted // ignore: cast_nullable_to_non_nullable
                    as int,
        totalWorkouts:
            null == totalWorkouts
                ? _value.totalWorkouts
                : totalWorkouts // ignore: cast_nullable_to_non_nullable
                    as int,
        currentStreak:
            null == currentStreak
                ? _value.currentStreak
                : currentStreak // ignore: cast_nullable_to_non_nullable
                    as int,
        longestStreak:
            null == longestStreak
                ? _value.longestStreak
                : longestStreak // ignore: cast_nullable_to_non_nullable
                    as int,
        achievements:
            null == achievements
                ? _value._achievements
                : achievements // ignore: cast_nullable_to_non_nullable
                    as List<Achievement>,
        categoryScores:
            null == categoryScores
                ? _value._categoryScores
                : categoryScores // ignore: cast_nullable_to_non_nullable
                    as Map<String, int>,
        lastUpdated:
            null == lastUpdated
                ? _value.lastUpdated
                : lastUpdated // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        createdAt:
            null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        weeklyScore:
            freezed == weeklyScore
                ? _value.weeklyScore
                : weeklyScore // ignore: cast_nullable_to_non_nullable
                    as int?,
        monthlyScore:
            freezed == monthlyScore
                ? _value.monthlyScore
                : monthlyScore // ignore: cast_nullable_to_non_nullable
                    as int?,
        averageWorkoutCompletion:
            freezed == averageWorkoutCompletion
                ? _value.averageWorkoutCompletion
                : averageWorkoutCompletion // ignore: cast_nullable_to_non_nullable
                    as double?,
        totalExercisesCompleted:
            freezed == totalExercisesCompleted
                ? _value.totalExercisesCompleted
                : totalExercisesCompleted // ignore: cast_nullable_to_non_nullable
                    as int?,
        totalWorkoutMinutes:
            freezed == totalWorkoutMinutes
                ? _value.totalWorkoutMinutes
                : totalWorkoutMinutes // ignore: cast_nullable_to_non_nullable
                    as int?,
        aiEvaluation:
            freezed == aiEvaluation
                ? _value._aiEvaluation
                : aiEvaluation // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>?,
        recentAchievements:
            freezed == recentAchievements
                ? _value._recentAchievements
                : recentAchievements // ignore: cast_nullable_to_non_nullable
                    as List<String>?,
        progressMetrics:
            freezed == progressMetrics
                ? _value._progressMetrics
                : progressMetrics // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserScoreImpl implements _UserScore {
  const _$UserScoreImpl({
    required this.id,
    required this.userId,
    required this.totalScore,
    required this.commitmentLevel,
    required this.workoutsCompleted,
    required this.totalWorkouts,
    required this.currentStreak,
    required this.longestStreak,
    required final List<Achievement> achievements,
    required final Map<String, int> categoryScores,
    required this.lastUpdated,
    required this.createdAt,
    this.weeklyScore,
    this.monthlyScore,
    this.averageWorkoutCompletion,
    this.totalExercisesCompleted,
    this.totalWorkoutMinutes,
    final Map<String, dynamic>? aiEvaluation,
    final List<String>? recentAchievements,
    final Map<String, dynamic>? progressMetrics,
  }) : _achievements = achievements,
       _categoryScores = categoryScores,
       _aiEvaluation = aiEvaluation,
       _recentAchievements = recentAchievements,
       _progressMetrics = progressMetrics;

  factory _$UserScoreImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserScoreImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final int totalScore;
  @override
  final double commitmentLevel;
  @override
  final int workoutsCompleted;
  @override
  final int totalWorkouts;
  @override
  final int currentStreak;
  @override
  final int longestStreak;
  final List<Achievement> _achievements;
  @override
  List<Achievement> get achievements {
    if (_achievements is EqualUnmodifiableListView) return _achievements;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_achievements);
  }

  final Map<String, int> _categoryScores;
  @override
  Map<String, int> get categoryScores {
    if (_categoryScores is EqualUnmodifiableMapView) return _categoryScores;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_categoryScores);
  }

  @override
  final DateTime lastUpdated;
  @override
  final DateTime createdAt;
  @override
  final int? weeklyScore;
  @override
  final int? monthlyScore;
  @override
  final double? averageWorkoutCompletion;
  @override
  final int? totalExercisesCompleted;
  @override
  final int? totalWorkoutMinutes;
  final Map<String, dynamic>? _aiEvaluation;
  @override
  Map<String, dynamic>? get aiEvaluation {
    final value = _aiEvaluation;
    if (value == null) return null;
    if (_aiEvaluation is EqualUnmodifiableMapView) return _aiEvaluation;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final List<String>? _recentAchievements;
  @override
  List<String>? get recentAchievements {
    final value = _recentAchievements;
    if (value == null) return null;
    if (_recentAchievements is EqualUnmodifiableListView)
      return _recentAchievements;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final Map<String, dynamic>? _progressMetrics;
  @override
  Map<String, dynamic>? get progressMetrics {
    final value = _progressMetrics;
    if (value == null) return null;
    if (_progressMetrics is EqualUnmodifiableMapView) return _progressMetrics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'UserScore(id: $id, userId: $userId, totalScore: $totalScore, commitmentLevel: $commitmentLevel, workoutsCompleted: $workoutsCompleted, totalWorkouts: $totalWorkouts, currentStreak: $currentStreak, longestStreak: $longestStreak, achievements: $achievements, categoryScores: $categoryScores, lastUpdated: $lastUpdated, createdAt: $createdAt, weeklyScore: $weeklyScore, monthlyScore: $monthlyScore, averageWorkoutCompletion: $averageWorkoutCompletion, totalExercisesCompleted: $totalExercisesCompleted, totalWorkoutMinutes: $totalWorkoutMinutes, aiEvaluation: $aiEvaluation, recentAchievements: $recentAchievements, progressMetrics: $progressMetrics)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserScoreImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.totalScore, totalScore) ||
                other.totalScore == totalScore) &&
            (identical(other.commitmentLevel, commitmentLevel) ||
                other.commitmentLevel == commitmentLevel) &&
            (identical(other.workoutsCompleted, workoutsCompleted) ||
                other.workoutsCompleted == workoutsCompleted) &&
            (identical(other.totalWorkouts, totalWorkouts) ||
                other.totalWorkouts == totalWorkouts) &&
            (identical(other.currentStreak, currentStreak) ||
                other.currentStreak == currentStreak) &&
            (identical(other.longestStreak, longestStreak) ||
                other.longestStreak == longestStreak) &&
            const DeepCollectionEquality().equals(
              other._achievements,
              _achievements,
            ) &&
            const DeepCollectionEquality().equals(
              other._categoryScores,
              _categoryScores,
            ) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.weeklyScore, weeklyScore) ||
                other.weeklyScore == weeklyScore) &&
            (identical(other.monthlyScore, monthlyScore) ||
                other.monthlyScore == monthlyScore) &&
            (identical(
                  other.averageWorkoutCompletion,
                  averageWorkoutCompletion,
                ) ||
                other.averageWorkoutCompletion == averageWorkoutCompletion) &&
            (identical(
                  other.totalExercisesCompleted,
                  totalExercisesCompleted,
                ) ||
                other.totalExercisesCompleted == totalExercisesCompleted) &&
            (identical(other.totalWorkoutMinutes, totalWorkoutMinutes) ||
                other.totalWorkoutMinutes == totalWorkoutMinutes) &&
            const DeepCollectionEquality().equals(
              other._aiEvaluation,
              _aiEvaluation,
            ) &&
            const DeepCollectionEquality().equals(
              other._recentAchievements,
              _recentAchievements,
            ) &&
            const DeepCollectionEquality().equals(
              other._progressMetrics,
              _progressMetrics,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    userId,
    totalScore,
    commitmentLevel,
    workoutsCompleted,
    totalWorkouts,
    currentStreak,
    longestStreak,
    const DeepCollectionEquality().hash(_achievements),
    const DeepCollectionEquality().hash(_categoryScores),
    lastUpdated,
    createdAt,
    weeklyScore,
    monthlyScore,
    averageWorkoutCompletion,
    totalExercisesCompleted,
    totalWorkoutMinutes,
    const DeepCollectionEquality().hash(_aiEvaluation),
    const DeepCollectionEquality().hash(_recentAchievements),
    const DeepCollectionEquality().hash(_progressMetrics),
  ]);

  /// Create a copy of UserScore
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserScoreImplCopyWith<_$UserScoreImpl> get copyWith =>
      __$$UserScoreImplCopyWithImpl<_$UserScoreImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserScoreImplToJson(this);
  }
}

abstract class _UserScore implements UserScore {
  const factory _UserScore({
    required final String id,
    required final String userId,
    required final int totalScore,
    required final double commitmentLevel,
    required final int workoutsCompleted,
    required final int totalWorkouts,
    required final int currentStreak,
    required final int longestStreak,
    required final List<Achievement> achievements,
    required final Map<String, int> categoryScores,
    required final DateTime lastUpdated,
    required final DateTime createdAt,
    final int? weeklyScore,
    final int? monthlyScore,
    final double? averageWorkoutCompletion,
    final int? totalExercisesCompleted,
    final int? totalWorkoutMinutes,
    final Map<String, dynamic>? aiEvaluation,
    final List<String>? recentAchievements,
    final Map<String, dynamic>? progressMetrics,
  }) = _$UserScoreImpl;

  factory _UserScore.fromJson(Map<String, dynamic> json) =
      _$UserScoreImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  int get totalScore;
  @override
  double get commitmentLevel;
  @override
  int get workoutsCompleted;
  @override
  int get totalWorkouts;
  @override
  int get currentStreak;
  @override
  int get longestStreak;
  @override
  List<Achievement> get achievements;
  @override
  Map<String, int> get categoryScores;
  @override
  DateTime get lastUpdated;
  @override
  DateTime get createdAt;
  @override
  int? get weeklyScore;
  @override
  int? get monthlyScore;
  @override
  double? get averageWorkoutCompletion;
  @override
  int? get totalExercisesCompleted;
  @override
  int? get totalWorkoutMinutes;
  @override
  Map<String, dynamic>? get aiEvaluation;
  @override
  List<String>? get recentAchievements;
  @override
  Map<String, dynamic>? get progressMetrics;

  /// Create a copy of UserScore
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserScoreImplCopyWith<_$UserScoreImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Achievement _$AchievementFromJson(Map<String, dynamic> json) {
  return _Achievement.fromJson(json);
}

/// @nodoc
mixin _$Achievement {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  AchievementType get type => throw _privateConstructorUsedError;
  AchievementTier get tier => throw _privateConstructorUsedError;
  int get pointsAwarded => throw _privateConstructorUsedError;
  DateTime get unlockedAt => throw _privateConstructorUsedError;
  String? get iconUrl => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this Achievement to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Achievement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AchievementCopyWith<Achievement> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AchievementCopyWith<$Res> {
  factory $AchievementCopyWith(
    Achievement value,
    $Res Function(Achievement) then,
  ) = _$AchievementCopyWithImpl<$Res, Achievement>;
  @useResult
  $Res call({
    String id,
    String name,
    String description,
    AchievementType type,
    AchievementTier tier,
    int pointsAwarded,
    DateTime unlockedAt,
    String? iconUrl,
    Map<String, dynamic>? metadata,
  });
}

/// @nodoc
class _$AchievementCopyWithImpl<$Res, $Val extends Achievement>
    implements $AchievementCopyWith<$Res> {
  _$AchievementCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Achievement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? type = null,
    Object? tier = null,
    Object? pointsAwarded = null,
    Object? unlockedAt = null,
    Object? iconUrl = freezed,
    Object? metadata = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            description:
                null == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String,
            type:
                null == type
                    ? _value.type
                    : type // ignore: cast_nullable_to_non_nullable
                        as AchievementType,
            tier:
                null == tier
                    ? _value.tier
                    : tier // ignore: cast_nullable_to_non_nullable
                        as AchievementTier,
            pointsAwarded:
                null == pointsAwarded
                    ? _value.pointsAwarded
                    : pointsAwarded // ignore: cast_nullable_to_non_nullable
                        as int,
            unlockedAt:
                null == unlockedAt
                    ? _value.unlockedAt
                    : unlockedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            iconUrl:
                freezed == iconUrl
                    ? _value.iconUrl
                    : iconUrl // ignore: cast_nullable_to_non_nullable
                        as String?,
            metadata:
                freezed == metadata
                    ? _value.metadata
                    : metadata // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AchievementImplCopyWith<$Res>
    implements $AchievementCopyWith<$Res> {
  factory _$$AchievementImplCopyWith(
    _$AchievementImpl value,
    $Res Function(_$AchievementImpl) then,
  ) = __$$AchievementImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String description,
    AchievementType type,
    AchievementTier tier,
    int pointsAwarded,
    DateTime unlockedAt,
    String? iconUrl,
    Map<String, dynamic>? metadata,
  });
}

/// @nodoc
class __$$AchievementImplCopyWithImpl<$Res>
    extends _$AchievementCopyWithImpl<$Res, _$AchievementImpl>
    implements _$$AchievementImplCopyWith<$Res> {
  __$$AchievementImplCopyWithImpl(
    _$AchievementImpl _value,
    $Res Function(_$AchievementImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Achievement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? type = null,
    Object? tier = null,
    Object? pointsAwarded = null,
    Object? unlockedAt = null,
    Object? iconUrl = freezed,
    Object? metadata = freezed,
  }) {
    return _then(
      _$AchievementImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        description:
            null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String,
        type:
            null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                    as AchievementType,
        tier:
            null == tier
                ? _value.tier
                : tier // ignore: cast_nullable_to_non_nullable
                    as AchievementTier,
        pointsAwarded:
            null == pointsAwarded
                ? _value.pointsAwarded
                : pointsAwarded // ignore: cast_nullable_to_non_nullable
                    as int,
        unlockedAt:
            null == unlockedAt
                ? _value.unlockedAt
                : unlockedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        iconUrl:
            freezed == iconUrl
                ? _value.iconUrl
                : iconUrl // ignore: cast_nullable_to_non_nullable
                    as String?,
        metadata:
            freezed == metadata
                ? _value._metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AchievementImpl implements _Achievement {
  const _$AchievementImpl({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.tier,
    required this.pointsAwarded,
    required this.unlockedAt,
    this.iconUrl,
    final Map<String, dynamic>? metadata,
  }) : _metadata = metadata;

  factory _$AchievementImpl.fromJson(Map<String, dynamic> json) =>
      _$$AchievementImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  final AchievementType type;
  @override
  final AchievementTier tier;
  @override
  final int pointsAwarded;
  @override
  final DateTime unlockedAt;
  @override
  final String? iconUrl;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'Achievement(id: $id, name: $name, description: $description, type: $type, tier: $tier, pointsAwarded: $pointsAwarded, unlockedAt: $unlockedAt, iconUrl: $iconUrl, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AchievementImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.tier, tier) || other.tier == tier) &&
            (identical(other.pointsAwarded, pointsAwarded) ||
                other.pointsAwarded == pointsAwarded) &&
            (identical(other.unlockedAt, unlockedAt) ||
                other.unlockedAt == unlockedAt) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    description,
    type,
    tier,
    pointsAwarded,
    unlockedAt,
    iconUrl,
    const DeepCollectionEquality().hash(_metadata),
  );

  /// Create a copy of Achievement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AchievementImplCopyWith<_$AchievementImpl> get copyWith =>
      __$$AchievementImplCopyWithImpl<_$AchievementImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AchievementImplToJson(this);
  }
}

abstract class _Achievement implements Achievement {
  const factory _Achievement({
    required final String id,
    required final String name,
    required final String description,
    required final AchievementType type,
    required final AchievementTier tier,
    required final int pointsAwarded,
    required final DateTime unlockedAt,
    final String? iconUrl,
    final Map<String, dynamic>? metadata,
  }) = _$AchievementImpl;

  factory _Achievement.fromJson(Map<String, dynamic> json) =
      _$AchievementImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  AchievementType get type;
  @override
  AchievementTier get tier;
  @override
  int get pointsAwarded;
  @override
  DateTime get unlockedAt;
  @override
  String? get iconUrl;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of Achievement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AchievementImplCopyWith<_$AchievementImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
