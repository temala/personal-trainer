import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_training_app/core/errors/app_error.dart';
import 'package:fitness_training_app/core/utils/logger.dart';
import 'package:fitness_training_app/core/utils/validators.dart';
import 'package:fitness_training_app/shared/domain/repositories/auth_repository.dart';
import 'package:fitness_training_app/shared/domain/repositories/user_repository.dart';
import 'package:fitness_training_app/shared/domain/entities/user_profile.dart';

/// Authentication service handling business logic
class AuthService {
  const AuthService({
    required AuthRepository authRepository,
    required UserRepository userRepository,
  }) : _authRepository = authRepository,
       _userRepository = userRepository;

  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  /// Get current authenticated user
  User? get currentUser => _authRepository.currentUser;

  /// Stream of authentication state changes
  Stream<User?> get authStateChanges => _authRepository.authStateChanges;

  /// Check if user is signed in
  bool get isSignedIn => _authRepository.isSignedIn;

  /// Get current user ID
  String? get currentUserId => _authRepository.currentUserId;

  /// Check if current user's email is verified
  bool get isEmailVerified => _authRepository.isEmailVerified;

  /// Register new user with email and password
  Future<AuthResult> registerUser({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // Validate input
      _validateRegistrationInput(email: email, password: password, name: name);

      AppLogger.info('Starting user registration process');

      // Register with Firebase Auth
      final authResult = await _authRepository.registerWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
      );

      AppLogger.info('User registered successfully: ${authResult.user.uid}');

      return authResult;
    } catch (e) {
      AppLogger.error('User registration failed', e);
      rethrow;
    }
  }

  /// Sign in user with email and password
  Future<AuthResult> signInUser({
    required String email,
    required String password,
  }) async {
    try {
      // Validate input
      _validateSignInInput(email: email, password: password);

      AppLogger.info('Starting user sign in process');

      // Sign in with Firebase Auth
      final authResult = await _authRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      AppLogger.info('User signed in successfully: ${authResult.user.uid}');

      return authResult;
    } catch (e) {
      AppLogger.error('User sign in failed', e);
      rethrow;
    }
  }

  /// Send email verification to current user
  Future<void> sendEmailVerification() async {
    try {
      if (isEmailVerified) {
        AppLogger.info('Email already verified');
        return;
      }

      await _authRepository.sendEmailVerification();
      AppLogger.info('Email verification sent');
    } catch (e) {
      AppLogger.error('Failed to send email verification', e);
      rethrow;
    }
  }

  /// Check email verification status
  Future<bool> checkEmailVerification() async {
    try {
      await _authRepository.reloadUser();
      final isVerified = isEmailVerified;
      AppLogger.info('Email verification status: $isVerified');
      return isVerified;
    } catch (e) {
      AppLogger.error('Failed to check email verification', e);
      rethrow;
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      if (!Validators.isValidEmail(email)) {
        throw const AppError.validation(message: 'Invalid email address');
      }

      await _authRepository.sendPasswordResetEmail(email);
      AppLogger.info('Password reset email sent');
    } catch (e) {
      AppLogger.error('Failed to send password reset email', e);
      rethrow;
    }
  }

  /// Sign out current user
  Future<void> signOut() async {
    try {
      await _authRepository.signOut();
      AppLogger.info('User signed out successfully');
    } catch (e) {
      AppLogger.error('Sign out failed', e);
      rethrow;
    }
  }

  /// Delete current user account and profile
  Future<void> deleteAccount({required String password}) async {
    try {
      final userId = currentUserId;
      if (userId == null) {
        throw const AppError.authentication(message: 'No user signed in');
      }

      // Reauthenticate before deletion
      await _authRepository.reauthenticateWithPassword(password);

      // Delete user profile from database
      await _userRepository.deleteUserProfile(userId);

      // Delete Firebase Auth account
      await _authRepository.deleteAccount();

      AppLogger.info('User account deleted successfully');
    } catch (e) {
      AppLogger.error('Account deletion failed', e);
      rethrow;
    }
  }

  /// Update user display name
  Future<void> updateDisplayName(String displayName) async {
    try {
      if (displayName.trim().isEmpty) {
        throw const AppError.validation(
          message: 'Display name cannot be empty',
        );
      }

      await _authRepository.updateDisplayName(displayName.trim());
      AppLogger.info('Display name updated successfully');
    } catch (e) {
      AppLogger.error('Failed to update display name', e);
      rethrow;
    }
  }

  /// Update user email
  Future<void> updateEmail(String newEmail) async {
    try {
      if (!Validators.isValidEmail(newEmail)) {
        throw const AppError.validation(message: 'Invalid email address');
      }

      await _authRepository.updateEmail(newEmail);
      AppLogger.info('Email update verification sent');
    } catch (e) {
      AppLogger.error('Failed to update email', e);
      rethrow;
    }
  }

  /// Update user password
  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      if (!Validators.isValidPassword(newPassword)) {
        throw const AppError.validation(
          message:
              'Password must be at least 8 characters long and contain letters and numbers',
        );
      }

      // Reauthenticate before password change
      await _authRepository.reauthenticateWithPassword(currentPassword);

      // Update password
      await _authRepository.updatePassword(newPassword);
      AppLogger.info('Password updated successfully');
    } catch (e) {
      AppLogger.error('Failed to update password', e);
      rethrow;
    }
  }

  /// Get ID token for current user
  Future<String?> getIdToken({bool forceRefresh = false}) async {
    try {
      return await _authRepository.getIdToken(forceRefresh: forceRefresh);
    } catch (e) {
      AppLogger.error('Failed to get ID token', e);
      return null;
    }
  }

  /// Check if user profile exists in database
  Future<bool> hasUserProfile() async {
    try {
      final userId = currentUserId;
      if (userId == null) return false;

      return await _userRepository.userExists(userId);
    } catch (e) {
      AppLogger.error('Failed to check user profile existence', e);
      return false;
    }
  }

  /// Get current user profile
  Future<UserProfile?> getCurrentUserProfile() async {
    try {
      final userId = currentUserId;
      if (userId == null) return null;

      return await _userRepository.getUserProfile(userId);
    } catch (e) {
      AppLogger.error('Failed to get current user profile', e);
      return null;
    }
  }

  /// Validate registration input
  void _validateRegistrationInput({
    required String email,
    required String password,
    required String name,
  }) {
    if (name.trim().isEmpty) {
      throw const AppError.validation(message: 'Name cannot be empty');
    }

    if (!Validators.isValidEmail(email)) {
      throw const AppError.validation(message: 'Invalid email address');
    }

    if (!Validators.isValidPassword(password)) {
      throw const AppError.validation(
        message:
            'Password must be at least 8 characters long and contain letters and numbers',
      );
    }
  }

  /// Validate sign in input
  void _validateSignInInput({required String email, required String password}) {
    if (!Validators.isValidEmail(email)) {
      throw const AppError.validation(message: 'Invalid email address');
    }

    if (password.isEmpty) {
      throw const AppError.validation(message: 'Password cannot be empty');
    }
  }
}
