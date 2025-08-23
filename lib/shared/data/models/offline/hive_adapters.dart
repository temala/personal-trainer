import 'package:hive/hive.dart';
import 'package:fitness_training_app/shared/domain/entities/entities.dart';
import 'package:fitness_training_app/shared/data/models/offline/offline_adapters.dart';
import 'package:fitness_training_app/shared/data/services/exercise_animation_service.dart';

/// Hive type adapters for all data models
/// This file registers all type adapters needed for offline storage

class HiveAdapters {
  /// Register all type adapters
  static void registerAdapters() {
    // Core entity adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserProfileAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(ExerciseAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(WorkoutPlanAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(WorkoutSessionAdapter());
    }
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(WorkoutExerciseAdapter());
    }
    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(ExerciseExecutionAdapter());
    }
    if (!Hive.isAdapterRegistered(6)) {
      Hive.registerAdapter(SetExecutionAdapter());
    }

    // Enum adapters
    if (!Hive.isAdapterRegistered(10)) {
      Hive.registerAdapter(FitnessGoalAdapter());
    }
    if (!Hive.isAdapterRegistered(11)) {
      Hive.registerAdapter(ActivityLevelAdapter());
    }
    if (!Hive.isAdapterRegistered(12)) {
      Hive.registerAdapter(ExerciseCategoryAdapter());
    }
    if (!Hive.isAdapterRegistered(13)) {
      Hive.registerAdapter(DifficultyLevelAdapter());
    }
    if (!Hive.isAdapterRegistered(14)) {
      Hive.registerAdapter(MuscleGroupAdapter());
    }
    if (!Hive.isAdapterRegistered(15)) {
      Hive.registerAdapter(WorkoutTypeAdapter());
    }
    if (!Hive.isAdapterRegistered(16)) {
      Hive.registerAdapter(SessionStatusAdapter());
    }
    if (!Hive.isAdapterRegistered(17)) {
      Hive.registerAdapter(ExecutionStatusAdapter());
    }
    if (!Hive.isAdapterRegistered(18)) {
      Hive.registerAdapter(SetStatusAdapter());
    }

    // Offline-specific adapters
    if (!Hive.isAdapterRegistered(20)) {
      Hive.registerAdapter(CachedWorkoutPlanAdapter());
    }
    if (!Hive.isAdapterRegistered(21)) {
      Hive.registerAdapter(OfflineWorkoutSessionAdapter());
    }
    if (!Hive.isAdapterRegistered(22)) {
      Hive.registerAdapter(SyncStatusAdapter());
    }
    if (!Hive.isAdapterRegistered(23)) {
      Hive.registerAdapter(CachedExerciseAdapter());
    }
    if (!Hive.isAdapterRegistered(24)) {
      Hive.registerAdapter(SyncQueueItemAdapter());
    }
    if (!Hive.isAdapterRegistered(25)) {
      Hive.registerAdapter(SyncOperationAdapter());
    }
    if (!Hive.isAdapterRegistered(26)) {
      Hive.registerAdapter(CachedAnimationAdapter());
    }
    if (!Hive.isAdapterRegistered(27)) {
      Hive.registerAdapter(ExerciseAnimationDataAdapter());
    }
    if (!Hive.isAdapterRegistered(28)) {
      Hive.registerAdapter(AnimationTypeAdapter());
    }
    if (!Hive.isAdapterRegistered(29)) {
      Hive.registerAdapter(AnimationSourceAdapter());
    }
  }
}

/// UserProfile Hive adapter
class UserProfileAdapter extends TypeAdapter<UserProfile> {
  @override
  final int typeId = 0;

