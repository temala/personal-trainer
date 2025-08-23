import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fitness_training_app/shared/domain/entities/workout_plan.dart';

part 'workout_session.freezed.dart';
part 'workout_session.g.dart';

/// Workout session entity tracking a user's workout execution
@freezed
class WorkoutSession with _$WorkoutSession {
  const factory WorkoutSession({
    required String id,
    required String userId,
    required String workoutPlanId,
    required SessionStatus status,
    required DateTime startedAt,
    required List<ExerciseExecution> exerciseExecutions,
    required Map<String, dynamic> metadata,
    String? workoutPlanName, // Cached for offline use
    DateTime? completedAt,
    DateTime? pausedAt,
    int? totalDurationSeconds,
    double? completionPercentage,
    int? totalCaloriesBurned,
    Map<String, dynamic>? aiEvaluation,
    String? userNotes,
    List<String>? skippedExerciseIds,
    Map<String, dynamic>? sessionData,
  }) = _WorkoutSession;

  factory WorkoutSession.fromJson(Map<String, dynamic> json) =>
      _$WorkoutSessionFromJson(json);
}

/// Individual exercise execution within a workout session
@freezed
class ExerciseExecution with _$ExerciseExecution {
  const factory ExerciseExecution({
    required String exerciseId,
    required int order,
    required ExecutionStatus status,
    required DateTime startedAt,
    required List<SetExecution> setExecutions,
    String? exerciseName, // Cached for offline use
    DateTime? completedAt,
    DateTime? skippedAt,
    int? totalDurationSeconds,
    String? skipReason,
    String? alternativeExerciseId,
    Map<String, dynamic>? executionData,
  }) = _ExerciseExecution;

  factory ExerciseExecution.fromJson(Map<String, dynamic> json) =>
      _$ExerciseExecutionFromJson(json);
}

/// Individual set execution within an exercise
@freezed
class SetExecution with _$SetExecution {
  const factory SetExecution({
    required int setNumber,
    required SetStatus status,
    required DateTime startedAt,
    DateTime? completedAt,
    int? actualReps,
    int? plannedReps,
    double? weight,
    int? durationSeconds,
    int? restDurationSeconds,
    String? notes,
  }) = _SetExecution;

  factory SetExecution.fromJson(Map<String, dynamic> json) =>
      _$SetExecutionFromJson(json);
}

/// Session status
enum SessionStatus {
  @JsonValue('not_started')
  notStarted,
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('paused')
  paused,
  @JsonValue('completed')
  completed,
  @JsonValue('abandoned')
  abandoned,
  @JsonValue('cancelled')
  cancelled,
}

/// Exercise execution status
enum ExecutionStatus {
  @JsonValue('not_started')
  notStarted,
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('completed')
  completed,
  @JsonValue('skipped')
  skipped,
  @JsonValue('alternative_used')
  alternativeUsed,
}

/// Set execution status
enum SetStatus {
  @JsonValue('not_started')
  notStarted,
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('completed')
  completed,
  @JsonValue('skipped')
  skipped,
}

/// Extension methods for WorkoutSession
extension WorkoutSessionExtension on WorkoutSession {
  /// Check if session is active
  bool get isActive =>
      status == SessionStatus.inProgress || status == SessionStatus.paused;

  /// Check if session is completed
  bool get isCompleted => status == SessionStatus.completed;

  /// Get completed exercises count
  int get completedExercisesCount {
    return exerciseExecutions
        .where((e) => e.status == ExecutionStatus.completed)
        .length;
  }

  /// Get total exercises count
  int get totalExercisesCount => exerciseExecutions.length;

  /// Calculate actual completion percentage
  double get actualCompletionPercentage {
    if (exerciseExecutions.isEmpty) return 0;

    final completedCount = completedExercisesCount;
    return (completedCount / totalExercisesCount) * 100;
  }

  /// Get session duration in minutes
  int get sessionDurationMinutes {
    if (totalDurationSeconds != null) {
      return (totalDurationSeconds! / 60).round();
    }

    final endTime = completedAt ?? DateTime.now();
    final duration = endTime.difference(startedAt);
    return duration.inMinutes;
  }

  /// Get formatted duration
  String get formattedDuration {
    final minutes = sessionDurationMinutes;
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    if (hours > 0) {
      return '${hours}h ${remainingMinutes}m';
    }
    return '${minutes}m';
  }

  /// Check if session was successful
  bool get isSuccessful {
    return isCompleted && actualCompletionPercentage >= 80.0;
  }

  /// Get session performance score (0-100)
  double get performanceScore {
    if (!isCompleted) return 0;

    var score = actualCompletionPercentage;

    // Bonus for completing all exercises
    if (actualCompletionPercentage == 100.0) {
      score += 10.0;
    }

    // Penalty for taking too long (more than 2x estimated time)
    // This would require workout plan data to calculate properly

    return score.clamp(0.0, 100.0);
  }

