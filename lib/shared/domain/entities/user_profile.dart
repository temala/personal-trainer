import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

/// User profile entity containing all user information
@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String email,
    required String name,
    required int age,
    required double height, // in cm
    required double weight, // in kg
    required double targetWeight, // in kg
    required FitnessGoal fitnessGoal,
    required ActivityLevel activityLevel,
    required List<String> preferredExerciseTypes,
    required List<String> dislikedExercises,
    required Map<String, dynamic> preferences,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? avatarUrl,
    bool? isPremium,
    DateTime? premiumExpiresAt,
    String? fcmToken,
    Map<String, dynamic>? aiProviderConfig,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}

/// User fitness goals
enum FitnessGoal {
  @JsonValue('lose_weight')
  loseWeight,
  @JsonValue('gain_muscle')
  gainMuscle,
  @JsonValue('maintain_fitness')
  maintainFitness,
  @JsonValue('improve_endurance')
  improveEndurance,
  @JsonValue('general_health')
  generalHealth,
}

/// User activity levels
enum ActivityLevel {
  @JsonValue('sedentary')
  sedentary,
  @JsonValue('lightly_active')
  lightlyActive,
  @JsonValue('moderately_active')
  moderatelyActive,
  @JsonValue('very_active')
  veryActive,
  @JsonValue('extremely_active')
  extremelyActive,
}

/// Extension methods for UserProfile
extension UserProfileExtension on UserProfile {
  /// Calculate BMI (Body Mass Index)
  double get bmi => weight / ((height / 100) * (height / 100));

  /// Get BMI category
  String get bmiCategory {
    final bmiValue = bmi;
    if (bmiValue < 18.5) return 'Underweight';
    if (bmiValue < 25) return 'Normal weight';
    if (bmiValue < 30) return 'Overweight';
    return 'Obese';
  }

  /// Check if user is premium
  bool get isActivePremium {
    if (isPremium != true) return false;
    if (premiumExpiresAt == null) return true;
    return DateTime.now().isBefore(premiumExpiresAt!);
  }

  /// Get weight difference from target
  double get weightDifference => weight - targetWeight;

  /// Check if user has reached target weight
  bool get hasReachedTarget => (weight - targetWeight).abs() <= 1.0;

  /// Validate user profile data
  List<String> validate() {
    final errors = <String>[];

    if (name.trim().isEmpty) {
      errors.add('Name cannot be empty');
    }

    if (age < 13 || age > 120) {
      errors.add('Age must be between 13 and 120');
    }

    if (height < 100 || height > 250) {
      errors.add('Height must be between 100 and 250 cm');
    }

    if (weight < 20 || weight > 500) {
      errors.add('Weight must be between 20 and 500 kg');
    }

    if (targetWeight < 20 || targetWeight > 500) {
      errors.add('Target weight must be between 20 and 500 kg');
    }

    if ((weight - targetWeight).abs() > 100) {
      errors.add('Target weight seems unrealistic');
    }

    return errors;
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return toJson()..remove('id'); // Firestore document ID is separate
  }
}

/// Helper methods for UserProfile
class UserProfileHelper {
  /// Create UserProfile from Firestore document
  static UserProfile fromFirestore(String id, Map<String, dynamic> data) {
    return UserProfile.fromJson({'id': id, ...data});
  }
}