  @override
  UserProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfile(
      id: fields[0] as String,
      email: fields[1] as String,
      name: fields[2] as String,
      age: fields[3] as int,
      height: fields[4] as double,
      weight: fields[5] as double,
      targetWeight: fields[6] as double,
      fitnessGoal: fields[7] as FitnessGoal,
      activityLevel: fields[8] as ActivityLevel,
      preferredExerciseTypes: (fields[9] as List).cast<String>(),
      dislikedExercises: (fields[10] as List).cast<String>(),
      preferences: Map<String, dynamic>.from(fields[11] as Map),
      createdAt: fields[12] as DateTime,
      updatedAt: fields[13] as DateTime,
      avatarUrl: fields[14] as String?,
      isPremium: fields[15] as bool?,
      premiumExpiresAt: fields[16] as DateTime?,
      fcmToken: fields[17] as String?,
      aiProviderConfig:
          fields[18] != null
              ? Map<String, dynamic>.from(fields[18] as Map)
              : null,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.age)
      ..writeByte(4)
      ..write(obj.height)
      ..writeByte(5)
      ..write(obj.weight)
      ..writeByte(6)
      ..write(obj.targetWeight)
      ..writeByte(7)
      ..write(obj.fitnessGoal)
      ..writeByte(8)
      ..write(obj.activityLevel)
      ..writeByte(9)
      ..write(obj.preferredExerciseTypes)
      ..writeByte(10)
      ..write(obj.dislikedExercises)
      ..writeByte(11)
      ..write(obj.preferences)
      ..writeByte(12)
      ..write(obj.createdAt)
      ..writeByte(13)
      ..write(obj.updatedAt)
      ..writeByte(14)
      ..write(obj.avatarUrl)
      ..writeByte(15)
      ..write(obj.isPremium)
      ..writeByte(16)
      ..write(obj.premiumExpiresAt)
      ..writeByte(17)
      ..write(obj.fcmToken)
      ..writeByte(18)
      ..write(obj.aiProviderConfig);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

/// Exercise Hive adapter
class ExerciseAdapter extends TypeAdapter<Exercise> {
  @override
  final int typeId = 1;

  @override
  Exercise read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Exercise(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      category: fields[3] as ExerciseCategory,
      difficulty: fields[4] as DifficultyLevel,
      targetMuscles: (fields[5] as List).cast<MuscleGroup>(),
      equipment: (fields[6] as List).cast<String>(),
      estimatedDurationSeconds: fields[7] as int,
      instructions: (fields[8] as List).cast<String>(),
      tips: (fields[9] as List).cast<String>(),
      metadata: Map<String, dynamic>.from(fields[10] as Map),
      animationUrl: fields[11] as String?,
      thumbnailUrl: fields[12] as String?,
      alternativeExerciseIds:
          fields[13] != null ? (fields[13] as List).cast<String>() : null,
      customData:
          fields[14] != null
              ? Map<String, dynamic>.from(fields[14] as Map)
              : null,
      isActive: fields[15] as bool?,
      createdAt: fields[16] as DateTime?,
      updatedAt: fields[17] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Exercise obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.difficulty)
      ..writeByte(5)
      ..write(obj.targetMuscles)
      ..writeByte(6)
      ..write(obj.equipment)
      ..writeByte(7)
      ..write(obj.estimatedDurationSeconds)
      ..writeByte(8)
      ..write(obj.instructions)
      ..writeByte(9)
      ..write(obj.tips)
      ..writeByte(10)
      ..write(obj.metadata)
      ..writeByte(11)
      ..write(obj.animationUrl)
      ..writeByte(12)
      ..write(obj.thumbnailUrl)
      ..writeByte(13)
      ..write(obj.alternativeExerciseIds)
      ..writeByte(14)
      ..write(obj.customData)
      ..writeByte(15)
      ..write(obj.isActive)
      ..writeByte(16)
      ..write(obj.createdAt)
      ..writeByte(17)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

/// WorkoutPlan Hive adapter
class WorkoutPlanAdapter extends TypeAdapter<WorkoutPlan> {
  @override
  final int typeId = 2;

