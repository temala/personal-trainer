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

AIProviderConfig _$AIProviderConfigFromJson(Map<String, dynamic> json) {
  return _AIProviderConfig.fromJson(json);
}

/// @nodoc
mixin _$AIProviderConfig {
  AIProviderType get type => throw _privateConstructorUsedError;
  String get apiKey => throw _privateConstructorUsedError;
  Map<String, dynamic> get additionalConfig =>
      throw _privateConstructorUsedError;
  bool get isEnabled => throw _privateConstructorUsedError;
  int get priority => throw _privateConstructorUsedError;
  int get timeoutSeconds => throw _privateConstructorUsedError;
  int get maxRetries => throw _privateConstructorUsedError;
  String? get baseUrl => throw _privateConstructorUsedError;
  String? get model => throw _privateConstructorUsedError;
  String? get webhookUrl => throw _privateConstructorUsedError;
  String? get workflowId => throw _privateConstructorUsedError;

  /// Serializes this AIProviderConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AIProviderConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AIProviderConfigCopyWith<AIProviderConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AIProviderConfigCopyWith<$Res> {
  factory $AIProviderConfigCopyWith(
    AIProviderConfig value,
    $Res Function(AIProviderConfig) then,
  ) = _$AIProviderConfigCopyWithImpl<$Res, AIProviderConfig>;
  @useResult
  $Res call({
    AIProviderType type,
    String apiKey,
    Map<String, dynamic> additionalConfig,
    bool isEnabled,
    int priority,
    int timeoutSeconds,
    int maxRetries,
    String? baseUrl,
    String? model,
    String? webhookUrl,
    String? workflowId,
  });
}

/// @nodoc
class _$AIProviderConfigCopyWithImpl<$Res, $Val extends AIProviderConfig>
    implements $AIProviderConfigCopyWith<$Res> {
  _$AIProviderConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AIProviderConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? apiKey = null,
    Object? additionalConfig = null,
    Object? isEnabled = null,
    Object? priority = null,
    Object? timeoutSeconds = null,
    Object? maxRetries = null,
    Object? baseUrl = freezed,
    Object? model = freezed,
    Object? webhookUrl = freezed,
    Object? workflowId = freezed,
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
            timeoutSeconds:
                null == timeoutSeconds
                    ? _value.timeoutSeconds
                    : timeoutSeconds // ignore: cast_nullable_to_non_nullable
                        as int,
            maxRetries:
                null == maxRetries
                    ? _value.maxRetries
                    : maxRetries // ignore: cast_nullable_to_non_nullable
                        as int,
            baseUrl:
                freezed == baseUrl
                    ? _value.baseUrl
                    : baseUrl // ignore: cast_nullable_to_non_nullable
                        as String?,
            model:
                freezed == model
                    ? _value.model
                    : model // ignore: cast_nullable_to_non_nullable
                        as String?,
            webhookUrl:
                freezed == webhookUrl
                    ? _value.webhookUrl
                    : webhookUrl // ignore: cast_nullable_to_non_nullable
                        as String?,
            workflowId:
                freezed == workflowId
                    ? _value.workflowId
                    : workflowId // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AIProviderConfigImplCopyWith<$Res>
    implements $AIProviderConfigCopyWith<$Res> {
  factory _$$AIProviderConfigImplCopyWith(
    _$AIProviderConfigImpl value,
    $Res Function(_$AIProviderConfigImpl) then,
  ) = __$$AIProviderConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    AIProviderType type,
    String apiKey,
    Map<String, dynamic> additionalConfig,
    bool isEnabled,
    int priority,
    int timeoutSeconds,
    int maxRetries,
    String? baseUrl,
    String? model,
    String? webhookUrl,
    String? workflowId,
  });
}

