import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_training_app/core/errors/app_error.dart';
import 'package:fitness_training_app/core/utils/logger.dart';
import 'package:fitness_training_app/shared/domain/repositories/auth_repository.dart';

/// Firebase implementation of AuthRepository
class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  @override
  bool get isSignedIn => currentUser != null;

  @override
  String? get currentUserId => currentUser?.uid;

  @override
  bool get isEmailVerified => currentUser?.emailVerified ?? false;

  @override
  Future<AuthResult> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      AppLogger.info('Attempting to register user with email: $email');

      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw const AppError.authentication(
          message: 'Registration failed: No user returned',
        );
      }

      // Update display name
      await user.updateDisplayName(name);
      await user.reload();

      // Send email verification
      await user.sendEmailVerification();

      AppLogger.info('User registered successfully: ${user.uid}');

      return AuthResult(
        user: user,
        isNewUser: true,
        additionalUserInfo: credential.additionalUserInfo,
      );
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Firebase Auth registration error: ${e.code}', e);
      throw _mapFirebaseAuthException(e);
    } catch (e, stackTrace) {
      AppLogger.error('Unexpected registration error', e, stackTrace);
      throw AppError.authentication(
        message: 'Registration failed: ${e.toString()}',
      );
    }
  }

  @override
  Future<AuthResult> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      AppLogger.info('Attempting to sign in user with email: $email');

      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw const AppError.authentication(
          message: 'Sign in failed: No user returned',
        );
      }

      AppLogger.info('User signed in successfully: ${user.uid}');

      return AuthResult(
        user: user,
        isNewUser: false,
        additionalUserInfo: credential.additionalUserInfo,
      );
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Firebase Auth sign in error: ${e.code}', e);
      throw _mapFirebaseAuthException(e);
    } catch (e, stackTrace) {
      AppLogger.error('Unexpected sign in error', e, stackTrace);
      throw AppError.authentication(message: 'Sign in failed: ${e.toString()}');
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    try {
      final user = currentUser;
      if (user == null) {
        throw const AppError.authentication(message: 'No user signed in');
      }

      if (user.emailVerified) {
        AppLogger.info('Email already verified for user: ${user.uid}');
        return;
      }

      await user.sendEmailVerification();
      AppLogger.info('Email verification sent to: ${user.email}');
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Firebase Auth email verification error: ${e.code}', e);
      throw _mapFirebaseAuthException(e);
    } catch (e, stackTrace) {
      AppLogger.error('Unexpected email verification error', e, stackTrace);
      throw AppError.authentication(
        message: 'Email verification failed: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> reloadUser() async {
    try {
      final user = currentUser;
      if (user == null) {
        throw const AppError.authentication(message: 'No user signed in');
      }

      await user.reload();
      AppLogger.info('User reloaded: ${user.uid}');
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Firebase Auth reload error: ${e.code}', e);
      throw _mapFirebaseAuthException(e);
    } catch (e, stackTrace) {
      AppLogger.error('Unexpected reload error', e, stackTrace);
      throw AppError.authentication(
        message: 'User reload failed: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      AppLogger.info('Password reset email sent to: $email');
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Firebase Auth password reset error: ${e.code}', e);
      throw _mapFirebaseAuthException(e);
    } catch (e, stackTrace) {
      AppLogger.error('Unexpected password reset error', e, stackTrace);
      throw AppError.authentication(
        message: 'Password reset failed: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      final userId = currentUserId;
      await _firebaseAuth.signOut();
      AppLogger.info('User signed out: $userId');
    } catch (e, stackTrace) {
      AppLogger.error('Sign out error', e, stackTrace);
      throw AppError.authentication(
        message: 'Sign out failed: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      final user = currentUser;
      if (user == null) {
        throw const AppError.authentication(message: 'No user signed in');
      }

      final userId = user.uid;
      await user.delete();
      AppLogger.info('User account deleted: $userId');
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Firebase Auth delete account error: ${e.code}', e);
      throw _mapFirebaseAuthException(e);
    } catch (e, stackTrace) {
      AppLogger.error('Unexpected delete account error', e, stackTrace);
      throw AppError.authentication(
        message: 'Account deletion failed: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> updateDisplayName(String displayName) async {
    try {
      final user = currentUser;
      if (user == null) {
        throw const AppError.authentication(message: 'No user signed in');
      }

      await user.updateDisplayName(displayName);
      await user.reload();
      AppLogger.info('Display name updated for user: ${user.uid}');
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Firebase Auth update display name error: ${e.code}', e);
      throw _mapFirebaseAuthException(e);
    } catch (e, stackTrace) {
      AppLogger.error('Unexpected update display name error', e, stackTrace);
      throw AppError.authentication(
        message: 'Display name update failed: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> updateEmail(String newEmail) async {
    try {
      final user = currentUser;
      if (user == null) {
        throw const AppError.authentication(message: 'No user signed in');
      }

      await user.verifyBeforeUpdateEmail(newEmail);
      AppLogger.info('Email update verification sent to: $newEmail');
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Firebase Auth update email error: ${e.code}', e);
      throw _mapFirebaseAuthException(e);
    } catch (e, stackTrace) {
      AppLogger.error('Unexpected update email error', e, stackTrace);
      throw AppError.authentication(
        message: 'Email update failed: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> updatePassword(String newPassword) async {
    try {
      final user = currentUser;
      if (user == null) {
        throw const AppError.authentication(message: 'No user signed in');
      }

      await user.updatePassword(newPassword);
      AppLogger.info('Password updated for user: ${user.uid}');
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Firebase Auth update password error: ${e.code}', e);
      throw _mapFirebaseAuthException(e);
    } catch (e, stackTrace) {
      AppLogger.error('Unexpected update password error', e, stackTrace);
      throw AppError.authentication(
        message: 'Password update failed: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> reauthenticateWithPassword(String password) async {
    try {
      final user = currentUser;
      if (user == null) {
        throw const AppError.authentication(message: 'No user signed in');
      }

      final email = user.email;
      if (email == null) {
        throw const AppError.authentication(
          message: 'User email not available',
        );
      }

      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);
      AppLogger.info('User reauthenticated: ${user.uid}');
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Firebase Auth reauthentication error: ${e.code}', e);
      throw _mapFirebaseAuthException(e);
    } catch (e, stackTrace) {
      AppLogger.error('Unexpected reauthentication error', e, stackTrace);
      throw AppError.authentication(
        message: 'Reauthentication failed: ${e.toString()}',
      );
    }
  }

  @override
  Future<String?> getIdToken({bool forceRefresh = false}) async {
    try {
      final user = currentUser;
      if (user == null) {
        return null;
      }

      final token = await user.getIdToken(forceRefresh);
      AppLogger.info('ID token retrieved for user: ${user.uid}');
      return token;
    } catch (e, stackTrace) {
      AppLogger.error('Get ID token error', e, stackTrace);
      return null;
    }
  }

  /// Map Firebase Auth exceptions to AppError
  AppError _mapFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return const AppError.validation(message: 'Password is too weak');
      case 'email-already-in-use':
        return const AppError.validation(
          message: 'Email is already registered',
        );
      case 'invalid-email':
        return const AppError.validation(message: 'Invalid email address');
      case 'user-disabled':
        return const AppError.authentication(
          message: 'User account has been disabled',
        );
      case 'user-not-found':
        return const AppError.authentication(
          message: 'No user found with this email',
        );
      case 'wrong-password':
        return const AppError.authentication(message: 'Incorrect password');
      case 'invalid-credential':
        return const AppError.authentication(message: 'Invalid credentials');
      case 'too-many-requests':
        return const AppError.network(
          message: 'Too many requests. Please try again later',
        );
      case 'operation-not-allowed':
        return const AppError.authentication(message: 'Operation not allowed');
      case 'requires-recent-login':
        return const AppError.authentication(
          message: 'Please sign in again to continue',
        );
      case 'credential-already-in-use':
        return const AppError.validation(
          message: 'Credential is already associated with another account',
        );
      case 'invalid-verification-code':
        return const AppError.validation(message: 'Invalid verification code');
      case 'invalid-verification-id':
        return const AppError.validation(message: 'Invalid verification ID');
      case 'network-request-failed':
        return const AppError.network(
          message: 'Network error. Please check your connection',
        );
      default:
        return AppError.authentication(
          message: 'Authentication error: ${e.message ?? e.code}',
        );
    }
  }
}
