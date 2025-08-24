import 'package:hive/hive.dart';

import 'package:fitness_training_app/core/utils/logger.dart';
import 'package:fitness_training_app/shared/data/models/offline/local_database.dart';

/// Service for handling database migrations and schema changes
class DatabaseMigrationService {
  static const String _migrationBoxName = 'migration_metadata';
  static const int _currentSchemaVersion = 2;

  /// Handle database migration and cleanup
  static Future<void> handleMigration() async {
    try {
      AppLogger.info('Starting database migration check...');

      // Check if we need to clear the database due to schema conflicts
      final needsReset = await _checkForSchemaConflicts();

      if (needsReset) {
        AppLogger.warning('Schema conflicts detected, clearing database...');
        await _clearAllHiveData();
        await _setSchemaVersion(_currentSchemaVersion);
        AppLogger.info('Database cleared and reset to current schema');
        return;
      }

      // Run normal migrations
      await _runIncrementalMigrations();
    } catch (e, stackTrace) {
      AppLogger.error(
        'Migration failed, clearing database as fallback',
        e,
        stackTrace,
      );
      await _clearAllHiveData();
      await _setSchemaVersion(_currentSchemaVersion);
    }
  }

  /// Check for schema conflicts that require a full reset
  static Future<bool> _checkForSchemaConflicts() async {
    try {
      // Try to open a simple metadata box to check for conflicts
      final testBox = await Hive.openBox('migration_test');
      await testBox.close();

      // Check if we can read existing data without errors
      final boxes = [
        'user_profiles',
        'exercises',
        'workout_plans',
        'workout_sessions',
        'cached_workout_plans',
        'offline_sessions',
        'cached_exercises',
        'sync_queue',
        'exercise_animations_cache',
      ];

      for (final boxName in boxes) {
        try {
          if (await _boxExists(boxName)) {
            // Try to open and immediately close to test for conflicts
            final box = await Hive.openBox(boxName);
            await box.close();
          }
        } catch (e) {
          AppLogger.warning('Schema conflict detected in box: $boxName');
          return true;
        }
      }

      return false;
    } catch (e) {
      AppLogger.warning('Error checking schema conflicts: $e');
      return true; // Assume conflict if we can't check
    }
  }

  /// Check if a Hive box exists
  static Future<bool> _boxExists(String boxName) async {
    try {
      final box = await Hive.openBox(boxName);
      final exists = box.isOpen;
      await box.close();
      return exists;
    } catch (e) {
      return false;
    }
  }

  /// Clear all Hive data
  static Future<void> _clearAllHiveData() async {
    try {
      AppLogger.info('Clearing all Hive database data...');

      // List of all known box names
      final boxNames = [
        'user_profiles',
        'exercises',
        'workout_plans',
        'workout_sessions',
        'cached_workout_plans',
        'offline_sessions',
        'cached_exercises',
        'sync_queue',
        'exercise_animations_cache',
        'metadata',
        'migration_metadata',
      ];

      int clearedBoxes = 0;

      for (final boxName in boxNames) {
        try {
          // Try to open and clear the box
          if (Hive.isBoxOpen(boxName)) {
            final box = Hive.box(boxName);
            await box.clear();
            await box.close();
          } else {
            final box = await Hive.openBox(boxName);
            await box.clear();
            await box.close();
          }
          clearedBoxes++;
          AppLogger.debug('Cleared box: $boxName');
        } catch (e) {
          // Try to delete the box file directly
          try {
            await Hive.deleteBoxFromDisk(boxName);
            AppLogger.debug('Deleted box from disk: $boxName');
            clearedBoxes++;
          } catch (deleteError) {
            AppLogger.warning('Could not clear box $boxName: $e');
          }
        }
      }

      // Close all boxes
      await Hive.close();

      AppLogger.info('Cleared $clearedBoxes Hive boxes');
    } catch (e, stackTrace) {
      AppLogger.error('Error clearing Hive data', e, stackTrace);
    }
  }

  /// Run incremental migrations
  static Future<void> _runIncrementalMigrations() async {
    final currentVersion = await _getCurrentSchemaVersion();

    if (currentVersion < _currentSchemaVersion) {
      AppLogger.info(
        'Running incremental migrations from v$currentVersion to v$_currentSchemaVersion',
      );

      for (
        int version = currentVersion + 1;
        version <= _currentSchemaVersion;
        version++
      ) {
        await _runMigrationForVersion(version);
        await _setSchemaVersion(version);
        AppLogger.info('Completed migration to version $version');
      }
    }
  }

  /// Get current schema version
  static Future<int> _getCurrentSchemaVersion() async {
    try {
      final migrationBox = await Hive.openBox(_migrationBoxName);
      final version =
          migrationBox.get('schema_version', defaultValue: 0) as int;
      await migrationBox.close();
      return version;
    } catch (e) {
      AppLogger.warning('Could not read schema version, assuming 0: $e');
      return 0;
    }
  }

  /// Set schema version
  static Future<void> _setSchemaVersion(int version) async {
    try {
      final migrationBox = await Hive.openBox(_migrationBoxName);
      await migrationBox.put('schema_version', version);
      await migrationBox.put('migrated_at', DateTime.now().toIso8601String());
      await migrationBox.close();
    } catch (e) {
      AppLogger.error('Could not set schema version: $e');
    }
  }

  /// Run migration for specific version
  static Future<void> _runMigrationForVersion(int version) async {
    switch (version) {
      case 1:
        await _migrationV1();
        break;
      case 2:
        await _migrationV2();
        break;
      default:
        AppLogger.warning('Unknown migration version: $version');
    }
  }

  /// Migration V1: Initial setup
  static Future<void> _migrationV1() async {
    AppLogger.info('Running migration V1: Initial setup');
    // This migration is handled by LocalDatabase._migrationV1()
  }

  /// Migration V2: Fix adapter conflicts
  static Future<void> _migrationV2() async {
    AppLogger.info('Running migration V2: Fix adapter conflicts');

    // This migration ensures all adapters are properly registered
    // and handles any data structure changes

    try {
      // Verify all boxes can be opened with new adapters
      await LocalDatabase.initialize();
      AppLogger.info('Migration V2 completed successfully');
    } catch (e) {
      AppLogger.error('Migration V2 failed: $e');
      throw e;
    }
  }

  /// Force clear database (for development/testing)
  static Future<void> forceClearDatabase() async {
    AppLogger.warning('Force clearing database...');
    await _clearAllHiveData();
    await _setSchemaVersion(_currentSchemaVersion);
    AppLogger.info('Database force cleared');
  }

  /// Get migration status
  static Future<Map<String, dynamic>> getMigrationStatus() async {
    try {
      final currentVersion = await _getCurrentSchemaVersion();
      final migrationBox = await Hive.openBox(_migrationBoxName);
      final migratedAt = migrationBox.get('migrated_at') as String?;
      await migrationBox.close();

      return {
        'current_version': currentVersion,
        'target_version': _currentSchemaVersion,
        'needs_migration': currentVersion < _currentSchemaVersion,
        'last_migrated': migratedAt,
      };
    } catch (e) {
      return {
        'current_version': 0,
        'target_version': _currentSchemaVersion,
        'needs_migration': true,
        'error': e.toString(),
      };
    }
  }
}
