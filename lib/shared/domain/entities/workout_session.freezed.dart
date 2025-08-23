// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

WorkoutSession _$WorkoutSessionFromJson(Map<String, dynamic> json) {
  return _WorkoutSession.fromJson(json);
}

/// @nodoc
mixin _$WorkoutSession {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get workoutPlanId => throw _privateConstructorUsedError;
  SessionStatus get status => throw _privateConstructorUsedError;
  DateTime get startedAt => throw _privateConstructorUsedError;
  List<ExerciseExecution> get exerciseExecutions =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;
  String? get workoutPlanName =>
      throw _privateConstructorUsedError; // Cached for offline use
  DateTime? get completedAt => throw _privateConstructorUsedError;
  DateTime? get pausedAt => throw _privateConstructorUsedError;
  int? get totalDurationSeconds => throw _privateConstructorUsedError;
  double? get completionPercentage => throw _privateConstructorUsedError;
  int? get totalCaloriesBurned => throw _privateConstructorUsedError;
  Map<String, dynamic>? get aiEvaluation => throw _privateConstructorUsedError;
  String? get userNotes => throw _privateConstructorUsedError;
  List<String>? get skippedExerciseIds => throw _privateConstructorUsedError;
  Map<String, dynamic>? get sessionData => throw _privateConstructorUsedError;

  /// Serializes this WorkoutSession to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkoutSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkoutSessionCopyWith<WorkoutSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkoutSessionCopyWith<$Res> {
  factory $WorkoutSessionCopyWith(
    WorkoutSession value,
    $Res Function(WorkoutSession) then,
  ) = _$WorkoutSessionCopyWithImpl<$Res, WorkoutSession>;
  @useResult
  $Res call({
    String id,
    String userId,
    String workoutPlanId,
    SessionStatus status,
    DateTime startedAt,
    List<ExerciseExecution> exerciseExecutions,
    Map<String, dynamic> metadata,
    String? workoutPlanName,
    DateTime? completedAt,
    DateTime? pausedAt,
    int? totalDurationSeconds,
    double? completionPercentage,
    int? totalCaloriesBurned,
    Map<String, dynamic>? aiEvaluation,
    String? userNotes,
    List<String>? skippedExerciseIds,
    Map<String, dynamic>? sessionData,
  });
}

/// @nodoc
class _$WorkoutSessionCopyWithImpl<$Res, $Val extends WorkoutSession>
    implements $WorkoutSessionCopyWith<$Res> {
  _$WorkoutSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkoutSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? workoutPlanId = null,
    Object? status = null,
    Object? startedAt = null,
    Object? exerciseExecutions = null,
    Object? metadata = null,
    Object? workoutPlanName = freezed,
    Object? completedAt = freezed,
    Object? pausedAt = freezed,
    Object? totalDurationSeconds = freezed,
    Object? completionPercentage = freezed,
    Object? totalCaloriesBurned = freezed,
    Object? aiEvaluation = freezed,
    Object? userNotes = freezed,
    Object? skippedExerciseIds = freezed,
    Object? sessionData = freezed,
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
            workoutPlanId:
                null == workoutPlanId
                    ? _value.workoutPlanId
                    : workoutPlanId // ignore: cast_nullable_to_non_nullable
                        as String,
            status:
                null == status
                    ? _value.status
                    : status // ignore: cast_nullable_to_non_nullable
                        as SessionStatus,
            startedAt:
                null == startedAt
                    ? _value.startedAt
                    : startedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            exerciseExecutions:
                null == exerciseExecutions
                    ? _value.exerciseExecutions
                    : exerciseExecutions // ignore: cast_nullable_to_non_nullable
                        as List<ExerciseExecution>,
            metadata:
                null == metadata
                    ? _value.metadata
                    : metadata // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>,
            workoutPlanName:
                freezed == workoutPlanName
                    ? _value.workoutPlanName
                    : workoutPlanName // ignore: cast_nullable_to_non_nullable
                        as String?,
            completedAt:
                freezed == completedAt
                    ? _value.completedAt
                    : completedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            pausedAt:
                freezed == pausedAt
                    ? _value.pausedAt
                    : pausedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            totalDurationSeconds:
                freezed == totalDurationSeconds
                    ? _value.totalDurationSeconds
                    : totalDurationSeconds // ignore: cast_nullable_to_non_nullable
                        as int?,
            completionPercentage:
                freezed == completionPercentage
                    ? _value.completionPercentage
                    : completionPercentage // ignore: cast_nullable_to_non_nullable
                        as double?,
            totalCaloriesBurned:
                freezed == totalCaloriesBurned
                    ? _value.totalCaloriesBurned
                    : totalCaloriesBurned // ignore: cast_nullable_to_non_nullable
                        as int?,
            aiEvaluation:
                freezed == aiEvaluation
                    ? _value.aiEvaluation
                    : aiEvaluation // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>?,
            userNotes:
                freezed == userNotes
                    ? _value.userNotes
                    : userNotes // ignore: cast_nullable_to_non_nullable
                        as String?,
            skippedExerciseIds:
                freezed == skippedExerciseIds
                    ? _value.skippedExerciseIds
                    : skippedExerciseIds // ignore: cast_nullable_to_non_nullable
                        as List<String>?,
            sessionData:
                freezed == sessionData
                    ? _value.sessionData
                    : sessionData // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WorkoutSessionImplCopyWith<$Res>
    implements $WorkoutSessionCopyWith<$Res> {
  factory _$$WorkoutSessionImplCopyWith(
    _$WorkoutSessionImpl value,
    $Res Function(_$WorkoutSessionImpl) then,
  ) = __$$WorkoutSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String workoutPlanId,
    SessionStatus status,
    DateTime startedAt,
    List<ExerciseExecution> exerciseExecutions,
    Map<String, dynamic> metadata,
    String? workoutPlanName,
    DateTime? completedAt,
    DateTime? pausedAt,
    int? totalDurationSeconds,
    double? completionPercentage,
    int? totalCaloriesBurned,
    Map<String, dynamic>? aiEvaluation,
    String? userNotes,
    List<String>? skippedExerciseIds,
    Map<String, dynamic>? sessionData,
  });
}

