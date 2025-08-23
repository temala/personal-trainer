import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';

import 'package:fitness_training_app/core/utils/logger.dart';
import 'package:fitness_training_app/shared/data/models/offline/offline_models.dart';

/// Manages offline functionality and connectivity monitoring
class OfflineManager {
  final Connectivity _connectivity;
  final StreamController<bool> _connectivityController =
      StreamController<bool>.broadcast();

  bool _isOnline = false;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  static const Duration _connectivityCheckInterval = Duration(seconds: 30);
  Timer? _connectivityTimer;

  OfflineManager({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  /// Stream of connectivity status changes
  Stream<bool> get connectivityStatus => _connectivityController.stream;

  /// Current connectivity status
  bool get isOnline => _isOnline;

  /// Initialize offline manager
  Future<void> initialize() async {
    try {
      // Check initial connectivity
      await _checkConnectivity();

      // Listen to connectivity changes
      _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
        _onConnectivityChanged,
        onError: (Object error) {
          AppLogger.error('Connectivity stream error', error);
        },
      );

      // Set up periodic connectivity checks
      _connectivityTimer = Timer.periodic(
        _connectivityCheckInterval,
        (_) => _checkConnectivity(),
      );

      AppLogger.info('OfflineManager initialized successfully');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to initialize OfflineManager', e, stackTrace);
      rethrow;
    }
  }

  /// Dispose resources
  Future<void> dispose() async {
    await _connectivitySubscription?.cancel();
    _connectivityTimer?.cancel();
    await _connectivityController.close();
    AppLogger.info('OfflineManager disposed');
  }

  /// Enable offline mode for the app
  Future<void> enableOfflineMode() async {
    try {
      // Initialize Hive boxes for offline storage
      await _initializeOfflineStorage();

      AppLogger.info('Offline mode enabled');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to enable offline mode', e, stackTrace);
      rethrow;
    }
  }

  /// Check if specific data is available offline
  Future<bool> isDataAvailableOffline({
    required String dataType,
    String? userId,
  }) async {
    try {
      switch (dataType) {
        case 'exercises':
          final exerciseBox = Hive.box<CachedExercise>('exercises_cache');
          return exerciseBox.isNotEmpty;

        case 'user_profile':
          if (userId == null) return false;
          final userBox = Hive.box('user_cache');
          return userBox.containsKey(userId);

        case 'workout_plans':
          if (userId == null) return false;
          final planBox = Hive.box<CachedWorkoutPlan>('workout_plans_cache');
          return planBox.values.any((plan) => plan.userId == userId);

        case 'workout_sessions':
          if (userId == null) return false;
          final sessionBox = Hive.box<OfflineWorkoutSession>(
            'workout_sessions_cache',
          );
          return sessionBox.values.any((session) => session.userId == userId);

        default:
          return false;
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error checking offline data availability for $dataType',
        e,
        stackTrace,
      );
      return false;
    }
  }

  /// Get offline storage statistics
  Future<Map<String, dynamic>> getOfflineStorageStats() async {
    try {
      final stats = <String, dynamic>{};

      // Exercise cache stats
      if (Hive.isBoxOpen('exercises_cache')) {
        final exerciseBox = Hive.box<CachedExercise>('exercises_cache');
        stats['exercises'] = {
          'count': exerciseBox.length,
          'sizeBytes': _estimateBoxSize(exerciseBox),
        };
      }

      // User cache stats
      if (Hive.isBoxOpen('user_cache')) {
        final userBox = Hive.box('user_cache');
        stats['users'] = {
          'count': userBox.length,
          'sizeBytes': _estimateBoxSize(userBox),
        };
      }

      // Workout plans cache stats
      if (Hive.isBoxOpen('workout_plans_cache')) {
        final planBox = Hive.box<CachedWorkoutPlan>('workout_plans_cache');
        stats['workoutPlans'] = {
          'count': planBox.length,
          'sizeBytes': _estimateBoxSize(planBox),
        };
      }

      // Workout sessions cache stats
      if (Hive.isBoxOpen('workout_sessions_cache')) {
        final sessionBox = Hive.box<OfflineWorkoutSession>(
          'workout_sessions_cache',
        );
        stats['workoutSessions'] = {
          'count': sessionBox.length,
          'sizeBytes': _estimateBoxSize(sessionBox),
        };
      }

      // Sync queue stats
      if (Hive.isBoxOpen('sync_queue')) {
        final syncBox = Hive.box<SyncQueueItem>('sync_queue');
        stats['syncQueue'] = {
          'count': syncBox.length,
          'sizeBytes': _estimateBoxSize(syncBox),
        };
      }

      stats['totalSizeBytes'] = stats.values
          .map((stat) => stat['sizeBytes'] as int? ?? 0)
          .fold<int>(0, (sum, size) => sum + size);

      return stats;
    } catch (e, stackTrace) {
      AppLogger.error('Error getting offline storage stats', e, stackTrace);
      return {};
    }
  }

  /// Clear offline cache for specific data type
  Future<void> clearOfflineCache({
    required String dataType,
    String? userId,
  }) async {
    try {
      switch (dataType) {
        case 'exercises':
          final exerciseBox = Hive.box<CachedExercise>('exercises_cache');
          await exerciseBox.clear();
          AppLogger.info('Cleared exercises cache');
          break;

        case 'user_profile':
          if (userId != null) {
            final userBox = Hive.box('user_cache');
            await userBox.delete(userId);
            AppLogger.info('Cleared user profile cache for $userId');
          }
          break;

        case 'workout_plans':
          if (userId != null) {
            final planBox = Hive.box<CachedWorkoutPlan>('workout_plans_cache');
            final keysToDelete =
                planBox.values
                    .where((plan) => plan.userId == userId)
                    .map((plan) => plan.id)
                    .toList();
            for (final key in keysToDelete) {
              await planBox.delete(key);
            }
            AppLogger.info('Cleared workout plans cache for $userId');
          }
          break;

        case 'workout_sessions':
          if (userId != null) {
            final sessionBox = Hive.box<OfflineWorkoutSession>(
              'workout_sessions_cache',
            );
            final keysToDelete =
                sessionBox.values
                    .where((session) => session.userId == userId)
                    .map((session) => session.sessionId)
                    .toList();
            for (final key in keysToDelete) {
              await sessionBox.delete(key);
            }
            AppLogger.info('Cleared workout sessions cache for $userId');
          }
          break;

        case 'all':
          await _clearAllCaches();
          AppLogger.info('Cleared all offline caches');
          break;
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error clearing offline cache for $dataType',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  /// Optimize offline storage by removing stale data
  Future<void> optimizeOfflineStorage() async {
    try {
      int removedItems = 0;

      // Clean up stale exercise cache
      if (Hive.isBoxOpen('exercises_cache')) {
        final exerciseBox = Hive.box<CachedExercise>('exercises_cache');
        final staleKeys = <String>[];

        for (final entry in exerciseBox.toMap().entries) {
          final cached = entry.value;
          if (cached.isStale && !cached.isFrequentlyAccessed) {
            staleKeys.add(entry.key as String);
          }
        }

        for (final key in staleKeys) {
          await exerciseBox.delete(key);
          removedItems++;
        }
      }

      // Clean up stale workout plans
      if (Hive.isBoxOpen('workout_plans_cache')) {
        final planBox = Hive.box<CachedWorkoutPlan>('workout_plans_cache');
        final staleKeys = <String>[];

        for (final entry in planBox.toMap().entries) {
          final cached = entry.value;
          if (cached.isStale) {
            staleKeys.add(entry.key as String);
          }
        }

        for (final key in staleKeys) {
          await planBox.delete(key);
          removedItems++;
        }
      }

      // Clean up old workout sessions (keep last 100 per user)
      if (Hive.isBoxOpen('workout_sessions_cache')) {
        final sessionBox = Hive.box<OfflineWorkoutSession>(
          'workout_sessions_cache',
        );
        final userSessions =
            <String, List<MapEntry<dynamic, OfflineWorkoutSession>>>{};

        // Group sessions by user
        for (final entry in sessionBox.toMap().entries) {
          final userId = entry.value.userId;
          userSessions.putIfAbsent(userId, () => []).add(entry);
        }

        // Keep only the latest 100 sessions per user
        for (final userSessionList in userSessions.values) {
          userSessionList.sort(
            (a, b) => b.value.createdAt.compareTo(a.value.createdAt),
          );

          if (userSessionList.length > 100) {
            final sessionsToRemove = userSessionList.skip(100);
            for (final entry in sessionsToRemove) {
              await sessionBox.delete(entry.key);
              removedItems++;
            }
          }
        }
      }

      AppLogger.info('Optimized offline storage, removed $removedItems items');
    } catch (e, stackTrace) {
      AppLogger.error('Error optimizing offline storage', e, stackTrace);
    }
  }

  /// Get connectivity quality assessment
  Future<ConnectivityQuality> getConnectivityQuality() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();

      if (connectivityResult.contains(ConnectivityResult.none)) {
        return ConnectivityQuality.none;
      }

      if (connectivityResult.contains(ConnectivityResult.wifi) ||
          connectivityResult.contains(ConnectivityResult.ethernet)) {
        return ConnectivityQuality.excellent;
      }

      if (connectivityResult.contains(ConnectivityResult.mobile)) {
        // For mobile, we assume good quality
        // In a real app, you might want to test actual network speed
        return ConnectivityQuality.good;
      }

      return ConnectivityQuality.poor;
    } catch (e) {
      AppLogger.warning('Error assessing connectivity quality, assuming poor');
      return ConnectivityQuality.poor;
    }
  }

  // Private methods

  Future<void> _checkConnectivity() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      final wasOnline = _isOnline;

      _isOnline =
          connectivityResult.contains(ConnectivityResult.mobile) ||
          connectivityResult.contains(ConnectivityResult.wifi) ||
          connectivityResult.contains(ConnectivityResult.ethernet);

      if (wasOnline != _isOnline) {
        _connectivityController.add(_isOnline);
        AppLogger.info(
          'Connectivity changed: ${_isOnline ? 'online' : 'offline'}',
        );
      }
    } catch (e) {
      AppLogger.warning('Error checking connectivity: $e');
      if (_isOnline) {
        _isOnline = false;
        _connectivityController.add(false);
      }
    }
  }

