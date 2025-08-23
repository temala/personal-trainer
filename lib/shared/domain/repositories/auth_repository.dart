import 'package:firebase_auth/firebase_auth.dart';

/// Authentication result containing user and additional info
class AuthResult {
  const AuthResult({
    required this.user,
    required this.isNewUser,
    this.additionalUserInfo,
  });

  final User user;
  final bool isNewUser;
  final AdditionalUserInfo? additionalUserInfo;
}

/// Authentication repository interface
abstract class AuthRepository {
  /// Get current authenticated user
  User? get currentUser;

  /// Stream of authentication state changes
  Stream<User?> get authStateChanges;

  /// Register new user with email and password
  Future<AuthResult> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  });

  /// Sign in with email and password
  Future<AuthResult> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Send email verification to current user
  Future<void> sendEmailVerification();

  /// Check if current user's email is verified
  bool get isEmailVerified;

  /// Reload current user to get updated verification status
  Future<void> reloadUser();

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email);

  /// Sign out current user
  Future<void> signOut();

  /// Delete current user account
  Future<void> deleteAccount();

  /// Update user display name
  Future<void> updateDisplayName(String displayName);

  /// Update user email
  Future<void> updateEmail(String newEmail);

  /// Update user password
  Future<void> updatePassword(String newPassword);

  /// Reauthenticate user with current credentials
  Future<void> reauthenticateWithPassword(String password);

  /// Get ID token for current user
  Future<String?> getIdToken({bool forceRefresh = false});

  /// Check if user is signed in
  bool get isSignedIn;

  /// Get user UID
  String? get currentUserId;
}
