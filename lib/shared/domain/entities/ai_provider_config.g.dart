// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_provider_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProviderConfigImpl _$$ProviderConfigImplFromJson(Map<String, dynamic> json) =>
    _$ProviderConfigImpl(
      type: $enumDecode(_$AIProviderTypeEnumMap, json['type']),
      apiKey: json['apiKey'] as String,
      additionalConfig: json['additionalConfig'] as Map<String, dynamic>,
      isEnabled: json['isEnabled'] as bool? ?? true,
      priority: (json['priority'] as num?)?.toInt() ?? 1,
      baseUrl: json['baseUrl'] as String?,
      timeoutSeconds: (json['timeoutSeconds'] as num?)?.toInt() ?? 30,
    );

Map<String, dynamic> _$$ProviderConfigImplToJson(
  _$ProviderConfigImpl instance,
) => <String, dynamic>{
  'type': _$AIProviderTypeEnumMap[instance.type]!,
  'apiKey': instance.apiKey,
  'additionalConfig': instance.additionalConfig,
  'isEnabled': instance.isEnabled,
  'priority': instance.priority,
  'baseUrl': instance.baseUrl,
  'timeoutSeconds': instance.timeoutSeconds,
};

const _$AIProviderTypeEnumMap = {
  AIProviderType.chatgpt: 'chatgpt',
  AIProviderType.n8nWorkflow: 'n8n_workflow',
  AIProviderType.claude: 'claude',
  AIProviderType.gemini: 'gemini',
  AIProviderType.custom: 'custom',
};

_$AIConfigurationImpl _$$AIConfigurationImplFromJson(
  Map<String, dynamic> json,
) => _$AIConfigurationImpl(
  providers: (json['providers'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(
      $enumDecode(_$AIProviderTypeEnumMap, k),
      ProviderConfig.fromJson(e as Map<String, dynamic>),
    ),
  ),
  primaryProvider: $enumDecode(
    _$AIProviderTypeEnumMap,
    json['primaryProvider'],
  ),
  fallbackProviders:
      (json['fallbackProviders'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$AIProviderTypeEnumMap, e))
          .toList() ??
      const [],
  enableFallback: json['enableFallback'] as bool? ?? true,
  maxRetries: (json['maxRetries'] as num?)?.toInt() ?? 3,
);

Map<String, dynamic> _$$AIConfigurationImplToJson(
  _$AIConfigurationImpl instance,
) => <String, dynamic>{
  'providers': instance.providers.map(
    (k, e) => MapEntry(_$AIProviderTypeEnumMap[k]!, e),
  ),
  'primaryProvider': _$AIProviderTypeEnumMap[instance.primaryProvider]!,
  'fallbackProviders':
      instance.fallbackProviders
          .map((e) => _$AIProviderTypeEnumMap[e]!)
          .toList(),
  'enableFallback': instance.enableFallback,
  'maxRetries': instance.maxRetries,
};

_$ProviderStatusImpl _$$ProviderStatusImplFromJson(Map<String, dynamic> json) =>
    _$ProviderStatusImpl(
      type: $enumDecode(_$AIProviderTypeEnumMap, json['type']),
      isAvailable: json['isAvailable'] as bool,
      lastChecked: DateTime.parse(json['lastChecked'] as String),
      errorMessage: json['errorMessage'] as String?,
      responseTime: (json['responseTime'] as num?)?.toDouble(),
      successRate: (json['successRate'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$ProviderStatusImplToJson(
  _$ProviderStatusImpl instance,
) => <String, dynamic>{
  'type': _$AIProviderTypeEnumMap[instance.type]!,
  'isAvailable': instance.isAvailable,
  'lastChecked': instance.lastChecked.toIso8601String(),
  'errorMessage': instance.errorMessage,
  'responseTime': instance.responseTime,
  'successRate': instance.successRate,
};
