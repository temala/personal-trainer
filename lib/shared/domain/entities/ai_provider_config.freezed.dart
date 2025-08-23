// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_provider_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProviderConfig _$ProviderConfigFromJson(Map<String, dynamic> json) {
  return _ProviderConfig.fromJson(json);
}

/// @nodoc
mixin _$ProviderConfig {
  AIProviderType get type => throw _privateConstructorUsedError;
  String get apiKey => throw _privateConstructorUsedError;
  Map<String, dynamic> get additionalConfig =>
      throw _privateConstructorUsedError;
  bool get isEnabled => throw _privateConstructorUsedError;
  int get priority => throw _privateConstructorUsedError;
  String? get baseUrl => throw _privateConstructorUsedError;
  int get timeoutSeconds => throw _privateConstructorUsedError;

  /// Serializes this ProviderConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProviderConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProviderConfigCopyWith<ProviderConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProviderConfigCopyWith<$Res> {
  factory $ProviderConfigCopyWith(
    ProviderConfig value,
    $Res Function(ProviderConfig) then,
  ) = _$ProviderConfigCopyWithImpl<$Res, ProviderConfig>;
  @useResult
  $Res call({
    AIProviderType type,
    String apiKey,
    Map<String, dynamic> additionalConfig,
    bool isEnabled,
    int priority,
    String? baseUrl,
    int timeoutSeconds,
  });
}

/// @nodoc
class _$ProviderConfigCopyWithImpl<$Res, $Val extends ProviderConfig>
    implements $ProviderConfigCopyWith<$Res> {
  _$ProviderConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProviderConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? apiKey = null,
    Object? additionalConfig = null,
    Object? isEnabled = null,
    Object? priority = null,
    Object? baseUrl = freezed,
    Object? timeoutSeconds = null,
  }) {
    return _then(
      _value.copyWith(
            type:
                null == type
                    ? _value.type
                    : type // ignore: cast_nullable_to_non_nullable
                        as AIProviderType,
            apiKey:
                null == apiKey
                    ? _value.apiKey
                    : apiKey // ignore: cast_nullable_to_non_nullable
                        as String,
            additionalConfig:
                null == additionalConfig
                    ? _value.additionalConfig
                    : additionalConfig // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>,
            isEnabled:
                null == isEnabled
                    ? _value.isEnabled
                    : isEnabled // ignore: cast_nullable_to_non_nullable
                        as bool,
            priority:
                null == priority
                    ? _value.priority
                    : priority // ignore: cast_nullable_to_non_nullable
                        as int,
            baseUrl:
                freezed == baseUrl
                    ? _value.baseUrl
                    : baseUrl // ignore: cast_nullable_to_non_nullable
                        as String?,
            timeoutSeconds:
                null == timeoutSeconds
                    ? _value.timeoutSeconds
                    : timeoutSeconds // ignore: cast_nullable_to_non_nullable
                        as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProviderConfigImplCopyWith<$Res>
    implements $ProviderConfigCopyWith<$Res> {
  factory _$$ProviderConfigImplCopyWith(
    _$ProviderConfigImpl value,
    $Res Function(_$ProviderConfigImpl) then,
  ) = __$$ProviderConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    AIProviderType type,
    String apiKey,
    Map<String, dynamic> additionalConfig,
    bool isEnabled,
    int priority,
    String? baseUrl,
    int timeoutSeconds,
  });
}

/// @nodoc
class __$$ProviderConfigImplCopyWithImpl<$Res>
    extends _$ProviderConfigCopyWithImpl<$Res, _$ProviderConfigImpl>
    implements _$$ProviderConfigImplCopyWith<$Res> {
  __$$ProviderConfigImplCopyWithImpl(
    _$ProviderConfigImpl _value,
    $Res Function(_$ProviderConfigImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProviderConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? apiKey = null,
    Object? additionalConfig = null,
    Object? isEnabled = null,
    Object? priority = null,
    Object? baseUrl = freezed,
    Object? timeoutSeconds = null,
  }) {
    return _then(
      _$ProviderConfigImpl(
        type:
            null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                    as AIProviderType,
        apiKey:
            null == apiKey
                ? _value.apiKey
                : apiKey // ignore: cast_nullable_to_non_nullable
                    as String,
        additionalConfig:
            null == additionalConfig
                ? _value._additionalConfig
                : additionalConfig // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>,
        isEnabled:
            null == isEnabled
                ? _value.isEnabled
                : isEnabled // ignore: cast_nullable_to_non_nullable
                    as bool,
        priority:
            null == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                    as int,
        baseUrl:
            freezed == baseUrl
                ? _value.baseUrl
                : baseUrl // ignore: cast_nullable_to_non_nullable
                    as String?,
        timeoutSeconds:
            null == timeoutSeconds
                ? _value.timeoutSeconds
                : timeoutSeconds // ignore: cast_nullable_to_non_nullable
                    as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProviderConfigImpl implements _ProviderConfig {
  const _$ProviderConfigImpl({
    required this.type,
    required this.apiKey,
    required final Map<String, dynamic> additionalConfig,
    this.isEnabled = true,
    this.priority = 1,
    this.baseUrl,
    this.timeoutSeconds = 30,
  }) : _additionalConfig = additionalConfig;

  factory _$ProviderConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProviderConfigImplFromJson(json);

  @override
  final AIProviderType type;
  @override
  final String apiKey;
  final Map<String, dynamic> _additionalConfig;
  @override
  Map<String, dynamic> get additionalConfig {
    if (_additionalConfig is EqualUnmodifiableMapView) return _additionalConfig;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_additionalConfig);
  }

  @override
  @JsonKey()
  final bool isEnabled;
  @override
  @JsonKey()
  final int priority;
  @override
  final String? baseUrl;
  @override
  @JsonKey()
  final int timeoutSeconds;

  @override
  String toString() {
    return 'ProviderConfig(type: $type, apiKey: $apiKey, additionalConfig: $additionalConfig, isEnabled: $isEnabled, priority: $priority, baseUrl: $baseUrl, timeoutSeconds: $timeoutSeconds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProviderConfigImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.apiKey, apiKey) || other.apiKey == apiKey) &&
            const DeepCollectionEquality().equals(
              other._additionalConfig,
              _additionalConfig,
            ) &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.baseUrl, baseUrl) || other.baseUrl == baseUrl) &&
            (identical(other.timeoutSeconds, timeoutSeconds) ||
                other.timeoutSeconds == timeoutSeconds));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    type,
    apiKey,
    const DeepCollectionEquality().hash(_additionalConfig),
    isEnabled,
    priority,
    baseUrl,
    timeoutSeconds,
  );

  /// Create a copy of ProviderConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProviderConfigImplCopyWith<_$ProviderConfigImpl> get copyWith =>
      __$$ProviderConfigImplCopyWithImpl<_$ProviderConfigImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ProviderConfigImplToJson(this);
  }
}

