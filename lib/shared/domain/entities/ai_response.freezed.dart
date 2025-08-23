// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AIResponse _$AIResponseFromJson(Map<String, dynamic> json) {
  return _AIResponse.fromJson(json);
}

/// @nodoc
mixin _$AIResponse {
  String get requestId => throw _privateConstructorUsedError;
  bool get success => throw _privateConstructorUsedError;
  Map<String, dynamic> get data => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  String get providerId => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  String? get errorCode => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this AIResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AIResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AIResponseCopyWith<AIResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AIResponseCopyWith<$Res> {
  factory $AIResponseCopyWith(
    AIResponse value,
    $Res Function(AIResponse) then,
  ) = _$AIResponseCopyWithImpl<$Res, AIResponse>;
  @useResult
  $Res call({
    String requestId,
    bool success,
    Map<String, dynamic> data,
    DateTime timestamp,
    String providerId,
    String? error,
    String? errorCode,
    Map<String, dynamic>? metadata,
  });
}

/// @nodoc
class _$AIResponseCopyWithImpl<$Res, $Val extends AIResponse>
    implements $AIResponseCopyWith<$Res> {
  _$AIResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AIResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requestId = null,
    Object? success = null,
    Object? data = null,
    Object? timestamp = null,
    Object? providerId = null,
    Object? error = freezed,
    Object? errorCode = freezed,
    Object? metadata = freezed,
  }) {
    return _then(
      _value.copyWith(
            requestId:
                null == requestId
                    ? _value.requestId
                    : requestId // ignore: cast_nullable_to_non_nullable
                        as String,
            success:
                null == success
                    ? _value.success
                    : success // ignore: cast_nullable_to_non_nullable
                        as bool,
            data:
                null == data
                    ? _value.data
                    : data // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>,
            timestamp:
                null == timestamp
                    ? _value.timestamp
                    : timestamp // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            providerId:
                null == providerId
                    ? _value.providerId
                    : providerId // ignore: cast_nullable_to_non_nullable
                        as String,
            error:
                freezed == error
                    ? _value.error
                    : error // ignore: cast_nullable_to_non_nullable
                        as String?,
            errorCode:
                freezed == errorCode
                    ? _value.errorCode
                    : errorCode // ignore: cast_nullable_to_non_nullable
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
abstract class _$$AIResponseImplCopyWith<$Res>
    implements $AIResponseCopyWith<$Res> {
  factory _$$AIResponseImplCopyWith(
    _$AIResponseImpl value,
    $Res Function(_$AIResponseImpl) then,
  ) = __$$AIResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String requestId,
    bool success,
    Map<String, dynamic> data,
    DateTime timestamp,
    String providerId,
    String? error,
    String? errorCode,
    Map<String, dynamic>? metadata,
  });
}

/// @nodoc
class __$$AIResponseImplCopyWithImpl<$Res>
    extends _$AIResponseCopyWithImpl<$Res, _$AIResponseImpl>
    implements _$$AIResponseImplCopyWith<$Res> {
  __$$AIResponseImplCopyWithImpl(
    _$AIResponseImpl _value,
    $Res Function(_$AIResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AIResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requestId = null,
    Object? success = null,
    Object? data = null,
    Object? timestamp = null,
    Object? providerId = null,
    Object? error = freezed,
    Object? errorCode = freezed,
    Object? metadata = freezed,
  }) {
    return _then(
      _$AIResponseImpl(
        requestId:
            null == requestId
                ? _value.requestId
                : requestId // ignore: cast_nullable_to_non_nullable
                    as String,
        success:
            null == success
                ? _value.success
                : success // ignore: cast_nullable_to_non_nullable
                    as bool,
        data:
            null == data
                ? _value._data
                : data // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>,
        timestamp:
            null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        providerId:
            null == providerId
                ? _value.providerId
                : providerId // ignore: cast_nullable_to_non_nullable
                    as String,
        error:
            freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                    as String?,
        errorCode:
            freezed == errorCode
                ? _value.errorCode
                : errorCode // ignore: cast_nullable_to_non_nullable
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
class _$AIResponseImpl implements _AIResponse {
  const _$AIResponseImpl({
    required this.requestId,
    required this.success,
    required final Map<String, dynamic> data,
    required this.timestamp,
    required this.providerId,
    this.error,
    this.errorCode,
    final Map<String, dynamic>? metadata,
  }) : _data = data,
       _metadata = metadata;

  factory _$AIResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$AIResponseImplFromJson(json);

  @override
  final String requestId;
  @override
  final bool success;
  final Map<String, dynamic> _data;
  @override
  Map<String, dynamic> get data {
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_data);
  }

  @override
  final DateTime timestamp;
  @override
  final String providerId;
  @override
  final String? error;
  @override
  final String? errorCode;
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
    return 'AIResponse(requestId: $requestId, success: $success, data: $data, timestamp: $timestamp, providerId: $providerId, error: $error, errorCode: $errorCode, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AIResponseImpl &&
            (identical(other.requestId, requestId) ||
                other.requestId == requestId) &&
            (identical(other.success, success) || other.success == success) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.providerId, providerId) ||
                other.providerId == providerId) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.errorCode, errorCode) ||
                other.errorCode == errorCode) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    requestId,
    success,
    const DeepCollectionEquality().hash(_data),
    timestamp,
    providerId,
    error,
    errorCode,
    const DeepCollectionEquality().hash(_metadata),
  );

  /// Create a copy of AIResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AIResponseImplCopyWith<_$AIResponseImpl> get copyWith =>
      __$$AIResponseImplCopyWithImpl<_$AIResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AIResponseImplToJson(this);
  }
}

