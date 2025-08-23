// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_provider_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AIProviderConfigImpl _$$AIProviderConfigImplFromJson(
  Map<String, dynamic> json,
) => _$AIProviderConfigImpl(
  type: $enumDecode(_$AIProviderTypeEnumMap, json['type']),
  apiKey: json['apiKey'] as String,
  additionalConfig:
      json['additionalConfig'] as Map<String, dynamic>? ?? const {},
  isEnabled: json['isEnabled'] as bool? ?? true,
  priority: (json['priority'] as num?)?.toInt() ?? 1,
  timeoutSeconds: (json['timeoutSeconds'] as num?)?.toInt() ?? 30,
  maxRetries: (json['maxRetries'] as num?)?.toInt() ?? 3,
  baseUrl: json['baseUrl'] as String?,
  model: json['model'] as String?,
  webhookUrl: json['webhookUrl'] as String?,
  workflowId: json['workflowId'] as String?,
);

Map<String, dynamic> _$$AIProviderConfigImplToJson(
  _$AIProviderConfigImpl instance,
) => <String, dynamic>{
  'type': _$AIProviderTypeEnumMap[instance.type]!,
  'apiKey': instance.apiKey,
  'additionalConfig': instance.additionalConfig,
  'isEnabled': instance.isEnabled,
  'priority': instance.priority,
  'timeoutSeconds': instance.timeoutSeconds,
  'maxRetries': instance.maxRetries,
  'baseUrl': instance.baseUrl,
  'model': instance.model,
  'webhookUrl': instance.webhookUrl,
  'workflowId': instance.workflowId,
};

const _$AIProviderTypeEnumMap = {
  AIProviderType.chatgpt: 'chatgpt',
  AIProviderType.n8nWorkflow: 'n8nWorkflow',
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
      AIProviderConfig.fromJson(e as Map<String, dynamic>),
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
  requestTimeoutSeconds: (json['requestTimeoutSeconds'] as num?)?.toInt() ?? 10,
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
  'requestTimeoutSeconds': instance.requestTimeoutSeconds,
};