abstract class _ProviderConfig implements ProviderConfig {
  const factory _ProviderConfig({
    required final AIProviderType type,
    required final String apiKey,
    required final Map<String, dynamic> additionalConfig,
    final bool isEnabled,
    final int priority,
    final String? baseUrl,
    final int timeoutSeconds,
  }) = _$ProviderConfigImpl;

  factory _ProviderConfig.fromJson(Map<String, dynamic> json) =
      _$ProviderConfigImpl.fromJson;

  @override
  AIProviderType get type;
  @override
  String get apiKey;
  @override
  Map<String, dynamic> get additionalConfig;
  @override
  bool get isEnabled;
  @override
  int get priority;
  @override
  String? get baseUrl;
  @override
  int get timeoutSeconds;

  /// Create a copy of ProviderConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProviderConfigImplCopyWith<_$ProviderConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AIConfiguration _$AIConfigurationFromJson(Map<String, dynamic> json) {
  return _AIConfiguration.fromJson(json);
}

/// @nodoc
mixin _$AIConfiguration {
  Map<AIProviderType, ProviderConfig> get providers =>
      throw _privateConstructorUsedError;
  AIProviderType get primaryProvider => throw _privateConstructorUsedError;
  List<AIProviderType> get fallbackProviders =>
      throw _privateConstructorUsedError;
  bool get enableFallback => throw _privateConstructorUsedError;
  int get maxRetries => throw _privateConstructorUsedError;

  /// Serializes this AIConfiguration to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AIConfiguration
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AIConfigurationCopyWith<AIConfiguration> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AIConfigurationCopyWith<$Res> {
  factory $AIConfigurationCopyWith(
    AIConfiguration value,
    $Res Function(AIConfiguration) then,
  ) = _$AIConfigurationCopyWithImpl<$Res, AIConfiguration>;
  @useResult
  $Res call({
    Map<AIProviderType, ProviderConfig> providers,
    AIProviderType primaryProvider,
    List<AIProviderType> fallbackProviders,
    bool enableFallback,
    int maxRetries,
  });
}

/// @nodoc
class _$AIConfigurationCopyWithImpl<$Res, $Val extends AIConfiguration>
    implements $AIConfigurationCopyWith<$Res> {
  _$AIConfigurationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AIConfiguration
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? providers = null,
    Object? primaryProvider = null,
    Object? fallbackProviders = null,
    Object? enableFallback = null,
    Object? maxRetries = null,
  }) {
    return _then(
      _value.copyWith(
            providers:
                null == providers
                    ? _value.providers
                    : providers // ignore: cast_nullable_to_non_nullable
                        as Map<AIProviderType, ProviderConfig>,
            primaryProvider:
                null == primaryProvider
                    ? _value.primaryProvider
                    : primaryProvider // ignore: cast_nullable_to_non_nullable
                        as AIProviderType,
            fallbackProviders:
                null == fallbackProviders
                    ? _value.fallbackProviders
                    : fallbackProviders // ignore: cast_nullable_to_non_nullable
                        as List<AIProviderType>,
            enableFallback:
                null == enableFallback
                    ? _value.enableFallback
                    : enableFallback // ignore: cast_nullable_to_non_nullable
                        as bool,
            maxRetries:
                null == maxRetries
                    ? _value.maxRetries
                    : maxRetries // ignore: cast_nullable_to_non_nullable
                        as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AIConfigurationImplCopyWith<$Res>
    implements $AIConfigurationCopyWith<$Res> {
  factory _$$AIConfigurationImplCopyWith(
    _$AIConfigurationImpl value,
    $Res Function(_$AIConfigurationImpl) then,
  ) = __$$AIConfigurationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    Map<AIProviderType, ProviderConfig> providers,
    AIProviderType primaryProvider,
    List<AIProviderType> fallbackProviders,
    bool enableFallback,
    int maxRetries,
  });
}

/// @nodoc
class __$$AIConfigurationImplCopyWithImpl<$Res>
    extends _$AIConfigurationCopyWithImpl<$Res, _$AIConfigurationImpl>
    implements _$$AIConfigurationImplCopyWith<$Res> {
  __$$AIConfigurationImplCopyWithImpl(
    _$AIConfigurationImpl _value,
    $Res Function(_$AIConfigurationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AIConfiguration
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? providers = null,
    Object? primaryProvider = null,
    Object? fallbackProviders = null,
    Object? enableFallback = null,
    Object? maxRetries = null,
  }) {
    return _then(
      _$AIConfigurationImpl(
        providers:
            null == providers
                ? _value._providers
                : providers // ignore: cast_nullable_to_non_nullable
                    as Map<AIProviderType, ProviderConfig>,
        primaryProvider:
            null == primaryProvider
                ? _value.primaryProvider
                : primaryProvider // ignore: cast_nullable_to_non_nullable
                    as AIProviderType,
        fallbackProviders:
            null == fallbackProviders
                ? _value._fallbackProviders
                : fallbackProviders // ignore: cast_nullable_to_non_nullable
                    as List<AIProviderType>,
        enableFallback:
            null == enableFallback
                ? _value.enableFallback
                : enableFallback // ignore: cast_nullable_to_non_nullable
                    as bool,
        maxRetries:
            null == maxRetries
                ? _value.maxRetries
                : maxRetries // ignore: cast_nullable_to_non_nullable
                    as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AIConfigurationImpl implements _AIConfiguration {
  const _$AIConfigurationImpl({
    required final Map<AIProviderType, ProviderConfig> providers,
    required this.primaryProvider,
    final List<AIProviderType> fallbackProviders = const [],
    this.enableFallback = true,
    this.maxRetries = 3,
  }) : _providers = providers,
       _fallbackProviders = fallbackProviders;

  factory _$AIConfigurationImpl.fromJson(Map<String, dynamic> json) =>
      _$$AIConfigurationImplFromJson(json);

  final Map<AIProviderType, ProviderConfig> _providers;
  @override
  Map<AIProviderType, ProviderConfig> get providers {
    if (_providers is EqualUnmodifiableMapView) return _providers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_providers);
  }

  @override
  final AIProviderType primaryProvider;
  final List<AIProviderType> _fallbackProviders;
  @override
  @JsonKey()
  List<AIProviderType> get fallbackProviders {
    if (_fallbackProviders is EqualUnmodifiableListView)
      return _fallbackProviders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_fallbackProviders);
  }

  @override
  @JsonKey()
  final bool enableFallback;
  @override
  @JsonKey()
  final int maxRetries;

  @override
  String toString() {
    return 'AIConfiguration(providers: $providers, primaryProvider: $primaryProvider, fallbackProviders: $fallbackProviders, enableFallback: $enableFallback, maxRetries: $maxRetries)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AIConfigurationImpl &&
            const DeepCollectionEquality().equals(
              other._providers,
              _providers,
            ) &&
            (identical(other.primaryProvider, primaryProvider) ||
                other.primaryProvider == primaryProvider) &&
            const DeepCollectionEquality().equals(
              other._fallbackProviders,
              _fallbackProviders,
            ) &&
            (identical(other.enableFallback, enableFallback) ||
                other.enableFallback == enableFallback) &&
            (identical(other.maxRetries, maxRetries) ||
                other.maxRetries == maxRetries));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_providers),
    primaryProvider,
    const DeepCollectionEquality().hash(_fallbackProviders),
    enableFallback,
    maxRetries,
  );

  /// Create a copy of AIConfiguration
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AIConfigurationImplCopyWith<_$AIConfigurationImpl> get copyWith =>
      __$$AIConfigurationImplCopyWithImpl<_$AIConfigurationImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AIConfigurationImplToJson(this);
  }
}

