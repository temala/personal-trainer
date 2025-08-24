import 'package:hive/hive.dart';
import 'package:fitness_training_app/shared/domain/entities/entities.dart';

/// Offline-specific models for cached data and sync management

/// Cached workout plan with offline metadata
@HiveType(typeId: 20)
class CachedWorkoutPlan extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String userId;

  @HiveField(2)
  WorkoutPlan workoutPlan;

  @HiveField(3)
  DateTime lastSynced;

  @HiveField(4)
  bool needsSync;

  @HiveField(5)
  DateTime cachedAt;

  @HiveField(6)
  Map<String, dynamic> syncMetadata;

  CachedWorkoutPlan({
    required this.id,
    required this.userId,
    required this.workoutPlan,
    required this.lastSynced,
    required this.needsSync,
    required this.cachedAt,
    required this.syncMetadata,
  });

  /// Create from WorkoutPlan
  factory CachedWorkoutPlan.fromWorkoutPlan(
    WorkoutPlan plan, {
    required String userId,
    bool needsSync = false,
  }) {
    return CachedWorkoutPlan(
      id: plan.id,
      userId: userId,
      workoutPlan: plan,
      lastSynced: DateTime.now(),
      needsSync: needsSync,
      cachedAt: DateTime.now(),
      syncMetadata: {},
    );
  }

  /// Check if cache is stale
  bool get isStale {
    final staleThreshold = Duration(hours: 24);
    return DateTime.now().difference(lastSynced) > staleThreshold;
  }

  /// Mark as needing sync
  void markForSync() {
    needsSync = true;
    syncMetadata['markedForSyncAt'] = DateTime.now().toIso8601String();
    if (isInBox) save();
  }

  /// Mark as synced
  void markAsSynced() {
    needsSync = false;
    lastSynced = DateTime.now();
    syncMetadata['lastSyncedAt'] = DateTime.now().toIso8601String();
    if (isInBox) save();
  }
}

/// Offline workout session with sync status
@HiveType(typeId: 21)
class OfflineWorkoutSession extends HiveObject {
  @HiveField(0)
  String sessionId;

  @HiveField(1)
  String userId;

  @HiveField(2)
  WorkoutSession session;

  @HiveField(3)
  SyncStatus syncStatus;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  DateTime? lastSyncAttempt;

  @HiveField(6)
  int syncRetryCount;

  @HiveField(7)
  String? syncError;

  @HiveField(8)
  Map<String, dynamic> offlineMetadata;

  OfflineWorkoutSession({
    required this.sessionId,
    required this.userId,
    required this.session,
    required this.syncStatus,
    required this.createdAt,
    this.lastSyncAttempt,
    this.syncRetryCount = 0,
    this.syncError,
    required this.offlineMetadata,
  });

  /// Create from WorkoutSession
  factory OfflineWorkoutSession.fromSession(
    WorkoutSession session, {
    required String userId,
  }) {
    return OfflineWorkoutSession(
      sessionId: session.id,
      userId: userId,
      session: session,
      syncStatus: SyncStatus.pending,
      createdAt: DateTime.now(),
      offlineMetadata: {'createdOffline': true, 'version': 1},
    );
  }

  /// Check if session is ready for sync
  bool get isReadyForSync {
    return syncStatus == SyncStatus.pending &&
        syncRetryCount < 3 &&
        (lastSyncAttempt == null ||
            DateTime.now().difference(lastSyncAttempt!).inMinutes > 5);
  }

  /// Mark sync attempt
  void markSyncAttempt(String? error) {
    lastSyncAttempt = DateTime.now();
    syncRetryCount++;
    syncError = error;

    if (error != null) {
      syncStatus = SyncStatus.failed;
    }

    if (isInBox) save();
  }

  /// Mark as synced
  void markAsSynced() {
    syncStatus = SyncStatus.synced;
    syncError = null;
    offlineMetadata['syncedAt'] = DateTime.now().toIso8601String();
    if (isInBox) save();
  }

