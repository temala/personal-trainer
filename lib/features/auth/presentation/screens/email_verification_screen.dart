import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitness_training_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:fitness_training_app/shared/presentation/widgets/custom_button.dart';
import 'package:fitness_training_app/shared/presentation/widgets/loading_overlay.dart';

/// Email verification screen
class EmailVerificationScreen extends ConsumerStatefulWidget {
  const EmailVerificationScreen({super.key});

  static const routeName = '/email-verification';

  @override
  ConsumerState<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState
    extends ConsumerState<EmailVerificationScreen> {
  Timer? _timer;
  bool _canResendEmail = false;
  int _resendCountdown = 60;

  @override
  void initState() {
    super.initState();
    _startEmailVerificationCheck();
    _startResendCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startEmailVerificationCheck() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      final controller = ref.read(authControllerProvider);
      final isVerified = await controller.checkEmailVerification();

      if (isVerified && mounted) {
        timer.cancel();

        // Check if user has profile
        final hasProfile = await controller.hasUserProfile();

        if (hasProfile) {
          // Navigate to main app
          Navigator.of(context).pushReplacementNamed('/home');
        } else {
          // Navigate to profile setup
          Navigator.of(context).pushReplacementNamed('/profile-setup');
        }
      }
    });
  }

  void _startResendCountdown() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown > 0) {
        setState(() {
          _resendCountdown--;
        });
      } else {
        setState(() {
          _canResendEmail = true;
        });
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authLoadingProvider);
    final error = ref.watch(authErrorProvider);
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      body: LoadingOverlay(
        isLoading: isLoading,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),

                // Email icon
                Icon(
                  Icons.mark_email_unread_outlined,
                  size: 100,
                  color: Theme.of(context).primaryColor,
                ),

                const SizedBox(height: 32),

                // Title
                Text(
                  'Verify Your Email',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                // Description
                Text(
                  'We\'ve sent a verification email to:',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                Text(
                  currentUser?.email ?? '',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 24),

                Text(
                  'Please check your email and click the verification link to continue.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 32),

                // Error message
                if (error != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red[200]!),
                    ),
                    child: Text(
                      error,
                      style: TextStyle(color: Colors.red[700], fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Resend email button
                CustomButton(
                  onPressed: _canResendEmail ? _handleResendEmail : null,
                  text:
                      _canResendEmail
                          ? 'Resend Verification Email'
                          : 'Resend in ${_resendCountdown}s',
                  isLoading: isLoading,
                ),

                const SizedBox(height: 16),

                // Check verification button
                CustomButton(
                  onPressed: _handleCheckVerification,
                  text: 'I\'ve Verified My Email',
                  variant: ButtonVariant.outlined,
                ),

                const Spacer(),

                // Sign out link
                TextButton(
                  onPressed: _handleSignOut,
                  child: Text(
                    'Sign Out',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleResendEmail() async {
    final controller = ref.read(authControllerProvider);

    final success = await controller.sendEmailVerification();

    if (success) {
      setState(() {
        _canResendEmail = false;
        _resendCountdown = 60;
      });
      _startResendCountdown();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification email sent!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  Future<void> _handleCheckVerification() async {
    final controller = ref.read(authControllerProvider);

    final isVerified = await controller.checkEmailVerification();

    if (isVerified && mounted) {
      // Check if user has profile
      final hasProfile = await controller.hasUserProfile();

      if (hasProfile) {
        // Navigate to main app
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        // Navigate to profile setup
        Navigator.of(context).pushReplacementNamed('/profile-setup');
      }
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email not verified yet. Please check your email.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  Future<void> _handleSignOut() async {
    final controller = ref.read(authControllerProvider);

    final success = await controller.signOut();

    if (success && mounted) {
      Navigator.of(context).pushReplacementNamed('/sign-in');
    }
  }
}