abstract class _AIConfiguration implements AIConfiguration {
  const factory _AIConfiguration({
    required final Map<AIProviderType, ProviderConfig> providers,
    required final AIProviderType primaryProvider,
    final List<AIProviderType> fallbackProviders,
    final bool enableFallback,
    final int maxRetries,
  }) = _$AIConfigurationImpl;

  factory _AIConfiguration.fromJson(Map<String, dynamic> json) =
      _$AIConfigurationImpl.fromJson;

  @override
  Map<AIProviderType, ProviderConfig> get providers;
  @override
  AIProviderType get primaryProvider;
  @override
  List<AIProviderType> get fallbackProviders;
  @override
  bool get enableFallback;
  @override
  int get maxRetries;

  /// Create a copy of AIConfiguration
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AIConfigurationImplCopyWith<_$AIConfigurationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProviderStatus _$ProviderStatusFromJson(Map<String, dynamic> json) {
  return _ProviderStatus.fromJson(json);
}

/// @nodoc
mixin _$ProviderStatus {
  AIProviderType get type => throw _privateConstructorUsedError;
  bool get isAvailable => throw _privateConstructorUsedError;
  DateTime get lastChecked => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  double? get responseTime => throw _privateConstructorUsedError;
  int? get successRate => throw _privateConstructorUsedError;

  /// Serializes this ProviderStatus to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProviderStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProviderStatusCopyWith<ProviderStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProviderStatusCopyWith<$Res> {
  factory $ProviderStatusCopyWith(
    ProviderStatus value,
    $Res Function(ProviderStatus) then,
  ) = _$ProviderStatusCopyWithImpl<$Res, ProviderStatus>;
  @useResult
  $Res call({
    AIProviderType type,
    bool isAvailable,
    DateTime lastChecked,
    String? errorMessage,
    double? responseTime,
    int? successRate,
  });
}

/// @nodoc
class _$ProviderStatusCopyWithImpl<$Res, $Val extends ProviderStatus>
    implements $ProviderStatusCopyWith<$Res> {
  _$ProviderStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProviderStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? isAvailable = null,
    Object? lastChecked = null,
    Object? errorMessage = freezed,
    Object? responseTime = freezed,
    Object? successRate = freezed,
  }) {
    return _then(
      _value.copyWith(
            type:
                null == type
                    ? _value.type
                    : type // ignore: cast_nullable_to_non_nullable
                        as AIProviderType,
            isAvailable:
                null == isAvailable
                    ? _value.isAvailable
                    : isAvailable // ignore: cast_nullable_to_non_nullable
                        as bool,
            lastChecked:
                null == lastChecked
                    ? _value.lastChecked
                    : lastChecked // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            errorMessage:
                freezed == errorMessage
                    ? _value.errorMessage
                    : errorMessage // ignore: cast_nullable_to_non_nullable
                        as String?,
            responseTime:
                freezed == responseTime
                    ? _value.responseTime
                    : responseTime // ignore: cast_nullable_to_non_nullable
                        as double?,
            successRate:
                freezed == successRate
                    ? _value.successRate
                    : successRate // ignore: cast_nullable_to_non_nullable
                        as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProviderStatusImplCopyWith<$Res>
    implements $ProviderStatusCopyWith<$Res> {
  factory _$$ProviderStatusImplCopyWith(
    _$ProviderStatusImpl value,
    $Res Function(_$ProviderStatusImpl) then,
  ) = __$$ProviderStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    AIProviderType type,
    bool isAvailable,
    DateTime lastChecked,
    String? errorMessage,
    double? responseTime,
    int? successRate,
  });
}

/// @nodoc
class __$$ProviderStatusImplCopyWithImpl<$Res>
    extends _$ProviderStatusCopyWithImpl<$Res, _$ProviderStatusImpl>
    implements _$$ProviderStatusImplCopyWith<$Res> {
  __$$ProviderStatusImplCopyWithImpl(
    _$ProviderStatusImpl _value,
    $Res Function(_$ProviderStatusImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProviderStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? isAvailable = null,
    Object? lastChecked = null,
    Object? errorMessage = freezed,
    Object? responseTime = freezed,
    Object? successRate = freezed,
  }) {
    return _then(
      _$ProviderStatusImpl(
        type:
            null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                    as AIProviderType,
        isAvailable:
            null == isAvailable
                ? _value.isAvailable
                : isAvailable // ignore: cast_nullable_to_non_nullable
                    as bool,
        lastChecked:
            null == lastChecked
                ? _value.lastChecked
                : lastChecked // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        errorMessage:
            freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                    as String?,
        responseTime:
            freezed == responseTime
                ? _value.responseTime
                : responseTime // ignore: cast_nullable_to_non_nullable
                    as double?,
        successRate:
            freezed == successRate
                ? _value.successRate
                : successRate // ignore: cast_nullable_to_non_nullable
                    as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProviderStatusImpl implements _ProviderStatus {
  const _$ProviderStatusImpl({
    required this.type,
    required this.isAvailable,
    required this.lastChecked,
    this.errorMessage,
    this.responseTime,
    this.successRate,
  });

  factory _$ProviderStatusImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProviderStatusImplFromJson(json);

  @override
  final AIProviderType type;
  @override
  final bool isAvailable;
  @override
  final DateTime lastChecked;
  @override
  final String? errorMessage;
  @override
  final double? responseTime;
  @override
  final int? successRate;

  @override
  String toString() {
    return 'ProviderStatus(type: $type, isAvailable: $isAvailable, lastChecked: $lastChecked, errorMessage: $errorMessage, responseTime: $responseTime, successRate: $successRate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProviderStatusImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable) &&
            (identical(other.lastChecked, lastChecked) ||
                other.lastChecked == lastChecked) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.responseTime, responseTime) ||
                other.responseTime == responseTime) &&
            (identical(other.successRate, successRate) ||
                other.successRate == successRate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    type,
    isAvailable,
    lastChecked,
    errorMessage,
    responseTime,
    successRate,
  );

  /// Create a copy of ProviderStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProviderStatusImplCopyWith<_$ProviderStatusImpl> get copyWith =>
      __$$ProviderStatusImplCopyWithImpl<_$ProviderStatusImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ProviderStatusImplToJson(this);
  }
}

abstract class _ProviderStatus implements ProviderStatus {
  const factory _ProviderStatus({
    required final AIProviderType type,
    required final bool isAvailable,
    required final DateTime lastChecked,
    final String? errorMessage,
    final double? responseTime,
    final int? successRate,
  }) = _$ProviderStatusImpl;

  factory _ProviderStatus.fromJson(Map<String, dynamic> json) =
      _$ProviderStatusImpl.fromJson;

  @override
  AIProviderType get type;
  @override
  bool get isAvailable;
  @override
  DateTime get lastChecked;
  @override
  String? get errorMessage;
  @override
  double? get responseTime;
  @override
  int? get successRate;

  /// Create a copy of ProviderStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProviderStatusImplCopyWith<_$ProviderStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