  @override
  WorkoutPlan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkoutPlan(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      exercises: (fields[3] as List).cast<WorkoutExercise>(),
      type: fields[4] as WorkoutType,
      difficulty: fields[5] as DifficultyLevel,
      estimatedDurationMinutes: fields[6] as int,
      targetMuscleGroups: (fields[7] as List).cast<String>(),
      metadata: Map<String, dynamic>.from(fields[8] as Map),
      userId: fields[9] as String?,
      aiGeneratedBy: fields[10] as String?,
      aiGenerationContext:
          fields[11] != null
              ? Map<String, dynamic>.from(fields[11] as Map)
              : null,
      isTemplate: fields[12] as bool?,
      isActive: fields[13] as bool?,
      createdAt: fields[14] as DateTime?,
      updatedAt: fields[15] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutPlan obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.exercises)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.difficulty)
      ..writeByte(6)
      ..write(obj.estimatedDurationMinutes)
      ..writeByte(7)
      ..write(obj.targetMuscleGroups)
      ..writeByte(8)
      ..write(obj.metadata)
      ..writeByte(9)
      ..write(obj.userId)
      ..writeByte(10)
      ..write(obj.aiGeneratedBy)
      ..writeByte(11)
      ..write(obj.aiGenerationContext)
      ..writeByte(12)
      ..write(obj.isTemplate)
      ..writeByte(13)
      ..write(obj.isActive)
      ..writeByte(14)
      ..write(obj.createdAt)
      ..writeByte(15)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutPlanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

/// WorkoutSession Hive adapter
class WorkoutSessionAdapter extends TypeAdapter<WorkoutSession> {
  @override
  final int typeId = 3;

  @override
  WorkoutSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkoutSession(
      id: fields[0] as String,
      userId: fields[1] as String,
      workoutPlanId: fields[2] as String,
      status: fields[3] as SessionStatus,
      startedAt: fields[4] as DateTime,
      exerciseExecutions: (fields[5] as List).cast<ExerciseExecution>(),
      metadata: Map<String, dynamic>.from(fields[6] as Map),
      workoutPlanName: fields[7] as String?,
      completedAt: fields[8] as DateTime?,
      pausedAt: fields[9] as DateTime?,
      totalDurationSeconds: fields[10] as int?,
      completionPercentage: fields[11] as double?,
      totalCaloriesBurned: fields[12] as int?,
      aiEvaluation:
          fields[13] != null
              ? Map<String, dynamic>.from(fields[13] as Map)
              : null,
      userNotes: fields[14] as String?,
      skippedExerciseIds:
          fields[15] != null ? (fields[15] as List).cast<String>() : null,
      sessionData:
          fields[16] != null
              ? Map<String, dynamic>.from(fields[16] as Map)
              : null,
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutSession obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.workoutPlanId)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.startedAt)
      ..writeByte(5)
      ..write(obj.exerciseExecutions)
      ..writeByte(6)
      ..write(obj.metadata)
      ..writeByte(7)
      ..write(obj.workoutPlanName)
      ..writeByte(8)
      ..write(obj.completedAt)
      ..writeByte(9)
      ..write(obj.pausedAt)
      ..writeByte(10)
      ..write(obj.totalDurationSeconds)
      ..writeByte(11)
      ..write(obj.completionPercentage)
      ..writeByte(12)
      ..write(obj.totalCaloriesBurned)
      ..writeByte(13)
      ..write(obj.aiEvaluation)
      ..writeByte(14)
      ..write(obj.userNotes)
      ..writeByte(15)
      ..write(obj.skippedExerciseIds)
      ..writeByte(16)
      ..write(obj.sessionData);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

/// WorkoutExercise Hive adapter
class WorkoutExerciseAdapter extends TypeAdapter<WorkoutExercise> {
  @override
  final int typeId = 4;

