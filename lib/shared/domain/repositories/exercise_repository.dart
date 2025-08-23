import 'package:fitness_training_app/shared/domain/entities/exercise.dart';

/// Repository interface for exercise data management
abstract class ExerciseRepository {
  /// Get all exercises from the database
  Future<List<Exercise>> getAllExercises();

  /// Get exercise by ID
  Future<Exercise?> getExerciseById(String id);

  /// Get exercises by category
  Future<List<Exercise>> getExercisesByCategory(ExerciseCategory category);

  /// Get exercises by difficulty level
  Future<List<Exercise>> getExercisesByDifficulty(DifficultyLevel difficulty);

  /// Get exercises by muscle group
  Future<List<Exercise>> getExercisesByMuscleGroup(MuscleGroup muscleGroup);

  /// Get alternative exercises for a given exercise
  Future<List<Exercise>> getAlternativeExercises(String exerciseId);

  /// Search exercises by name or description
  Future<List<Exercise>> searchExercises(String query);

  /// Get exercises matching user preferences
  Future<List<Exercise>> getExercisesForUser({
    required List<String> preferredTypes,
    required List<String> dislikedExercises,
    required List<String> availableEquipment,
    DifficultyLevel? maxDifficulty,
  });

  /// Stream of all exercises (for real-time updates)
  Stream<List<Exercise>> watchAllExercises();

  /// Stream of exercises by category
  Stream<List<Exercise>> watchExercisesByCategory(ExerciseCategory category);

  /// Check if exercise database is available offline
  Future<bool> isAvailableOffline();

  /// Force refresh from remote source
  Future<void> refreshFromRemote();

  /// Get cache status information
  Future<Map<String, dynamic>> getCacheStatus();
}
