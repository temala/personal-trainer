import 'package:freezed_annotation/freezed_annotation.dart';

import 'fitness_enums.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

/// User profile entity
@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String email,
    required DateTime createdAt,
    required DateTime lastUpdated,
    String? displayName,
    String? name,
    String? photoUrl,
    String? phoneNumber,
    DateTime? dateOfBirth,
    int? age,
    String? gender,
    double? height,
    double? weight,
    double? targetWeight,
    String? fitnessLevel,
    FitnessGoal? fitnessGoal,
    ActivityLevel? activityLevel,
    List<String>? fitnessGoals,
    List<String>? preferredExerciseTypes,
    List<String>? dislikedExercises,
    Map<String, dynamic>? preferences,
    Map<String, dynamic>? aiProviderConfig,
    bool? isEmailVerified,
    bool? isActive,
    bool? isActivePremium,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}

/// Extension methods for UserProfile
extension UserProfileExtension on UserProfile {
  /// Get display name or fallback to email
  String get displayNameOrEmail => displayName ?? name ?? email;

  /// Check if profile is complete
  bool get isProfileComplete {
    return displayName != null &&
        dateOfBirth != null &&
        gender != null &&
        fitnessLevel != null &&
        (fitnessGoals?.isNotEmpty ?? false);
  }

  /// Calculate weight difference from target
  double? get weightDifference {
    if (weight == null || targetWeight == null) return null;
    return weight! - targetWeight!;
  }

  /// Validate profile data
  bool validate() {
    return email.isNotEmpty &&
        id.isNotEmpty &&
        (age == null || age! > 0) &&
        (weight == null || weight! > 0) &&
        (height == null || height! > 0);
  }

  /// Get age from date of birth
  int? get age {
    if (dateOfBirth == null) return null;
    final now = DateTime.now();
    final ageYears = now.year - dateOfBirth!.year;
    if (now.month < dateOfBirth!.month ||
        (now.month == dateOfBirth!.month && now.day < dateOfBirth!.day)) {
      return ageYears - 1;
    }
    return ageYears;
  }

  /// Get BMI if height and weight are available
  double? get bmi {
    if (height == null || weight == null || height! <= 0) return null;
    final heightInMeters = height! / 100; // Convert cm to meters
    return weight! / (heightInMeters * heightInMeters);
  }

  /// Get BMI category
  String? get bmiCategory {
    final bmiValue = bmi;
    if (bmiValue == null) return null;

    if (bmiValue < 18.5) return 'Underweight';
    if (bmiValue < 25) return 'Normal weight';
    if (bmiValue < 30) return 'Overweight';
    return 'Obese';
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

  /// Create initial user profile
  static UserProfile createInitial({
    required String id,
    required String email,
    String? displayName,
  }) {
    return UserProfile(
      id: id,
      email: email,
      displayName: displayName,
      createdAt: DateTime.now(),
      lastUpdated: DateTime.now(),
      isEmailVerified: false,
      isActive: true,
      preferences: {},
      metadata: {},
    );
  }
}
