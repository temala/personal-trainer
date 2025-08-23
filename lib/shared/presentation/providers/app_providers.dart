import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fitness_training_app/core/utils/logger.dart';
import 'package:fitness_training_app/shared/data/models/offline/local_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Connectivity provider to monitor network status
final connectivityProvider = StreamProvider<List<ConnectivityResult>>((ref) {
  return Connectivity().onConnectivityChanged;
});

/// Shared preferences provider
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden');
});

/// Hive initialization status provider
final hiveInitializedProvider = Provider<bool>((ref) {
  return true; // Will be overridden in main.dart
});

/// Hive database provider
final hiveProvider = Provider<HiveInterface>((ref) {
  return Hive;
});

/// Network status provider
final networkStatusProvider = Provider<bool>((ref) {
  final connectivity = ref.watch(connectivityProvider);
  return connectivity.when(
    data: (results) => !results.contains(ConnectivityResult.none),
    loading: () => false,
    error: (_, __) => false,
  );
});

/// App initialization provider
final appInitializationProvider = FutureProvider<void>((ref) async {
  // Check if Hive is initialized
  final hiveInitialized = ref.watch(hiveInitializedProvider);
  if (!hiveInitialized) {
    throw Exception('Hive database not initialized');
  }

  // Additional initialization logic will be added here
  AppLogger.info('App initialization completed successfully');
});

/// Theme mode provider
final themeModeProvider = StateProvider<bool>((ref) {
  // Default to light theme, will be loaded from preferences
  return false; // false = light, true = dark
});