/// @nodoc
class __$$AIProviderConfigImplCopyWithImpl<$Res>
    extends _$AIProviderConfigCopyWithImpl<$Res, _$AIProviderConfigImpl>
    implements _$$AIProviderConfigImplCopyWith<$Res> {
  __$$AIProviderConfigImplCopyWithImpl(
    _$AIProviderConfigImpl _value,
    $Res Function(_$AIProviderConfigImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AIProviderConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? apiKey = null,
    Object? additionalConfig = null,
    Object? isEnabled = null,
    Object? priority = null,
    Object? timeoutSeconds = null,
    Object? maxRetries = null,
    Object? baseUrl = freezed,
    Object? model = freezed,
    Object? webhookUrl = freezed,
    Object? workflowId = freezed,
  }) {
    return _then(
      _$AIProviderConfigImpl(
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
        timeoutSeconds:
            null == timeoutSeconds
                ? _value.timeoutSeconds
                : timeoutSeconds // ignore: cast_nullable_to_non_nullable
                    as int,
        maxRetries:
            null == maxRetries
                ? _value.maxRetries
                : maxRetries // ignore: cast_nullable_to_non_nullable
                    as int,
        baseUrl:
            freezed == baseUrl
                ? _value.baseUrl
                : baseUrl // ignore: cast_nullable_to_non_nullable
                    as String?,
        model:
            freezed == model
                ? _value.model
                : model // ignore: cast_nullable_to_non_nullable
                    as String?,
        webhookUrl:
            freezed == webhookUrl
                ? _value.webhookUrl
                : webhookUrl // ignore: cast_nullable_to_non_nullable
                    as String?,
        workflowId:
            freezed == workflowId
                ? _value.workflowId
                : workflowId // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AIProviderConfigImpl implements _AIProviderConfig {
  const _$AIProviderConfigImpl({
    required this.type,
    required this.apiKey,
    final Map<String, dynamic> additionalConfig = const {},
    this.isEnabled = true,
    this.priority = 1,
    this.timeoutSeconds = 30,
    this.maxRetries = 3,
    this.baseUrl,
    this.model,
    this.webhookUrl,
    this.workflowId,
  }) : _additionalConfig = additionalConfig;

  factory _$AIProviderConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$AIProviderConfigImplFromJson(json);

  @override
  final AIProviderType type;
  @override
  final String apiKey;
  final Map<String, dynamic> _additionalConfig;
  @override
  @JsonKey()
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
  @JsonKey()
  final int timeoutSeconds;
  @override
  @JsonKey()
  final int maxRetries;
  @override
  final String? baseUrl;
  @override
  final String? model;
  @override
  final String? webhookUrl;
  @override
  final String? workflowId;

  @override
  String toString() {
    return 'AIProviderConfig(type: $type, apiKey: $apiKey, additionalConfig: $additionalConfig, isEnabled: $isEnabled, priority: $priority, timeoutSeconds: $timeoutSeconds, maxRetries: $maxRetries, baseUrl: $baseUrl, model: $model, webhookUrl: $webhookUrl, workflowId: $workflowId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AIProviderConfigImpl &&
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
            (identical(other.timeoutSeconds, timeoutSeconds) ||
                other.timeoutSeconds == timeoutSeconds) &&
            (identical(other.maxRetries, maxRetries) ||
                other.maxRetries == maxRetries) &&
            (identical(other.baseUrl, baseUrl) || other.baseUrl == baseUrl) &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.webhookUrl, webhookUrl) ||
                other.webhookUrl == webhookUrl) &&
            (identical(other.workflowId, workflowId) ||
                other.workflowId == workflowId));
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
    timeoutSeconds,
    maxRetries,
    baseUrl,
    model,
    webhookUrl,
    workflowId,
  );

  /// Create a copy of AIProviderConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AIProviderConfigImplCopyWith<_$AIProviderConfigImpl> get copyWith =>
      __$$AIProviderConfigImplCopyWithImpl<_$AIProviderConfigImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AIProviderConfigImplToJson(this);
  }
}

abstract class _AIProviderConfig implements AIProviderConfig {
  const factory _AIProviderConfig({
    required final AIProviderType type,
    required final String apiKey,
    final Map<String, dynamic> additionalConfig,
    final bool isEnabled,
    final int priority,
    final int timeoutSeconds,
    final int maxRetries,
    final String? baseUrl,
    final String? model,
    final String? webhookUrl,
    final String? workflowId,
  }) = _$AIProviderConfigImpl;

  factory _AIProviderConfig.fromJson(Map<String, dynamic> json) =
      _$AIProviderConfigImpl.fromJson;

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
  int get timeoutSeconds;
  @override
  int get maxRetries;
  @override
  String? get baseUrl;
  @override
  String? get model;
  @override
  String? get webhookUrl;
  @override
  String? get workflowId;