  /// Mark as failed
  void markAsFailed(String error) {
    syncStatus = SyncStatus.failed;
    syncError = error;
    if (isInBox) save();
  }
}

/// Sync status for offline data
@HiveType(typeId: 22)
enum SyncStatus {
  @HiveField(0)
  pending,

  @HiveField(1)
  syncing,

  @HiveField(2)
  synced,

  @HiveField(3)
  failed,

  @HiveField(4)
  conflict,
}

/// Cached exercise with offline metadata
@HiveType(typeId: 23)
class CachedExercise extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  Exercise exercise;

  @HiveField(2)
  DateTime cachedAt;

  @HiveField(3)
  DateTime lastAccessed;

  @HiveField(4)
  int accessCount;

  @HiveField(5)
  bool isPreloaded;

  @HiveField(6)
  Map<String, dynamic> cacheMetadata;

  CachedExercise({
    required this.id,
    required this.exercise,
    required this.cachedAt,
    required this.lastAccessed,
    this.accessCount = 0,
    this.isPreloaded = false,
    required this.cacheMetadata,
  });

  /// Create from Exercise
  factory CachedExercise.fromExercise(
    Exercise exercise, {
    bool isPreloaded = false,
  }) {
    return CachedExercise(
      id: exercise.id,
      exercise: exercise,
      cachedAt: DateTime.now(),
      lastAccessed: DateTime.now(),
      accessCount: 0,
      isPreloaded: isPreloaded,
      cacheMetadata: {'version': 1, 'source': 'firebase'},
    );
  }

  /// Mark as accessed
  void markAccessed() {
    lastAccessed = DateTime.now();
    accessCount++;
    if (isInBox) save();
  }

  /// Check if cache is stale
  bool get isStale {
    final staleThreshold = Duration(days: 7);
    return DateTime.now().difference(cachedAt) > staleThreshold;
  }

  /// Check if frequently accessed
  bool get isFrequentlyAccessed {
    return accessCount > 10;
  }
}

/// Sync queue item for managing offline operations
@HiveType(typeId: 24)
class SyncQueueItem extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  SyncOperation operation;

  @HiveField(2)
  String entityType;

  @HiveField(3)
  String entityId;

  @HiveField(4)
  Map<String, dynamic> data;

  @HiveField(5)
  DateTime createdAt;

  @HiveField(6)
  int priority;

  @HiveField(7)
  int retryCount;

  @HiveField(8)
  DateTime? lastAttempt;

  @HiveField(9)
  String? error;

  @HiveField(10)
  Map<String, dynamic> metadata;

  SyncQueueItem({
    required this.id,
    required this.operation,
    required this.entityType,
    required this.entityId,
    required this.data,
    required this.createdAt,
    this.priority = 0,
    this.retryCount = 0,
    this.lastAttempt,
    this.error,
    required this.metadata,
  });

  /// Create for workout session sync
  factory SyncQueueItem.forWorkoutSession(
    WorkoutSession session, {
    SyncOperation operation = SyncOperation.create,
    int priority = 1,
  }) {
    return SyncQueueItem(
      id: '${operation.name}_session_${session.id}',
      operation: operation,
      entityType: 'WorkoutSession',
      entityId: session.id,
      data: session.toJson(),
      createdAt: DateTime.now(),
      priority: priority,
      metadata: {
        'userId': session.userId,
        'sessionStatus': session.status.name,
      },
    );
  }

  /// Create for user profile sync
  factory SyncQueueItem.forUserProfile(
    UserProfile profile, {
    SyncOperation operation = SyncOperation.update,
    int priority = 2,
  }) {
    return SyncQueueItem(
      id: '${operation.name}_profile_${profile.id}',
      operation: operation,
      entityType: 'UserProfile',
      entityId: profile.id,
      data: profile.toJson(),
      createdAt: DateTime.now(),
      priority: priority,
      metadata: {'userId': profile.id},
    );
  }

  /// Check if ready for retry
  bool get isReadyForRetry {
    if (retryCount >= 3) return false;
    if (lastAttempt == null) return true;

    final backoffMinutes = [1, 5, 15][retryCount.clamp(0, 2)];
    return DateTime.now().difference(lastAttempt!).inMinutes >= backoffMinutes;
  }

  /// Mark attempt
  void markAttempt(String? error) {
    lastAttempt = DateTime.now();
    retryCount++;
    this.error = error;
    if (isInBox) save();
  }

  /// Get priority level description
  String get priorityDescription {
    switch (priority) {
      case 0:
        return 'Critical';
      case 1:
        return 'High';
      case 2:
        return 'Medium';
      case 3:
        return 'Low';
      default:
        return 'Unknown';
    }
  }
}

