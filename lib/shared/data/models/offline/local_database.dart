import 'package:hive_flutter/hive_flutter.dart';

import 'package:fitness_training_app/core/utils/logger.dart';
import 'package:fitness_training_app/shared/data/models/offline/hive_adapters.dart';
import 'package:fitness_training_app/shared/data/models/offline/offline_models.dart';
import 'package:fitness_training_app/shared/data/services/exercise_animation_service.dart';
import 'package:fitness_training_app/shared/domain/entities/user_profile.dart';

/// Local database manager using Hive for offline storage
class LocalDatabase {
  static const String _userProfileBox = 'user_profiles';
  static const String _exercisesBox = 'exercises';
  static const String _workoutPlansBox = 'workout_plans';
  static const String _workoutSessionsBox = 'workout_sessions';
  static const String _cachedWorkoutPlansBox = 'cached_workout_plans';
  static const String _offlineSessionsBox = 'offline_sessions';
  static const String _cachedExercisesBox = 'cached_exercises';
  static const String _syncQueueBox = 'sync_queue';
  static const String _animationCacheBox = 'exercise_animations_cache';
  static const String _metadataBox = 'metadata';

  static const int _currentSchemaVersion = 1;

  /// Initialize the local database
  static Future<void> initialize() async {
    try {
      AppLogger.info('Initializing local database...');

      // Initialize Hive
      await Hive.initFlutter();

      // Register all type adapters
      HiveAdapters.registerAdapters();

      // Open all boxes
      await _openBoxes();

      // Run migrations if needed
      await _runMigrations();

      AppLogger.info('Local database initialized successfully');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to initialize local database', e, stackTrace);
      rethrow;
    }
  }

  /// Open all required Hive boxes
  static Future<void> _openBoxes() async {
    final boxes = [
      _userProfileBox,
      _exercisesBox,
      _workoutPlansBox,
      _workoutSessionsBox,
      _cachedWorkoutPlansBox,
      _offlineSessionsBox,
      _cachedExercisesBox,
      _syncQueueBox,
      _animationCacheBox,
      _metadataBox,
    ];

    for (final boxName in boxes) {
      try {
        // Open typed boxes for specific data types
        if (boxName == _userProfileBox) {
          await Hive.openBox<UserProfile>(boxName);
        } else if (boxName == _cachedWorkoutPlansBox) {
          await Hive.openBox<CachedWorkoutPlan>(boxName);
        } else if (boxName == _offlineSessionsBox) {
          await Hive.openBox<OfflineWorkoutSession>(boxName);
        } else if (boxName == _cachedExercisesBox) {
          await Hive.openBox<CachedExercise>(boxName);
        } else if (boxName == _syncQueueBox) {
          await Hive.openBox<SyncQueueItem>(boxName);
        } else if (boxName == _animationCacheBox) {
          await Hive.openBox<CachedAnimation>(boxName);
        } else {
          await Hive.openBox(boxName);
        }
        AppLogger.debug('Opened box: $boxName');
      } catch (e) {
        AppLogger.error('Failed to open box: $boxName', e);
        rethrow;
      }
    }
  }

  /// Run database migrations
  static Future<void> _runMigrations() async {
    try {
      final metadataBox = Hive.box(_metadataBox);
      final currentVersion =
          metadataBox.get('schema_version', defaultValue: 0) as int;

      if (currentVersion < _currentSchemaVersion) {
        AppLogger.info(
          'Running database migrations from version $currentVersion to $_currentSchemaVersion',
        );

        // Run migrations sequentially
        for (
          int version = currentVersion + 1;
          version <= _currentSchemaVersion;
          version++
        ) {
          await _runMigration(version);
          metadataBox.put('schema_version', version);
          AppLogger.info('Completed migration to version $version');
        }

        AppLogger.info('All database migrations completed');
      } else {
        AppLogger.debug(
          'Database schema is up to date (version $currentVersion)',
        );
      }
    } catch (e, stackTrace) {
      AppLogger.error('Failed to run database migrations', e, stackTrace);
      rethrow;
    }
  }

  /// Run a specific migration
  static Future<void> _runMigration(int version) async {
    switch (version) {
      case 1:
        await _migrationV1();
        break;
      default:
        AppLogger.warning('Unknown migration version: $version');
    }
  }

