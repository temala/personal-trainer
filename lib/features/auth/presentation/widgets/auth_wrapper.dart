import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitness_training_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:fitness_training_app/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:fitness_training_app/features/auth/presentation/screens/email_verification_screen.dart';
import 'package:fitness_training_app/features/profile/presentation/screens/profile_setup_screen.dart';
import 'package:fitness_training_app/core/routing/app_router.dart';

/// Authentication wrapper that determines which screen to show
class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          // User not signed in - show sign in screen
          return const SignInScreen();
        }

        if (!user.emailVerified) {
          // User signed in but email not verified
          return const EmailVerificationScreen();
        }

        // User signed in and email verified - check if profile exists
        return FutureBuilder<bool>(
          future: _checkUserProfile(ref),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const _LoadingScreen();
            }

            if (snapshot.hasError) {
              return _ErrorScreen(error: snapshot.error.toString());
            }

            final hasProfile = snapshot.data ?? false;

            if (!hasProfile) {
              // User needs to complete profile setup
              return const ProfileSetupScreen();
            }

            // User is fully set up - show main app
            return const HomeScreen();
          },
        );
      },
      loading: () => const _LoadingScreen(),
      error: (error, stackTrace) => _ErrorScreen(error: error.toString()),
    );
  }

  Future<bool> _checkUserProfile(WidgetRef ref) async {
    try {
      final authController = ref.read(authControllerProvider);
      return await authController.hasUserProfile();
    } catch (e) {
      return false;
    }
  }
}

/// Loading screen widget
class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fitness_center, size: 80, color: Colors.blue),
            SizedBox(height: 24),
            Text(
              'Fitness Training App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Loading your fitness journey...',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 32),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

/// Error screen widget
class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen({required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 80, color: Colors.red),
              const SizedBox(height: 24),
              const Text(
                'Something went wrong',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                error,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // Restart the app or navigate to sign in
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil('/sign-in', (route) => false);
                },
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
