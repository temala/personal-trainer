// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Exercise _$ExerciseFromJson(Map<String, dynamic> json) {
  return _Exercise.fromJson(json);
}

/// @nodoc
mixin _$Exercise {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  ExerciseCategory get category => throw _privateConstructorUsedError;
  DifficultyLevel get difficulty => throw _privateConstructorUsedError;
  List<MuscleGroup> get targetMuscles => throw _privateConstructorUsedError;
  List<String> get equipment => throw _privateConstructorUsedError;
  int get estimatedDurationSeconds => throw _privateConstructorUsedError;
  List<String> get instructions => throw _privateConstructorUsedError;
  List<String> get tips => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;
  String? get animationUrl => throw _privateConstructorUsedError;
  String? get thumbnailUrl => throw _privateConstructorUsedError;
  List<String>? get alternativeExerciseIds =>
      throw _privateConstructorUsedError;
  Map<String, dynamic>? get customData => throw _privateConstructorUsedError;
  bool? get isActive => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Exercise to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Exercise
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExerciseCopyWith<Exercise> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExerciseCopyWith<$Res> {
  factory $ExerciseCopyWith(Exercise value, $Res Function(Exercise) then) =
      _$ExerciseCopyWithImpl<$Res, Exercise>;
  @useResult
  $Res call({
    String id,
    String name,
    String description,
    ExerciseCategory category,
    DifficultyLevel difficulty,
    List<MuscleGroup> targetMuscles,
    List<String> equipment,
    int estimatedDurationSeconds,
    List<String> instructions,
    List<String> tips,
    Map<String, dynamic> metadata,
    String? animationUrl,
    String? thumbnailUrl,
    List<String>? alternativeExerciseIds,
    Map<String, dynamic>? customData,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$ExerciseCopyWithImpl<$Res, $Val extends Exercise>
    implements $ExerciseCopyWith<$Res> {
  _$ExerciseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Exercise
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? category = null,
    Object? difficulty = null,
    Object? targetMuscles = null,
    Object? equipment = null,
    Object? estimatedDurationSeconds = null,
    Object? instructions = null,
    Object? tips = null,
    Object? metadata = null,
    Object? animationUrl = freezed,
    Object? thumbnailUrl = freezed,
    Object? alternativeExerciseIds = freezed,
    Object? customData = freezed,
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
            category:
                null == category
                    ? _value.category
                    : category // ignore: cast_nullable_to_non_nullable
                        as ExerciseCategory,
            difficulty:
                null == difficulty
                    ? _value.difficulty
                    : difficulty // ignore: cast_nullable_to_non_nullable
                        as DifficultyLevel,
            targetMuscles:
                null == targetMuscles
                    ? _value.targetMuscles
                    : targetMuscles // ignore: cast_nullable_to_non_nullable
                        as List<MuscleGroup>,
            equipment:
                null == equipment
                    ? _value.equipment
                    : equipment // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            estimatedDurationSeconds:
                null == estimatedDurationSeconds
                    ? _value.estimatedDurationSeconds
                    : estimatedDurationSeconds // ignore: cast_nullable_to_non_nullable
                        as int,
            instructions:
                null == instructions
                    ? _value.instructions
                    : instructions // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            tips:
                null == tips
                    ? _value.tips
                    : tips // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            metadata:
                null == metadata
                    ? _value.metadata
                    : metadata // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>,
            animationUrl:
                freezed == animationUrl
                    ? _value.animationUrl
                    : animationUrl // ignore: cast_nullable_to_non_nullable
                        as String?,
            thumbnailUrl:
                freezed == thumbnailUrl
                    ? _value.thumbnailUrl
                    : thumbnailUrl // ignore: cast_nullable_to_non_nullable
                        as String?,
            alternativeExerciseIds:
                freezed == alternativeExerciseIds
                    ? _value.alternativeExerciseIds
                    : alternativeExerciseIds // ignore: cast_nullable_to_non_nullable
                        as List<String>?,
            customData:
                freezed == customData
                    ? _value.customData
                    : customData // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>?,
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
abstract class _$$ExerciseImplCopyWith<$Res>
    implements $ExerciseCopyWith<$Res> {
  factory _$$ExerciseImplCopyWith(
    _$ExerciseImpl value,
    $Res Function(_$ExerciseImpl) then,
  ) = __$$ExerciseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String description,
    ExerciseCategory category,
    DifficultyLevel difficulty,
    List<MuscleGroup> targetMuscles,
    List<String> equipment,
    int estimatedDurationSeconds,
    List<String> instructions,
    List<String> tips,
    Map<String, dynamic> metadata,
    String? animationUrl,
    String? thumbnailUrl,
    List<String>? alternativeExerciseIds,
    Map<String, dynamic>? customData,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$ExerciseImplCopyWithImpl<$Res>
    extends _$ExerciseCopyWithImpl<$Res, _$ExerciseImpl>
    implements _$$ExerciseImplCopyWith<$Res> {
  __$$ExerciseImplCopyWithImpl(
    _$ExerciseImpl _value,
    $Res Function(_$ExerciseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Exercise
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? category = null,
    Object? difficulty = null,
    Object? targetMuscles = null,
    Object? equipment = null,
    Object? estimatedDurationSeconds = null,
    Object? instructions = null,
    Object? tips = null,
    Object? metadata = null,
    Object? animationUrl = freezed,
    Object? thumbnailUrl = freezed,
    Object? alternativeExerciseIds = freezed,
    Object? customData = freezed,
    Object? isActive = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$ExerciseImpl(
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
        category:
            null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                    as ExerciseCategory,
        difficulty:
            null == difficulty
                ? _value.difficulty
                : difficulty // ignore: cast_nullable_to_non_nullable
                    as DifficultyLevel,
        targetMuscles:
            null == targetMuscles
                ? _value._targetMuscles
                : targetMuscles // ignore: cast_nullable_to_non_nullable
                    as List<MuscleGroup>,
        equipment:
            null == equipment
                ? _value._equipment
                : equipment // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        estimatedDurationSeconds:
            null == estimatedDurationSeconds
                ? _value.estimatedDurationSeconds
                : estimatedDurationSeconds // ignore: cast_nullable_to_non_nullable
                    as int,
        instructions:
            null == instructions
                ? _value._instructions
                : instructions // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        tips:
            null == tips
                ? _value._tips
                : tips // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        metadata:
            null == metadata
                ? _value._metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>,
        animationUrl:
            freezed == animationUrl
                ? _value.animationUrl
                : animationUrl // ignore: cast_nullable_to_non_nullable
                    as String?,
        thumbnailUrl:
            freezed == thumbnailUrl
                ? _value.thumbnailUrl
                : thumbnailUrl // ignore: cast_nullable_to_non_nullable
                    as String?,
        alternativeExerciseIds:
            freezed == alternativeExerciseIds
                ? _value._alternativeExerciseIds
                : alternativeExerciseIds // ignore: cast_nullable_to_non_nullable
                    as List<String>?,
        customData:
            freezed == customData
                ? _value._customData
                : customData // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>?,
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
class _$ExerciseImpl implements _Exercise {
  const _$ExerciseImpl({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.difficulty,
    required final List<MuscleGroup> targetMuscles,
    required final List<String> equipment,
    required this.estimatedDurationSeconds,
    required final List<String> instructions,
    required final List<String> tips,
    required final Map<String, dynamic> metadata,
    this.animationUrl,
    this.thumbnailUrl,
    final List<String>? alternativeExerciseIds,
    final Map<String, dynamic>? customData,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  }) : _targetMuscles = targetMuscles,
       _equipment = equipment,
       _instructions = instructions,
       _tips = tips,
       _metadata = metadata,
       _alternativeExerciseIds = alternativeExerciseIds,
       _customData = customData;

  factory _$ExerciseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExerciseImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  final ExerciseCategory category;
  @override
  final DifficultyLevel difficulty;
  final List<MuscleGroup> _targetMuscles;
  @override
  List<MuscleGroup> get targetMuscles {
    if (_targetMuscles is EqualUnmodifiableListView) return _targetMuscles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_targetMuscles);
  }

  final List<String> _equipment;
  @override
  List<String> get equipment {
    if (_equipment is EqualUnmodifiableListView) return _equipment;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_equipment);
  }

  @override
  final int estimatedDurationSeconds;
  final List<String> _instructions;
  @override
  List<String> get instructions {
    if (_instructions is EqualUnmodifiableListView) return _instructions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_instructions);
  }

  final List<String> _tips;
  @override
  List<String> get tips {
    if (_tips is EqualUnmodifiableListView) return _tips;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tips);
  }

  final Map<String, dynamic> _metadata;
  @override
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  final String? animationUrl;
  @override
  final String? thumbnailUrl;
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

  final Map<String, dynamic>? _customData;
  @override
  Map<String, dynamic>? get customData {
    final value = _customData;
    if (value == null) return null;
    if (_customData is EqualUnmodifiableMapView) return _customData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final bool? isActive;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Exercise(id: $id, name: $name, description: $description, category: $category, difficulty: $difficulty, targetMuscles: $targetMuscles, equipment: $equipment, estimatedDurationSeconds: $estimatedDurationSeconds, instructions: $instructions, tips: $tips, metadata: $metadata, animationUrl: $animationUrl, thumbnailUrl: $thumbnailUrl, alternativeExerciseIds: $alternativeExerciseIds, customData: $customData, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExerciseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            const DeepCollectionEquality().equals(
              other._targetMuscles,
              _targetMuscles,
            ) &&
            const DeepCollectionEquality().equals(
              other._equipment,
              _equipment,
            ) &&
            (identical(
                  other.estimatedDurationSeconds,
                  estimatedDurationSeconds,
                ) ||
                other.estimatedDurationSeconds == estimatedDurationSeconds) &&
            const DeepCollectionEquality().equals(
              other._instructions,
              _instructions,
            ) &&
            const DeepCollectionEquality().equals(other._tips, _tips) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.animationUrl, animationUrl) ||
                other.animationUrl == animationUrl) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            const DeepCollectionEquality().equals(
              other._alternativeExerciseIds,
              _alternativeExerciseIds,
            ) &&
            const DeepCollectionEquality().equals(
              other._customData,
              _customData,
            ) &&
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
    category,
    difficulty,
    const DeepCollectionEquality().hash(_targetMuscles),
    const DeepCollectionEquality().hash(_equipment),
    estimatedDurationSeconds,
    const DeepCollectionEquality().hash(_instructions),
    const DeepCollectionEquality().hash(_tips),
    const DeepCollectionEquality().hash(_metadata),
    animationUrl,
    thumbnailUrl,
    const DeepCollectionEquality().hash(_alternativeExerciseIds),
    const DeepCollectionEquality().hash(_customData),
    isActive,
    createdAt,
    updatedAt,
  );

  /// Create a copy of Exercise
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExerciseImplCopyWith<_$ExerciseImpl> get copyWith =>
      __$$ExerciseImplCopyWithImpl<_$ExerciseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExerciseImplToJson(this);
  }
}

abstract class _Exercise implements Exercise {
  const factory _Exercise({
    required final String id,
    required final String name,
    required final String description,
    required final ExerciseCategory category,
    required final DifficultyLevel difficulty,
    required final List<MuscleGroup> targetMuscles,
    required final List<String> equipment,
    required final int estimatedDurationSeconds,
    required final List<String> instructions,
    required final List<String> tips,
    required final Map<String, dynamic> metadata,
    final String? animationUrl,
    final String? thumbnailUrl,
    final List<String>? alternativeExerciseIds,
    final Map<String, dynamic>? customData,
    final bool? isActive,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$ExerciseImpl;

  factory _Exercise.fromJson(Map<String, dynamic> json) =
      _$ExerciseImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  ExerciseCategory get category;
  @override
  DifficultyLevel get difficulty;
  @override
  List<MuscleGroup> get targetMuscles;
  @override
  List<String> get equipment;
  @override
  int get estimatedDurationSeconds;
  @override
  List<String> get instructions;
  @override
  List<String> get tips;
  @override
  Map<String, dynamic> get metadata;
  @override
  String? get animationUrl;
  @override
  String? get thumbnailUrl;
  @override
  List<String>? get alternativeExerciseIds;
  @override
  Map<String, dynamic>? get customData;
  @override
  bool? get isActive;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of Exercise
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExerciseImplCopyWith<_$ExerciseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