  /// Migration to version 1 - Initial schema setup
  static Future<void> _migrationV1() async {
    AppLogger.info('Running migration V1: Initial schema setup');

    // Set up initial metadata
    final metadataBox = Hive.box(_metadataBox);
    metadataBox
      ..put('created_at', DateTime.now().toIso8601String())
      ..put('app_version', '1.0.0');

    // Initialize sync queue if empty - use the typed box accessor
    final syncQueueBox = Hive.box<SyncQueueItem>(_syncQueueBox);
    if (syncQueueBox.isEmpty) {
      AppLogger.debug('Initialized empty sync queue');
    }

    // Set up cache cleanup metadata
    final cacheMetadata = {
      'last_cleanup': DateTime.now().toIso8601String(),
      'cleanup_interval_hours': 24,
      'max_cache_size_mb': 100,
    };
    metadataBox.put('cache_metadata', cacheMetadata);
  }

  /// Get user profile box
  static Box<UserProfile> get userProfileBox =>
      Hive.box<UserProfile>(_userProfileBox);

  /// Get exercises box
  static Box get exercisesBox => Hive.box(_exercisesBox);

  /// Get workout plans box
  static Box get workoutPlansBox => Hive.box(_workoutPlansBox);

  /// Get workout sessions box
  static Box get workoutSessionsBox => Hive.box(_workoutSessionsBox);

  /// Get cached workout plans box
  static Box<CachedWorkoutPlan> get cachedWorkoutPlansBox =>
      Hive.box<CachedWorkoutPlan>(_cachedWorkoutPlansBox);

  /// Get offline sessions box
  static Box<OfflineWorkoutSession> get offlineSessionsBox =>
      Hive.box<OfflineWorkoutSession>(_offlineSessionsBox);

  /// Get cached exercises box
  static Box<CachedExercise> get cachedExercisesBox =>
      Hive.box<CachedExercise>(_cachedExercisesBox);

  /// Get sync queue box
  static Box<SyncQueueItem> get syncQueueBox =>
      Hive.box<SyncQueueItem>(_syncQueueBox);

  /// Get animation cache box
  static Box<CachedAnimation> get animationCacheBox =>
      Hive.box<CachedAnimation>(_animationCacheBox);

  /// Get metadata box
  static Box get metadataBox => Hive.box(_metadataBox);

  /// Clear all data (for testing or reset)
  static Future<void> clearAllData() async {
    try {
      AppLogger.warning('Clearing all local database data');

      final boxes = [
        _userProfileBox,
        _exercisesBox,
        _workoutPlansBox,
        _workoutSessionsBox,
        _cachedWorkoutPlansBox,
        _offlineSessionsBox,
        _cachedExercisesBox,
        _syncQueueBox,
      ];

      for (final boxName in boxes) {
        final box = Hive.box(boxName);
        await box.clear();
        AppLogger.debug('Cleared box: $boxName');
      }

      // Reset metadata but keep schema version
      final metadataBox = Hive.box(_metadataBox);
      final schemaVersion = metadataBox.get('schema_version');
      await metadataBox.clear();
      metadataBox.put('schema_version', schemaVersion);
      metadataBox.put('cleared_at', DateTime.now().toIso8601String());

      AppLogger.info('All local database data cleared');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to clear local database data', e, stackTrace);
      rethrow;
    }
  }

  /// Get database statistics
  static Map<String, dynamic> getStatistics() {
    try {
      return {
        'schema_version': metadataBox.get('schema_version', defaultValue: 0),
        'user_profiles_count': userProfileBox.length,
        'exercises_count': exercisesBox.length,
        'workout_plans_count': workoutPlansBox.length,
        'workout_sessions_count': workoutSessionsBox.length,
        'cached_workout_plans_count': cachedWorkoutPlansBox.length,
        'offline_sessions_count': offlineSessionsBox.length,
        'cached_exercises_count': cachedExercisesBox.length,
        'sync_queue_count': syncQueueBox.length,
        'total_size_estimate_kb': _estimateTotalSize(),
        'last_cleanup':
            metadataBox.get(
              'cache_metadata',
              defaultValue: <String, dynamic>{},
            )['last_cleanup'],
      };
    } catch (e) {
      AppLogger.error('Failed to get database statistics', e);
      return {'error': e.toString()};
    }
  }

  /// Estimate total database size in KB
  static int _estimateTotalSize() {
    try {
      int totalSize = 0;

      // Rough estimation based on box lengths and average record sizes
      totalSize += userProfileBox.length * 2; // ~2KB per profile
      totalSize += exercisesBox.length * 5; // ~5KB per exercise
      totalSize += workoutPlansBox.length * 10; // ~10KB per plan
      totalSize += workoutSessionsBox.length * 15; // ~15KB per session
      totalSize += cachedWorkoutPlansBox.length * 12; // ~12KB per cached plan
      totalSize += offlineSessionsBox.length * 18; // ~18KB per offline session
      totalSize += cachedExercisesBox.length * 6; // ~6KB per cached exercise
      totalSize += syncQueueBox.length * 3; // ~3KB per sync item

      return totalSize;
    } catch (e) {
      AppLogger.error('Failed to estimate database size', e);
      return 0;
    }
  }

