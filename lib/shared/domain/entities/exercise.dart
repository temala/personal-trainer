import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise.freezed.dart';
part 'exercise.g.dart';

/// Exercise entity representing a single exercise
@freezed
class Exercise with _$Exercise {
  const factory Exercise({
    required String id,
    required String name,
    required String description,
    required ExerciseCategory category,
    required DifficultyLevel difficulty,
    required List<MuscleGroup> targetMuscles,
    required List<String> equipment,
    required int estimatedDurationSeconds,
    required List<String> instructions,
    required List<String> tips,
    required Map<String, dynamic> metadata,
    String? animationUrl,
    String? thumbnailUrl,
    List<String>? alternativeExerciseIds,
    Map<String, dynamic>? customData,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Exercise;

  factory Exercise.fromJson(Map<String, dynamic> json) =>
      _$ExerciseFromJson(json);
}

/// Exercise categories
enum ExerciseCategory {
  @JsonValue('cardio')
  cardio,
  @JsonValue('strength')
  strength,
  @JsonValue('flexibility')
  flexibility,
  @JsonValue('balance')
  balance,
  @JsonValue('sports')
  sports,
  @JsonValue('rehabilitation')
  rehabilitation,
}

/// Difficulty levels
enum DifficultyLevel {
  @JsonValue('beginner')
  beginner,
  @JsonValue('intermediate')
  intermediate,
  @JsonValue('advanced')
  advanced,
  @JsonValue('expert')
  expert,
}

/// Muscle groups
enum MuscleGroup {
  @JsonValue('chest')
  chest,
  @JsonValue('back')
  back,
  @JsonValue('shoulders')
  shoulders,
  @JsonValue('arms')
  arms,
  @JsonValue('core')
  core,
  @JsonValue('legs')
  legs,
  @JsonValue('glutes')
  glutes,
  @JsonValue('full_body')
  fullBody,
}

/// Extension methods for Exercise
extension ExerciseExtension on Exercise {
  /// Get formatted duration
  String get formattedDuration {
    final minutes = estimatedDurationSeconds ~/ 60;
    final seconds = estimatedDurationSeconds % 60;
    if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    }
    return '${seconds}s';
  }

  /// Check if exercise requires equipment
  bool get requiresEquipment => equipment.isNotEmpty;

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

  /// Get category icon
  String get categoryIcon {
    switch (category) {
      case ExerciseCategory.cardio:
        return '❤️';
      case ExerciseCategory.strength:
        return '💪';
      case ExerciseCategory.flexibility:
        return '🤸';
      case ExerciseCategory.balance:
        return '⚖️';
      case ExerciseCategory.sports:
        return '⚽';
      case ExerciseCategory.rehabilitation:
        return '🏥';
    }
  }

  /// Validate exercise data
  List<String> validate() {
    final errors = <String>[];

    if (name.trim().isEmpty) {
      errors.add('Exercise name cannot be empty');
    }

    if (description.trim().isEmpty) {
      errors.add('Exercise description cannot be empty');
    }

    if (estimatedDurationSeconds <= 0) {
      errors.add('Duration must be greater than 0');
    }

    if (instructions.isEmpty) {
      errors.add('Exercise must have at least one instruction');
    }

    if (targetMuscles.isEmpty) {
      errors.add('Exercise must target at least one muscle group');
    }

    return errors;
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return toJson()..remove('id'); // Firestore document ID is separate
  }

  /// Check if exercise matches user preferences
  bool matchesPreferences({
    required List<String> preferredTypes,
    required List<String> dislikedExercises,
    required List<String> availableEquipment,
  }) {
    // Check if exercise is disliked
    if (dislikedExercises.contains(id) || dislikedExercises.contains(name)) {
      return false;
    }

    // Check equipment availability
    if (requiresEquipment) {
      final hasRequiredEquipment = equipment.every(
        (eq) => availableEquipment.contains(eq),
      );
      if (!hasRequiredEquipment) return false;
    }

    // Check preferred types
    if (preferredTypes.isNotEmpty) {
      final categoryMatch = preferredTypes.contains(category.name);
      final muscleMatch = targetMuscles.any(
        (muscle) => preferredTypes.contains(muscle.name),
      );
      return categoryMatch || muscleMatch;
    }

    return true;
  }
}

/// Helper methods for Exercise
class ExerciseHelper {
  /// Create Exercise from Firestore document
  static Exercise fromFirestore(String id, Map<String, dynamic> data) {
    return Exercise.fromJson({'id': id, ...data});
  }
}
