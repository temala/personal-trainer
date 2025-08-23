// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) {
  return _UserProfile.fromJson(json);
}

/// @nodoc
mixin _$UserProfile {
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get age => throw _privateConstructorUsedError;
  double get height => throw _privateConstructorUsedError; // in cm
  double get weight => throw _privateConstructorUsedError; // in kg
  double get targetWeight => throw _privateConstructorUsedError; // in kg
  FitnessGoal get fitnessGoal => throw _privateConstructorUsedError;
  ActivityLevel get activityLevel => throw _privateConstructorUsedError;
  List<String> get preferredExerciseTypes => throw _privateConstructorUsedError;
  List<String> get dislikedExercises => throw _privateConstructorUsedError;
  Map<String, dynamic> get preferences => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;
  bool? get isPremium => throw _privateConstructorUsedError;
  DateTime? get premiumExpiresAt => throw _privateConstructorUsedError;
  String? get fcmToken => throw _privateConstructorUsedError;
  Map<String, dynamic>? get aiProviderConfig =>
      throw _privateConstructorUsedError;

  /// Serializes this UserProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserProfileCopyWith<UserProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileCopyWith<$Res> {
  factory $UserProfileCopyWith(
    UserProfile value,
    $Res Function(UserProfile) then,
  ) = _$UserProfileCopyWithImpl<$Res, UserProfile>;
  @useResult
  $Res call({
    String id,
    String email,
    String name,
    int age,
    double height,
    double weight,
    double targetWeight,
    FitnessGoal fitnessGoal,
    ActivityLevel activityLevel,
    List<String> preferredExerciseTypes,
    List<String> dislikedExercises,
    Map<String, dynamic> preferences,
    DateTime createdAt,
    DateTime updatedAt,
    String? avatarUrl,
    bool? isPremium,
    DateTime? premiumExpiresAt,
    String? fcmToken,
    Map<String, dynamic>? aiProviderConfig,
  });
}

/// @nodoc
class _$UserProfileCopyWithImpl<$Res, $Val extends UserProfile>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? name = null,
    Object? age = null,
    Object? height = null,
    Object? weight = null,
    Object? targetWeight = null,
    Object? fitnessGoal = null,
    Object? activityLevel = null,
    Object? preferredExerciseTypes = null,
    Object? dislikedExercises = null,
    Object? preferences = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? avatarUrl = freezed,
    Object? isPremium = freezed,
    Object? premiumExpiresAt = freezed,
    Object? fcmToken = freezed,
    Object? aiProviderConfig = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            email:
                null == email
                    ? _value.email
                    : email // ignore: cast_nullable_to_non_nullable
                        as String,
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            age:
                null == age
                    ? _value.age
                    : age // ignore: cast_nullable_to_non_nullable
                        as int,
            height:
                null == height
                    ? _value.height
                    : height // ignore: cast_nullable_to_non_nullable
                        as double,
            weight:
                null == weight
                    ? _value.weight
                    : weight // ignore: cast_nullable_to_non_nullable
                        as double,
            targetWeight:
                null == targetWeight
                    ? _value.targetWeight
                    : targetWeight // ignore: cast_nullable_to_non_nullable
                        as double,
            fitnessGoal:
                null == fitnessGoal
                    ? _value.fitnessGoal
                    : fitnessGoal // ignore: cast_nullable_to_non_nullable
                        as FitnessGoal,
            activityLevel:
                null == activityLevel
                    ? _value.activityLevel
                    : activityLevel // ignore: cast_nullable_to_non_nullable
                        as ActivityLevel,
            preferredExerciseTypes:
                null == preferredExerciseTypes
                    ? _value.preferredExerciseTypes
                    : preferredExerciseTypes // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            dislikedExercises:
                null == dislikedExercises
                    ? _value.dislikedExercises
                    : dislikedExercises // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            preferences:
                null == preferences
                    ? _value.preferences
                    : preferences // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>,
            createdAt:
                null == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            updatedAt:
                null == updatedAt
                    ? _value.updatedAt
                    : updatedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            avatarUrl:
                freezed == avatarUrl
                    ? _value.avatarUrl
                    : avatarUrl // ignore: cast_nullable_to_non_nullable
                        as String?,
            isPremium:
                freezed == isPremium
                    ? _value.isPremium
                    : isPremium // ignore: cast_nullable_to_non_nullable
                        as bool?,
            premiumExpiresAt:
                freezed == premiumExpiresAt
                    ? _value.premiumExpiresAt
                    : premiumExpiresAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            fcmToken:
                freezed == fcmToken
                    ? _value.fcmToken
                    : fcmToken // ignore: cast_nullable_to_non_nullable
                        as String?,
            aiProviderConfig:
                freezed == aiProviderConfig
                    ? _value.aiProviderConfig
                    : aiProviderConfig // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserProfileImplCopyWith<$Res>
    implements $UserProfileCopyWith<$Res> {
  factory _$$UserProfileImplCopyWith(
    _$UserProfileImpl value,
    $Res Function(_$UserProfileImpl) then,
  ) = __$$UserProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String email,
    String name,
    int age,
    double height,
    double weight,
    double targetWeight,
    FitnessGoal fitnessGoal,
    ActivityLevel activityLevel,
    List<String> preferredExerciseTypes,
    List<String> dislikedExercises,
    Map<String, dynamic> preferences,
    DateTime createdAt,
    DateTime updatedAt,
    String? avatarUrl,
    bool? isPremium,
    DateTime? premiumExpiresAt,
    String? fcmToken,
    Map<String, dynamic>? aiProviderConfig,
  });
}

