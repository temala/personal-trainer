import 'package:fitness_training_app/shared/domain/entities/workout_plan.dart';
import 'package:fitness_training_app/shared/domain/entities/workout_session.dart';

/// Repository interface for workout data management
abstract class WorkoutRepository {
  // Workout Plan methods
  /// Get workout plan by ID
  Future<WorkoutPlan?> getWorkoutPlan(String planId);

  /// Get workout plans for user
  Future<List<WorkoutPlan>> getWorkoutPlansForUser(String userId);

  /// Create new workout plan
  Future<WorkoutPlan> createWorkoutPlan(WorkoutPlan plan);

  /// Update workout plan
  Future<WorkoutPlan> updateWorkoutPlan(WorkoutPlan plan);

  /// Delete workout plan
  Future<void> deleteWorkoutPlan(String planId);

  /// Get active workout plan for user
  Future<WorkoutPlan?> getActiveWorkoutPlan(String userId);

  /// Set active workout plan for user
  Future<void> setActiveWorkoutPlan(String userId, String planId);

  // Workout Session methods
  /// Get workout session by ID
  Future<WorkoutSession?> getWorkoutSession(String sessionId);

  /// Get workout sessions for user
  Future<List<WorkoutSession>> getWorkoutSessionsForUser(
    String userId, {
    int? limit,
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Create new workout session
  Future<WorkoutSession> createWorkoutSession(WorkoutSession session);

  /// Update workout session
  Future<WorkoutSession> updateWorkoutSession(WorkoutSession session);

  /// Delete workout session
  Future<void> deleteWorkoutSession(String sessionId);

  /// Get active workout session for user
  Future<WorkoutSession?> getActiveWorkoutSession(String userId);

  /// Complete workout session
  Future<WorkoutSession> completeWorkoutSession(
    String sessionId,
    Map<String, dynamic> completionData,
  );

  /// Abandon workout session
  Future<WorkoutSession> abandonWorkoutSession(String sessionId, String reason);

  // Statistics and Analytics
  /// Get user workout statistics
  Future<Map<String, dynamic>> getUserWorkoutStats(String userId);

  /// Get user progress data
  Future<List<Map<String, dynamic>>> getUserProgressData(
    String userId, {
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Get workout completion rate
  Future<double> getWorkoutCompletionRate(String userId);

  // Streaming methods
  /// Stream workout plans for user
  Stream<List<WorkoutPlan>> watchWorkoutPlansForUser(String userId);

  /// Stream workout sessions for user
  Stream<List<WorkoutSession>> watchWorkoutSessionsForUser(String userId);

  /// Stream active workout session
  Stream<WorkoutSession?> watchActiveWorkoutSession(String userId);

  // Offline support
  /// Check if workout data is available offline
  Future<bool> isAvailableOffline(String userId);

  /// Force refresh from remote source
  Future<void> refreshFromRemote(String userId);

  /// Get cache status information
  Future<Map<String, dynamic>> getCacheStatus(String userId);

  /// Get pending sync operations
  Future<List<Map<String, dynamic>>> getPendingSyncOperations(String userId);
}