/// @nodoc
class __$$WorkoutSessionImplCopyWithImpl<$Res>
    extends _$WorkoutSessionCopyWithImpl<$Res, _$WorkoutSessionImpl>
    implements _$$WorkoutSessionImplCopyWith<$Res> {
  __$$WorkoutSessionImplCopyWithImpl(
    _$WorkoutSessionImpl _value,
    $Res Function(_$WorkoutSessionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WorkoutSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? workoutPlanId = null,
    Object? status = null,
    Object? startedAt = null,
    Object? exerciseExecutions = null,
    Object? metadata = null,
    Object? workoutPlanName = freezed,
    Object? completedAt = freezed,
    Object? pausedAt = freezed,
    Object? totalDurationSeconds = freezed,
    Object? completionPercentage = freezed,
    Object? totalCaloriesBurned = freezed,
    Object? aiEvaluation = freezed,
    Object? userNotes = freezed,
    Object? skippedExerciseIds = freezed,
    Object? sessionData = freezed,
  }) {
    return _then(
      _$WorkoutSessionImpl(
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
        workoutPlanId:
            null == workoutPlanId
                ? _value.workoutPlanId
                : workoutPlanId // ignore: cast_nullable_to_non_nullable
                    as String,
        status:
            null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                    as SessionStatus,
        startedAt:
            null == startedAt
                ? _value.startedAt
                : startedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        exerciseExecutions:
            null == exerciseExecutions
                ? _value._exerciseExecutions
                : exerciseExecutions // ignore: cast_nullable_to_non_nullable
                    as List<ExerciseExecution>,
        metadata:
            null == metadata
                ? _value._metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>,
        workoutPlanName:
            freezed == workoutPlanName
                ? _value.workoutPlanName
                : workoutPlanName // ignore: cast_nullable_to_non_nullable
                    as String?,
        completedAt:
            freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        pausedAt:
            freezed == pausedAt
                ? _value.pausedAt
                : pausedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        totalDurationSeconds:
            freezed == totalDurationSeconds
                ? _value.totalDurationSeconds
                : totalDurationSeconds // ignore: cast_nullable_to_non_nullable
                    as int?,
        completionPercentage:
            freezed == completionPercentage
                ? _value.completionPercentage
                : completionPercentage // ignore: cast_nullable_to_non_nullable
                    as double?,
        totalCaloriesBurned:
            freezed == totalCaloriesBurned
                ? _value.totalCaloriesBurned
                : totalCaloriesBurned // ignore: cast_nullable_to_non_nullable
                    as int?,
        aiEvaluation:
            freezed == aiEvaluation
                ? _value._aiEvaluation
                : aiEvaluation // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>?,
        userNotes:
            freezed == userNotes
                ? _value.userNotes
                : userNotes // ignore: cast_nullable_to_non_nullable
                    as String?,
        skippedExerciseIds:
            freezed == skippedExerciseIds
                ? _value._skippedExerciseIds
                : skippedExerciseIds // ignore: cast_nullable_to_non_nullable
                    as List<String>?,
        sessionData:
            freezed == sessionData
                ? _value._sessionData
                : sessionData // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkoutSessionImpl implements _WorkoutSession {
  const _$WorkoutSessionImpl({
    required this.id,
    required this.userId,
    required this.workoutPlanId,
    required this.status,
    required this.startedAt,
    required final List<ExerciseExecution> exerciseExecutions,
    required final Map<String, dynamic> metadata,
    this.workoutPlanName,
    this.completedAt,
    this.pausedAt,
    this.totalDurationSeconds,
    this.completionPercentage,
    this.totalCaloriesBurned,
    final Map<String, dynamic>? aiEvaluation,
    this.userNotes,
    final List<String>? skippedExerciseIds,
    final Map<String, dynamic>? sessionData,
  }) : _exerciseExecutions = exerciseExecutions,
       _metadata = metadata,
       _aiEvaluation = aiEvaluation,
       _skippedExerciseIds = skippedExerciseIds,
       _sessionData = sessionData;

  factory _$WorkoutSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkoutSessionImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String workoutPlanId;
  @override
  final SessionStatus status;
  @override
  final DateTime startedAt;
  final List<ExerciseExecution> _exerciseExecutions;
  @override
  List<ExerciseExecution> get exerciseExecutions {
    if (_exerciseExecutions is EqualUnmodifiableListView)
      return _exerciseExecutions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_exerciseExecutions);
  }

  final Map<String, dynamic> _metadata;
  @override
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  final String? workoutPlanName;
  // Cached for offline use
  @override
  final DateTime? completedAt;
  @override
  final DateTime? pausedAt;
  @override
  final int? totalDurationSeconds;
  @override
  final double? completionPercentage;
  @override
  final int? totalCaloriesBurned;
  final Map<String, dynamic>? _aiEvaluation;
  @override
  Map<String, dynamic>? get aiEvaluation {
    final value = _aiEvaluation;
    if (value == null) return null;
    if (_aiEvaluation is EqualUnmodifiableMapView) return _aiEvaluation;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? userNotes;
  final List<String>? _skippedExerciseIds;
  @override
  List<String>? get skippedExerciseIds {
    final value = _skippedExerciseIds;
    if (value == null) return null;
    if (_skippedExerciseIds is EqualUnmodifiableListView)
      return _skippedExerciseIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final Map<String, dynamic>? _sessionData;
  @override
  Map<String, dynamic>? get sessionData {
    final value = _sessionData;
    if (value == null) return null;
    if (_sessionData is EqualUnmodifiableMapView) return _sessionData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'WorkoutSession(id: $id, userId: $userId, workoutPlanId: $workoutPlanId, status: $status, startedAt: $startedAt, exerciseExecutions: $exerciseExecutions, metadata: $metadata, workoutPlanName: $workoutPlanName, completedAt: $completedAt, pausedAt: $pausedAt, totalDurationSeconds: $totalDurationSeconds, completionPercentage: $completionPercentage, totalCaloriesBurned: $totalCaloriesBurned, aiEvaluation: $aiEvaluation, userNotes: $userNotes, skippedExerciseIds: $skippedExerciseIds, sessionData: $sessionData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkoutSessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.workoutPlanId, workoutPlanId) ||
                other.workoutPlanId == workoutPlanId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            const DeepCollectionEquality().equals(
              other._exerciseExecutions,
              _exerciseExecutions,
            ) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.workoutPlanName, workoutPlanName) ||
                other.workoutPlanName == workoutPlanName) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.pausedAt, pausedAt) ||
                other.pausedAt == pausedAt) &&
            (identical(other.totalDurationSeconds, totalDurationSeconds) ||
                other.totalDurationSeconds == totalDurationSeconds) &&
            (identical(other.completionPercentage, completionPercentage) ||
                other.completionPercentage == completionPercentage) &&
            (identical(other.totalCaloriesBurned, totalCaloriesBurned) ||
                other.totalCaloriesBurned == totalCaloriesBurned) &&
            const DeepCollectionEquality().equals(
              other._aiEvaluation,
              _aiEvaluation,
            ) &&
            (identical(other.userNotes, userNotes) ||
                other.userNotes == userNotes) &&
            const DeepCollectionEquality().equals(
              other._skippedExerciseIds,
              _skippedExerciseIds,
            ) &&
            const DeepCollectionEquality().equals(
              other._sessionData,
              _sessionData,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    workoutPlanId,
    status,
    startedAt,
    const DeepCollectionEquality().hash(_exerciseExecutions),
    const DeepCollectionEquality().hash(_metadata),
    workoutPlanName,
    completedAt,
    pausedAt,
    totalDurationSeconds,
    completionPercentage,
    totalCaloriesBurned,
    const DeepCollectionEquality().hash(_aiEvaluation),
    userNotes,
    const DeepCollectionEquality().hash(_skippedExerciseIds),
    const DeepCollectionEquality().hash(_sessionData),
  );

  /// Create a copy of WorkoutSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkoutSessionImplCopyWith<_$WorkoutSessionImpl> get copyWith =>
      __$$WorkoutSessionImplCopyWithImpl<_$WorkoutSessionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkoutSessionImplToJson(this);
  }
}