/// @nodoc
class __$$UserProfileImplCopyWithImpl<$Res>
    extends _$UserProfileCopyWithImpl<$Res, _$UserProfileImpl>
    implements _$$UserProfileImplCopyWith<$Res> {
  __$$UserProfileImplCopyWithImpl(
    _$UserProfileImpl _value,
    $Res Function(_$UserProfileImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? name = null,
    Object? age = null,
    Object? height = null,
    Object? weight = null,
    Object? targetWeight = null,
    Object? fitnessGoal = null,
    Object? activityLevel = null,
    Object? preferredExerciseTypes = null,
    Object? dislikedExercises = null,
    Object? preferences = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? avatarUrl = freezed,
    Object? isPremium = freezed,
    Object? premiumExpiresAt = freezed,
    Object? fcmToken = freezed,
    Object? aiProviderConfig = freezed,
  }) {
    return _then(
      _$UserProfileImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        email:
            null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                    as String,
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        age:
            null == age
                ? _value.age
                : age // ignore: cast_nullable_to_non_nullable
                    as int,
        height:
            null == height
                ? _value.height
                : height // ignore: cast_nullable_to_non_nullable
                    as double,
        weight:
            null == weight
                ? _value.weight
                : weight // ignore: cast_nullable_to_non_nullable
                    as double,
        targetWeight:
            null == targetWeight
                ? _value.targetWeight
                : targetWeight // ignore: cast_nullable_to_non_nullable
                    as double,
        fitnessGoal:
            null == fitnessGoal
                ? _value.fitnessGoal
                : fitnessGoal // ignore: cast_nullable_to_non_nullable
                    as FitnessGoal,
        activityLevel:
            null == activityLevel
                ? _value.activityLevel
                : activityLevel // ignore: cast_nullable_to_non_nullable
                    as ActivityLevel,
        preferredExerciseTypes:
            null == preferredExerciseTypes
                ? _value._preferredExerciseTypes
                : preferredExerciseTypes // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        dislikedExercises:
            null == dislikedExercises
                ? _value._dislikedExercises
                : dislikedExercises // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        preferences:
            null == preferences
                ? _value._preferences
                : preferences // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>,
        createdAt:
            null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        updatedAt:
            null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        avatarUrl:
            freezed == avatarUrl
                ? _value.avatarUrl
                : avatarUrl // ignore: cast_nullable_to_non_nullable
                    as String?,
        isPremium:
            freezed == isPremium
                ? _value.isPremium
                : isPremium // ignore: cast_nullable_to_non_nullable
                    as bool?,
        premiumExpiresAt:
            freezed == premiumExpiresAt
                ? _value.premiumExpiresAt
                : premiumExpiresAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        fcmToken:
            freezed == fcmToken
                ? _value.fcmToken
                : fcmToken // ignore: cast_nullable_to_non_nullable
                    as String?,
        aiProviderConfig:
            freezed == aiProviderConfig
                ? _value._aiProviderConfig
                : aiProviderConfig // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserProfileImpl implements _UserProfile {
  const _$UserProfileImpl({
    required this.id,
    required this.email,
    required this.name,
    required this.age,
    required this.height,
    required this.weight,
    required this.targetWeight,
    required this.fitnessGoal,
    required this.activityLevel,
    required final List<String> preferredExerciseTypes,
    required final List<String> dislikedExercises,
    required final Map<String, dynamic> preferences,
    required this.createdAt,
    required this.updatedAt,
    this.avatarUrl,
    this.isPremium,
    this.premiumExpiresAt,
    this.fcmToken,
    final Map<String, dynamic>? aiProviderConfig,
  }) : _preferredExerciseTypes = preferredExerciseTypes,
       _dislikedExercises = dislikedExercises,
       _preferences = preferences,
       _aiProviderConfig = aiProviderConfig;

  factory _$UserProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProfileImplFromJson(json);

  @override
  final String id;
  @override
  final String email;
  @override
  final String name;
  @override
  final int age;
  @override
  final double height;
  // in cm
  @override
  final double weight;
  // in kg
  @override
  final double targetWeight;
  // in kg
  @override
  final FitnessGoal fitnessGoal;
  @override
  final ActivityLevel activityLevel;
  final List<String> _preferredExerciseTypes;
  @override
  List<String> get preferredExerciseTypes {
    if (_preferredExerciseTypes is EqualUnmodifiableListView)
      return _preferredExerciseTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_preferredExerciseTypes);
  }

  final List<String> _dislikedExercises;
  @override
  List<String> get dislikedExercises {
    if (_dislikedExercises is EqualUnmodifiableListView)
      return _dislikedExercises;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dislikedExercises);
  }

  final Map<String, dynamic> _preferences;
  @override
  Map<String, dynamic> get preferences {
    if (_preferences is EqualUnmodifiableMapView) return _preferences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_preferences);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final String? avatarUrl;
  @override
  final bool? isPremium;
  @override
  final DateTime? premiumExpiresAt;
  @override
  final String? fcmToken;
  final Map<String, dynamic>? _aiProviderConfig;
  @override
  Map<String, dynamic>? get aiProviderConfig {
    final value = _aiProviderConfig;
    if (value == null) return null;
    if (_aiProviderConfig is EqualUnmodifiableMapView) return _aiProviderConfig;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'UserProfile(id: $id, email: $email, name: $name, age: $age, height: $height, weight: $weight, targetWeight: $targetWeight, fitnessGoal: $fitnessGoal, activityLevel: $activityLevel, preferredExerciseTypes: $preferredExerciseTypes, dislikedExercises: $dislikedExercises, preferences: $preferences, createdAt: $createdAt, updatedAt: $updatedAt, avatarUrl: $avatarUrl, isPremium: $isPremium, premiumExpiresAt: $premiumExpiresAt, fcmToken: $fcmToken, aiProviderConfig: $aiProviderConfig)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.age, age) || other.age == age) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.targetWeight, targetWeight) ||
                other.targetWeight == targetWeight) &&
            (identical(other.fitnessGoal, fitnessGoal) ||
                other.fitnessGoal == fitnessGoal) &&
            (identical(other.activityLevel, activityLevel) ||
                other.activityLevel == activityLevel) &&
            const DeepCollectionEquality().equals(
              other._preferredExerciseTypes,
              _preferredExerciseTypes,
            ) &&
            const DeepCollectionEquality().equals(
              other._dislikedExercises,
              _dislikedExercises,
            ) &&
            const DeepCollectionEquality().equals(
              other._preferences,
              _preferences,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.isPremium, isPremium) ||
                other.isPremium == isPremium) &&
            (identical(other.premiumExpiresAt, premiumExpiresAt) ||
                other.premiumExpiresAt == premiumExpiresAt) &&
            (identical(other.fcmToken, fcmToken) ||
                other.fcmToken == fcmToken) &&
            const DeepCollectionEquality().equals(
              other._aiProviderConfig,
              _aiProviderConfig,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    email,
    name,
    age,
    height,
    weight,
    targetWeight,
    fitnessGoal,
    activityLevel,
    const DeepCollectionEquality().hash(_preferredExerciseTypes),
    const DeepCollectionEquality().hash(_dislikedExercises),
    const DeepCollectionEquality().hash(_preferences),
    createdAt,
    updatedAt,
    avatarUrl,
    isPremium,
    premiumExpiresAt,
    fcmToken,
    const DeepCollectionEquality().hash(_aiProviderConfig),
  ]);

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      __$$UserProfileImplCopyWithImpl<_$UserProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserProfileImplToJson(this);
  }
}

