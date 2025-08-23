import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitness_training_app/features/auth/data/services/auth_service.dart';
import 'package:fitness_training_app/shared/data/repositories/firebase_auth_repository.dart';
import 'package:fitness_training_app/shared/data/repositories/firebase_user_repository.dart';
import 'package:fitness_training_app/shared/domain/repositories/auth_repository.dart';
import 'package:fitness_training_app/shared/domain/repositories/user_repository.dart';
import 'package:fitness_training_app/shared/domain/entities/user_profile.dart';

/// Auth repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FirebaseAuthRepository();
});

/// User repository provider
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return FirebaseUserRepository();
});

/// Auth service provider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(
    authRepository: ref.watch(authRepositoryProvider),
    userRepository: ref.watch(userRepositoryProvider),
  );
});

/// Current user stream provider
final authStateProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

/// Current user provider (synchronous)
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user) => user,
    loading: () => null,
    error: (_, __) => null,
  );
});

/// Current user ID provider
final currentUserIdProvider = Provider<String?>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.uid;
});

/// Is signed in provider
final isSignedInProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user != null;
});

/// Is email verified provider
final isEmailVerifiedProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.emailVerified ?? false;
});

/// Current user profile provider
final currentUserProfileProvider = FutureProvider<UserProfile?>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return null;

  final authService = ref.watch(authServiceProvider);
  return authService.getCurrentUserProfile();
});

/// Authentication loading state provider
final authLoadingProvider = StateProvider<bool>((ref) => false);

/// Authentication error provider
final authErrorProvider = StateProvider<String?>((ref) => null);

/// Authentication controller provider
final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController(ref);
});

/// Authentication controller
class AuthController {
  AuthController(this._ref);

  final Ref _ref;

  AuthService get _authService => _ref.read(authServiceProvider);

  /// Register new user
  Future<bool> registerUser({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      _ref.read(authLoadingProvider.notifier).state = true;
      _ref.read(authErrorProvider.notifier).state = null;

      await _authService.registerUser(
        email: email,
        password: password,
        name: name,
      );

      return true;
    } catch (e) {
      _ref.read(authErrorProvider.notifier).state = e.toString();
      return false;
    } finally {
      _ref.read(authLoadingProvider.notifier).state = false;
    }
  }

  /// Sign in user
  Future<bool> signInUser({
    required String email,
    required String password,
  }) async {
    try {
      _ref.read(authLoadingProvider.notifier).state = true;
      _ref.read(authErrorProvider.notifier).state = null;

      await _authService.signInUser(email: email, password: password);

      return true;
    } catch (e) {
      _ref.read(authErrorProvider.notifier).state = e.toString();
      return false;
    } finally {
      _ref.read(authLoadingProvider.notifier).state = false;
    }
  }

  /// Send email verification
  Future<bool> sendEmailVerification() async {
    try {
      _ref.read(authLoadingProvider.notifier).state = true;
      _ref.read(authErrorProvider.notifier).state = null;

      await _authService.sendEmailVerification();
      return true;
    } catch (e) {
      _ref.read(authErrorProvider.notifier).state = e.toString();
      return false;
    } finally {
      _ref.read(authLoadingProvider.notifier).state = false;
    }
  }

  /// Check email verification status
  Future<bool> checkEmailVerification() async {
    try {
      return await _authService.checkEmailVerification();
    } catch (e) {
      _ref.read(authErrorProvider.notifier).state = e.toString();
      return false;
    }
  }

  /// Send password reset email
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      _ref.read(authLoadingProvider.notifier).state = true;
      _ref.read(authErrorProvider.notifier).state = null;

      await _authService.sendPasswordResetEmail(email);
      return true;
    } catch (e) {
      _ref.read(authErrorProvider.notifier).state = e.toString();
      return false;
    } finally {
      _ref.read(authLoadingProvider.notifier).state = false;
    }
  }

  /// Sign out user
  Future<bool> signOut() async {
    try {
      _ref.read(authLoadingProvider.notifier).state = true;
      _ref.read(authErrorProvider.notifier).state = null;

      await _authService.signOut();
      return true;
    } catch (e) {
      _ref.read(authErrorProvider.notifier).state = e.toString();
      return false;
    } finally {
      _ref.read(authLoadingProvider.notifier).state = false;
    }
  }

  /// Delete user account
  Future<bool> deleteAccount({required String password}) async {
    try {
      _ref.read(authLoadingProvider.notifier).state = true;
      _ref.read(authErrorProvider.notifier).state = null;

      await _authService.deleteAccount(password: password);
      return true;
    } catch (e) {
      _ref.read(authErrorProvider.notifier).state = e.toString();
      return false;
    } finally {
      _ref.read(authLoadingProvider.notifier).state = false;
    }
  }

  /// Update display name
  Future<bool> updateDisplayName(String displayName) async {
    try {
      _ref.read(authLoadingProvider.notifier).state = true;
      _ref.read(authErrorProvider.notifier).state = null;

      await _authService.updateDisplayName(displayName);
      return true;
    } catch (e) {
      _ref.read(authErrorProvider.notifier).state = e.toString();
      return false;
    } finally {
      _ref.read(authLoadingProvider.notifier).state = false;
    }
  }

  /// Update email
  Future<bool> updateEmail(String newEmail) async {
    try {
      _ref.read(authLoadingProvider.notifier).state = true;
      _ref.read(authErrorProvider.notifier).state = null;

      await _authService.updateEmail(newEmail);
      return true;
    } catch (e) {
      _ref.read(authErrorProvider.notifier).state = e.toString();
      return false;
    } finally {
      _ref.read(authLoadingProvider.notifier).state = false;
    }
  }

  /// Update password
  Future<bool> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      _ref.read(authLoadingProvider.notifier).state = true;
      _ref.read(authErrorProvider.notifier).state = null;

      await _authService.updatePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return true;
    } catch (e) {
      _ref.read(authErrorProvider.notifier).state = e.toString();
      return false;
    } finally {
      _ref.read(authLoadingProvider.notifier).state = false;
    }
  }

  /// Clear error state
  void clearError() {
    _ref.read(authErrorProvider.notifier).state = null;
  }

  /// Check if user has profile
  Future<bool> hasUserProfile() async {
    return await _authService.hasUserProfile();
  }
}