/// Cached animation data for exercises
@HiveType(typeId: 26)
class CachedAnimation extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  ExerciseAnimationData animationData;

  @HiveField(2)
  DateTime cachedAt;

  @HiveField(3)
  int sizeBytes;

  @HiveField(4)
  int accessCount;

  @HiveField(5)
  DateTime lastAccessed;

  CachedAnimation({
    required this.id,
    required this.animationData,
    required this.cachedAt,
    required this.sizeBytes,
    required this.accessCount,
    required this.lastAccessed,
  });

  /// Create from animation data
  factory CachedAnimation.fromAnimationData(
    String id,
    ExerciseAnimationData animationData, {
    int sizeBytes = 0,
  }) {
    return CachedAnimation(
      id: id,
      animationData: animationData,
      cachedAt: DateTime.now(),
      lastAccessed: DateTime.now(),
      sizeBytes: sizeBytes,
      accessCount: 0,
    );
  }

  /// Mark as accessed
  void markAccessed() {
    lastAccessed = DateTime.now();
    accessCount++;
    if (isInBox) save();
  }

  /// Check if cache is stale
  bool get isStale {
    final staleThreshold = Duration(days: 30); // Animations are cached longer
    return DateTime.now().difference(cachedAt) > staleThreshold;
  }
}

/// Exercise animation data structure
@HiveType(typeId: 27)
class ExerciseAnimationData extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  AnimationType type;

  @HiveField(2)
  String data;

  @HiveField(3)
  AnimationSource source;

  @HiveField(4)
  int duration; // in milliseconds

  @HiveField(5)
  bool isLooping;

  @HiveField(6)
  Map<String, dynamic> metadata;

  ExerciseAnimationData({
    required this.id,
    required this.type,
    required this.data,
    required this.source,
    required this.duration,
    this.isLooping = true,
    required this.metadata,
  });

  /// Create from JSON
  factory ExerciseAnimationData.fromJson(Map<String, dynamic> json) {
    return ExerciseAnimationData(
      id: json['id'] as String,
      type: AnimationType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => AnimationType.lottie,
      ),
      data: json['data'] as String,
      source: AnimationSource.values.firstWhere(
        (e) => e.name == json['source'],
        orElse: () => AnimationSource.storage,
      ),
      duration: json['duration'] as int,
      isLooping: json['isLooping'] as bool? ?? true,
      metadata:
          json['metadata'] != null
              ? Map<String, dynamic>.from(json['metadata'] as Map)
              : {},
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'data': data,
      'source': source.name,
      'duration': duration,
      'isLooping': isLooping,
      'metadata': metadata,
    };
  }
}

/// Animation types
@HiveType(typeId: 40)
enum AnimationType {
  @HiveField(0)
  lottie,
  @HiveField(1)
  rive,
  @HiveField(2)
  gif,
  @HiveField(3)
  video,
}

/// Animation sources
@HiveType(typeId: 41)
enum AnimationSource {
  @HiveField(0)
  assets,
  @HiveField(1)
  storage,
  @HiveField(2)
  cache,
  @HiveField(3)
  generated,
}

/// Sync operations
enum SyncOperation { create, update, delete, sync }