  /// Validate workout session data
  List<String> validate() {
    final errors = <String>[];

    if (userId.trim().isEmpty) {
      errors.add('User ID cannot be empty');
    }

    if (workoutPlanId.trim().isEmpty) {
      errors.add('Workout plan ID cannot be empty');
    }

    if (exerciseExecutions.isEmpty) {
      errors.add('Session must have at least one exercise execution');
    }

    // Validate exercise executions
    for (final execution in exerciseExecutions) {
      final executionErrors = execution.validate();
      errors.addAll(
        executionErrors.map((e) => 'Exercise ${execution.order}: $e'),
      );
    }

    return errors;
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return toJson()..remove('id'); // Firestore document ID is separate
  }
}

/// Helper methods for WorkoutSession
class WorkoutSessionHelper {
  /// Create WorkoutSession from Firestore document
  static WorkoutSession fromFirestore(String id, Map<String, dynamic> data) {
    return WorkoutSession.fromJson({'id': id, ...data});
  }

  /// Create a new session from workout plan
  static WorkoutSession createFromPlan({
    required String userId,
    required WorkoutPlan workoutPlan,
  }) {
    final exerciseExecutions =
        workoutPlan.exercises.map((exercise) {
          return ExerciseExecution(
            exerciseId: exercise.exerciseId,
            order: exercise.order,
            status: ExecutionStatus.notStarted,
            startedAt: DateTime.now(),
            setExecutions: List.generate(exercise.sets, (index) {
              return SetExecution(
                setNumber: index + 1,
                status: SetStatus.notStarted,
                startedAt: DateTime.now(),
                plannedReps: exercise.repsPerSet,
              );
            }),
            exerciseName: exercise.exerciseName,
          );
        }).toList();

    return WorkoutSession(
      id: '', // Will be set by repository
      userId: userId,
      workoutPlanId: workoutPlan.id,
      status: SessionStatus.notStarted,
      startedAt: DateTime.now(),
      exerciseExecutions: exerciseExecutions,
      metadata: {},
      workoutPlanName: workoutPlan.name,
      completionPercentage: 0,
    );
  }
}

/// Extension methods for ExerciseExecution
extension ExerciseExecutionExtension on ExerciseExecution {
  /// Check if exercise is completed
  bool get isCompleted => status == ExecutionStatus.completed;

  /// Get completed sets count
  int get completedSetsCount {
    return setExecutions.where((s) => s.status == SetStatus.completed).length;
  }

  /// Get total sets count
  int get totalSetsCount => setExecutions.length;

  /// Calculate completion percentage for this exercise
  double get completionPercentage {
    if (setExecutions.isEmpty) return 0;
    return (completedSetsCount / totalSetsCount) * 100;
  }

  /// Get exercise duration in seconds
  int get exerciseDurationSeconds {
    if (totalDurationSeconds != null) {
      return totalDurationSeconds!;
    }

    if (completedAt != null) {
      return completedAt!.difference(startedAt).inSeconds;
    }

    return DateTime.now().difference(startedAt).inSeconds;
  }

  /// Validate exercise execution data
  List<String> validate() {
    final errors = <String>[];

    if (exerciseId.trim().isEmpty) {
      errors.add('Exercise ID cannot be empty');
    }

    if (order <= 0) {
      errors.add('Exercise order must be greater than 0');
    }

    if (setExecutions.isEmpty) {
      errors.add('Exercise must have at least one set execution');
    }

    // Validate set executions
    for (final setExecution in setExecutions) {
      final setErrors = setExecution.validate();
      errors.addAll(setErrors.map((e) => 'Set ${setExecution.setNumber}: $e'));
    }

    return errors;
  }
}

/// Extension methods for SetExecution
extension SetExecutionExtension on SetExecution {
  /// Check if set is completed
  bool get isCompleted => status == SetStatus.completed;

  /// Get set duration in seconds
  int get setDurationSeconds {
    if (durationSeconds != null) {
      return durationSeconds!;
    }

    if (completedAt != null) {
      return completedAt!.difference(startedAt).inSeconds;
    }

    return DateTime.now().difference(startedAt).inSeconds;
  }

  /// Check if set was performed as planned
  bool get wasPerformedAsPlanned {
    return isCompleted &&
        actualReps != null &&
        plannedReps != null &&
        actualReps! >= plannedReps!;
  }

  /// Validate set execution data
  List<String> validate() {
    final errors = <String>[];

    if (setNumber <= 0) {
      errors.add('Set number must be greater than 0');
    }

    if (actualReps != null && (actualReps! < 0 || actualReps! > 1000)) {
      errors.add('Actual reps must be between 0 and 1000');
    }

    if (plannedReps != null && (plannedReps! < 0 || plannedReps! > 1000)) {
      errors.add('Planned reps must be between 0 and 1000');
    }

    if (weight != null && (weight! < 0 || weight! > 1000)) {
      errors.add('Weight must be between 0 and 1000 kg');
    }

    return errors;
  }
}