abstract class _WorkoutSession implements WorkoutSession {
  const factory _WorkoutSession({
    required final String id,
    required final String userId,
    required final String workoutPlanId,
    required final SessionStatus status,
    required final DateTime startedAt,
    required final List<ExerciseExecution> exerciseExecutions,
    required final Map<String, dynamic> metadata,
    final String? workoutPlanName,
    final DateTime? completedAt,
    final DateTime? pausedAt,
    final int? totalDurationSeconds,
    final double? completionPercentage,
    final int? totalCaloriesBurned,
    final Map<String, dynamic>? aiEvaluation,
    final String? userNotes,
    final List<String>? skippedExerciseIds,
    final Map<String, dynamic>? sessionData,
  }) = _$WorkoutSessionImpl;

  factory _WorkoutSession.fromJson(Map<String, dynamic> json) =
      _$WorkoutSessionImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get workoutPlanId;
  @override
  SessionStatus get status;
  @override
  DateTime get startedAt;
  @override
  List<ExerciseExecution> get exerciseExecutions;
  @override
  Map<String, dynamic> get metadata;
  @override
  String? get workoutPlanName; // Cached for offline use
  @override
  DateTime? get completedAt;
  @override
  DateTime? get pausedAt;
  @override
  int? get totalDurationSeconds;
  @override
  double? get completionPercentage;
  @override
  int? get totalCaloriesBurned;
  @override
  Map<String, dynamic>? get aiEvaluation;
  @override
  String? get userNotes;
  @override
  List<String>? get skippedExerciseIds;
  @override
  Map<String, dynamic>? get sessionData;