abstract class _AIResponse implements AIResponse {
  const factory _AIResponse({
    required final String requestId,
    required final bool success,
    required final Map<String, dynamic> data,
    required final DateTime timestamp,
    required final String providerId,
    final String? error,
    final String? errorCode,
    final Map<String, dynamic>? metadata,
  }) = _$AIResponseImpl;

  factory _AIResponse.fromJson(Map<String, dynamic> json) =
      _$AIResponseImpl.fromJson;

  @override
  String get requestId;
  @override
  bool get success;
  @override
  Map<String, dynamic> get data;
  @override
  DateTime get timestamp;
  @override
  String get providerId;
  @override
  String? get error;
  @override
  String? get errorCode;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of AIResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AIResponseImplCopyWith<_$AIResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WorkoutPlanResponse _$WorkoutPlanResponseFromJson(Map<String, dynamic> json) {
  return _WorkoutPlanResponse.fromJson(json);
}

/// @nodoc
mixin _$WorkoutPlanResponse {
  List<Map<String, dynamic>> get weeklyPlan =>
      throw _privateConstructorUsedError;
  String? get planId => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  List<String>? get recommendations => throw _privateConstructorUsedError;

  /// Serializes this WorkoutPlanResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkoutPlanResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkoutPlanResponseCopyWith<WorkoutPlanResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkoutPlanResponseCopyWith<$Res> {
  factory $WorkoutPlanResponseCopyWith(
    WorkoutPlanResponse value,
    $Res Function(WorkoutPlanResponse) then,
  ) = _$WorkoutPlanResponseCopyWithImpl<$Res, WorkoutPlanResponse>;
  @useResult
  $Res call({
    List<Map<String, dynamic>> weeklyPlan,
    String? planId,
    Map<String, dynamic>? metadata,
    List<String>? recommendations,
  });
}

/// @nodoc
class _$WorkoutPlanResponseCopyWithImpl<$Res, $Val extends WorkoutPlanResponse>
    implements $WorkoutPlanResponseCopyWith<$Res> {
  _$WorkoutPlanResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkoutPlanResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? weeklyPlan = null,
    Object? planId = freezed,
    Object? metadata = freezed,
    Object? recommendations = freezed,
  }) {
    return _then(
      _value.copyWith(
            weeklyPlan:
                null == weeklyPlan
                    ? _value.weeklyPlan
                    : weeklyPlan // ignore: cast_nullable_to_non_nullable
                        as List<Map<String, dynamic>>,
            planId:
                freezed == planId
                    ? _value.planId
                    : planId // ignore: cast_nullable_to_non_nullable
                        as String?,
            metadata:
                freezed == metadata
                    ? _value.metadata
                    : metadata // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>?,
            recommendations:
                freezed == recommendations
                    ? _value.recommendations
                    : recommendations // ignore: cast_nullable_to_non_nullable
                        as List<String>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WorkoutPlanResponseImplCopyWith<$Res>
    implements $WorkoutPlanResponseCopyWith<$Res> {
  factory _$$WorkoutPlanResponseImplCopyWith(
    _$WorkoutPlanResponseImpl value,
    $Res Function(_$WorkoutPlanResponseImpl) then,
  ) = __$$WorkoutPlanResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<Map<String, dynamic>> weeklyPlan,
    String? planId,
    Map<String, dynamic>? metadata,
    List<String>? recommendations,
  });
}

/// @nodoc
class __$$WorkoutPlanResponseImplCopyWithImpl<$Res>
    extends _$WorkoutPlanResponseCopyWithImpl<$Res, _$WorkoutPlanResponseImpl>
    implements _$$WorkoutPlanResponseImplCopyWith<$Res> {
  __$$WorkoutPlanResponseImplCopyWithImpl(
    _$WorkoutPlanResponseImpl _value,
    $Res Function(_$WorkoutPlanResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WorkoutPlanResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? weeklyPlan = null,
    Object? planId = freezed,
    Object? metadata = freezed,
    Object? recommendations = freezed,
  }) {
    return _then(
      _$WorkoutPlanResponseImpl(
        weeklyPlan:
            null == weeklyPlan
                ? _value._weeklyPlan
                : weeklyPlan // ignore: cast_nullable_to_non_nullable
                    as List<Map<String, dynamic>>,
        planId:
            freezed == planId
                ? _value.planId
                : planId // ignore: cast_nullable_to_non_nullable
                    as String?,
        metadata:
            freezed == metadata
                ? _value._metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>?,
        recommendations:
            freezed == recommendations
                ? _value._recommendations
                : recommendations // ignore: cast_nullable_to_non_nullable
                    as List<String>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkoutPlanResponseImpl implements _WorkoutPlanResponse {
  const _$WorkoutPlanResponseImpl({
    required final List<Map<String, dynamic>> weeklyPlan,
    this.planId,
    final Map<String, dynamic>? metadata,
    final List<String>? recommendations,
  }) : _weeklyPlan = weeklyPlan,
       _metadata = metadata,
       _recommendations = recommendations;

  factory _$WorkoutPlanResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkoutPlanResponseImplFromJson(json);

  final List<Map<String, dynamic>> _weeklyPlan;
  @override
  List<Map<String, dynamic>> get weeklyPlan {
    if (_weeklyPlan is EqualUnmodifiableListView) return _weeklyPlan;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_weeklyPlan);
  }

  @override
  final String? planId;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final List<String>? _recommendations;
  @override
  List<String>? get recommendations {
    final value = _recommendations;
    if (value == null) return null;
    if (_recommendations is EqualUnmodifiableListView) return _recommendations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'WorkoutPlanResponse(weeklyPlan: $weeklyPlan, planId: $planId, metadata: $metadata, recommendations: $recommendations)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkoutPlanResponseImpl &&
            const DeepCollectionEquality().equals(
              other._weeklyPlan,
              _weeklyPlan,
            ) &&
            (identical(other.planId, planId) || other.planId == planId) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            const DeepCollectionEquality().equals(
              other._recommendations,
              _recommendations,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_weeklyPlan),
    planId,
    const DeepCollectionEquality().hash(_metadata),
    const DeepCollectionEquality().hash(_recommendations),
  );

  /// Create a copy of WorkoutPlanResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkoutPlanResponseImplCopyWith<_$WorkoutPlanResponseImpl> get copyWith =>
      __$$WorkoutPlanResponseImplCopyWithImpl<_$WorkoutPlanResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkoutPlanResponseImplToJson(this);
  }
}

abstract class _WorkoutPlanResponse implements WorkoutPlanResponse {
  const factory _WorkoutPlanResponse({
    required final List<Map<String, dynamic>> weeklyPlan,
    final String? planId,
    final Map<String, dynamic>? metadata,
    final List<String>? recommendations,
  }) = _$WorkoutPlanResponseImpl;

  factory _WorkoutPlanResponse.fromJson(Map<String, dynamic> json) =
      _$WorkoutPlanResponseImpl.fromJson;

  @override
  List<Map<String, dynamic>> get weeklyPlan;
  @override
  String? get planId;
  @override
  Map<String, dynamic>? get metadata;
  @override
  List<String>? get recommendations;

  /// Create a copy of WorkoutPlanResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkoutPlanResponseImplCopyWith<_$WorkoutPlanResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AlternativeExerciseResponse _$AlternativeExerciseResponseFromJson(
  Map<String, dynamic> json,
) {
  return _AlternativeExerciseResponse.fromJson(json);
}

/// @nodoc
mixin _$AlternativeExerciseResponse {
  Map<String, dynamic> get alternativeExercise =>
      throw _privateConstructorUsedError;
  String? get reason => throw _privateConstructorUsedError;
  double? get confidenceScore => throw _privateConstructorUsedError;

  /// Serializes this AlternativeExerciseResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AlternativeExerciseResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AlternativeExerciseResponseCopyWith<AlternativeExerciseResponse>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlternativeExerciseResponseCopyWith<$Res> {
  factory $AlternativeExerciseResponseCopyWith(
    AlternativeExerciseResponse value,
    $Res Function(AlternativeExerciseResponse) then,
  ) =
      _$AlternativeExerciseResponseCopyWithImpl<
        $Res,
        AlternativeExerciseResponse
      >;
  @useResult
  $Res call({
    Map<String, dynamic> alternativeExercise,
    String? reason,
    double? confidenceScore,
  });
}

/// @nodoc
class _$AlternativeExerciseResponseCopyWithImpl<
  $Res,
  $Val extends AlternativeExerciseResponse
>
    implements $AlternativeExerciseResponseCopyWith<$Res> {
  _$AlternativeExerciseResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AlternativeExerciseResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? alternativeExercise = null,
    Object? reason = freezed,
    Object? confidenceScore = freezed,
  }) {
    return _then(
      _value.copyWith(
            alternativeExercise:
                null == alternativeExercise
                    ? _value.alternativeExercise
                    : alternativeExercise // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>,
            reason:
                freezed == reason
                    ? _value.reason
                    : reason // ignore: cast_nullable_to_non_nullable
                        as String?,
            confidenceScore:
                freezed == confidenceScore
                    ? _value.confidenceScore
                    : confidenceScore // ignore: cast_nullable_to_non_nullable
                        as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AlternativeExerciseResponseImplCopyWith<$Res>
    implements $AlternativeExerciseResponseCopyWith<$Res> {
  factory _$$AlternativeExerciseResponseImplCopyWith(
    _$AlternativeExerciseResponseImpl value,
    $Res Function(_$AlternativeExerciseResponseImpl) then,
  ) = __$$AlternativeExerciseResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    Map<String, dynamic> alternativeExercise,
    String? reason,
    double? confidenceScore,
  });
}

/// @nodoc
class __$$AlternativeExerciseResponseImplCopyWithImpl<$Res>
    extends
        _$AlternativeExerciseResponseCopyWithImpl<
          $Res,
          _$AlternativeExerciseResponseImpl
        >
    implements _$$AlternativeExerciseResponseImplCopyWith<$Res> {
  __$$AlternativeExerciseResponseImplCopyWithImpl(
    _$AlternativeExerciseResponseImpl _value,
    $Res Function(_$AlternativeExerciseResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AlternativeExerciseResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? alternativeExercise = null,
    Object? reason = freezed,
    Object? confidenceScore = freezed,
  }) {
    return _then(
      _$AlternativeExerciseResponseImpl(
        alternativeExercise:
            null == alternativeExercise
                ? _value._alternativeExercise
                : alternativeExercise // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>,
        reason:
            freezed == reason
                ? _value.reason
                : reason // ignore: cast_nullable_to_non_nullable
                    as String?,
        confidenceScore:
            freezed == confidenceScore
                ? _value.confidenceScore
                : confidenceScore // ignore: cast_nullable_to_non_nullable
                    as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AlternativeExerciseResponseImpl
    implements _AlternativeExerciseResponse {
  const _$AlternativeExerciseResponseImpl({
    required final Map<String, dynamic> alternativeExercise,
    this.reason,
    this.confidenceScore,
  }) : _alternativeExercise = alternativeExercise;

  factory _$AlternativeExerciseResponseImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$AlternativeExerciseResponseImplFromJson(json);

  final Map<String, dynamic> _alternativeExercise;
  @override
  Map<String, dynamic> get alternativeExercise {
    if (_alternativeExercise is EqualUnmodifiableMapView)
      return _alternativeExercise;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_alternativeExercise);
  }

  @override
  final String? reason;
  @override
  final double? confidenceScore;

  @override
  String toString() {
    return 'AlternativeExerciseResponse(alternativeExercise: $alternativeExercise, reason: $reason, confidenceScore: $confidenceScore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlternativeExerciseResponseImpl &&
            const DeepCollectionEquality().equals(
              other._alternativeExercise,
              _alternativeExercise,
            ) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.confidenceScore, confidenceScore) ||
                other.confidenceScore == confidenceScore));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_alternativeExercise),
    reason,
    confidenceScore,
  );

  /// Create a copy of AlternativeExerciseResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AlternativeExerciseResponseImplCopyWith<_$AlternativeExerciseResponseImpl>
  get copyWith => __$$AlternativeExerciseResponseImplCopyWithImpl<
    _$AlternativeExerciseResponseImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AlternativeExerciseResponseImplToJson(this);
  }
}

abstract class _AlternativeExerciseResponse
    implements AlternativeExerciseResponse {
  const factory _AlternativeExerciseResponse({
    required final Map<String, dynamic> alternativeExercise,
    final String? reason,
    final double? confidenceScore,
  }) = _$AlternativeExerciseResponseImpl;

  factory _AlternativeExerciseResponse.fromJson(Map<String, dynamic> json) =
      _$AlternativeExerciseResponseImpl.fromJson;

  @override
  Map<String, dynamic> get alternativeExercise;
  @override
  String? get reason;
  @override
  double? get confidenceScore;

  /// Create a copy of AlternativeExerciseResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AlternativeExerciseResponseImplCopyWith<_$AlternativeExerciseResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}

NotificationResponse _$NotificationResponseFromJson(Map<String, dynamic> json) {
  return _NotificationResponse.fromJson(json);
}

/// @nodoc
mixin _$NotificationResponse {
  String get message => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  Map<String, dynamic>? get customData => throw _privateConstructorUsedError;

  /// Serializes this NotificationResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NotificationResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationResponseCopyWith<NotificationResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationResponseCopyWith<$Res> {
  factory $NotificationResponseCopyWith(
    NotificationResponse value,
    $Res Function(NotificationResponse) then,
  ) = _$NotificationResponseCopyWithImpl<$Res, NotificationResponse>;
  @useResult
  $Res call({
    String message,
    String? title,
    String? category,
    Map<String, dynamic>? customData,
  });
}

/// @nodoc
class _$NotificationResponseCopyWithImpl<
  $Res,
  $Val extends NotificationResponse
>
    implements $NotificationResponseCopyWith<$Res> {
  _$NotificationResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? title = freezed,
    Object? category = freezed,
    Object? customData = freezed,
  }) {
    return _then(
      _value.copyWith(
            message:
                null == message
                    ? _value.message
                    : message // ignore: cast_nullable_to_non_nullable
                        as String,
            title:
                freezed == title
                    ? _value.title
                    : title // ignore: cast_nullable_to_non_nullable
                        as String?,
            category:
                freezed == category
                    ? _value.category
                    : category // ignore: cast_nullable_to_non_nullable
                        as String?,
            customData:
                freezed == customData
                    ? _value.customData
                    : customData // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NotificationResponseImplCopyWith<$Res>
    implements $NotificationResponseCopyWith<$Res> {
  factory _$$NotificationResponseImplCopyWith(
    _$NotificationResponseImpl value,
    $Res Function(_$NotificationResponseImpl) then,
  ) = __$$NotificationResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String message,
    String? title,
    String? category,
    Map<String, dynamic>? customData,
  });
}

/// @nodoc
class __$$NotificationResponseImplCopyWithImpl<$Res>
    extends _$NotificationResponseCopyWithImpl<$Res, _$NotificationResponseImpl>
    implements _$$NotificationResponseImplCopyWith<$Res> {
  __$$NotificationResponseImplCopyWithImpl(
    _$NotificationResponseImpl _value,
    $Res Function(_$NotificationResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NotificationResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? title = freezed,
    Object? category = freezed,
    Object? customData = freezed,
  }) {
    return _then(
      _$NotificationResponseImpl(
        message:
            null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                    as String,
        title:
            freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                    as String?,
        category:
            freezed == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                    as String?,
        customData:
            freezed == customData
                ? _value._customData
                : customData // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationResponseImpl implements _NotificationResponse {
  const _$NotificationResponseImpl({
    required this.message,
    this.title,
    this.category,
    final Map<String, dynamic>? customData,
  }) : _customData = customData;

  factory _$NotificationResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationResponseImplFromJson(json);

  @override
  final String message;
  @override
  final String? title;
  @override
  final String? category;
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
  String toString() {
    return 'NotificationResponse(message: $message, title: $title, category: $category, customData: $customData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationResponseImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality().equals(
              other._customData,
              _customData,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    message,
    title,
    category,
    const DeepCollectionEquality().hash(_customData),
  );

  /// Create a copy of NotificationResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationResponseImplCopyWith<_$NotificationResponseImpl>
  get copyWith =>
      __$$NotificationResponseImplCopyWithImpl<_$NotificationResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationResponseImplToJson(this);
  }
}

abstract class _NotificationResponse implements NotificationResponse {
  const factory _NotificationResponse({
    required final String message,
    final String? title,
    final String? category,
    final Map<String, dynamic>? customData,
  }) = _$NotificationResponseImpl;

  factory _NotificationResponse.fromJson(Map<String, dynamic> json) =
      _$NotificationResponseImpl.fromJson;

  @override
  String get message;
  @override
  String? get title;
  @override
  String? get category;
  @override
  Map<String, dynamic>? get customData;

  /// Create a copy of NotificationResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationResponseImplCopyWith<_$NotificationResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}

N8NWorkflowResponse _$N8NWorkflowResponseFromJson(Map<String, dynamic> json) {
  return _N8NWorkflowResponse.fromJson(json);
}

/// @nodoc
mixin _$N8NWorkflowResponse {
  String get workflowId => throw _privateConstructorUsedError;
  Map<String, dynamic> get result => throw _privateConstructorUsedError;
  String? get executionId => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  Map<String, dynamic>? get executionData => throw _privateConstructorUsedError;

  /// Serializes this N8NWorkflowResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of N8NWorkflowResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $N8NWorkflowResponseCopyWith<N8NWorkflowResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $N8NWorkflowResponseCopyWith<$Res> {
  factory $N8NWorkflowResponseCopyWith(
    N8NWorkflowResponse value,
    $Res Function(N8NWorkflowResponse) then,
  ) = _$N8NWorkflowResponseCopyWithImpl<$Res, N8NWorkflowResponse>;
  @useResult
  $Res call({
    String workflowId,
    Map<String, dynamic> result,
    String? executionId,
    String? status,
    Map<String, dynamic>? executionData,
  });
}

/// @nodoc
class _$N8NWorkflowResponseCopyWithImpl<$Res, $Val extends N8NWorkflowResponse>
    implements $N8NWorkflowResponseCopyWith<$Res> {
  _$N8NWorkflowResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of N8NWorkflowResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workflowId = null,
    Object? result = null,
    Object? executionId = freezed,
    Object? status = freezed,
    Object? executionData = freezed,
  }) {
    return _then(
      _value.copyWith(
            workflowId:
                null == workflowId
                    ? _value.workflowId
                    : workflowId // ignore: cast_nullable_to_non_nullable
                        as String,
            result:
                null == result
                    ? _value.result
                    : result // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>,
            executionId:
                freezed == executionId
                    ? _value.executionId
                    : executionId // ignore: cast_nullable_to_non_nullable
                        as String?,
            status:
                freezed == status
                    ? _value.status
                    : status // ignore: cast_nullable_to_non_nullable
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
abstract class _$$N8NWorkflowResponseImplCopyWith<$Res>
    implements $N8NWorkflowResponseCopyWith<$Res> {
  factory _$$N8NWorkflowResponseImplCopyWith(
    _$N8NWorkflowResponseImpl value,
    $Res Function(_$N8NWorkflowResponseImpl) then,
  ) = __$$N8NWorkflowResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String workflowId,
    Map<String, dynamic> result,
    String? executionId,
    String? status,
    Map<String, dynamic>? executionData,
  });
}

/// @nodoc
class __$$N8NWorkflowResponseImplCopyWithImpl<$Res>
    extends _$N8NWorkflowResponseCopyWithImpl<$Res, _$N8NWorkflowResponseImpl>
    implements _$$N8NWorkflowResponseImplCopyWith<$Res> {
  __$$N8NWorkflowResponseImplCopyWithImpl(
    _$N8NWorkflowResponseImpl _value,
    $Res Function(_$N8NWorkflowResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of N8NWorkflowResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workflowId = null,
    Object? result = null,
    Object? executionId = freezed,
    Object? status = freezed,
    Object? executionData = freezed,
  }) {
    return _then(
      _$N8NWorkflowResponseImpl(
        workflowId:
            null == workflowId
                ? _value.workflowId
                : workflowId // ignore: cast_nullable_to_non_nullable
                    as String,
        result:
            null == result
                ? _value._result
                : result // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>,
        executionId:
            freezed == executionId
                ? _value.executionId
                : executionId // ignore: cast_nullable_to_non_nullable
                    as String?,
        status:
            freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
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
class _$N8NWorkflowResponseImpl implements _N8NWorkflowResponse {
  const _$N8NWorkflowResponseImpl({
    required this.workflowId,
    required final Map<String, dynamic> result,
    this.executionId,
    this.status,
    final Map<String, dynamic>? executionData,
  }) : _result = result,
       _executionData = executionData;

  factory _$N8NWorkflowResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$N8NWorkflowResponseImplFromJson(json);

  @override
  final String workflowId;
  final Map<String, dynamic> _result;
  @override
  Map<String, dynamic> get result {
    if (_result is EqualUnmodifiableMapView) return _result;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_result);
  }

  @override
  final String? executionId;
  @override
  final String? status;
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
    return 'N8NWorkflowResponse(workflowId: $workflowId, result: $result, executionId: $executionId, status: $status, executionData: $executionData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$N8NWorkflowResponseImpl &&
            (identical(other.workflowId, workflowId) ||
                other.workflowId == workflowId) &&
            const DeepCollectionEquality().equals(other._result, _result) &&
            (identical(other.executionId, executionId) ||
                other.executionId == executionId) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(
              other._executionData,
              _executionData,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    workflowId,
    const DeepCollectionEquality().hash(_result),
    executionId,
    status,
    const DeepCollectionEquality().hash(_executionData),
  );

  /// Create a copy of N8NWorkflowResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$N8NWorkflowResponseImplCopyWith<_$N8NWorkflowResponseImpl> get copyWith =>
      __$$N8NWorkflowResponseImplCopyWithImpl<_$N8NWorkflowResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$N8NWorkflowResponseImplToJson(this);
  }
}

abstract class _N8NWorkflowResponse implements N8NWorkflowResponse {
  const factory _N8NWorkflowResponse({
    required final String workflowId,
    required final Map<String, dynamic> result,
    final String? executionId,
    final String? status,
    final Map<String, dynamic>? executionData,
  }) = _$N8NWorkflowResponseImpl;

  factory _N8NWorkflowResponse.fromJson(Map<String, dynamic> json) =
      _$N8NWorkflowResponseImpl.fromJson;

  @override
  String get workflowId;
  @override
  Map<String, dynamic> get result;
  @override
  String? get executionId;
  @override
  String? get status;
  @override
  Map<String, dynamic>? get executionData;

  /// Create a copy of N8NWorkflowResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$N8NWorkflowResponseImplCopyWith<_$N8NWorkflowResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