  /// Perform cache cleanup
  static Future<void> performCacheCleanup() async {
    try {
      AppLogger.info('Starting cache cleanup...');

      final now = DateTime.now();
      int cleanedItems = 0;

      // Clean up stale cached workout plans
      final cachedPlans = cachedWorkoutPlansBox.values.toList();
      for (final plan in cachedPlans) {
        if (plan.isStale && !plan.needsSync) {
          await plan.delete();
          cleanedItems++;
        }
      }

      // Clean up old cached exercises that are not frequently accessed
      final cachedExercises = cachedExercisesBox.values.toList();
      for (final exercise in cachedExercises) {
        if (exercise.isStale &&
            !exercise.isFrequentlyAccessed &&
            !exercise.isPreloaded) {
          await exercise.delete();
          cleanedItems++;
        }
      }

      // Clean up old sync queue items that have failed too many times
      final syncItems = syncQueueBox.values.toList();
      for (final item in syncItems) {
        if (item.retryCount >= 3 &&
            item.lastAttempt != null &&
            now.difference(item.lastAttempt!).inDays > 7) {
          await item.delete();
          cleanedItems++;
        }
      }

      // Update cleanup metadata
      final metadataBox = Hive.box(_metadataBox);
      final cacheMetadata = Map<String, dynamic>.from(
        metadataBox.get('cache_metadata', defaultValue: <String, dynamic>{})
            as Map<dynamic, dynamic>,
      );
      cacheMetadata['last_cleanup'] = now.toIso8601String();
      cacheMetadata['last_cleanup_items_removed'] = cleanedItems;
      metadataBox.put('cache_metadata', cacheMetadata);

      AppLogger.info('Cache cleanup completed. Removed $cleanedItems items');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to perform cache cleanup', e, stackTrace);
    }
  }

  /// Check if cache cleanup is needed
  static bool isCacheCleanupNeeded() {
    try {
      final metadataBox = Hive.box(_metadataBox);
      final cacheMetadata = metadataBox.get(
        'cache_metadata',
        defaultValue: <String, dynamic>{},
      );
      final lastCleanupStr = cacheMetadata['last_cleanup'] as String?;

      if (lastCleanupStr == null) return true;

      final lastCleanup = DateTime.parse(lastCleanupStr);
      final cleanupInterval = Duration(
        hours: cacheMetadata['cleanup_interval_hours'] as int? ?? 24,
      );

      return DateTime.now().difference(lastCleanup) > cleanupInterval;
    } catch (e) {
      AppLogger.error('Failed to check cache cleanup status', e);
      return true; // Default to needing cleanup on error
    }
  }

  /// Close all boxes and cleanup
  static Future<void> close() async {
    try {
      AppLogger.info('Closing local database...');
      await Hive.close();
      AppLogger.info('Local database closed');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to close local database', e, stackTrace);
    }
  }

  /// Compact all boxes to optimize storage
  static Future<void> compactDatabase() async {
    try {
      AppLogger.info('Compacting database...');

      final boxes = [
        _userProfileBox,
        _exercisesBox,
        _workoutPlansBox,
        _workoutSessionsBox,
        _cachedWorkoutPlansBox,
        _offlineSessionsBox,
        _cachedExercisesBox,
        _syncQueueBox,
        _metadataBox,
      ];

      for (final boxName in boxes) {
        final box = Hive.box(boxName);
        await box.compact();
        AppLogger.debug('Compacted box: $boxName');
      }

      AppLogger.info('Database compaction completed');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to compact database', e, stackTrace);
    }
  }
}

/// Database schema information
class DatabaseSchema {
  static const int currentVersion = 1;

  static const Map<String, String> boxDescriptions = {
    'user_profiles': 'User profile data and preferences',
    'exercises': 'Exercise definitions and metadata',
    'workout_plans': 'Workout plans and routines',
    'workout_sessions': 'Completed workout sessions',
    'cached_workout_plans': 'Cached workout plans with sync metadata',
    'offline_sessions': 'Offline workout sessions pending sync',
    'cached_exercises': 'Cached exercise data for offline use',
    'sync_queue': 'Queue of operations pending synchronization',
    'metadata': 'Database metadata and configuration',
  };

  static const Map<int, String> migrationDescriptions = {
    1: 'Initial schema setup with all core boxes and metadata',
  };
}
