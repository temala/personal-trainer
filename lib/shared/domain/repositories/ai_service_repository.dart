import 'package:fitness_training_app/shared/domain/entities/ai_response.dart';
import 'package:fitness_training_app/shared/domain/entities/exercise.dart';
import 'package:fitness_training_app/shared/domain/entities/user_profile.dart';
import 'package:fitness_training_app/shared/domain/entities/workout_plan.dart';

/// High-level AI service repository interface for the application layer
abstract class AIServiceRepository {
  /// Generate a personalized weekly workout plan
  Future<WorkoutPlan> generateWeeklyPlan(
    UserProfile profile,
    List<Exercise> availableExercises,
  );

  /// Get an alternative exercise based on user feedback
  Future<Exercise?> getAlternativeExercise(
    String currentExerciseId,
    AlternativeType type,
    List<Exercise> availableExercises,
    UserProfile userProfile,
  );

  /// Generate a personalized notification message
  Future<String> generateNotificationMessage(
    UserProfile userProfile,
    Map<String, dynamic> context,
  );

  /// Analyze user progress and provide insights
  Future<Map<String, dynamic>> analyzeProgress(
    UserProfile userProfile,
    Map<String, dynamic> progressData,
  );

  /// Test if AI services are available
  Future<bool> isServiceAvailable();

  /// Get current service status
  Future<Map<String, dynamic>> getServiceStatus();
}

/// Types of exercise alternatives
enum AlternativeType { dislike, notPossible }

/// Extension to convert AlternativeType to string
extension AlternativeTypeExtension on AlternativeType {
  String get value {
    switch (this) {
      case AlternativeType.dislike:
        return 'dislike';
      case AlternativeType.notPossible:
        return 'not_possible';
    }
  }
}

/// User context for AI requests
class UserContext {
  const UserContext({
    required this.name,
    required this.age,
    this.lastWorkout,
    this.completedWorkouts = 0,
    this.preferredExercises = const [],
    this.dislikedExercises = const [],
    this.fitnessLevel = 'beginner',
  });
  final String name;
  final int age;
  final DateTime? lastWorkout;
  final int completedWorkouts;
  final List<String> preferredExercises;
  final List<String> dislikedExercises;
  final String fitnessLevel;

  Map<String, dynamic> toJson() => {
    'name': name,
    'age': age,
    'lastWorkout': lastWorkout?.toIso8601String(),
    'completedWorkouts': completedWorkouts,
    'preferredExercises': preferredExercises,
    'dislikedExercises': dislikedExercises,
    'fitnessLevel': fitnessLevel,
  };
}