  /// Create a copy of WorkoutSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkoutSessionImplCopyWith<_$WorkoutSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ExerciseExecution _$ExerciseExecutionFromJson(Map<String, dynamic> json) {
  return _ExerciseExecution.fromJson(json);
}

/// @nodoc
mixin _$ExerciseExecution {
  String get exerciseId => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;
  ExecutionStatus get status => throw _privateConstructorUsedError;
  DateTime get startedAt => throw _privateConstructorUsedError;
  List<SetExecution> get setExecutions => throw _privateConstructorUsedError;
  String? get exerciseName =>
      throw _privateConstructorUsedError; // Cached for offline use
  DateTime? get completedAt => throw _privateConstructorUsedError;
  DateTime? get skippedAt => throw _privateConstructorUsedError;
  int? get totalDurationSeconds => throw _privateConstructorUsedError;
  String? get skipReason => throw _privateConstructorUsedError;
  String? get alternativeExerciseId => throw _privateConstructorUsedError;
  Map<String, dynamic>? get executionData => throw _privateConstructorUsedError;

  /// Serializes this ExerciseExecution to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExerciseExecution
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExerciseExecutionCopyWith<ExerciseExecution> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExerciseExecutionCopyWith<$Res> {
  factory $ExerciseExecutionCopyWith(
    ExerciseExecution value,
    $Res Function(ExerciseExecution) then,
  ) = _$ExerciseExecutionCopyWithImpl<$Res, ExerciseExecution>;
  @useResult
  $Res call({
    String exerciseId,
    int order,
    ExecutionStatus status,
    DateTime startedAt,
    List<SetExecution> setExecutions,
    String? exerciseName,
    DateTime? completedAt,
    DateTime? skippedAt,
    int? totalDurationSeconds,
    String? skipReason,
    String? alternativeExerciseId,
    Map<String, dynamic>? executionData,
  });
}

/// @nodoc
class _$ExerciseExecutionCopyWithImpl<$Res, $Val extends ExerciseExecution>
    implements $ExerciseExecutionCopyWith<$Res> {
  _$ExerciseExecutionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExerciseExecution
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? exerciseId = null,
    Object? order = null,
    Object? status = null,
    Object? startedAt = null,
    Object? setExecutions = null,
    Object? exerciseName = freezed,
    Object? completedAt = freezed,
    Object? skippedAt = freezed,
    Object? totalDurationSeconds = freezed,
    Object? skipReason = freezed,
    Object? alternativeExerciseId = freezed,
    Object? executionData = freezed,
  }) {
    return _then(
      _value.copyWith(
            exerciseId:
                null == exerciseId
                    ? _value.exerciseId
                    : exerciseId // ignore: cast_nullable_to_non_nullable
                        as String,
            order:
                null == order
                    ? _value.order
                    : order // ignore: cast_nullable_to_non_nullable
                        as int,
            status:
                null == status
                    ? _value.status
                    : status // ignore: cast_nullable_to_non_nullable
                        as ExecutionStatus,
            startedAt:
                null == startedAt
                    ? _value.startedAt
                    : startedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            setExecutions:
                null == setExecutions
                    ? _value.setExecutions
                    : setExecutions // ignore: cast_nullable_to_non_nullable
                        as List<SetExecution>,
            exerciseName:
                freezed == exerciseName
                    ? _value.exerciseName
                    : exerciseName // ignore: cast_nullable_to_non_nullable
                        as String?,
            completedAt:
                freezed == completedAt
                    ? _value.completedAt
                    : completedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            skippedAt:
                freezed == skippedAt
                    ? _value.skippedAt
                    : skippedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            totalDurationSeconds:
                freezed == totalDurationSeconds
                    ? _value.totalDurationSeconds
                    : totalDurationSeconds // ignore: cast_nullable_to_non_nullable
                        as int?,
            skipReason:
                freezed == skipReason
                    ? _value.skipReason
                    : skipReason // ignore: cast_nullable_to_non_nullable
                        as String?,
            alternativeExerciseId:
                freezed == alternativeExerciseId
                    ? _value.alternativeExerciseId
                    : alternativeExerciseId // ignore: cast_nullable_to_non_nullable
                        as String?,
            executionData:
                freezed == executionData
                    ? _value.executionData
                    : executionData // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ExerciseExecutionImplCopyWith<$Res>
    implements $ExerciseExecutionCopyWith<$Res> {
  factory _$$ExerciseExecutionImplCopyWith(
    _$ExerciseExecutionImpl value,
    $Res Function(_$ExerciseExecutionImpl) then,
  ) = __$$ExerciseExecutionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String exerciseId,
    int order,
    ExecutionStatus status,
    DateTime startedAt,
    List<SetExecution> setExecutions,
    String? exerciseName,
    DateTime? completedAt,
    DateTime? skippedAt,
    int? totalDurationSeconds,
    String? skipReason,
    String? alternativeExerciseId,
    Map<String, dynamic>? executionData,
  });
}

/// @nodoc
class __$$ExerciseExecutionImplCopyWithImpl<$Res>
    extends _$ExerciseExecutionCopyWithImpl<$Res, _$ExerciseExecutionImpl>
    implements _$$ExerciseExecutionImplCopyWith<$Res> {
  __$$ExerciseExecutionImplCopyWithImpl(
    _$ExerciseExecutionImpl _value,
    $Res Function(_$ExerciseExecutionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ExerciseExecution
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? exerciseId = null,
    Object? order = null,
    Object? status = null,
    Object? startedAt = null,
    Object? setExecutions = null,
    Object? exerciseName = freezed,
    Object? completedAt = freezed,
    Object? skippedAt = freezed,
    Object? totalDurationSeconds = freezed,
    Object? skipReason = freezed,
    Object? alternativeExerciseId = freezed,
    Object? executionData = freezed,
  }) {
    return _then(
      _$ExerciseExecutionImpl(
        exerciseId:
            null == exerciseId
                ? _value.exerciseId
                : exerciseId // ignore: cast_nullable_to_non_nullable
                    as String,
        order:
            null == order
                ? _value.order
                : order // ignore: cast_nullable_to_non_nullable
                    as int,
        status:
            null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                    as ExecutionStatus,
        startedAt:
            null == startedAt
                ? _value.startedAt
                : startedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        setExecutions:
            null == setExecutions
                ? _value._setExecutions
                : setExecutions // ignore: cast_nullable_to_non_nullable
                    as List<SetExecution>,
        exerciseName:
            freezed == exerciseName
                ? _value.exerciseName
                : exerciseName // ignore: cast_nullable_to_non_nullable
                    as String?,
        completedAt:
            freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        skippedAt:
            freezed == skippedAt
                ? _value.skippedAt
                : skippedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        totalDurationSeconds:
            freezed == totalDurationSeconds
                ? _value.totalDurationSeconds
                : totalDurationSeconds // ignore: cast_nullable_to_non_nullable
                    as int?,
        skipReason:
            freezed == skipReason
                ? _value.skipReason
                : skipReason // ignore: cast_nullable_to_non_nullable
                    as String?,
        alternativeExerciseId:
            freezed == alternativeExerciseId
                ? _value.alternativeExerciseId
                : alternativeExerciseId // ignore: cast_nullable_to_non_nullable
                    as String?,
        executionData:
            freezed == executionData
                ? _value._executionData
                : executionData // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ExerciseExecutionImpl implements _ExerciseExecution {
  const _$ExerciseExecutionImpl({
    required this.exerciseId,
    required this.order,
    required this.status,
    required this.startedAt,
    required final List<SetExecution> setExecutions,
    this.exerciseName,
    this.completedAt,
    this.skippedAt,
    this.totalDurationSeconds,
    this.skipReason,
    this.alternativeExerciseId,
    final Map<String, dynamic>? executionData,
  }) : _setExecutions = setExecutions,
       _executionData = executionData;

  factory _$ExerciseExecutionImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExerciseExecutionImplFromJson(json);

  @override
  final String exerciseId;
  @override
  final int order;
  @override
  final ExecutionStatus status;
  @override
  final DateTime startedAt;
  final List<SetExecution> _setExecutions;
  @override
  List<SetExecution> get setExecutions {
    if (_setExecutions is EqualUnmodifiableListView) return _setExecutions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_setExecutions);
  }

  @override
  final String? exerciseName;
  // Cached for offline use
  @override
  final DateTime? completedAt;
  @override
  final DateTime? skippedAt;
  @override
  final int? totalDurationSeconds;
  @override
  final String? skipReason;
  @override
  final String? alternativeExerciseId;
  final Map<String, dynamic>? _executionData;
  @override
  Map<String, dynamic>? get executionData {
    final value = _executionData;
    if (value == null) return null;
    if (_executionData is EqualUnmodifiableMapView) return _executionData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'ExerciseExecution(exerciseId: $exerciseId, order: $order, status: $status, startedAt: $startedAt, setExecutions: $setExecutions, exerciseName: $exerciseName, completedAt: $completedAt, skippedAt: $skippedAt, totalDurationSeconds: $totalDurationSeconds, skipReason: $skipReason, alternativeExerciseId: $alternativeExerciseId, executionData: $executionData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExerciseExecutionImpl &&
            (identical(other.exerciseId, exerciseId) ||
                other.exerciseId == exerciseId) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            const DeepCollectionEquality().equals(
              other._setExecutions,
              _setExecutions,
            ) &&
            (identical(other.exerciseName, exerciseName) ||
                other.exerciseName == exerciseName) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.skippedAt, skippedAt) ||
                other.skippedAt == skippedAt) &&
            (identical(other.totalDurationSeconds, totalDurationSeconds) ||
                other.totalDurationSeconds == totalDurationSeconds) &&
            (identical(other.skipReason, skipReason) ||
                other.skipReason == skipReason) &&
            (identical(other.alternativeExerciseId, alternativeExerciseId) ||
                other.alternativeExerciseId == alternativeExerciseId) &&
            const DeepCollectionEquality().equals(
              other._executionData,
              _executionData,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    exerciseId,
    order,
    status,
    startedAt,
    const DeepCollectionEquality().hash(_setExecutions),
    exerciseName,
    completedAt,
    skippedAt,
    totalDurationSeconds,
    skipReason,
    alternativeExerciseId,
    const DeepCollectionEquality().hash(_executionData),
  );

  /// Create a copy of ExerciseExecution
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExerciseExecutionImplCopyWith<_$ExerciseExecutionImpl> get copyWith =>
      __$$ExerciseExecutionImplCopyWithImpl<_$ExerciseExecutionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ExerciseExecutionImplToJson(this);
  }
}

abstract class _ExerciseExecution implements ExerciseExecution {
  const factory _ExerciseExecution({
    required final String exerciseId,
    required final int order,
    required final ExecutionStatus status,
    required final DateTime startedAt,
    required final List<SetExecution> setExecutions,
    final String? exerciseName,
    final DateTime? completedAt,
    final DateTime? skippedAt,
    final int? totalDurationSeconds,
    final String? skipReason,
    final String? alternativeExerciseId,
    final Map<String, dynamic>? executionData,
  }) = _$ExerciseExecutionImpl;

  factory _ExerciseExecution.fromJson(Map<String, dynamic> json) =
      _$ExerciseExecutionImpl.fromJson;

  @override
  String get exerciseId;
  @override
  int get order;
  @override
  ExecutionStatus get status;
  @override
  DateTime get startedAt;
  @override
  List<SetExecution> get setExecutions;
  @override
  String? get exerciseName; // Cached for offline use
  @override
  DateTime? get completedAt;
  @override
  DateTime? get skippedAt;
  @override
  int? get totalDurationSeconds;
  @override
  String? get skipReason;
  @override
  String? get alternativeExerciseId;
  @override
  Map<String, dynamic>? get executionData;

  /// Create a copy of ExerciseExecution
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExerciseExecutionImplCopyWith<_$ExerciseExecutionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SetExecution _$SetExecutionFromJson(Map<String, dynamic> json) {
  return _SetExecution.fromJson(json);
}

/// @nodoc
mixin _$SetExecution {
  int get setNumber => throw _privateConstructorUsedError;
  SetStatus get status => throw _privateConstructorUsedError;
  DateTime get startedAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  int? get actualReps => throw _privateConstructorUsedError;
  int? get plannedReps => throw _privateConstructorUsedError;
  double? get weight => throw _privateConstructorUsedError;
  int? get durationSeconds => throw _privateConstructorUsedError;
  int? get restDurationSeconds => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this SetExecution to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SetExecution
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SetExecutionCopyWith<SetExecution> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SetExecutionCopyWith<$Res> {
  factory $SetExecutionCopyWith(
    SetExecution value,
    $Res Function(SetExecution) then,
  ) = _$SetExecutionCopyWithImpl<$Res, SetExecution>;
  @useResult
  $Res call({
    int setNumber,
    SetStatus status,
    DateTime startedAt,
    DateTime? completedAt,
    int? actualReps,
    int? plannedReps,
    double? weight,
    int? durationSeconds,
    int? restDurationSeconds,
    String? notes,
  });
}

/// @nodoc
class _$SetExecutionCopyWithImpl<$Res, $Val extends SetExecution>
    implements $SetExecutionCopyWith<$Res> {
  _$SetExecutionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SetExecution
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? setNumber = null,
    Object? status = null,
    Object? startedAt = null,
    Object? completedAt = freezed,
    Object? actualReps = freezed,
    Object? plannedReps = freezed,
    Object? weight = freezed,
    Object? durationSeconds = freezed,
    Object? restDurationSeconds = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _value.copyWith(
            setNumber:
                null == setNumber
                    ? _value.setNumber
                    : setNumber // ignore: cast_nullable_to_non_nullable
                        as int,
            status:
                null == status
                    ? _value.status
                    : status // ignore: cast_nullable_to_non_nullable
                        as SetStatus,
            startedAt:
                null == startedAt
                    ? _value.startedAt
                    : startedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            completedAt:
                freezed == completedAt
                    ? _value.completedAt
                    : completedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            actualReps:
                freezed == actualReps
                    ? _value.actualReps
                    : actualReps // ignore: cast_nullable_to_non_nullable
                        as int?,
            plannedReps:
                freezed == plannedReps
                    ? _value.plannedReps
                    : plannedReps // ignore: cast_nullable_to_non_nullable
                        as int?,
            weight:
                freezed == weight
                    ? _value.weight
                    : weight // ignore: cast_nullable_to_non_nullable
                        as double?,
            durationSeconds:
                freezed == durationSeconds
                    ? _value.durationSeconds
                    : durationSeconds // ignore: cast_nullable_to_non_nullable
                        as int?,
            restDurationSeconds:
                freezed == restDurationSeconds
                    ? _value.restDurationSeconds
                    : restDurationSeconds // ignore: cast_nullable_to_non_nullable
                        as int?,
            notes:
                freezed == notes
                    ? _value.notes
                    : notes // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SetExecutionImplCopyWith<$Res>
    implements $SetExecutionCopyWith<$Res> {
  factory _$$SetExecutionImplCopyWith(
    _$SetExecutionImpl value,
    $Res Function(_$SetExecutionImpl) then,
  ) = __$$SetExecutionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int setNumber,
    SetStatus status,
    DateTime startedAt,
    DateTime? completedAt,
    int? actualReps,
    int? plannedReps,
    double? weight,
    int? durationSeconds,
    int? restDurationSeconds,
    String? notes,
  });
}

/// @nodoc
class __$$SetExecutionImplCopyWithImpl<$Res>
    extends _$SetExecutionCopyWithImpl<$Res, _$SetExecutionImpl>
    implements _$$SetExecutionImplCopyWith<$Res> {
  __$$SetExecutionImplCopyWithImpl(
    _$SetExecutionImpl _value,
    $Res Function(_$SetExecutionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SetExecution
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? setNumber = null,
    Object? status = null,
    Object? startedAt = null,
    Object? completedAt = freezed,
    Object? actualReps = freezed,
    Object? plannedReps = freezed,
    Object? weight = freezed,
    Object? durationSeconds = freezed,
    Object? restDurationSeconds = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _$SetExecutionImpl(
        setNumber:
            null == setNumber
                ? _value.setNumber
                : setNumber // ignore: cast_nullable_to_non_nullable
                    as int,
        status:
            null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                    as SetStatus,
        startedAt:
            null == startedAt
                ? _value.startedAt
                : startedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        completedAt:
            freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        actualReps:
            freezed == actualReps
                ? _value.actualReps
                : actualReps // ignore: cast_nullable_to_non_nullable
                    as int?,
        plannedReps:
            freezed == plannedReps
                ? _value.plannedReps
                : plannedReps // ignore: cast_nullable_to_non_nullable
                    as int?,
        weight:
            freezed == weight
                ? _value.weight
                : weight // ignore: cast_nullable_to_non_nullable
                    as double?,
        durationSeconds:
            freezed == durationSeconds
                ? _value.durationSeconds
                : durationSeconds // ignore: cast_nullable_to_non_nullable
                    as int?,
        restDurationSeconds:
            freezed == restDurationSeconds
                ? _value.restDurationSeconds
                : restDurationSeconds // ignore: cast_nullable_to_non_nullable
                    as int?,
        notes:
            freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SetExecutionImpl implements _SetExecution {
  const _$SetExecutionImpl({
    required this.setNumber,
    required this.status,
    required this.startedAt,
    this.completedAt,
    this.actualReps,
    this.plannedReps,
    this.weight,
    this.durationSeconds,
    this.restDurationSeconds,
    this.notes,
  });

  factory _$SetExecutionImpl.fromJson(Map<String, dynamic> json) =>
      _$$SetExecutionImplFromJson(json);

  @override
  final int setNumber;
  @override
  final SetStatus status;
  @override
  final DateTime startedAt;
  @override
  final DateTime? completedAt;
  @override
  final int? actualReps;
  @override
  final int? plannedReps;
  @override
  final double? weight;
  @override
  final int? durationSeconds;
  @override
  final int? restDurationSeconds;
  @override
  final String? notes;

  @override
  String toString() {
    return 'SetExecution(setNumber: $setNumber, status: $status, startedAt: $startedAt, completedAt: $completedAt, actualReps: $actualReps, plannedReps: $plannedReps, weight: $weight, durationSeconds: $durationSeconds, restDurationSeconds: $restDurationSeconds, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SetExecutionImpl &&
            (identical(other.setNumber, setNumber) ||
                other.setNumber == setNumber) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.actualReps, actualReps) ||
                other.actualReps == actualReps) &&
            (identical(other.plannedReps, plannedReps) ||
                other.plannedReps == plannedReps) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.durationSeconds, durationSeconds) ||
                other.durationSeconds == durationSeconds) &&
            (identical(other.restDurationSeconds, restDurationSeconds) ||
                other.restDurationSeconds == restDurationSeconds) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    setNumber,
    status,
    startedAt,
    completedAt,
    actualReps,
    plannedReps,
    weight,
    durationSeconds,
    restDurationSeconds,
    notes,
  );

  /// Create a copy of SetExecution
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SetExecutionImplCopyWith<_$SetExecutionImpl> get copyWith =>
      __$$SetExecutionImplCopyWithImpl<_$SetExecutionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SetExecutionImplToJson(this);
  }
}

abstract class _SetExecution implements SetExecution {
  const factory _SetExecution({
    required final int setNumber,
    required final SetStatus status,
    required final DateTime startedAt,
    final DateTime? completedAt,
    final int? actualReps,
    final int? plannedReps,
    final double? weight,
    final int? durationSeconds,
    final int? restDurationSeconds,
    final String? notes,
  }) = _$SetExecutionImpl;

  factory _SetExecution.fromJson(Map<String, dynamic> json) =
      _$SetExecutionImpl.fromJson;

  @override
  int get setNumber;
  @override
  SetStatus get status;
  @override
  DateTime get startedAt;
  @override
  DateTime? get completedAt;
  @override
  int? get actualReps;
  @override
  int? get plannedReps;
  @override
  double? get weight;
  @override
  int? get durationSeconds;
  @override
  int? get restDurationSeconds;
  @override
  String? get notes;

  /// Create a copy of SetExecution
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SetExecutionImplCopyWith<_$SetExecutionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
