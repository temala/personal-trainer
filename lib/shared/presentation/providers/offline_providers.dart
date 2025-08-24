import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitness_training_app/shared/data/services/offline_manager.dart';

/// Provider for OfflineManager
final offlineManagerProvider = Provider<OfflineManager>((ref) {
  return OfflineManager();
});
