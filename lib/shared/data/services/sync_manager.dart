import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

import 'package:fitness_training_app/core/constants/firebase_constants.dart';
import 'package:fitness_training_app/core/utils/logger.dart';
import 'package:fitness_training_app/shared/data/models/offline/offline_models.dart';
import 'package:fitness_training_app/shared/data/services/offline_manager.dart';
import 'package:fitness_training_app/shared/domain/entities/user_profile.dart';
import 'package:fitness_training_app/shared/domain/entities/workout_plan.dart';
import 'package:fitness_training_app/shared/domain/entities/workout_session.dart';

/// Manages data synchronization between local cache and Firebase
class SyncManager {
  final FirebaseFirestore _firestore;
  final Box<SyncQueueItem> _syncQueue;
  final OfflineManager _offlineManager;

  static const String _syncQueueBoxName = 'sync_queue';
  static const Duration _syncInterval = Duration(minutes: 5);
  static const int _maxRetryAttempts = 3;
  static const int _maxConcurrentSyncs = 3;

  Timer? _syncTimer;
  bool _isSyncing = false;
  int _activeSyncOperations = 0;

  SyncManager({
    FirebaseFirestore? firestore,
    Box<SyncQueueItem>? syncQueue,
    OfflineManager? offlineManager,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _syncQueue = syncQueue ?? Hive.box<SyncQueueItem>(_syncQueueBoxName),
       _offlineManager = offlineManager ?? OfflineManager();

  /// Initialize sync manager
  Future<void> initialize() async {
    try {
      // Listen to connectivity changes
      _offlineManager.connectivityStatus.listen(_onConnectivityChanged);

      // Start periodic sync if online
      if (_offlineManager.isOnline) {
        _startPeriodicSync();
      }

      AppLogger.info('SyncManager initialized successfully');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to initialize SyncManager', e, stackTrace);
      rethrow;
    }
  }

  /// Dispose resources
  Future<void> dispose() async {
    _syncTimer?.cancel();
    AppLogger.info('SyncManager disposed');
  }

  /// Manually trigger sync when online
  Future<void> syncWhenOnline() async {
    if (!_offlineManager.isOnline) {
      AppLogger.info('Cannot sync while offline');
      return;
    }

    if (_isSyncing) {
      AppLogger.info('Sync already in progress');
      return;
    }

    await _performSync();
  }

  /// Add item to sync queue
  Future<void> queueForSync(SyncQueueItem item) async {
    try {
      await _syncQueue.put(item.id, item);
      AppLogger.info(
        'Queued ${item.operation.name} ${item.entityType} ${item.entityId} for sync',
      );

      // Try immediate sync if online and not already syncing
      if (_offlineManager.isOnline &&
          !_isSyncing &&
          _activeSyncOperations < _maxConcurrentSyncs) {
        _performSingleSync(item);
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error queuing item for sync', e, stackTrace);
    }
  }

  /// Get pending sync operations count
  int get pendingSyncCount => _syncQueue.length;

  /// Get sync queue status
  Map<String, dynamic> getSyncStatus() {
    final pendingItems = _syncQueue.values.toList();
    final priorityGroups = <int, int>{};

    for (final item in pendingItems) {
      priorityGroups[item.priority] = (priorityGroups[item.priority] ?? 0) + 1;
    }

    return {
      'totalPending': pendingItems.length,
      'isSyncing': _isSyncing,
      'activeSyncOperations': _activeSyncOperations,
      'priorityGroups': priorityGroups,
      'failedItems':
          pendingItems
              .where((item) => item.retryCount >= _maxRetryAttempts)
              .length,
    };
  }

  /// Clear failed sync items
  Future<void> clearFailedSyncItems() async {
    try {
      final failedItems =
          _syncQueue.values
              .where((item) => item.retryCount >= _maxRetryAttempts)
              .toList();

      for (final item in failedItems) {
        await _syncQueue.delete(item.id);
      }

      AppLogger.info('Cleared ${failedItems.length} failed sync items');
    } catch (e, stackTrace) {
      AppLogger.error('Error clearing failed sync items', e, stackTrace);
    }
  }

  /// Retry failed sync items
  Future<void> retryFailedSyncItems() async {
    try {
      final failedItems =
          _syncQueue.values
              .where((item) => item.retryCount >= _maxRetryAttempts)
              .toList();

      for (final item in failedItems) {
        // Reset retry count and error
        final resetItem = SyncQueueItem(
          id: item.id,
          operation: item.operation,
          entityType: item.entityType,
          entityId: item.entityId,
          data: item.data,
          createdAt: item.createdAt,
          priority: item.priority,
          retryCount: 0,
          lastAttempt: null,
          error: null,
          metadata: item.metadata,
        );

        await _syncQueue.put(resetItem.id, resetItem);
      }

      AppLogger.info('Reset ${failedItems.length} failed sync items for retry');

      // Trigger sync if online
      if (_offlineManager.isOnline) {
        await _performSync();
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error retrying failed sync items', e, stackTrace);
    }
  }

  /// Resolve data conflicts using different strategies
  Future<void> resolveDataConflicts() async {
    try {
      // This is a simplified conflict resolution
      // In a real app, you might want more sophisticated conflict resolution

      final conflictItems =
          _syncQueue.values
              .where((item) => item.error?.contains('conflict') == true)
              .toList();

      for (final item in conflictItems) {
        await _resolveConflict(item);
      }

      AppLogger.info('Resolved ${conflictItems.length} data conflicts');
    } catch (e, stackTrace) {
      AppLogger.error('Error resolving data conflicts', e, stackTrace);
    }
  }

  /// Merge offline changes with server data
  Future<void> mergeOfflineChanges() async {
    try {
      if (!_offlineManager.isOnline) {
        AppLogger.info('Cannot merge offline changes while offline');
        return;
      }

      // Process all pending sync items with merge strategy
      final pendingItems =
          _syncQueue.values.where((item) => item.isReadyForRetry).toList();

      // Sort by priority (lower number = higher priority)
      pendingItems.sort((a, b) => a.priority.compareTo(b.priority));

      for (final item in pendingItems) {
        if (_activeSyncOperations >= _maxConcurrentSyncs) {
          break;
        }

        await _performSingleSync(item);
      }

      AppLogger.info('Merged ${pendingItems.length} offline changes');
    } catch (e, stackTrace) {
      AppLogger.error('Error merging offline changes', e, stackTrace);
    }
  }

  // Private methods

  void _onConnectivityChanged(bool isOnline) {
    if (isOnline) {
      AppLogger.info('Connection restored, starting sync');
      _startPeriodicSync();
      _performSync();
    } else {
      AppLogger.info('Connection lost, stopping sync');
      _stopPeriodicSync();
    }
  }

  void _startPeriodicSync() {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(_syncInterval, (_) => _performSync());
  }

  void _stopPeriodicSync() {
    _syncTimer?.cancel();
  }

  Future<void> _performSync() async {
    if (_isSyncing || !_offlineManager.isOnline) {
      return;
    }

    _isSyncing = true;

    try {
      final connectivityQuality =
          await _offlineManager.getConnectivityQuality();
      await _adaptiveSync(connectivityQuality);
    } catch (e, stackTrace) {
      AppLogger.error('Error during sync', e, stackTrace);
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> _adaptiveSync(ConnectivityQuality quality) async {
    switch (quality) {
      case ConnectivityQuality.excellent:
        await _fullSync();
        break;
      case ConnectivityQuality.good:
        await _prioritySync();
        break;
      case ConnectivityQuality.poor:
        await _criticalDataOnly();
        break;
      case ConnectivityQuality.none:
        // No sync when offline
        break;
    }
  }

  Future<void> _fullSync() async {
    final pendingItems =
        _syncQueue.values.where((item) => item.isReadyForRetry).toList();

    // Sort by priority and creation time
    pendingItems.sort((a, b) {
      final priorityComparison = a.priority.compareTo(b.priority);
      if (priorityComparison != 0) return priorityComparison;
      return a.createdAt.compareTo(b.createdAt);
    });

    AppLogger.info('Starting full sync of ${pendingItems.length} items');

    for (final item in pendingItems) {
      if (_activeSyncOperations >= _maxConcurrentSyncs) {
        await Future.delayed(const Duration(milliseconds: 100));
        continue;
      }

      await _performSingleSync(item);
    }
  }

  Future<void> _prioritySync() async {
    final highPriorityItems =
        _syncQueue.values
            .where((item) => item.isReadyForRetry && item.priority <= 1)
            .toList();

    highPriorityItems.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    AppLogger.info(
      'Starting priority sync of ${highPriorityItems.length} items',
    );

    for (final item in highPriorityItems) {
      if (_activeSyncOperations >= _maxConcurrentSyncs) {
        break;
      }

      await _performSingleSync(item);
    }
  }

  Future<void> _criticalDataOnly() async {
    final criticalItems =
        _syncQueue.values
            .where((item) => item.isReadyForRetry && item.priority == 0)
            .toList();

    criticalItems.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    AppLogger.info('Starting critical sync of ${criticalItems.length} items');

    for (final item in criticalItems) {
      if (_activeSyncOperations >= 1) {
        // Only one critical sync at a time
        break;
      }

      await _performSingleSync(item);
    }
  }

  Future<void> _performSingleSync(SyncQueueItem item) async {
    _activeSyncOperations++;

    try {
      await _syncItem(item);
      await _syncQueue.delete(item.id);
      AppLogger.info(
        'Successfully synced ${item.operation.name} ${item.entityType} ${item.entityId}',
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to sync ${item.operation.name} ${item.entityType} ${item.entityId}',
        e,
        stackTrace,
      );

      // Update retry count and error
      item.markAttempt(e.toString());
      await _syncQueue.put(item.id, item);

      // Remove from queue if max retries exceeded
      if (item.retryCount >= _maxRetryAttempts) {
        AppLogger.warning(
          'Max retries exceeded for ${item.entityType} ${item.entityId}',
        );
      }
    } finally {
      _activeSyncOperations--;
    }
  }

  Future<void> _syncItem(SyncQueueItem item) async {
    final collection = _getCollectionForEntityType(item.entityType);

    switch (item.operation) {
      case SyncOperation.create:
        await _syncCreate(collection, item);
        break;
      case SyncOperation.update:
        await _syncUpdate(collection, item);
        break;
      case SyncOperation.delete:
        await _syncDelete(collection, item);
        break;
      case SyncOperation.sync:
        await _syncBidirectional(collection, item);
        break;
    }
  }

  Future<void> _syncCreate(String collection, SyncQueueItem item) async {
    // For create operations, we need to handle temporary IDs
    if (item.entityId.startsWith('temp_')) {
      // Create new document and update local references
      final docRef = await _firestore.collection(collection).add(item.data);

      // Update local cache with real ID
      await _updateLocalReferences(item.entityType, item.entityId, docRef.id);
    } else {
      // Use the provided ID
      await _firestore.collection(collection).doc(item.entityId).set(item.data);
    }
  }

  Future<void> _syncUpdate(String collection, SyncQueueItem item) async {
    // Check if document exists on server
    final doc =
        await _firestore.collection(collection).doc(item.entityId).get();

    if (doc.exists) {
      // Merge with server data to avoid conflicts
      final serverData = doc.data()!;
      final mergedData = _mergeData(serverData, item.data);
      await _firestore
          .collection(collection)
          .doc(item.entityId)
          .update(mergedData);
    } else {
      // Document doesn't exist on server, create it
      await _firestore.collection(collection).doc(item.entityId).set(item.data);
    }
  }

  Future<void> _syncDelete(String collection, SyncQueueItem item) async {
    await _firestore.collection(collection).doc(item.entityId).delete();
  }

  Future<void> _syncBidirectional(String collection, SyncQueueItem item) async {
    // Fetch latest from server and merge with local changes
    final doc =
        await _firestore.collection(collection).doc(item.entityId).get();

    if (doc.exists) {
      final serverData = doc.data()!;
      final mergedData = _mergeData(serverData, item.data);

      // Update server with merged data
      await _firestore
          .collection(collection)
          .doc(item.entityId)
          .update(mergedData);

      // Update local cache with merged data
      await _updateLocalCache(item.entityType, item.entityId, mergedData);
    } else {
      // Document doesn't exist on server, create it
      await _firestore.collection(collection).doc(item.entityId).set(item.data);
    }
  }

  String _getCollectionForEntityType(String entityType) {
    switch (entityType) {
      case 'UserProfile':
        return FirebaseConstants.users;
      case 'WorkoutPlan':
        return FirebaseConstants.workoutPlans;
      case 'WorkoutSession':
        return FirebaseConstants.workoutSessions;
      case 'Exercise':
        return FirebaseConstants.exercises;
      default:
        throw ArgumentError('Unknown entity type: $entityType');
    }
  }

  Map<String, dynamic> _mergeData(
    Map<String, dynamic> serverData,
    Map<String, dynamic> localData,
  ) {
    // Simple merge strategy - local data takes precedence for most fields
    // In a real app, you might want more sophisticated merging based on timestamps

    final merged = Map<String, dynamic>.from(serverData);

    for (final entry in localData.entries) {
      // Skip null values
      if (entry.value != null) {
        merged[entry.key] = entry.value;
      }
    }

    // Always use the latest timestamp
    merged['updatedAt'] = FieldValue.serverTimestamp();

    return merged;
  }

  Future<void> _updateLocalReferences(
    String entityType,
    String oldId,
    String newId,
  ) async {
    // Update local cache references from temporary ID to real ID
    switch (entityType) {
      case 'WorkoutPlan':
        final planBox = Hive.box<CachedWorkoutPlan>('workout_plans_cache');
        final cachedPlan = planBox.get(oldId);
        if (cachedPlan != null) {
          final updatedPlan = cachedPlan.workoutPlan.copyWith(id: newId);
          final newCachedPlan = CachedWorkoutPlan.fromWorkoutPlan(
            updatedPlan,
            userId: cachedPlan.userId,
          );
          await planBox.delete(oldId);
          await planBox.put(newId, newCachedPlan);
        }
        break;

      case 'WorkoutSession':
        final sessionBox = Hive.box<OfflineWorkoutSession>(
          'workout_sessions_cache',
        );
        final cachedSession = sessionBox.get(oldId);
        if (cachedSession != null) {
          final updatedSession = cachedSession.session.copyWith(id: newId);
          final newCachedSession = OfflineWorkoutSession.fromSession(
            updatedSession,
            userId: cachedSession.userId,
          );
          await sessionBox.delete(oldId);
          await sessionBox.put(newId, newCachedSession);
        }
        break;
    }
  }

  Future<void> _updateLocalCache(
    String entityType,
    String entityId,
    Map<String, dynamic> data,
  ) async {
    // Update local cache with merged data
    switch (entityType) {
      case 'UserProfile':
        final userBox = Hive.box('user_cache');
        final profile = UserProfile.fromJson({'id': entityId, ...data});
        await userBox.put(entityId, profile);
        break;

      case 'WorkoutPlan':
        final planBox = Hive.box<CachedWorkoutPlan>('workout_plans_cache');
        final plan = WorkoutPlan.fromJson({'id': entityId, ...data});
        final cachedPlan = CachedWorkoutPlan.fromWorkoutPlan(
          plan,
          userId: data['userId'] as String? ?? '',
        );
        await planBox.put(entityId as String, cachedPlan);
        break;

      case 'WorkoutSession':
        final sessionBox = Hive.box<OfflineWorkoutSession>(
          'workout_sessions_cache',
        );
        final session = WorkoutSession.fromJson({'id': entityId, ...data});
        final cachedSession = OfflineWorkoutSession.fromSession(
          session,
          userId: data['userId'] as String? ?? '',
        );
        await sessionBox.put(entityId as String, cachedSession);
        break;
    }
  }

  Future<void> _resolveConflict(SyncQueueItem item) async {
    // Simple conflict resolution: server wins for now
    // In a real app, you might want user input or more sophisticated resolution

    try {
      final collection = _getCollectionForEntityType(item.entityType);
      final doc =
          await _firestore.collection(collection).doc(item.entityId).get();

      if (doc.exists) {
        // Update local cache with server data
        await _updateLocalCache(item.entityType, item.entityId, doc.data()!);
        AppLogger.info(
          'Resolved conflict for ${item.entityType} ${item.entityId} - server wins',
        );
      }

      // Remove from sync queue
      await _syncQueue.delete(item.id);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error resolving conflict for ${item.entityType} ${item.entityId}',
        e,
        stackTrace,
      );
    }
  }
}