  /// Create a copy of AIProviderConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AIProviderConfigImplCopyWith<_$AIProviderConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AIConfiguration _$AIConfigurationFromJson(Map<String, dynamic> json) {
  return _AIConfiguration.fromJson(json);
}

/// @nodoc
mixin _$AIConfiguration {
  Map<AIProviderType, AIProviderConfig> get providers =>
      throw _privateConstructorUsedError;
  AIProviderType get primaryProvider => throw _privateConstructorUsedError;
  List<AIProviderType> get fallbackProviders =>
      throw _privateConstructorUsedError;
  bool get enableFallback => throw _privateConstructorUsedError;
  int get requestTimeoutSeconds => throw _privateConstructorUsedError;

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
    Map<AIProviderType, AIProviderConfig> providers,
    AIProviderType primaryProvider,
    List<AIProviderType> fallbackProviders,
    bool enableFallback,
    int requestTimeoutSeconds,
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
    Object? requestTimeoutSeconds = null,
  }) {
    return _then(
      _value.copyWith(
            providers:
                null == providers
                    ? _value.providers
                    : providers // ignore: cast_nullable_to_non_nullable
                        as Map<AIProviderType, AIProviderConfig>,
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
            requestTimeoutSeconds:
                null == requestTimeoutSeconds
                    ? _value.requestTimeoutSeconds
                    : requestTimeoutSeconds // ignore: cast_nullable_to_non_nullable
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
    Map<AIProviderType, AIProviderConfig> providers,
    AIProviderType primaryProvider,
    List<AIProviderType> fallbackProviders,
    bool enableFallback,
    int requestTimeoutSeconds,
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
    Object? requestTimeoutSeconds = null,
  }) {
    return _then(
      _$AIConfigurationImpl(
        providers:
            null == providers
                ? _value._providers
                : providers // ignore: cast_nullable_to_non_nullable
                    as Map<AIProviderType, AIProviderConfig>,
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
        requestTimeoutSeconds:
            null == requestTimeoutSeconds
                ? _value.requestTimeoutSeconds
                : requestTimeoutSeconds // ignore: cast_nullable_to_non_nullable
                    as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AIConfigurationImpl implements _AIConfiguration {
  const _$AIConfigurationImpl({
    required final Map<AIProviderType, AIProviderConfig> providers,
    required this.primaryProvider,
    final List<AIProviderType> fallbackProviders = const [],
    this.enableFallback = true,
    this.requestTimeoutSeconds = 10,
  }) : _providers = providers,
       _fallbackProviders = fallbackProviders;

  factory _$AIConfigurationImpl.fromJson(Map<String, dynamic> json) =>
      _$$AIConfigurationImplFromJson(json);

  final Map<AIProviderType, AIProviderConfig> _providers;
  @override
  Map<AIProviderType, AIProviderConfig> get providers {
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
  final int requestTimeoutSeconds;

  @override
  String toString() {
    return 'AIConfiguration(providers: $providers, primaryProvider: $primaryProvider, fallbackProviders: $fallbackProviders, enableFallback: $enableFallback, requestTimeoutSeconds: $requestTimeoutSeconds)';
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
            (identical(other.requestTimeoutSeconds, requestTimeoutSeconds) ||
                other.requestTimeoutSeconds == requestTimeoutSeconds));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_providers),
    primaryProvider,
    const DeepCollectionEquality().hash(_fallbackProviders),
    enableFallback,
    requestTimeoutSeconds,
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
    required final Map<AIProviderType, AIProviderConfig> providers,
    required final AIProviderType primaryProvider,
    final List<AIProviderType> fallbackProviders,
    final bool enableFallback,
    final int requestTimeoutSeconds,
  }) = _$AIConfigurationImpl;

  factory _AIConfiguration.fromJson(Map<String, dynamic> json) =
      _$AIConfigurationImpl.fromJson;

  @override
  Map<AIProviderType, AIProviderConfig> get providers;
  @override
  AIProviderType get primaryProvider;
  @override
  List<AIProviderType> get fallbackProviders;
  @override
  bool get enableFallback;
  @override
  int get requestTimeoutSeconds;

  /// Create a copy of AIConfiguration
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AIConfigurationImplCopyWith<_$AIConfigurationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
