// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AIRequest _$AIRequestFromJson(Map<String, dynamic> json) {
  return _AIRequest.fromJson(json);
}

/// @nodoc
mixin _$AIRequest {
  String get requestId => throw _privateConstructorUsedError;
  AIRequestType get type => throw _privateConstructorUsedError;
  Map<String, dynamic> get payload => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  Map<String, String>? get headers => throw _privateConstructorUsedError;
  int? get timeoutSeconds => throw _privateConstructorUsedError;

  /// Serializes this AIRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AIRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AIRequestCopyWith<AIRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AIRequestCopyWith<$Res> {
  factory $AIRequestCopyWith(AIRequest value, $Res Function(AIRequest) then) =
      _$AIRequestCopyWithImpl<$Res, AIRequest>;
  @useResult
  $Res call({
    String requestId,
    AIRequestType type,
    Map<String, dynamic> payload,
    DateTime timestamp,
    String userId,
    Map<String, String>? headers,
    int? timeoutSeconds,
  });
}

/// @nodoc
class _$AIRequestCopyWithImpl<$Res, $Val extends AIRequest>
    implements $AIRequestCopyWith<$Res> {
  _$AIRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AIRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requestId = null,
    Object? type = null,
    Object? payload = null,
    Object? timestamp = null,
    Object? userId = null,
    Object? headers = freezed,
    Object? timeoutSeconds = freezed,
  }) {
    return _then(
      _value.copyWith(
            requestId:
                null == requestId
                    ? _value.requestId
                    : requestId // ignore: cast_nullable_to_non_nullable
                        as String,
            type:
                null == type
                    ? _value.type
                    : type // ignore: cast_nullable_to_non_nullable
                        as AIRequestType,
            payload:
                null == payload
                    ? _value.payload
                    : payload // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>,
            timestamp:
                null == timestamp
                    ? _value.timestamp
                    : timestamp // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            userId:
                null == userId
                    ? _value.userId
                    : userId // ignore: cast_nullable_to_non_nullable
                        as String,
            headers:
                freezed == headers
                    ? _value.headers
                    : headers // ignore: cast_nullable_to_non_nullable
                        as Map<String, String>?,
            timeoutSeconds:
                freezed == timeoutSeconds
                    ? _value.timeoutSeconds
                    : timeoutSeconds // ignore: cast_nullable_to_non_nullable
                        as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AIRequestImplCopyWith<$Res>
    implements $AIRequestCopyWith<$Res> {
  factory _$$AIRequestImplCopyWith(
    _$AIRequestImpl value,
    $Res Function(_$AIRequestImpl) then,
  ) = __$$AIRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String requestId,
    AIRequestType type,
    Map<String, dynamic> payload,
    DateTime timestamp,
    String userId,
    Map<String, String>? headers,
    int? timeoutSeconds,
  });
}

/// @nodoc
class __$$AIRequestImplCopyWithImpl<$Res>
    extends _$AIRequestCopyWithImpl<$Res, _$AIRequestImpl>
    implements _$$AIRequestImplCopyWith<$Res> {
  __$$AIRequestImplCopyWithImpl(
    _$AIRequestImpl _value,
    $Res Function(_$AIRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AIRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requestId = null,
    Object? type = null,
    Object? payload = null,
    Object? timestamp = null,
    Object? userId = null,
    Object? headers = freezed,
    Object? timeoutSeconds = freezed,
  }) {
    return _then(
      _$AIRequestImpl(
        requestId:
            null == requestId
                ? _value.requestId
                : requestId // ignore: cast_nullable_to_non_nullable
                    as String,
        type:
            null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                    as AIRequestType,
        payload:
            null == payload
                ? _value._payload
                : payload // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>,
        timestamp:
            null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        userId:
            null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                    as String,
        headers:
            freezed == headers
                ? _value._headers
                : headers // ignore: cast_nullable_to_non_nullable
                    as Map<String, String>?,
        timeoutSeconds:
            freezed == timeoutSeconds
                ? _value.timeoutSeconds
                : timeoutSeconds // ignore: cast_nullable_to_non_nullable
                    as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AIRequestImpl implements _AIRequest {
  const _$AIRequestImpl({
    required this.requestId,
    required this.type,
    required final Map<String, dynamic> payload,
    required this.timestamp,
    required this.userId,
    final Map<String, String>? headers,
    this.timeoutSeconds,
  }) : _payload = payload,
       _headers = headers;

  factory _$AIRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$AIRequestImplFromJson(json);

  @override
  final String requestId;
  @override
  final AIRequestType type;
  final Map<String, dynamic> _payload;
  @override
  Map<String, dynamic> get payload {
    if (_payload is EqualUnmodifiableMapView) return _payload;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_payload);
  }

  @override
  final DateTime timestamp;
  @override
  final String userId;
  final Map<String, String>? _headers;
  @override
  Map<String, String>? get headers {
    final value = _headers;
    if (value == null) return null;
    if (_headers is EqualUnmodifiableMapView) return _headers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final int? timeoutSeconds;

  @override
  String toString() {
    return 'AIRequest(requestId: $requestId, type: $type, payload: $payload, timestamp: $timestamp, userId: $userId, headers: $headers, timeoutSeconds: $timeoutSeconds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AIRequestImpl &&
            (identical(other.requestId, requestId) ||
                other.requestId == requestId) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(other._payload, _payload) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            const DeepCollectionEquality().equals(other._headers, _headers) &&
            (identical(other.timeoutSeconds, timeoutSeconds) ||
                other.timeoutSeconds == timeoutSeconds));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    requestId,
    type,
    const DeepCollectionEquality().hash(_payload),
    timestamp,
    userId,
    const DeepCollectionEquality().hash(_headers),
    timeoutSeconds,
  );

  /// Create a copy of AIRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AIRequestImplCopyWith<_$AIRequestImpl> get copyWith =>
      __$$AIRequestImplCopyWithImpl<_$AIRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AIRequestImplToJson(this);
  }
}

abstract class _AIRequest implements AIRequest {
  const factory _AIRequest({
    required final String requestId,
    required final AIRequestType type,
    required final Map<String, dynamic> payload,
    required final DateTime timestamp,
    required final String userId,
    final Map<String, String>? headers,
    final int? timeoutSeconds,
  }) = _$AIRequestImpl;

  factory _AIRequest.fromJson(Map<String, dynamic> json) =
      _$AIRequestImpl.fromJson;

  @override
  String get requestId;
  @override
  AIRequestType get type;
  @override
  Map<String, dynamic> get payload;
  @override
  DateTime get timestamp;
  @override
  String get userId;
  @override
  Map<String, String>? get headers;
  @override
  int? get timeoutSeconds;

  /// Create a copy of AIRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AIRequestImplCopyWith<_$AIRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WorkoutPlanRequest _$WorkoutPlanRequestFromJson(Map<String, dynamic> json) {
  return _WorkoutPlanRequest.fromJson(json);
}

/// @nodoc
mixin _$WorkoutPlanRequest {
  String get userId => throw _privateConstructorUsedError;
  Map<String, dynamic> get userProfile => throw _privateConstructorUsedError;
  List<Map<String, dynamic>> get availableExercises =>
      throw _privateConstructorUsedError;
  Map<String, dynamic>? get preferences => throw _privateConstructorUsedError;
  List<String>? get excludedExercises => throw _privateConstructorUsedError;

  /// Serializes this WorkoutPlanRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkoutPlanRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkoutPlanRequestCopyWith<WorkoutPlanRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkoutPlanRequestCopyWith<$Res> {
  factory $WorkoutPlanRequestCopyWith(
    WorkoutPlanRequest value,
    $Res Function(WorkoutPlanRequest) then,
  ) = _$WorkoutPlanRequestCopyWithImpl<$Res, WorkoutPlanRequest>;
  @useResult
  $Res call({
    String userId,
    Map<String, dynamic> userProfile,
    List<Map<String, dynamic>> availableExercises,
    Map<String, dynamic>? preferences,
    List<String>? excludedExercises,
  });
}

/// @nodoc
class _$WorkoutPlanRequestCopyWithImpl<$Res, $Val extends WorkoutPlanRequest>
    implements $WorkoutPlanRequestCopyWith<$Res> {
  _$WorkoutPlanRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkoutPlanRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? userProfile = null,
    Object? availableExercises = null,
    Object? preferences = freezed,
    Object? excludedExercises = freezed,
  }) {
    return _then(
      _value.copyWith(
            userId:
                null == userId
                    ? _value.userId
                    : userId // ignore: cast_nullable_to_non_nullable
                        as String,
            userProfile:
                null == userProfile
                    ? _value.userProfile
                    : userProfile // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>,
            availableExercises:
                null == availableExercises
                    ? _value.availableExercises
                    : availableExercises // ignore: cast_nullable_to_non_nullable
                        as List<Map<String, dynamic>>,
            preferences:
                freezed == preferences
                    ? _value.preferences
                    : preferences // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>?,
            excludedExercises:
                freezed == excludedExercises
                    ? _value.excludedExercises
                    : excludedExercises // ignore: cast_nullable_to_non_nullable
                        as List<String>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WorkoutPlanRequestImplCopyWith<$Res>
    implements $WorkoutPlanRequestCopyWith<$Res> {
  factory _$$WorkoutPlanRequestImplCopyWith(
    _$WorkoutPlanRequestImpl value,
    $Res Function(_$WorkoutPlanRequestImpl) then,
  ) = __$$WorkoutPlanRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String userId,
    Map<String, dynamic> userProfile,
    List<Map<String, dynamic>> availableExercises,
    Map<String, dynamic>? preferences,
    List<String>? excludedExercises,
  });
}

/// @nodoc
class __$$WorkoutPlanRequestImplCopyWithImpl<$Res>
    extends _$WorkoutPlanRequestCopyWithImpl<$Res, _$WorkoutPlanRequestImpl>
    implements _$$WorkoutPlanRequestImplCopyWith<$Res> {
  __$$WorkoutPlanRequestImplCopyWithImpl(
    _$WorkoutPlanRequestImpl _value,
    $Res Function(_$WorkoutPlanRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WorkoutPlanRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? userProfile = null,
    Object? availableExercises = null,
    Object? preferences = freezed,
    Object? excludedExercises = freezed,
  }) {
    return _then(
      _$WorkoutPlanRequestImpl(
        userId:
            null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                    as String,
        userProfile:
            null == userProfile
                ? _value._userProfile
                : userProfile // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>,
        availableExercises:
            null == availableExercises
                ? _value._availableExercises
                : availableExercises // ignore: cast_nullable_to_non_nullable
                    as List<Map<String, dynamic>>,
        preferences:
            freezed == preferences
                ? _value._preferences
                : preferences // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>?,
        excludedExercises:
            freezed == excludedExercises
                ? _value._excludedExercises
                : excludedExercises // ignore: cast_nullable_to_non_nullable
                    as List<String>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkoutPlanRequestImpl implements _WorkoutPlanRequest {
  const _$WorkoutPlanRequestImpl({
    required this.userId,
    required final Map<String, dynamic> userProfile,
    required final List<Map<String, dynamic>> availableExercises,
    final Map<String, dynamic>? preferences,
    final List<String>? excludedExercises,
  }) : _userProfile = userProfile,
       _availableExercises = availableExercises,
       _preferences = preferences,
       _excludedExercises = excludedExercises;

  factory _$WorkoutPlanRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkoutPlanRequestImplFromJson(json);

  @override
  final String userId;
  final Map<String, dynamic> _userProfile;
  @override
  Map<String, dynamic> get userProfile {
    if (_userProfile is EqualUnmodifiableMapView) return _userProfile;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_userProfile);
  }

  final List<Map<String, dynamic>> _availableExercises;
  @override
  List<Map<String, dynamic>> get availableExercises {
    if (_availableExercises is EqualUnmodifiableListView)
      return _availableExercises;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_availableExercises);
  }

  final Map<String, dynamic>? _preferences;
  @override
  Map<String, dynamic>? get preferences {
    final value = _preferences;
    if (value == null) return null;
    if (_preferences is EqualUnmodifiableMapView) return _preferences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final List<String>? _excludedExercises;
  @override
  List<String>? get excludedExercises {
    final value = _excludedExercises;
    if (value == null) return null;
    if (_excludedExercises is EqualUnmodifiableListView)
      return _excludedExercises;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'WorkoutPlanRequest(userId: $userId, userProfile: $userProfile, availableExercises: $availableExercises, preferences: $preferences, excludedExercises: $excludedExercises)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkoutPlanRequestImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            const DeepCollectionEquality().equals(
              other._userProfile,
              _userProfile,
            ) &&
            const DeepCollectionEquality().equals(
              other._availableExercises,
              _availableExercises,
            ) &&
            const DeepCollectionEquality().equals(
              other._preferences,
              _preferences,
            ) &&
            const DeepCollectionEquality().equals(
              other._excludedExercises,
              _excludedExercises,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    const DeepCollectionEquality().hash(_userProfile),
    const DeepCollectionEquality().hash(_availableExercises),
    const DeepCollectionEquality().hash(_preferences),
    const DeepCollectionEquality().hash(_excludedExercises),
  );

  /// Create a copy of WorkoutPlanRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkoutPlanRequestImplCopyWith<_$WorkoutPlanRequestImpl> get copyWith =>
      __$$WorkoutPlanRequestImplCopyWithImpl<_$WorkoutPlanRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkoutPlanRequestImplToJson(this);
  }
}

abstract class _WorkoutPlanRequest implements WorkoutPlanRequest {
  const factory _WorkoutPlanRequest({
    required final String userId,
    required final Map<String, dynamic> userProfile,
    required final List<Map<String, dynamic>> availableExercises,
    final Map<String, dynamic>? preferences,
    final List<String>? excludedExercises,
  }) = _$WorkoutPlanRequestImpl;

  factory _WorkoutPlanRequest.fromJson(Map<String, dynamic> json) =
      _$WorkoutPlanRequestImpl.fromJson;

  @override
  String get userId;
  @override
  Map<String, dynamic> get userProfile;
  @override
  List<Map<String, dynamic>> get availableExercises;
  @override
  Map<String, dynamic>? get preferences;
  @override
  List<String>? get excludedExercises;

  /// Create a copy of WorkoutPlanRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkoutPlanRequestImplCopyWith<_$WorkoutPlanRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AlternativeExerciseRequest _$AlternativeExerciseRequestFromJson(
  Map<String, dynamic> json,
) {
  return _AlternativeExerciseRequest.fromJson(json);
}

/// @nodoc
mixin _$AlternativeExerciseRequest {
  String get userId => throw _privateConstructorUsedError;
  String get currentExerciseId => throw _privateConstructorUsedError;
  String get alternativeType =>
      throw _privateConstructorUsedError; // 'dislike' or 'not_possible'
  List<Map<String, dynamic>> get availableExercises =>
      throw _privateConstructorUsedError;
  Map<String, dynamic>? get userContext => throw _privateConstructorUsedError;

  /// Serializes this AlternativeExerciseRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AlternativeExerciseRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AlternativeExerciseRequestCopyWith<AlternativeExerciseRequest>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlternativeExerciseRequestCopyWith<$Res> {
  factory $AlternativeExerciseRequestCopyWith(
    AlternativeExerciseRequest value,
    $Res Function(AlternativeExerciseRequest) then,
  ) =
      _$AlternativeExerciseRequestCopyWithImpl<
        $Res,
        AlternativeExerciseRequest
      >;
  @useResult
  $Res call({
    String userId,
    String currentExerciseId,
    String alternativeType,
    List<Map<String, dynamic>> availableExercises,
    Map<String, dynamic>? userContext,
  });
}

/// @nodoc
class _$AlternativeExerciseRequestCopyWithImpl<
  $Res,
  $Val extends AlternativeExerciseRequest
>
    implements $AlternativeExerciseRequestCopyWith<$Res> {
  _$AlternativeExerciseRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AlternativeExerciseRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? currentExerciseId = null,
    Object? alternativeType = null,
    Object? availableExercises = null,
    Object? userContext = freezed,
  }) {
    return _then(
      _value.copyWith(
            userId:
                null == userId
                    ? _value.userId
                    : userId // ignore: cast_nullable_to_non_nullable
                        as String,
            currentExerciseId:
                null == currentExerciseId
                    ? _value.currentExerciseId
                    : currentExerciseId // ignore: cast_nullable_to_non_nullable
                        as String,
            alternativeType:
                null == alternativeType
                    ? _value.alternativeType
                    : alternativeType // ignore: cast_nullable_to_non_nullable
                        as String,
            availableExercises:
                null == availableExercises
                    ? _value.availableExercises
                    : availableExercises // ignore: cast_nullable_to_non_nullable
                        as List<Map<String, dynamic>>,
            userContext:
                freezed == userContext
                    ? _value.userContext
                    : userContext // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AlternativeExerciseRequestImplCopyWith<$Res>
    implements $AlternativeExerciseRequestCopyWith<$Res> {
  factory _$$AlternativeExerciseRequestImplCopyWith(
    _$AlternativeExerciseRequestImpl value,
    $Res Function(_$AlternativeExerciseRequestImpl) then,
  ) = __$$AlternativeExerciseRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String userId,
    String currentExerciseId,
    String alternativeType,
    List<Map<String, dynamic>> availableExercises,
    Map<String, dynamic>? userContext,
  });
}

/// @nodoc
class __$$AlternativeExerciseRequestImplCopyWithImpl<$Res>
    extends
        _$AlternativeExerciseRequestCopyWithImpl<
          $Res,
          _$AlternativeExerciseRequestImpl
        >
    implements _$$AlternativeExerciseRequestImplCopyWith<$Res> {
  __$$AlternativeExerciseRequestImplCopyWithImpl(
    _$AlternativeExerciseRequestImpl _value,
    $Res Function(_$AlternativeExerciseRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AlternativeExerciseRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? currentExerciseId = null,
    Object? alternativeType = null,
    Object? availableExercises = null,
    Object? userContext = freezed,
  }) {
    return _then(
      _$AlternativeExerciseRequestImpl(
        userId:
            null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                    as String,
        currentExerciseId:
            null == currentExerciseId
                ? _value.currentExerciseId
                : currentExerciseId // ignore: cast_nullable_to_non_nullable
                    as String,
        alternativeType:
            null == alternativeType
                ? _value.alternativeType
                : alternativeType // ignore: cast_nullable_to_non_nullable
                    as String,
        availableExercises:
            null == availableExercises
                ? _value._availableExercises
                : availableExercises // ignore: cast_nullable_to_non_nullable
                    as List<Map<String, dynamic>>,
        userContext:
            freezed == userContext
                ? _value._userContext
                : userContext // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AlternativeExerciseRequestImpl implements _AlternativeExerciseRequest {
  const _$AlternativeExerciseRequestImpl({
    required this.userId,
    required this.currentExerciseId,
    required this.alternativeType,
    required final List<Map<String, dynamic>> availableExercises,
    final Map<String, dynamic>? userContext,
  }) : _availableExercises = availableExercises,
       _userContext = userContext;

  factory _$AlternativeExerciseRequestImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$AlternativeExerciseRequestImplFromJson(json);

  @override
  final String userId;
  @override
  final String currentExerciseId;
  @override
  final String alternativeType;
  // 'dislike' or 'not_possible'
  final List<Map<String, dynamic>> _availableExercises;
  // 'dislike' or 'not_possible'
  @override
  List<Map<String, dynamic>> get availableExercises {
    if (_availableExercises is EqualUnmodifiableListView)
      return _availableExercises;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_availableExercises);
  }

  final Map<String, dynamic>? _userContext;
  @override
  Map<String, dynamic>? get userContext {
    final value = _userContext;
    if (value == null) return null;
    if (_userContext is EqualUnmodifiableMapView) return _userContext;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'AlternativeExerciseRequest(userId: $userId, currentExerciseId: $currentExerciseId, alternativeType: $alternativeType, availableExercises: $availableExercises, userContext: $userContext)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlternativeExerciseRequestImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.currentExerciseId, currentExerciseId) ||
                other.currentExerciseId == currentExerciseId) &&
            (identical(other.alternativeType, alternativeType) ||
                other.alternativeType == alternativeType) &&
            const DeepCollectionEquality().equals(
              other._availableExercises,
              _availableExercises,
            ) &&
            const DeepCollectionEquality().equals(
              other._userContext,
              _userContext,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    currentExerciseId,
    alternativeType,
    const DeepCollectionEquality().hash(_availableExercises),
    const DeepCollectionEquality().hash(_userContext),
  );

  /// Create a copy of AlternativeExerciseRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AlternativeExerciseRequestImplCopyWith<_$AlternativeExerciseRequestImpl>
  get copyWith => __$$AlternativeExerciseRequestImplCopyWithImpl<
    _$AlternativeExerciseRequestImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AlternativeExerciseRequestImplToJson(this);
  }
}

abstract class _AlternativeExerciseRequest
    implements AlternativeExerciseRequest {
  const factory _AlternativeExerciseRequest({
    required final String userId,
    required final String currentExerciseId,
    required final String alternativeType,
    required final List<Map<String, dynamic>> availableExercises,
    final Map<String, dynamic>? userContext,
  }) = _$AlternativeExerciseRequestImpl;

  factory _AlternativeExerciseRequest.fromJson(Map<String, dynamic> json) =
      _$AlternativeExerciseRequestImpl.fromJson;

  @override
  String get userId;
  @override
  String get currentExerciseId;
  @override
  String get alternativeType; // 'dislike' or 'not_possible'
  @override
  List<Map<String, dynamic>> get availableExercises;
  @override
  Map<String, dynamic>? get userContext;

  /// Create a copy of AlternativeExerciseRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AlternativeExerciseRequestImplCopyWith<_$AlternativeExerciseRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}

NotificationRequest _$NotificationRequestFromJson(Map<String, dynamic> json) {
  return _NotificationRequest.fromJson(json);
}

/// @nodoc
mixin _$NotificationRequest {
  String get userId => throw _privateConstructorUsedError;
  Map<String, dynamic> get userContext => throw _privateConstructorUsedError;
  String? get notificationType => throw _privateConstructorUsedError;
  Map<String, dynamic>? get additionalData =>
      throw _privateConstructorUsedError;

  /// Serializes this NotificationRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NotificationRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationRequestCopyWith<NotificationRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationRequestCopyWith<$Res> {
  factory $NotificationRequestCopyWith(
    NotificationRequest value,
    $Res Function(NotificationRequest) then,
  ) = _$NotificationRequestCopyWithImpl<$Res, NotificationRequest>;
  @useResult
  $Res call({
    String userId,
    Map<String, dynamic> userContext,
    String? notificationType,
    Map<String, dynamic>? additionalData,
  });
}

/// @nodoc
class _$NotificationRequestCopyWithImpl<$Res, $Val extends NotificationRequest>
    implements $NotificationRequestCopyWith<$Res> {
  _$NotificationRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? userContext = null,
    Object? notificationType = freezed,
    Object? additionalData = freezed,
  }) {
    return _then(
      _value.copyWith(
            userId:
                null == userId
                    ? _value.userId
                    : userId // ignore: cast_nullable_to_non_nullable
                        as String,
            userContext:
                null == userContext
                    ? _value.userContext
                    : userContext // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>,
            notificationType:
                freezed == notificationType
                    ? _value.notificationType
                    : notificationType // ignore: cast_nullable_to_non_nullable
                        as String?,
            additionalData:
                freezed == additionalData
                    ? _value.additionalData
                    : additionalData // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NotificationRequestImplCopyWith<$Res>
    implements $NotificationRequestCopyWith<$Res> {
  factory _$$NotificationRequestImplCopyWith(
    _$NotificationRequestImpl value,
    $Res Function(_$NotificationRequestImpl) then,
  ) = __$$NotificationRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String userId,
    Map<String, dynamic> userContext,
    String? notificationType,
    Map<String, dynamic>? additionalData,
  });
}

/// @nodoc
class __$$NotificationRequestImplCopyWithImpl<$Res>
    extends _$NotificationRequestCopyWithImpl<$Res, _$NotificationRequestImpl>
    implements _$$NotificationRequestImplCopyWith<$Res> {
  __$$NotificationRequestImplCopyWithImpl(
    _$NotificationRequestImpl _value,
    $Res Function(_$NotificationRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NotificationRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? userContext = null,
    Object? notificationType = freezed,
    Object? additionalData = freezed,
  }) {
    return _then(
      _$NotificationRequestImpl(
        userId:
            null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                    as String,
        userContext:
            null == userContext
                ? _value._userContext
                : userContext // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>,
        notificationType:
            freezed == notificationType
                ? _value.notificationType
                : notificationType // ignore: cast_nullable_to_non_nullable
                    as String?,
        additionalData:
            freezed == additionalData
                ? _value._additionalData
                : additionalData // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationRequestImpl implements _NotificationRequest {
  const _$NotificationRequestImpl({
    required this.userId,
    required final Map<String, dynamic> userContext,
    this.notificationType,
    final Map<String, dynamic>? additionalData,
  }) : _userContext = userContext,
       _additionalData = additionalData;

  factory _$NotificationRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationRequestImplFromJson(json);

  @override
  final String userId;
  final Map<String, dynamic> _userContext;
  @override
  Map<String, dynamic> get userContext {
    if (_userContext is EqualUnmodifiableMapView) return _userContext;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_userContext);
  }

  @override
  final String? notificationType;
  final Map<String, dynamic>? _additionalData;
  @override
  Map<String, dynamic>? get additionalData {
    final value = _additionalData;
    if (value == null) return null;
    if (_additionalData is EqualUnmodifiableMapView) return _additionalData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'NotificationRequest(userId: $userId, userContext: $userContext, notificationType: $notificationType, additionalData: $additionalData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationRequestImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            const DeepCollectionEquality().equals(
              other._userContext,
              _userContext,
            ) &&
            (identical(other.notificationType, notificationType) ||
                other.notificationType == notificationType) &&
            const DeepCollectionEquality().equals(
              other._additionalData,
              _additionalData,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    const DeepCollectionEquality().hash(_userContext),
    notificationType,
    const DeepCollectionEquality().hash(_additionalData),
  );

  /// Create a copy of NotificationRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationRequestImplCopyWith<_$NotificationRequestImpl> get copyWith =>
      __$$NotificationRequestImplCopyWithImpl<_$NotificationRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationRequestImplToJson(this);
  }
}

abstract class _NotificationRequest implements NotificationRequest {
  const factory _NotificationRequest({
    required final String userId,
    required final Map<String, dynamic> userContext,
    final String? notificationType,
    final Map<String, dynamic>? additionalData,
  }) = _$NotificationRequestImpl;

  factory _NotificationRequest.fromJson(Map<String, dynamic> json) =
      _$NotificationRequestImpl.fromJson;

  @override
  String get userId;
  @override
  Map<String, dynamic> get userContext;
  @override
  String? get notificationType;
  @override
  Map<String, dynamic>? get additionalData;

  /// Create a copy of NotificationRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationRequestImplCopyWith<_$NotificationRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

N8NWorkflowRequest _$N8NWorkflowRequestFromJson(Map<String, dynamic> json) {
  return _N8NWorkflowRequest.fromJson(json);
}

/// @nodoc
mixin _$N8NWorkflowRequest {
  String get workflowId => throw _privateConstructorUsedError;
  Map<String, dynamic> get inputData => throw _privateConstructorUsedError;
  String? get webhookUrl => throw _privateConstructorUsedError;
  Map<String, String>? get headers => throw _privateConstructorUsedError;

  /// Serializes this N8NWorkflowRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of N8NWorkflowRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $N8NWorkflowRequestCopyWith<N8NWorkflowRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $N8NWorkflowRequestCopyWith<$Res> {
  factory $N8NWorkflowRequestCopyWith(
    N8NWorkflowRequest value,
    $Res Function(N8NWorkflowRequest) then,
  ) = _$N8NWorkflowRequestCopyWithImpl<$Res, N8NWorkflowRequest>;
  @useResult
  $Res call({
    String workflowId,
    Map<String, dynamic> inputData,
    String? webhookUrl,
    Map<String, String>? headers,
  });
}

/// @nodoc
class _$N8NWorkflowRequestCopyWithImpl<$Res, $Val extends N8NWorkflowRequest>
    implements $N8NWorkflowRequestCopyWith<$Res> {
  _$N8NWorkflowRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of N8NWorkflowRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workflowId = null,
    Object? inputData = null,
    Object? webhookUrl = freezed,
    Object? headers = freezed,
  }) {
    return _then(
      _value.copyWith(
            workflowId:
                null == workflowId
                    ? _value.workflowId
                    : workflowId // ignore: cast_nullable_to_non_nullable
                        as String,
            inputData:
                null == inputData
                    ? _value.inputData
                    : inputData // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>,
            webhookUrl:
                freezed == webhookUrl
                    ? _value.webhookUrl
                    : webhookUrl // ignore: cast_nullable_to_non_nullable
                        as String?,
            headers:
                freezed == headers
                    ? _value.headers
                    : headers // ignore: cast_nullable_to_non_nullable
                        as Map<String, String>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$N8NWorkflowRequestImplCopyWith<$Res>
    implements $N8NWorkflowRequestCopyWith<$Res> {
  factory _$$N8NWorkflowRequestImplCopyWith(
    _$N8NWorkflowRequestImpl value,
    $Res Function(_$N8NWorkflowRequestImpl) then,
  ) = __$$N8NWorkflowRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String workflowId,
    Map<String, dynamic> inputData,
    String? webhookUrl,
    Map<String, String>? headers,
  });
}

/// @nodoc
class __$$N8NWorkflowRequestImplCopyWithImpl<$Res>
    extends _$N8NWorkflowRequestCopyWithImpl<$Res, _$N8NWorkflowRequestImpl>
    implements _$$N8NWorkflowRequestImplCopyWith<$Res> {
  __$$N8NWorkflowRequestImplCopyWithImpl(
    _$N8NWorkflowRequestImpl _value,
    $Res Function(_$N8NWorkflowRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of N8NWorkflowRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workflowId = null,
    Object? inputData = null,
    Object? webhookUrl = freezed,
    Object? headers = freezed,
  }) {
    return _then(
      _$N8NWorkflowRequestImpl(
        workflowId:
            null == workflowId
                ? _value.workflowId
                : workflowId // ignore: cast_nullable_to_non_nullable
                    as String,
        inputData:
            null == inputData
                ? _value._inputData
                : inputData // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>,
        webhookUrl:
            freezed == webhookUrl
                ? _value.webhookUrl
                : webhookUrl // ignore: cast_nullable_to_non_nullable
                    as String?,
        headers:
            freezed == headers
                ? _value._headers
                : headers // ignore: cast_nullable_to_non_nullable
                    as Map<String, String>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$N8NWorkflowRequestImpl implements _N8NWorkflowRequest {
  const _$N8NWorkflowRequestImpl({
    required this.workflowId,
    required final Map<String, dynamic> inputData,
    this.webhookUrl,
    final Map<String, String>? headers,
  }) : _inputData = inputData,
       _headers = headers;

  factory _$N8NWorkflowRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$N8NWorkflowRequestImplFromJson(json);

  @override
  final String workflowId;
  final Map<String, dynamic> _inputData;
  @override
  Map<String, dynamic> get inputData {
    if (_inputData is EqualUnmodifiableMapView) return _inputData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_inputData);
  }

  @override
  final String? webhookUrl;
  final Map<String, String>? _headers;
  @override
  Map<String, String>? get headers {
    final value = _headers;
    if (value == null) return null;
    if (_headers is EqualUnmodifiableMapView) return _headers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'N8NWorkflowRequest(workflowId: $workflowId, inputData: $inputData, webhookUrl: $webhookUrl, headers: $headers)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$N8NWorkflowRequestImpl &&
            (identical(other.workflowId, workflowId) ||
                other.workflowId == workflowId) &&
            const DeepCollectionEquality().equals(
              other._inputData,
              _inputData,
            ) &&
            (identical(other.webhookUrl, webhookUrl) ||
                other.webhookUrl == webhookUrl) &&
            const DeepCollectionEquality().equals(other._headers, _headers));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    workflowId,
    const DeepCollectionEquality().hash(_inputData),
    webhookUrl,
    const DeepCollectionEquality().hash(_headers),
  );

  /// Create a copy of N8NWorkflowRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$N8NWorkflowRequestImplCopyWith<_$N8NWorkflowRequestImpl> get copyWith =>
      __$$N8NWorkflowRequestImplCopyWithImpl<_$N8NWorkflowRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$N8NWorkflowRequestImplToJson(this);
  }
}

abstract class _N8NWorkflowRequest implements N8NWorkflowRequest {
  const factory _N8NWorkflowRequest({
    required final String workflowId,
    required final Map<String, dynamic> inputData,
    final String? webhookUrl,
    final Map<String, String>? headers,
  }) = _$N8NWorkflowRequestImpl;

  factory _N8NWorkflowRequest.fromJson(Map<String, dynamic> json) =
      _$N8NWorkflowRequestImpl.fromJson;

  @override
  String get workflowId;
  @override
  Map<String, dynamic> get inputData;
  @override
  String? get webhookUrl;
  @override
  Map<String, String>? get headers;

  /// Create a copy of N8NWorkflowRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$N8NWorkflowRequestImplCopyWith<_$N8NWorkflowRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
