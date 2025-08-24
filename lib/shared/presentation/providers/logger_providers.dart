import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitness_training_app/core/utils/logger.dart';

/// Provider for AppLogger
final loggerProvider = Provider<AppLogger>((ref) {
  return AppLogger();
});
