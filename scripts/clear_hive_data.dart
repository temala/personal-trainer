#!/usr/bin/env dart

import 'dart:io';

/// Script to clear Hive database files to resolve schema conflicts
Future<void> main(List<String> args) async {
  print('🧹 Clearing Hive database files...');

  final force = args.contains('--force') || args.contains('-f');
  final verbose = args.contains('--verbose') || args.contains('-v');

  if (!force) {
    print('⚠️  This will delete all local app data including:');
    print('   • User profiles and preferences');
    print('   • Cached workout plans and exercises');
    print('   • Offline workout sessions');
    print('   • Animation cache\n');
    stdout.write('Continue? (y/N): ');
    final input = stdin.readLineSync()?.toLowerCase();
    if (input != 'y' && input != 'yes') {
      print('❌ Cancelled');
      return;
    }
  }

  final searchPatterns = [
    '.hive',
    '.hive_generator',
    '.lock',
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

  final locations = [
    '${Platform.environment['HOME']}/Library/Developer/CoreSimulator/Devices',
    '${Platform.environment['HOME']}/.android/avd',
    './build',
    '${Platform.environment['HOME']}/Library/Application Support',
    '${Platform.environment['HOME']}/.local/share',
    '${Platform.environment['APPDATA']}',
  ];

  var filesDeleted = 0;
  var filesScanned = 0;
  var directoriesChecked = 0;

  for (final location in locations) {
    final dir = Directory(location);
    if (await dir.exists()) {
      directoriesChecked++;
      print('\n🔍 Searching in: $location');

      await for (final entity in dir.list(
        recursive: true,
        followLinks: false,
      )) {
        filesScanned++;

        if (entity is File) {
          final path = entity.path.toLowerCase();
          final fileName = entity.uri.pathSegments.last.toLowerCase();

          final shouldDelete = searchPatterns.any(
            (pattern) =>
                path.contains(pattern.toLowerCase()) ||
                fileName.contains(pattern.toLowerCase()),
          );

          if (shouldDelete) {
            try {
              await entity.delete();
              filesDeleted++;
              if (verbose) {
                print('🗑️  Deleted: ${entity.path}');
              }
            } catch (e) {
              print('⚠️  Could not delete: ${entity.path} ($e)');
            }
          }
        }

        // Update live progress every 100 files
        if (filesScanned % 100 == 0) {
          stdout.write(
            '\r   • Scanned: $filesScanned | Deleted: $filesDeleted',
          );
        }

        // Yield control to event loop every 500 files to avoid freezing
        if (filesScanned % 500 == 0) {
          await Future.delayed(Duration(milliseconds: 1));
        }
      }
    }
  }

  print('\n\n✅ Scan complete:');
  print('   • Directories checked: $directoriesChecked');
  print('   • Files scanned: $filesScanned');
  print('   • Files deleted: $filesDeleted\n');

  if (filesDeleted > 0) {
    print('💡 Database cleared! The app will start with a fresh database.');
  } else {
    print('💡 No Hive files found. The database may already be clean.');
  }

  print('\n🚀 You can now run: flutter run');
}
