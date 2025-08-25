import 'package:flutter/material.dart';
import 'package:fitness_training_app/features/auth/presentation/screens/email_verification_screen.dart';
import 'package:fitness_training_app/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:fitness_training_app/features/auth/presentation/screens/registration_screen.dart';
import 'package:fitness_training_app/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:fitness_training_app/features/home/presentation/screens/home_screen.dart';
import 'package:fitness_training_app/features/home/presentation/screens/main_navigation_screen.dart';
import 'package:fitness_training_app/features/profile/presentation/screens/account_settings_screen.dart';
import 'package:fitness_training_app/features/profile/presentation/screens/ai_provider_settings_screen.dart';
import 'package:fitness_training_app/features/profile/presentation/screens/notification_settings_screen.dart';
import 'package:fitness_training_app/features/profile/presentation/screens/privacy_settings_screen.dart';
import 'package:fitness_training_app/features/profile/presentation/screens/profile_setup_screen.dart';
import 'package:fitness_training_app/features/profile/presentation/screens/settings_screen.dart';
import 'package:fitness_training_app/features/workout/presentation/screens/workout_session_screen.dart';

/// App router for handling navigation
class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
      case '/sign-in':
        return MaterialPageRoute(
          builder: (_) => const SignInScreen(),
          settings: settings,
        );

      case '/register':
        return MaterialPageRoute(
          builder: (_) => const RegistrationScreen(),
          settings: settings,
        );

      case '/email-verification':
        return MaterialPageRoute(
          builder: (_) => const EmailVerificationScreen(),
          settings: settings,
        );

      case '/forgot-password':
        return MaterialPageRoute(
          builder: (_) => const ForgotPasswordScreen(),
          settings: settings,
        );

      case '/profile-setup':
        return MaterialPageRoute(
          builder: (_) => const ProfileSetupScreen(),
          settings: settings,
        );

      case '/home':
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );

      case '/main':
        return MaterialPageRoute(
          builder: (_) => const MainNavigationScreen(),
          settings: settings,
        );

      case '/settings':
        return MaterialPageRoute(
          builder: (_) => const SettingsScreen(),
          settings: settings,
        );

      case '/notification-settings':
        return MaterialPageRoute(
          builder: (_) => const NotificationSettingsScreen(),
          settings: settings,
        );

      case '/ai-provider-settings':
        return MaterialPageRoute(
          builder: (_) => const AIProviderSettingsScreen(),
          settings: settings,
        );

      case '/privacy-settings':
        return MaterialPageRoute(
          builder: (_) => const PrivacySettingsScreen(),
          settings: settings,
        );

      case '/account-settings':
        return MaterialPageRoute(
          builder: (_) => const AccountSettingsScreen(),
          settings: settings,
        );

      case '/workout-session':
        return MaterialPageRoute(
          builder: (_) => const WorkoutSessionScreen(),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const NotFoundScreen(),
          settings: settings,
        );
    }
  }
}

/// 404 Not Found screen
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 100, color: Colors.red),
            SizedBox(height: 24),
            Text(
              '404 - Page Not Found',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'The page you are looking for does not exist.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
