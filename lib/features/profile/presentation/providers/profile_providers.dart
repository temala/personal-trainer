import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitness_training_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:fitness_training_app/shared/domain/entities/fitness_enums.dart';
import 'package:fitness_training_app/shared/domain/entities/user_profile.dart';
import 'package:fitness_training_app/shared/domain/repositories/user_repository.dart';

/// Profile loading state provider
final profileLoadingProvider = StateProvider<bool>((ref) => false);

/// Profile error provider
final profileErrorProvider = StateProvider<String?>((ref) => null);

/// Profile controller provider
final profileControllerProvider = Provider<ProfileController>((ref) {
  return ProfileController(ref);
});

/// Profile controller
class ProfileController {
  ProfileController(this._ref);

  final Ref _ref;

  UserRepository get _userRepository => _ref.read(userRepositoryProvider);

  /// Create user profile
  Future<bool> createUserProfile({
    required String name,
    required int age,
    required double height,
    required double weight,
    required double targetWeight,
    required FitnessGoal fitnessGoal,
    required ActivityLevel activityLevel,
    required List<String> preferredExerciseTypes,
  }) async {
    try {
      _ref.read(profileLoadingProvider.notifier).state = true;
      _ref.read(profileErrorProvider.notifier).state = null;

      final currentUser = _ref.read(currentUserProvider);
      if (currentUser == null) {
        throw Exception('No user signed in');
      }

      final profile = UserProfile(
        id: currentUser.uid,
        email: currentUser.email!,
        lastUpdated: DateTime.now(),
        name: name,
        age: age,
        height: height,
        weight: weight,
        targetWeight: targetWeight,
        fitnessGoal: fitnessGoal,
        activityLevel: activityLevel,
        preferredExerciseTypes: preferredExerciseTypes,
        dislikedExercises: [],
        preferences: {},
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _userRepository.createUserProfile(profile);
      return true;
    } catch (e) {
      _ref.read(profileErrorProvider.notifier).state = e.toString();
      return false;
    } finally {
      _ref.read(profileLoadingProvider.notifier).state = false;
    }
  }

  /// Update user profile
  Future<bool> updateUserProfile(UserProfile profile) async {
    try {
      _ref.read(profileLoadingProvider.notifier).state = true;
      _ref.read(profileErrorProvider.notifier).state = null;

      final updatedProfile = profile.copyWith(
        updatedAt: DateTime.now(),
        lastUpdated: DateTime.now(),
      );

      await _userRepository.updateUserProfile(updatedProfile);
      return true;
    } catch (e) {
      _ref.read(profileErrorProvider.notifier).state = e.toString();
      return false;
    } finally {
      _ref.read(profileLoadingProvider.notifier).state = false;
    }
  }

  /// Update fitness metrics
  Future<bool> updateFitnessMetrics({
    required String userId,
    double? weight,
    double? targetWeight,
    double? height,
  }) async {
    try {
      _ref.read(profileLoadingProvider.notifier).state = true;
      _ref.read(profileErrorProvider.notifier).state = null;

      await _userRepository.updateFitnessMetrics(
        userId: userId,
        weight: weight,
        targetWeight: targetWeight,
        height: height,
      );
      return true;
    } catch (e) {
      _ref.read(profileErrorProvider.notifier).state = e.toString();
      return false;
    } finally {
      _ref.read(profileLoadingProvider.notifier).state = false;
    }
  }

  /// Update user preferences
  Future<bool> updateUserPreferences({
    required String userId,
    required Map<String, dynamic> preferences,
  }) async {
    try {
      _ref.read(profileLoadingProvider.notifier).state = true;
      _ref.read(profileErrorProvider.notifier).state = null;

      await _userRepository.updateUserPreferences(userId, preferences);
      return true;
    } catch (e) {
      _ref.read(profileErrorProvider.notifier).state = e.toString();
      return false;
    } finally {
      _ref.read(profileLoadingProvider.notifier).state = false;
    }
  }

  /// Update exercise preferences
  Future<bool> updateExercisePreferences({
    required String userId,
    required Map<String, dynamic> preferences,
  }) async {
    try {
      _ref.read(profileLoadingProvider.notifier).state = true;
      _ref.read(profileErrorProvider.notifier).state = null;

      await _userRepository.updateExercisePreferences(userId, preferences);
      return true;
    } catch (e) {
      _ref.read(profileErrorProvider.notifier).state = e.toString();
      return false;
    } finally {
      _ref.read(profileLoadingProvider.notifier).state = false;
    }
  }

  /// Update premium status
  Future<bool> updatePremiumStatus({
    required String userId,
    required bool isPremium,
    DateTime? expiresAt,
  }) async {
    try {
      _ref.read(profileLoadingProvider.notifier).state = true;
      _ref.read(profileErrorProvider.notifier).state = null;

      await _userRepository.updatePremiumStatus(
        userId: userId,
        isPremium: isPremium,
        expiresAt: expiresAt,
      );
      return true;
    } catch (e) {
      _ref.read(profileErrorProvider.notifier).state = e.toString();
      return false;
    } finally {
      _ref.read(profileLoadingProvider.notifier).state = false;
    }
  }

  /// Update FCM token
  Future<bool> updateFCMToken({
    required String userId,
    required String? fcmToken,
  }) async {
    try {
      await _userRepository.updateFCMToken(userId, fcmToken);
      return true;
    } catch (e) {
      _ref.read(profileErrorProvider.notifier).state = e.toString();
      return false;
    }
  }

  /// Update AI provider configuration
  Future<bool> updateAIProviderConfig({
    required String userId,
    required Map<String, dynamic> config,
  }) async {
    try {
      _ref.read(profileLoadingProvider.notifier).state = true;
      _ref.read(profileErrorProvider.notifier).state = null;

      await _userRepository.updateAIProviderConfig(userId, config);
      return true;
    } catch (e) {
      _ref.read(profileErrorProvider.notifier).state = e.toString();
      return false;
    } finally {
      _ref.read(profileLoadingProvider.notifier).state = false;
    }
  }

  /// Clear error state
  void clearError() {
    _ref.read(profileErrorProvider.notifier).state = null;
  }
}
