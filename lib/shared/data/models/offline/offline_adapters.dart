import 'package:hive/hive.dart';
import 'package:fitness_training_app/shared/domain/entities/entities.dart';
import 'package:fitness_training_app/shared/data/models/offline/offline_models.dart';

/// Hive adapters for offline-specific models

/// CachedWorkoutPlan Hive adapter
class CachedWorkoutPlanAdapter extends TypeAdapter<CachedWorkoutPlan> {
  @override
  final int typeId = 20;

  @override
  CachedWorkoutPlan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CachedWorkoutPlan(
      id: fields[0] as String,
      userId: fields[1] as String,
      workoutPlan: fields[2] as WorkoutPlan,
      lastSynced: fields[3] as DateTime,
      needsSync: fields[4] as bool,
      cachedAt: fields[5] as DateTime,
      syncMetadata: Map<String, dynamic>.from(fields[6] as Map),
    );
  }

  @override
  void write(BinaryWriter writer, CachedWorkoutPlan obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.workoutPlan)
      ..writeByte(3)
      ..write(obj.lastSynced)
      ..writeByte(4)
      ..write(obj.needsSync)
      ..writeByte(5)
      ..write(obj.cachedAt)
      ..writeByte(6)
      ..write(obj.syncMetadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CachedWorkoutPlanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

/// OfflineWorkoutSession Hive adapter
class OfflineWorkoutSessionAdapter extends TypeAdapter<OfflineWorkoutSession> {
  @override
  final int typeId = 21;

  @override
  OfflineWorkoutSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OfflineWorkoutSession(
      sessionId: fields[0] as String,
      userId: fields[1] as String,
      session: fields[2] as WorkoutSession,
      syncStatus: fields[3] as SyncStatus,
      createdAt: fields[4] as DateTime,
      lastSyncAttempt: fields[5] as DateTime?,
      syncRetryCount: fields[6] as int,
      syncError: fields[7] as String?,
      offlineMetadata: Map<String, dynamic>.from(fields[8] as Map),
    );
  }

  @override
  void write(BinaryWriter writer, OfflineWorkoutSession obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.sessionId)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.session)
      ..writeByte(3)
      ..write(obj.syncStatus)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.lastSyncAttempt)
      ..writeByte(6)
      ..write(obj.syncRetryCount)
      ..writeByte(7)
      ..write(obj.syncError)
      ..writeByte(8)
      ..write(obj.offlineMetadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OfflineWorkoutSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

/// SyncStatus Hive adapter
class SyncStatusAdapter extends TypeAdapter<SyncStatus> {
  @override
  final int typeId = 22;

  @override
  SyncStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SyncStatus.pending;
      case 1:
        return SyncStatus.syncing;
      case 2:
        return SyncStatus.synced;
      case 3:
        return SyncStatus.failed;
      case 4:
        return SyncStatus.conflict;
      default:
        return SyncStatus.pending;
    }
  }

  @override
  void write(BinaryWriter writer, SyncStatus obj) {
    switch (obj) {
      case SyncStatus.pending:
        writer.writeByte(0);
        break;
      case SyncStatus.syncing:
        writer.writeByte(1);
        break;
      case SyncStatus.synced:
        writer.writeByte(2);
        break;
      case SyncStatus.failed:
        writer.writeByte(3);
        break;
      case SyncStatus.conflict:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SyncStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

/// CachedExercise Hive adapter
class CachedExerciseAdapter extends TypeAdapter<CachedExercise> {
  @override
  final int typeId = 23;

  @override
  CachedExercise read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CachedExercise(
      id: fields[0] as String,
      exercise: fields[1] as Exercise,
      cachedAt: fields[2] as DateTime,
      lastAccessed: fields[3] as DateTime,
      accessCount: fields[4] as int,
      isPreloaded: fields[5] as bool,
      cacheMetadata: Map<String, dynamic>.from(fields[6] as Map),
    );
  }

  @override
  void write(BinaryWriter writer, CachedExercise obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.exercise)
      ..writeByte(2)
      ..write(obj.cachedAt)
      ..writeByte(3)
      ..write(obj.lastAccessed)
      ..writeByte(4)
      ..write(obj.accessCount)
      ..writeByte(5)
      ..write(obj.isPreloaded)
      ..writeByte(6)
      ..write(obj.cacheMetadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CachedExerciseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

/// SyncQueueItem Hive adapter
class SyncQueueItemAdapter extends TypeAdapter<SyncQueueItem> {
  @override
  final int typeId = 24;

  @override
  SyncQueueItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SyncQueueItem(
      id: fields[0] as String,
      operation: fields[1] as SyncOperation,
      entityType: fields[2] as String,
      entityId: fields[3] as String,
      data: Map<String, dynamic>.from(fields[4] as Map),
      createdAt: fields[5] as DateTime,
      priority: fields[6] as int,
      retryCount: fields[7] as int,
      lastAttempt: fields[8] as DateTime?,
      error: fields[9] as String?,
      metadata: Map<String, dynamic>.from(fields[10] as Map),
    );
  }

  @override
  void write(BinaryWriter writer, SyncQueueItem obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.operation)
      ..writeByte(2)
      ..write(obj.entityType)
      ..writeByte(3)
      ..write(obj.entityId)
      ..writeByte(4)
      ..write(obj.data)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.priority)
      ..writeByte(7)
      ..write(obj.retryCount)
      ..writeByte(8)
      ..write(obj.lastAttempt)
      ..writeByte(9)
      ..write(obj.error)
      ..writeByte(10)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SyncQueueItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

/// SyncOperation Hive adapter
class SyncOperationAdapter extends TypeAdapter<SyncOperation> {
  @override
  final int typeId = 25;

  @override
  SyncOperation read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SyncOperation.create;
      case 1:
        return SyncOperation.update;
      case 2:
        return SyncOperation.delete;
      case 3:
        return SyncOperation.sync;
      default:
        return SyncOperation.sync;
    }
  }

  @override
  void write(BinaryWriter writer, SyncOperation obj) {
    switch (obj) {
      case SyncOperation.create:
        writer.writeByte(0);
        break;
      case SyncOperation.update:
        writer.writeByte(1);
        break;
      case SyncOperation.delete:
        writer.writeByte(2);
        break;
      case SyncOperation.sync:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SyncOperationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