abstract class _UserProfile implements UserProfile {
  const factory _UserProfile({
    required final String id,
    required final String email,
    required final String name,
    required final int age,
    required final double height,
    required final double weight,
    required final double targetWeight,
    required final FitnessGoal fitnessGoal,
    required final ActivityLevel activityLevel,
    required final List<String> preferredExerciseTypes,
    required final List<String> dislikedExercises,
    required final Map<String, dynamic> preferences,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final String? avatarUrl,
    final bool? isPremium,
    final DateTime? premiumExpiresAt,
    final String? fcmToken,
    final Map<String, dynamic>? aiProviderConfig,
  }) = _$UserProfileImpl;

  factory _UserProfile.fromJson(Map<String, dynamic> json) =
      _$UserProfileImpl.fromJson;

  @override
  String get id;
  @override
  String get email;
  @override
  String get name;
  @override
  int get age;
  @override
  double get height; // in cm
  @override
  double get weight; // in kg
  @override
  double get targetWeight; // in kg
  @override
  FitnessGoal get fitnessGoal;
  @override
  ActivityLevel get activityLevel;
  @override
  List<String> get preferredExerciseTypes;
  @override
  List<String> get dislikedExercises;
  @override
  Map<String, dynamic> get preferences;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  String? get avatarUrl;
  @override
  bool? get isPremium;
  @override
  DateTime? get premiumExpiresAt;
  @override
  String? get fcmToken;
  @override
  Map<String, dynamic>? get aiProviderConfig;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
