// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout_plan.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

WorkoutPlan _$WorkoutPlanFromJson(Map<String, dynamic> json) {
  return _WorkoutPlan.fromJson(json);
}

/// @nodoc
mixin _$WorkoutPlan {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<WorkoutExercise> get exercises => throw _privateConstructorUsedError;
  WorkoutType get type => throw _privateConstructorUsedError;
  DifficultyLevel get difficulty => throw _privateConstructorUsedError;
  int get estimatedDurationMinutes => throw _privateConstructorUsedError;
  List<String> get targetMuscleGroups => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;
  String? get userId => throw _privateConstructorUsedError;
  String? get aiGeneratedBy => throw _privateConstructorUsedError;
  Map<String, dynamic>? get aiGenerationContext =>
      throw _privateConstructorUsedError;
  bool? get isTemplate => throw _privateConstructorUsedError;
  bool? get isActive => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this WorkoutPlan to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkoutPlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkoutPlanCopyWith<WorkoutPlan> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkoutPlanCopyWith<$Res> {
  factory $WorkoutPlanCopyWith(
    WorkoutPlan value,
    $Res Function(WorkoutPlan) then,
  ) = _$WorkoutPlanCopyWithImpl<$Res, WorkoutPlan>;
  @useResult
  $Res call({
    String id,
    String name,
    String description,
    List<WorkoutExercise> exercises,
    WorkoutType type,
    DifficultyLevel difficulty,
    int estimatedDurationMinutes,
    List<String> targetMuscleGroups,
    Map<String, dynamic> metadata,
    String? userId,
    String? aiGeneratedBy,
    Map<String, dynamic>? aiGenerationContext,
    bool? isTemplate,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$WorkoutPlanCopyWithImpl<$Res, $Val extends WorkoutPlan>
    implements $WorkoutPlanCopyWith<$Res> {
  _$WorkoutPlanCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkoutPlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? exercises = null,
    Object? type = null,
    Object? difficulty = null,
    Object? estimatedDurationMinutes = null,
    Object? targetMuscleGroups = null,
    Object? metadata = null,
    Object? userId = freezed,
    Object? aiGeneratedBy = freezed,
    Object? aiGenerationContext = freezed,
    Object? isTemplate = freezed,
    Object? isActive = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
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
            exercises:
                null == exercises
                    ? _value.exercises
                    : exercises // ignore: cast_nullable_to_non_nullable
                        as List<WorkoutExercise>,
            type:
                null == type
                    ? _value.type
                    : type // ignore: cast_nullable_to_non_nullable
                        as WorkoutType,
            difficulty:
                null == difficulty
                    ? _value.difficulty
                    : difficulty // ignore: cast_nullable_to_non_nullable
                        as DifficultyLevel,
            estimatedDurationMinutes:
                null == estimatedDurationMinutes
                    ? _value.estimatedDurationMinutes
                    : estimatedDurationMinutes // ignore: cast_nullable_to_non_nullable
                        as int,
            targetMuscleGroups:
                null == targetMuscleGroups
                    ? _value.targetMuscleGroups
                    : targetMuscleGroups // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            metadata:
                null == metadata
                    ? _value.metadata
                    : metadata // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>,
            userId:
                freezed == userId
                    ? _value.userId
                    : userId // ignore: cast_nullable_to_non_nullable
                        as String?,
            aiGeneratedBy:
                freezed == aiGeneratedBy
                    ? _value.aiGeneratedBy
                    : aiGeneratedBy // ignore: cast_nullable_to_non_nullable
                        as String?,
            aiGenerationContext:
                freezed == aiGenerationContext
                    ? _value.aiGenerationContext
                    : aiGenerationContext // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>?,
            isTemplate:
                freezed == isTemplate
                    ? _value.isTemplate
                    : isTemplate // ignore: cast_nullable_to_non_nullable
                        as bool?,
            isActive:
                freezed == isActive
                    ? _value.isActive
                    : isActive // ignore: cast_nullable_to_non_nullable
                        as bool?,
            createdAt:
                freezed == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            updatedAt:
                freezed == updatedAt
                    ? _value.updatedAt
                    : updatedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WorkoutPlanImplCopyWith<$Res>
    implements $WorkoutPlanCopyWith<$Res> {
  factory _$$WorkoutPlanImplCopyWith(
    _$WorkoutPlanImpl value,
    $Res Function(_$WorkoutPlanImpl) then,
  ) = __$$WorkoutPlanImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String description,
    List<WorkoutExercise> exercises,
    WorkoutType type,
    DifficultyLevel difficulty,
    int estimatedDurationMinutes,
    List<String> targetMuscleGroups,
    Map<String, dynamic> metadata,
    String? userId,
    String? aiGeneratedBy,
    Map<String, dynamic>? aiGenerationContext,
    bool? isTemplate,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$WorkoutPlanImplCopyWithImpl<$Res>
    extends _$WorkoutPlanCopyWithImpl<$Res, _$WorkoutPlanImpl>
    implements _$$WorkoutPlanImplCopyWith<$Res> {
  __$$WorkoutPlanImplCopyWithImpl(
    _$WorkoutPlanImpl _value,
    $Res Function(_$WorkoutPlanImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WorkoutPlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? exercises = null,
    Object? type = null,
    Object? difficulty = null,
    Object? estimatedDurationMinutes = null,
    Object? targetMuscleGroups = null,
    Object? metadata = null,
    Object? userId = freezed,
    Object? aiGeneratedBy = freezed,
    Object? aiGenerationContext = freezed,
    Object? isTemplate = freezed,
    Object? isActive = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$WorkoutPlanImpl(
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
        exercises:
            null == exercises
                ? _value._exercises
                : exercises // ignore: cast_nullable_to_non_nullable
                    as List<WorkoutExercise>,
        type:
            null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                    as WorkoutType,
        difficulty:
            null == difficulty
                ? _value.difficulty
                : difficulty // ignore: cast_nullable_to_non_nullable
                    as DifficultyLevel,
        estimatedDurationMinutes:
            null == estimatedDurationMinutes
                ? _value.estimatedDurationMinutes
                : estimatedDurationMinutes // ignore: cast_nullable_to_non_nullable
                    as int,
        targetMuscleGroups:
            null == targetMuscleGroups
                ? _value._targetMuscleGroups
                : targetMuscleGroups // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        metadata:
            null == metadata
                ? _value._metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>,
        userId:
            freezed == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                    as String?,
        aiGeneratedBy:
            freezed == aiGeneratedBy
                ? _value.aiGeneratedBy
                : aiGeneratedBy // ignore: cast_nullable_to_non_nullable
                    as String?,
        aiGenerationContext:
            freezed == aiGenerationContext
                ? _value._aiGenerationContext
                : aiGenerationContext // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>?,
        isTemplate:
            freezed == isTemplate
                ? _value.isTemplate
                : isTemplate // ignore: cast_nullable_to_non_nullable
                    as bool?,
        isActive:
            freezed == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                    as bool?,
        createdAt:
            freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        updatedAt:
            freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkoutPlanImpl implements _WorkoutPlan {
  const _$WorkoutPlanImpl({
    required this.id,
    required this.name,
    required this.description,
    required final List<WorkoutExercise> exercises,
    required this.type,
    required this.difficulty,
    required this.estimatedDurationMinutes,
    required final List<String> targetMuscleGroups,
    required final Map<String, dynamic> metadata,
    this.userId,
    this.aiGeneratedBy,
    final Map<String, dynamic>? aiGenerationContext,
    this.isTemplate,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  }) : _exercises = exercises,
       _targetMuscleGroups = targetMuscleGroups,
       _metadata = metadata,
       _aiGenerationContext = aiGenerationContext;

  factory _$WorkoutPlanImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkoutPlanImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  final List<WorkoutExercise> _exercises;
  @override
  List<WorkoutExercise> get exercises {
    if (_exercises is EqualUnmodifiableListView) return _exercises;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_exercises);
  }

  @override
  final WorkoutType type;
  @override
  final DifficultyLevel difficulty;
  @override
  final int estimatedDurationMinutes;
  final List<String> _targetMuscleGroups;
  @override
  List<String> get targetMuscleGroups {
    if (_targetMuscleGroups is EqualUnmodifiableListView)
      return _targetMuscleGroups;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_targetMuscleGroups);
  }

  final Map<String, dynamic> _metadata;
  @override
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  final String? userId;
  @override
  final String? aiGeneratedBy;
  final Map<String, dynamic>? _aiGenerationContext;
  @override
  Map<String, dynamic>? get aiGenerationContext {
    final value = _aiGenerationContext;
    if (value == null) return null;
    if (_aiGenerationContext is EqualUnmodifiableMapView)
      return _aiGenerationContext;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final bool? isTemplate;
  @override
  final bool? isActive;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'WorkoutPlan(id: $id, name: $name, description: $description, exercises: $exercises, type: $type, difficulty: $difficulty, estimatedDurationMinutes: $estimatedDurationMinutes, targetMuscleGroups: $targetMuscleGroups, metadata: $metadata, userId: $userId, aiGeneratedBy: $aiGeneratedBy, aiGenerationContext: $aiGenerationContext, isTemplate: $isTemplate, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkoutPlanImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(
              other._exercises,
              _exercises,
            ) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            (identical(
                  other.estimatedDurationMinutes,
                  estimatedDurationMinutes,
                ) ||
                other.estimatedDurationMinutes == estimatedDurationMinutes) &&
            const DeepCollectionEquality().equals(
              other._targetMuscleGroups,
              _targetMuscleGroups,
            ) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.aiGeneratedBy, aiGeneratedBy) ||
                other.aiGeneratedBy == aiGeneratedBy) &&
            const DeepCollectionEquality().equals(
              other._aiGenerationContext,
              _aiGenerationContext,
            ) &&
            (identical(other.isTemplate, isTemplate) ||
                other.isTemplate == isTemplate) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    description,
    const DeepCollectionEquality().hash(_exercises),
    type,
    difficulty,
    estimatedDurationMinutes,
    const DeepCollectionEquality().hash(_targetMuscleGroups),
    const DeepCollectionEquality().hash(_metadata),
    userId,
    aiGeneratedBy,
    const DeepCollectionEquality().hash(_aiGenerationContext),
    isTemplate,
    isActive,
    createdAt,
    updatedAt,
  );

  /// Create a copy of WorkoutPlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkoutPlanImplCopyWith<_$WorkoutPlanImpl> get copyWith =>
      __$$WorkoutPlanImplCopyWithImpl<_$WorkoutPlanImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkoutPlanImplToJson(this);
  }
}

abstract class _WorkoutPlan implements WorkoutPlan {
  const factory _WorkoutPlan({
    required final String id,
    required final String name,
    required final String description,
    required final List<WorkoutExercise> exercises,
    required final WorkoutType type,
    required final DifficultyLevel difficulty,
    required final int estimatedDurationMinutes,
    required final List<String> targetMuscleGroups,
    required final Map<String, dynamic> metadata,
    final String? userId,
    final String? aiGeneratedBy,
    final Map<String, dynamic>? aiGenerationContext,
    final bool? isTemplate,
    final bool? isActive,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$WorkoutPlanImpl;

  factory _WorkoutPlan.fromJson(Map<String, dynamic> json) =
      _$WorkoutPlanImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  List<WorkoutExercise> get exercises;
  @override
  WorkoutType get type;
  @override
  DifficultyLevel get difficulty;
  @override
  int get estimatedDurationMinutes;
  @override
  List<String> get targetMuscleGroups;
  @override
  Map<String, dynamic> get metadata;
  @override
  String? get userId;
  @override
  String? get aiGeneratedBy;
  @override
  Map<String, dynamic>? get aiGenerationContext;
  @override
  bool? get isTemplate;
  @override
  bool? get isActive;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of WorkoutPlan
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkoutPlanImplCopyWith<_$WorkoutPlanImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WorkoutExercise _$WorkoutExerciseFromJson(Map<String, dynamic> json) {
  return _WorkoutExercise.fromJson(json);
}

/// @nodoc
mixin _$WorkoutExercise {
  String get exerciseId => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;
  int get sets => throw _privateConstructorUsedError;
  int get repsPerSet => throw _privateConstructorUsedError;
  int get restBetweenSetsSeconds => throw _privateConstructorUsedError;
  String? get exerciseName =>
      throw _privateConstructorUsedError; // Cached for offline use
  String? get exerciseDescription =>
      throw _privateConstructorUsedError; // Cached for offline use
  Map<String, dynamic>? get exerciseMetadata =>
      throw _privateConstructorUsedError;
  Map<String, dynamic>? get customInstructions =>
      throw _privateConstructorUsedError;
  List<String>? get alternativeExerciseIds =>
      throw _privateConstructorUsedError;

  /// Serializes this WorkoutExercise to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkoutExercise
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkoutExerciseCopyWith<WorkoutExercise> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkoutExerciseCopyWith<$Res> {
  factory $WorkoutExerciseCopyWith(
    WorkoutExercise value,
    $Res Function(WorkoutExercise) then,
  ) = _$WorkoutExerciseCopyWithImpl<$Res, WorkoutExercise>;
  @useResult
  $Res call({
    String exerciseId,
    int order,
    int sets,
    int repsPerSet,
    int restBetweenSetsSeconds,
    String? exerciseName,
    String? exerciseDescription,
    Map<String, dynamic>? exerciseMetadata,
    Map<String, dynamic>? customInstructions,
    List<String>? alternativeExerciseIds,
  });
}

/// @nodoc
class _$WorkoutExerciseCopyWithImpl<$Res, $Val extends WorkoutExercise>
    implements $WorkoutExerciseCopyWith<$Res> {
  _$WorkoutExerciseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkoutExercise
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? exerciseId = null,
    Object? order = null,
    Object? sets = null,
    Object? repsPerSet = null,
    Object? restBetweenSetsSeconds = null,
    Object? exerciseName = freezed,
    Object? exerciseDescription = freezed,
    Object? exerciseMetadata = freezed,
    Object? customInstructions = freezed,
    Object? alternativeExerciseIds = freezed,
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
            sets:
                null == sets
                    ? _value.sets
                    : sets // ignore: cast_nullable_to_non_nullable
                        as int,
            repsPerSet:
                null == repsPerSet
                    ? _value.repsPerSet
                    : repsPerSet // ignore: cast_nullable_to_non_nullable
                        as int,
            restBetweenSetsSeconds:
                null == restBetweenSetsSeconds
                    ? _value.restBetweenSetsSeconds
                    : restBetweenSetsSeconds // ignore: cast_nullable_to_non_nullable
                        as int,
            exerciseName:
                freezed == exerciseName
                    ? _value.exerciseName
                    : exerciseName // ignore: cast_nullable_to_non_nullable
                        as String?,
            exerciseDescription:
                freezed == exerciseDescription
                    ? _value.exerciseDescription
                    : exerciseDescription // ignore: cast_nullable_to_non_nullable
                        as String?,
            exerciseMetadata:
                freezed == exerciseMetadata
                    ? _value.exerciseMetadata
                    : exerciseMetadata // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>?,
            customInstructions:
                freezed == customInstructions
                    ? _value.customInstructions
                    : customInstructions // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>?,
            alternativeExerciseIds:
                freezed == alternativeExerciseIds
                    ? _value.alternativeExerciseIds
                    : alternativeExerciseIds // ignore: cast_nullable_to_non_nullable
                        as List<String>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WorkoutExerciseImplCopyWith<$Res>
    implements $WorkoutExerciseCopyWith<$Res> {
  factory _$$WorkoutExerciseImplCopyWith(
    _$WorkoutExerciseImpl value,
    $Res Function(_$WorkoutExerciseImpl) then,
  ) = __$$WorkoutExerciseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String exerciseId,
    int order,
    int sets,
    int repsPerSet,
    int restBetweenSetsSeconds,
    String? exerciseName,
    String? exerciseDescription,
    Map<String, dynamic>? exerciseMetadata,
    Map<String, dynamic>? customInstructions,
    List<String>? alternativeExerciseIds,
  });
}

/// @nodoc
class __$$WorkoutExerciseImplCopyWithImpl<$Res>
    extends _$WorkoutExerciseCopyWithImpl<$Res, _$WorkoutExerciseImpl>
    implements _$$WorkoutExerciseImplCopyWith<$Res> {
  __$$WorkoutExerciseImplCopyWithImpl(
    _$WorkoutExerciseImpl _value,
    $Res Function(_$WorkoutExerciseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WorkoutExercise
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? exerciseId = null,
    Object? order = null,
    Object? sets = null,
    Object? repsPerSet = null,
    Object? restBetweenSetsSeconds = null,
    Object? exerciseName = freezed,
    Object? exerciseDescription = freezed,
    Object? exerciseMetadata = freezed,
    Object? customInstructions = freezed,
    Object? alternativeExerciseIds = freezed,
  }) {
    return _then(
      _$WorkoutExerciseImpl(
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
        sets:
            null == sets
                ? _value.sets
                : sets // ignore: cast_nullable_to_non_nullable
                    as int,
        repsPerSet:
            null == repsPerSet
                ? _value.repsPerSet
                : repsPerSet // ignore: cast_nullable_to_non_nullable
                    as int,
        restBetweenSetsSeconds:
            null == restBetweenSetsSeconds
                ? _value.restBetweenSetsSeconds
                : restBetweenSetsSeconds // ignore: cast_nullable_to_non_nullable
                    as int,
        exerciseName:
            freezed == exerciseName
                ? _value.exerciseName
                : exerciseName // ignore: cast_nullable_to_non_nullable
                    as String?,
        exerciseDescription:
            freezed == exerciseDescription
                ? _value.exerciseDescription
                : exerciseDescription // ignore: cast_nullable_to_non_nullable
                    as String?,
        exerciseMetadata:
            freezed == exerciseMetadata
                ? _value._exerciseMetadata
                : exerciseMetadata // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>?,
        customInstructions:
            freezed == customInstructions
                ? _value._customInstructions
                : customInstructions // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>?,
        alternativeExerciseIds:
            freezed == alternativeExerciseIds
                ? _value._alternativeExerciseIds
                : alternativeExerciseIds // ignore: cast_nullable_to_non_nullable
                    as List<String>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkoutExerciseImpl implements _WorkoutExercise {
  const _$WorkoutExerciseImpl({
    required this.exerciseId,
    required this.order,
    required this.sets,
    required this.repsPerSet,
    required this.restBetweenSetsSeconds,
    this.exerciseName,
    this.exerciseDescription,
    final Map<String, dynamic>? exerciseMetadata,
    final Map<String, dynamic>? customInstructions,
    final List<String>? alternativeExerciseIds,
  }) : _exerciseMetadata = exerciseMetadata,
       _customInstructions = customInstructions,
       _alternativeExerciseIds = alternativeExerciseIds;

  factory _$WorkoutExerciseImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkoutExerciseImplFromJson(json);

  @override
  final String exerciseId;
  @override
  final int order;
  @override
  final int sets;
  @override
  final int repsPerSet;
  @override
  final int restBetweenSetsSeconds;
  @override
  final String? exerciseName;
  // Cached for offline use
  @override
  final String? exerciseDescription;
  // Cached for offline use
  final Map<String, dynamic>? _exerciseMetadata;
  // Cached for offline use
  @override
  Map<String, dynamic>? get exerciseMetadata {
    final value = _exerciseMetadata;
    if (value == null) return null;
    if (_exerciseMetadata is EqualUnmodifiableMapView) return _exerciseMetadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _customInstructions;
  @override
  Map<String, dynamic>? get customInstructions {
    final value = _customInstructions;
    if (value == null) return null;
    if (_customInstructions is EqualUnmodifiableMapView)
      return _customInstructions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final List<String>? _alternativeExerciseIds;
  @override
  List<String>? get alternativeExerciseIds {
    final value = _alternativeExerciseIds;
    if (value == null) return null;
    if (_alternativeExerciseIds is EqualUnmodifiableListView)
      return _alternativeExerciseIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'WorkoutExercise(exerciseId: $exerciseId, order: $order, sets: $sets, repsPerSet: $repsPerSet, restBetweenSetsSeconds: $restBetweenSetsSeconds, exerciseName: $exerciseName, exerciseDescription: $exerciseDescription, exerciseMetadata: $exerciseMetadata, customInstructions: $customInstructions, alternativeExerciseIds: $alternativeExerciseIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkoutExerciseImpl &&
            (identical(other.exerciseId, exerciseId) ||
                other.exerciseId == exerciseId) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.sets, sets) || other.sets == sets) &&
            (identical(other.repsPerSet, repsPerSet) ||
                other.repsPerSet == repsPerSet) &&
            (identical(other.restBetweenSetsSeconds, restBetweenSetsSeconds) ||
                other.restBetweenSetsSeconds == restBetweenSetsSeconds) &&
            (identical(other.exerciseName, exerciseName) ||
                other.exerciseName == exerciseName) &&
            (identical(other.exerciseDescription, exerciseDescription) ||
                other.exerciseDescription == exerciseDescription) &&
            const DeepCollectionEquality().equals(
              other._exerciseMetadata,
              _exerciseMetadata,
            ) &&
            const DeepCollectionEquality().equals(
              other._customInstructions,
              _customInstructions,
            ) &&
            const DeepCollectionEquality().equals(
              other._alternativeExerciseIds,
              _alternativeExerciseIds,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    exerciseId,
    order,
    sets,
    repsPerSet,
    restBetweenSetsSeconds,
    exerciseName,
    exerciseDescription,
    const DeepCollectionEquality().hash(_exerciseMetadata),
    const DeepCollectionEquality().hash(_customInstructions),
    const DeepCollectionEquality().hash(_alternativeExerciseIds),
  );

  /// Create a copy of WorkoutExercise
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkoutExerciseImplCopyWith<_$WorkoutExerciseImpl> get copyWith =>
      __$$WorkoutExerciseImplCopyWithImpl<_$WorkoutExerciseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkoutExerciseImplToJson(this);
  }
}

abstract class _WorkoutExercise implements WorkoutExercise {
  const factory _WorkoutExercise({
    required final String exerciseId,
    required final int order,
    required final int sets,
    required final int repsPerSet,
    required final int restBetweenSetsSeconds,
    final String? exerciseName,
    final String? exerciseDescription,
    final Map<String, dynamic>? exerciseMetadata,
    final Map<String, dynamic>? customInstructions,
    final List<String>? alternativeExerciseIds,
  }) = _$WorkoutExerciseImpl;

  factory _WorkoutExercise.fromJson(Map<String, dynamic> json) =
      _$WorkoutExerciseImpl.fromJson;

  @override
  String get exerciseId;
  @override
  int get order;
  @override
  int get sets;
  @override
  int get repsPerSet;
  @override
  int get restBetweenSetsSeconds;
  @override
  String? get exerciseName; // Cached for offline use
  @override
  String? get exerciseDescription; // Cached for offline use
  @override
  Map<String, dynamic>? get exerciseMetadata;
  @override
  Map<String, dynamic>? get customInstructions;
  @override
  List<String>? get alternativeExerciseIds;

  /// Create a copy of WorkoutExercise
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkoutExerciseImplCopyWith<_$WorkoutExerciseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