  void _onConnectivityChanged(List<ConnectivityResult> results) {
    final wasOnline = _isOnline;

    _isOnline =
        results.contains(ConnectivityResult.mobile) ||
        results.contains(ConnectivityResult.wifi) ||
        results.contains(ConnectivityResult.ethernet);

    if (wasOnline != _isOnline) {
      _connectivityController.add(_isOnline);
      AppLogger.info(
        'Connectivity changed: ${_isOnline ? 'online' : 'offline'}',
      );
    }
  }

  Future<void> _initializeOfflineStorage() async {
    // Initialize all required Hive boxes
    final boxNames = [
      'exercises_cache',
      'user_cache',
      'workout_plans_cache',
      'workout_sessions_cache',
      'sync_queue',
    ];

    for (final boxName in boxNames) {
      if (!Hive.isBoxOpen(boxName)) {
        await Hive.openBox(boxName);
      }
    }
  }

  int _estimateBoxSize(Box box) {
    // Simple estimation based on number of items
    // In a real app, you might want more accurate size calculation
    return box.length * 1024; // Assume 1KB per item on average
  }

  Future<void> _clearAllCaches() async {
    final boxNames = [
      'exercises_cache',
      'user_cache',
      'workout_plans_cache',
      'workout_sessions_cache',
    ];

    for (final boxName in boxNames) {
      if (Hive.isBoxOpen(boxName)) {
        final box = Hive.box(boxName);
        await box.clear();
      }
    }
  }
}

/// Connectivity quality levels
enum ConnectivityQuality { none, poor, good, excellent }
