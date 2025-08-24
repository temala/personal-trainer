import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import 'package:fitness_training_app/core/utils/logger.dart';
import 'package:fitness_training_app/shared/data/services/database_migration_service.dart';

/// Service for resetting Hive database during development
class HiveResetService {
  /// Reset the entire Hive database
  static Future<void> resetDatabase() async {
    if (kDebugMode) {
      AppLogger.warning('🔄 Resetting Hive database...');

      try {
        await DatabaseMigrationService.forceClearDatabase();
        AppLogger.info('✅ Database reset completed');
      } catch (e, stackTrace) {
        AppLogger.error('❌ Database reset failed', e, stackTrace);
      }
    } else {
      AppLogger.warning('Database reset is only available in debug mode');
    }
  }

  /// Check if database needs reset due to schema conflicts
  static Future<bool> needsReset() async {
    try {
      // Try to access a known box to check for conflicts
      final testBox = await Hive.openBox('schema_test');
      await testBox.close();
      return false;
    } catch (e) {
      AppLogger.warning('Schema conflict detected: $e');
      return true;
    }
  }

  /// Get database status information
  static Future<Map<String, dynamic>> getDatabaseStatus() async {
    try {
      final migrationStatus =
          await DatabaseMigrationService.getMigrationStatus();

      final openBoxes = <String>[];
      // Note: Hive doesn't provide a direct way to list all open boxes
      // This is a limitation of the Hive API

      return {
        'migration_status': migrationStatus,
        'open_boxes': openBoxes,
        'needs_reset': await needsReset(),
      };
    } catch (e) {
      return {'error': e.toString(), 'needs_reset': true};
    }
  }
}
