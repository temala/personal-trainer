import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fitness_training_app/core/config/firebase_config.dart';
import 'package:fitness_training_app/core/routing/app_router.dart';
import 'package:fitness_training_app/core/utils/logger.dart';
import 'package:fitness_training_app/features/auth/presentation/widgets/auth_wrapper.dart';
import 'package:fitness_training_app/shared/data/models/offline/local_database.dart';
import 'package:fitness_training_app/shared/presentation/providers/app_providers.dart';
import 'package:fitness_training_app/shared/presentation/themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Enable debug logging in debug mode
  if (kDebugMode) {
    AppLogger.info('Running in debug mode');
  }

  SharedPreferences? sharedPreferences;
  bool firebaseInitialized = false;
  bool hiveInitialized = false;

  try {
    // Initialize SharedPreferences (critical)
    sharedPreferences = await SharedPreferences.getInstance();
    AppLogger.info('SharedPreferences initialized successfully');
  } catch (e, stackTrace) {
    AppLogger.error('Failed to initialize SharedPreferences', e, stackTrace);
  }

  try {
    // Initialize Hive database (critical for offline functionality)
    await LocalDatabase.initialize();
    hiveInitialized = true;
    AppLogger.info('Hive database initialized successfully');
  } catch (e, stackTrace) {
    AppLogger.error('Failed to initialize Hive database', e, stackTrace);
    hiveInitialized = false;
  }

  try {
    // Initialize Firebase (non-critical for basic app functionality)
    await FirebaseConfig.initialize();
    firebaseInitialized = true;
    AppLogger.info('Firebase initialized successfully');
  } catch (e, stackTrace) {
    AppLogger.error(
      'Failed to initialize Firebase (continuing without Firebase)',
      e,
      stackTrace,
    );
    firebaseInitialized = false;
  }

  // Always run the app, even if some services failed to initialize
  runApp(
    ProviderScope(
      overrides: [
        if (sharedPreferences != null)
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        hiveInitializedProvider.overrideWithValue(hiveInitialized),
      ],
      child: FitnessTrainingApp(
        firebaseInitialized: firebaseInitialized,
        hiveInitialized: hiveInitialized,
      ),
    ),
  );
}

class FitnessTrainingApp extends ConsumerWidget {
  const FitnessTrainingApp({
    super.key,
    this.firebaseInitialized = true,
    this.hiveInitialized = true,
  });

  final bool firebaseInitialized;
  final bool hiveInitialized;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeModeProvider);

    // Show error screen if critical services failed to initialize
    if (!hiveInitialized) {
      return MaterialApp(
        title: 'Fitness Training App',
        theme: AppTheme.lightTheme,
        home: ErrorScreen(
          message: 'Database initialization failed. Please restart the app.',
        ),
      );
    }

    final appInitialization = ref.watch(appInitializationProvider);

    return MaterialApp(
      title: 'Fitness Training App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: '/',
      home: appInitialization.when(
        data: (_) => const AuthWrapper(),
        loading: () => const LoadingScreen(),
        error: (error, stackTrace) {
          AppLogger.error('App initialization failed', error, stackTrace);
          return ErrorScreen(message: 'Failed to initialize app: $error');
        },
      ),
    );
  }
}

/// Loading screen shown during app initialization
class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo placeholder
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.fitness_center,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Fitness Training App',
              style: Theme.of(
                context,
              ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Initializing your fitness journey...',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 32),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}

/// Error screen shown when app initialization fails
class ErrorScreen extends StatelessWidget {
  const ErrorScreen({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 80,
                color: AppTheme.errorColor,
              ),
              const SizedBox(height: 24),
              Text(
                'Oops! Something went wrong',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppTheme.errorColor,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                message,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppTheme.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // Restart the app
                  // In a real app, you might want to implement app restart functionality
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