  @override
  WorkoutExercise read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkoutExercise(
      exerciseId: fields[0] as String,
      order: fields[1] as int,
      sets: fields[2] as int,
      repsPerSet: fields[3] as int,
      restBetweenSetsSeconds: fields[4] as int,
      exerciseName: fields[5] as String?,
      exerciseDescription: fields[6] as String?,
      exerciseMetadata:
          fields[7] != null
              ? Map<String, dynamic>.from(fields[7] as Map)
              : null,
      customInstructions:
          fields[8] != null
              ? Map<String, dynamic>.from(fields[8] as Map)
              : null,
      alternativeExerciseIds:
          fields[9] != null ? (fields[9] as List).cast<String>() : null,
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutExercise obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.exerciseId)
      ..writeByte(1)
      ..write(obj.order)
      ..writeByte(2)
      ..write(obj.sets)
      ..writeByte(3)
      ..write(obj.repsPerSet)
      ..writeByte(4)
      ..write(obj.restBetweenSetsSeconds)
      ..writeByte(5)
      ..write(obj.exerciseName)
      ..writeByte(6)
      ..write(obj.exerciseDescription)
      ..writeByte(7)
      ..write(obj.exerciseMetadata)
      ..writeByte(8)
      ..write(obj.customInstructions)
      ..writeByte(9)
      ..write(obj.alternativeExerciseIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutExerciseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

/// ExerciseExecution Hive adapter
class ExerciseExecutionAdapter extends TypeAdapter<ExerciseExecution> {
  @override
  final int typeId = 5;

  @override
  ExerciseExecution read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExerciseExecution(
      exerciseId: fields[0] as String,
      order: fields[1] as int,
      status: fields[2] as ExecutionStatus,
      startedAt: fields[3] as DateTime,
      setExecutions: (fields[4] as List).cast<SetExecution>(),
      exerciseName: fields[5] as String?,
      completedAt: fields[6] as DateTime?,
      skippedAt: fields[7] as DateTime?,
      totalDurationSeconds: fields[8] as int?,
      skipReason: fields[9] as String?,
      alternativeExerciseId: fields[10] as String?,
      executionData:
          fields[11] != null
              ? Map<String, dynamic>.from(fields[11] as Map)
              : null,
    );
  }

  @override
  void write(BinaryWriter writer, ExerciseExecution obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.exerciseId)
      ..writeByte(1)
      ..write(obj.order)
      ..writeByte(2)
      ..write(obj.status)
      ..writeByte(3)
      ..write(obj.startedAt)
      ..writeByte(4)
      ..write(obj.setExecutions)
      ..writeByte(5)
      ..write(obj.exerciseName)
      ..writeByte(6)
      ..write(obj.completedAt)
      ..writeByte(7)
      ..write(obj.skippedAt)
      ..writeByte(8)
      ..write(obj.totalDurationSeconds)
      ..writeByte(9)
      ..write(obj.skipReason)
      ..writeByte(10)
      ..write(obj.alternativeExerciseId)
      ..writeByte(11)
      ..write(obj.executionData);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseExecutionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

/// SetExecution Hive adapter
class SetExecutionAdapter extends TypeAdapter<SetExecution> {
  @override
  final int typeId = 6;

  @override
  SetExecution read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SetExecution(
      setNumber: fields[0] as int,
      status: fields[1] as SetStatus,
      startedAt: fields[2] as DateTime,
      completedAt: fields[3] as DateTime?,
      actualReps: fields[4] as int?,
      plannedReps: fields[5] as int?,
      weight: fields[6] as double?,
      durationSeconds: fields[7] as int?,
      restDurationSeconds: fields[8] as int?,
      notes: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SetExecution obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.setNumber)
      ..writeByte(1)
      ..write(obj.status)
      ..writeByte(2)
      ..write(obj.startedAt)
      ..writeByte(3)
      ..write(obj.completedAt)
      ..writeByte(4)
      ..write(obj.actualReps)
      ..writeByte(5)
      ..write(obj.plannedReps)
      ..writeByte(6)
      ..write(obj.weight)
      ..writeByte(7)
      ..write(obj.durationSeconds)
      ..writeByte(8)
      ..write(obj.restDurationSeconds)
      ..writeByte(9)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SetExecutionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
// Enum Adapters

/// FitnessGoal Hive adapter
class FitnessGoalAdapter extends TypeAdapter<FitnessGoal> {
  @override
  final int typeId = 10;

  @override
  FitnessGoal read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return FitnessGoal.loseWeight;
      case 1:
        return FitnessGoal.gainMuscle;
      case 2:
        return FitnessGoal.maintainFitness;
      case 3:
        return FitnessGoal.improveEndurance;
      case 4:
        return FitnessGoal.generalHealth;
      default:
        return FitnessGoal.generalHealth;
    }
  }

  @override
  void write(BinaryWriter writer, FitnessGoal obj) {
    switch (obj) {
      case FitnessGoal.loseWeight:
        writer.writeByte(0);
        break;
      case FitnessGoal.gainMuscle:
        writer.writeByte(1);
        break;
      case FitnessGoal.maintainFitness:
        writer.writeByte(2);
        break;
      case FitnessGoal.improveEndurance:
        writer.writeByte(3);
        break;
      case FitnessGoal.generalHealth:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FitnessGoalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

/// ActivityLevel Hive adapter
class ActivityLevelAdapter extends TypeAdapter<ActivityLevel> {
  @override
  final int typeId = 11;

  @override
  ActivityLevel read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ActivityLevel.sedentary;
      case 1:
        return ActivityLevel.lightlyActive;
      case 2:
        return ActivityLevel.moderatelyActive;
      case 3:
        return ActivityLevel.veryActive;
      case 4:
        return ActivityLevel.extremelyActive;
      default:
        return ActivityLevel.sedentary;
    }
  }

  @override
  void write(BinaryWriter writer, ActivityLevel obj) {
    switch (obj) {
      case ActivityLevel.sedentary:
        writer.writeByte(0);
        break;
      case ActivityLevel.lightlyActive:
        writer.writeByte(1);
        break;
      case ActivityLevel.moderatelyActive:
        writer.writeByte(2);
        break;
      case ActivityLevel.veryActive:
        writer.writeByte(3);
        break;
      case ActivityLevel.extremelyActive:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityLevelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

/// ExerciseCategory Hive adapter
class ExerciseCategoryAdapter extends TypeAdapter<ExerciseCategory> {
  @override
  final int typeId = 12;

  @override
  ExerciseCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ExerciseCategory.cardio;
      case 1:
        return ExerciseCategory.strength;
      case 2:
        return ExerciseCategory.flexibility;
      case 3:
        return ExerciseCategory.balance;
      case 4:
        return ExerciseCategory.sports;
      case 5:
        return ExerciseCategory.rehabilitation;
      default:
        return ExerciseCategory.strength;
    }
  }

  @override
  void write(BinaryWriter writer, ExerciseCategory obj) {
    switch (obj) {
      case ExerciseCategory.cardio:
        writer.writeByte(0);
        break;
      case ExerciseCategory.strength:
        writer.writeByte(1);
        break;
      case ExerciseCategory.flexibility:
        writer.writeByte(2);
        break;
      case ExerciseCategory.balance:
        writer.writeByte(3);
        break;
      case ExerciseCategory.sports:
        writer.writeByte(4);
        break;
      case ExerciseCategory.rehabilitation:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

/// DifficultyLevel Hive adapter
class DifficultyLevelAdapter extends TypeAdapter<DifficultyLevel> {
  @override
  final int typeId = 13;

  @override
  DifficultyLevel read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DifficultyLevel.beginner;
      case 1:
        return DifficultyLevel.intermediate;
      case 2:
        return DifficultyLevel.advanced;
      case 3:
        return DifficultyLevel.expert;
      default:
        return DifficultyLevel.beginner;
    }
  }

  @override
  void write(BinaryWriter writer, DifficultyLevel obj) {
    switch (obj) {
      case DifficultyLevel.beginner:
        writer.writeByte(0);
        break;
      case DifficultyLevel.intermediate:
        writer.writeByte(1);
        break;
      case DifficultyLevel.advanced:
        writer.writeByte(2);
        break;
      case DifficultyLevel.expert:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DifficultyLevelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

/// MuscleGroup Hive adapter
class MuscleGroupAdapter extends TypeAdapter<MuscleGroup> {
  @override
  final int typeId = 14;

  @override
  MuscleGroup read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MuscleGroup.chest;
      case 1:
        return MuscleGroup.back;
      case 2:
        return MuscleGroup.shoulders;
      case 3:
        return MuscleGroup.arms;
      case 4:
        return MuscleGroup.core;
      case 5:
        return MuscleGroup.legs;
      case 6:
        return MuscleGroup.glutes;
      case 7:
        return MuscleGroup.fullBody;
      default:
        return MuscleGroup.fullBody;
    }
  }

  @override
  void write(BinaryWriter writer, MuscleGroup obj) {
    switch (obj) {
      case MuscleGroup.chest:
        writer.writeByte(0);
        break;
      case MuscleGroup.back:
        writer.writeByte(1);
        break;
      case MuscleGroup.shoulders:
        writer.writeByte(2);
        break;
      case MuscleGroup.arms:
        writer.writeByte(3);
        break;
      case MuscleGroup.core:
        writer.writeByte(4);
        break;
      case MuscleGroup.legs:
        writer.writeByte(5);
        break;
      case MuscleGroup.glutes:
        writer.writeByte(6);
        break;
      case MuscleGroup.fullBody:
        writer.writeByte(7);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MuscleGroupAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

/// WorkoutType Hive adapter
class WorkoutTypeAdapter extends TypeAdapter<WorkoutType> {
  @override
  final int typeId = 15;

  @override
  WorkoutType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return WorkoutType.strengthTraining;
      case 1:
        return WorkoutType.cardio;
      case 2:
        return WorkoutType.hiit;
      case 3:
        return WorkoutType.yoga;
      case 4:
        return WorkoutType.pilates;
      case 5:
        return WorkoutType.stretching;
      case 6:
        return WorkoutType.mixed;
      case 7:
        return WorkoutType.custom;
      default:
        return WorkoutType.mixed;
    }
  }

  @override
  void write(BinaryWriter writer, WorkoutType obj) {
    switch (obj) {
      case WorkoutType.strengthTraining:
        writer.writeByte(0);
        break;
      case WorkoutType.cardio:
        writer.writeByte(1);
        break;
      case WorkoutType.hiit:
        writer.writeByte(2);
        break;
      case WorkoutType.yoga:
        writer.writeByte(3);
        break;
      case WorkoutType.pilates:
        writer.writeByte(4);
        break;
      case WorkoutType.stretching:
        writer.writeByte(5);
        break;
      case WorkoutType.mixed:
        writer.writeByte(6);
        break;
      case WorkoutType.custom:
        writer.writeByte(7);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

/// SessionStatus Hive adapter
class SessionStatusAdapter extends TypeAdapter<SessionStatus> {
  @override
  final int typeId = 16;

  @override
  SessionStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SessionStatus.notStarted;
      case 1:
        return SessionStatus.inProgress;
      case 2:
        return SessionStatus.paused;
      case 3:
        return SessionStatus.completed;
      case 4:
        return SessionStatus.abandoned;
      case 5:
        return SessionStatus.cancelled;
      default:
        return SessionStatus.notStarted;
    }
  }

  @override
  void write(BinaryWriter writer, SessionStatus obj) {
    switch (obj) {
      case SessionStatus.notStarted:
        writer.writeByte(0);
        break;
      case SessionStatus.inProgress:
        writer.writeByte(1);
        break;
      case SessionStatus.paused:
        writer.writeByte(2);
        break;
      case SessionStatus.completed:
        writer.writeByte(3);
        break;
      case SessionStatus.abandoned:
        writer.writeByte(4);
        break;
      case SessionStatus.cancelled:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

/// ExecutionStatus Hive adapter
class ExecutionStatusAdapter extends TypeAdapter<ExecutionStatus> {
  @override
  final int typeId = 17;

  @override
  ExecutionStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ExecutionStatus.notStarted;
      case 1:
        return ExecutionStatus.inProgress;
      case 2:
        return ExecutionStatus.completed;
      case 3:
        return ExecutionStatus.skipped;
      case 4:
        return ExecutionStatus.alternativeUsed;
      default:
        return ExecutionStatus.notStarted;
    }
  }

  @override
  void write(BinaryWriter writer, ExecutionStatus obj) {
    switch (obj) {
      case ExecutionStatus.notStarted:
        writer.writeByte(0);
        break;
      case ExecutionStatus.inProgress:
        writer.writeByte(1);
        break;
      case ExecutionStatus.completed:
        writer.writeByte(2);
        break;
      case ExecutionStatus.skipped:
        writer.writeByte(3);
        break;
      case ExecutionStatus.alternativeUsed:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExecutionStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

/// SetStatus Hive adapter
class SetStatusAdapter extends TypeAdapter<SetStatus> {
  @override
  final int typeId = 18;

  @override
  SetStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SetStatus.notStarted;
      case 1:
        return SetStatus.inProgress;
      case 2:
        return SetStatus.completed;
      case 3:
        return SetStatus.skipped;
      default:
        return SetStatus.notStarted;
    }
  }

  @override
  void write(BinaryWriter writer, SetStatus obj) {
    switch (obj) {
      case SetStatus.notStarted:
        writer.writeByte(0);
        break;
      case SetStatus.inProgress:
        writer.writeByte(1);
        break;
      case SetStatus.completed:
        writer.writeByte(2);
        break;
      case SetStatus.skipped:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SetStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

/// CachedAnimation Hive adapter
class CachedAnimationAdapter extends TypeAdapter<CachedAnimation> {
  @override
  final int typeId = 26;

  @override
  CachedAnimation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CachedAnimation(
      id: fields[0] as String,
      animationData: fields[1] as ExerciseAnimationData,
      cachedAt: fields[2] as DateTime,
      sizeBytes: fields[3] as int,
      accessCount: fields[4] as int,
      lastAccessed: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, CachedAnimation obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.animationData)
      ..writeByte(2)
      ..write(obj.cachedAt)
      ..writeByte(3)
      ..write(obj.sizeBytes)
      ..writeByte(4)
      ..write(obj.accessCount)
      ..writeByte(5)
      ..write(obj.lastAccessed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CachedAnimationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

/// ExerciseAnimationData Hive adapter
class ExerciseAnimationDataAdapter extends TypeAdapter<ExerciseAnimationData> {
  @override
  final int typeId = 27;

  @override
  ExerciseAnimationData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExerciseAnimationData(
      id: fields[0] as String,
      type: fields[1] as AnimationType,
      data: fields[2] as String,
      source: fields[3] as AnimationSource,
      duration: fields[4] as int,
      isLooping: fields[5] as bool,
      metadata: Map<String, dynamic>.from(fields[6] as Map),
    );
  }

  @override
  void write(BinaryWriter writer, ExerciseAnimationData obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.data)
      ..writeByte(3)
      ..write(obj.source)
      ..writeByte(4)
      ..write(obj.duration)
      ..writeByte(5)
      ..write(obj.isLooping)
      ..writeByte(6)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseAnimationDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

/// AnimationType Hive adapter
class AnimationTypeAdapter extends TypeAdapter<AnimationType> {
  @override
  final int typeId = 28;

  @override
  AnimationType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AnimationType.lottie;
      case 1:
        return AnimationType.rive;
      case 2:
        return AnimationType.gif;
      case 3:
        return AnimationType.video;
      default:
        return AnimationType.lottie;
    }
  }

  @override
  void write(BinaryWriter writer, AnimationType obj) {
    switch (obj) {
      case AnimationType.lottie:
        writer.writeByte(0);
        break;
      case AnimationType.rive:
        writer.writeByte(1);
        break;
      case AnimationType.gif:
        writer.writeByte(2);
        break;
      case AnimationType.video:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnimationTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

/// AnimationSource Hive adapter
class AnimationSourceAdapter extends TypeAdapter<AnimationSource> {
  @override
  final int typeId = 29;

  @override
  AnimationSource read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AnimationSource.assets;
      case 1:
        return AnimationSource.storage;
      case 2:
        return AnimationSource.cache;
      case 3:
        return AnimationSource.generated;
      default:
        return AnimationSource.assets;
    }
  }

  @override
  void write(BinaryWriter writer, AnimationSource obj) {
    switch (obj) {
      case AnimationSource.assets:
        writer.writeByte(0);
        break;
      case AnimationSource.storage:
        writer.writeByte(1);
        break;
      case AnimationSource.cache:
        writer.writeByte(2);
        break;
      case AnimationSource.generated:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnimationSourceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
