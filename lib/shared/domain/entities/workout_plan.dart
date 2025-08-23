import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fitness_training_app/shared/domain/entities/exercise.dart';

part 'workout_plan.freezed.dart';
part 'workout_plan.g.dart';

/// Workout plan entity containing a sequence of exercises
@freezed
class WorkoutPlan with _$WorkoutPlan {
  const factory WorkoutPlan({
    required String id,
    required String name,
    required String description,
    required List<WorkoutExercise> exercises,
    required WorkoutType type,
    required DifficultyLevel difficulty,
    required int estimatedDurationMinutes,
    required List<String> targetMuscleGroups,
    required Map<String, dynamic> metadata,
    String? userId,
    String? aiGeneratedBy,
    Map<String, dynamic>? aiGenerationContext,
    bool? isTemplate,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _WorkoutPlan;

  factory WorkoutPlan.fromJson(Map<String, dynamic> json) =>
      _$WorkoutPlanFromJson(json);
}

/// Individual exercise within a workout plan
@freezed
class WorkoutExercise with _$WorkoutExercise {
  const factory WorkoutExercise({
    required String exerciseId,
    required int order,
    required int sets,
    required int repsPerSet,
    required int restBetweenSetsSeconds,
    String? exerciseName, // Cached for offline use
    String? exerciseDescription, // Cached for offline use
    Map<String, dynamic>? exerciseMetadata,
    Map<String, dynamic>? customInstructions,
    List<String>? alternativeExerciseIds,
  }) = _WorkoutExercise;

  factory WorkoutExercise.fromJson(Map<String, dynamic> json) =>
      _$WorkoutExerciseFromJson(json);
}

/// Workout types
enum WorkoutType {
  @JsonValue('strength_training')
  strengthTraining,
  @JsonValue('cardio')
  cardio,
  @JsonValue('hiit')
  hiit,
  @JsonValue('yoga')
  yoga,
  @JsonValue('pilates')
  pilates,
  @JsonValue('stretching')
  stretching,
  @JsonValue('mixed')
  mixed,
  @JsonValue('custom')
  custom,
}

/// Extension methods for WorkoutPlan
extension WorkoutPlanExtension on WorkoutPlan {
  /// Get total number of exercises
  int get totalExercises => exercises.length;

  /// Get total estimated duration including rest periods
  int get totalEstimatedMinutes {
    var totalSeconds = 0;

    for (final exercise in exercises) {
      // Estimated time per set (assuming 30 seconds per set)
      final exerciseTime = exercise.sets * 30;
      // Rest time between sets
      final restTime = (exercise.sets - 1) * exercise.restBetweenSetsSeconds;
      totalSeconds += exerciseTime + restTime;
    }

    return (totalSeconds / 60).ceil();
  }

  /// Get workout type icon
  String get typeIcon {
    switch (type) {
      case WorkoutType.strengthTraining:
        return '🏋️';
      case WorkoutType.cardio:
        return '🏃';
      case WorkoutType.hiit:
        return '⚡';
      case WorkoutType.yoga:
        return '🧘';
      case WorkoutType.pilates:
        return '🤸';
      case WorkoutType.stretching:
        return '🤲';
      case WorkoutType.mixed:
        return '🔄';
      case WorkoutType.custom:
        return '⚙️';
    }
  }

  /// Get difficulty color
  String get difficultyColor {
    switch (difficulty) {
      case DifficultyLevel.beginner:
        return '#4CAF50'; // Green
      case DifficultyLevel.intermediate:
        return '#FF9800'; // Orange
      case DifficultyLevel.advanced:
        return '#F44336'; // Red
      case DifficultyLevel.expert:
        return '#9C27B0'; // Purple
    }
  }

  /// Validate workout plan data
  List<String> validate() {
    final errors = <String>[];

    if (name.trim().isEmpty) {
      errors.add('Workout plan name cannot be empty');
    }

    if (description.trim().isEmpty) {
      errors.add('Workout plan description cannot be empty');
    }

    if (exercises.isEmpty) {
      errors.add('Workout plan must have at least one exercise');
    }

    if (exercises.length > 15) {
      errors.add('Workout plan cannot have more than 15 exercises');
    }

    // Validate exercise order
    final orders = exercises.map((e) => e.order).toList();
    orders.sort();
    for (var i = 0; i < orders.length; i++) {
      if (orders[i] != i + 1) {
        errors.add('Exercise order must be sequential starting from 1');
        break;
      }
    }

    // Validate individual exercises
    for (final exercise in exercises) {
      final exerciseErrors = exercise.validate();
      errors.addAll(
        exerciseErrors.map((e) => 'Exercise ${exercise.order}: $e'),
      );
    }

    return errors;
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return toJson()..remove('id'); // Firestore document ID is separate
  }

  /// Create from Firestore document
  static WorkoutPlan fromFirestore(String id, Map<String, dynamic> data) {
    return WorkoutPlan.fromJson({'id': id, ...data});
  }

  /// Check if workout plan is suitable for user
  bool isSuitableForUser({
    required DifficultyLevel userLevel,
    required int availableTimeMinutes,
    required List<String> preferredTypes,
  }) {
    // Check difficulty level
    final difficultyIndex = DifficultyLevel.values.indexOf(difficulty);
    final userLevelIndex = DifficultyLevel.values.indexOf(userLevel);

    // Allow same level or one level higher
    if (difficultyIndex > userLevelIndex + 1) {
      return false;
    }

    // Check time availability
    if (totalEstimatedMinutes > availableTimeMinutes) {
      return false;
    }

    // Check type preferences
    if (preferredTypes.isNotEmpty) {
      final typeMatch = preferredTypes.contains(type.name);
      final muscleMatch = targetMuscleGroups.any(
        (muscle) => preferredTypes.contains(muscle),
      );
      return typeMatch || muscleMatch;
    }

    return true;
  }
}

/// Extension methods for WorkoutExercise
extension WorkoutExerciseExtension on WorkoutExercise {
  /// Get total estimated time for this exercise including rest
  int get totalTimeSeconds {
    final exerciseTime = sets * 30; // Assuming 30 seconds per set
    final restTime = (sets - 1) * restBetweenSetsSeconds;
    return exerciseTime + restTime;
  }

  /// Get formatted time
  String get formattedTime {
    final minutes = totalTimeSeconds ~/ 60;
    final seconds = totalTimeSeconds % 60;
    if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    }
    return '${seconds}s';
  }

  /// Validate workout exercise data
  List<String> validate() {
    final errors = <String>[];

    if (exerciseId.trim().isEmpty) {
      errors.add('Exercise ID cannot be empty');
    }

    if (order <= 0) {
      errors.add('Exercise order must be greater than 0');
    }

    if (sets <= 0 || sets > 10) {
      errors.add('Sets must be between 1 and 10');
    }

    if (repsPerSet <= 0 || repsPerSet > 100) {
      errors.add('Reps per set must be between 1 and 100');
    }

    if (restBetweenSetsSeconds < 0 || restBetweenSetsSeconds > 300) {
      errors.add('Rest between sets must be between 0 and 300 seconds');
    }

    return errors;
  }
}
