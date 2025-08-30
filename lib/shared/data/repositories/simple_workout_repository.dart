import 'dart:async';

import 'package:fitness_training_app/shared/domain/entities/workout_plan.dart';
import 'package:fitness_training_app/shared/domain/entities/workout_session.dart';
import 'package:fitness_training_app/shared/domain/repositories/workout_repository.dart';

/// Simple in-memory workout repository for testing and development
class SimpleWorkoutRepository implements WorkoutRepository {
  final Map<String, WorkoutPlan> _plans = {};
  final Map<String, WorkoutSession> _sessions = {};
  final StreamController<List<WorkoutPlan>> _plansController =
      StreamController<List<WorkoutPlan>>.broadcast();
  final StreamController<List<WorkoutSession>> _sessionsController =
      StreamController<List<WorkoutSession>>.broadcast();

  @override
  Future<WorkoutPlan?> getWorkoutPlan(String planId) async {
    return _plans[planId];
  }

  @override
  Future<List<WorkoutPlan>> getWorkoutPlansForUser(String userId) async {
    return _plans.values.where((plan) => plan.userId == userId).toList();
  }

  @override
  Future<WorkoutPlan> createWorkoutPlan(WorkoutPlan plan) async {
    final id = 'plan_${DateTime.now().millisecondsSinceEpoch}';
    final planWithId = plan.copyWith(id: id);
    _plans[id] = planWithId;
    _notifyPlansChanged();
    return planWithId;
  }

  @override
  Future<WorkoutPlan> updateWorkoutPlan(WorkoutPlan plan) async {
    _plans[plan.id] = plan;
    _notifyPlansChanged();
    return plan;
  }

  @override
  Future<void> deleteWorkoutPlan(String planId) async {
    _plans.remove(planId);
    _notifyPlansChanged();
  }

  @override
  Future<WorkoutPlan?> getActiveWorkoutPlan(String userId) async {
    final plans = await getWorkoutPlansForUser(userId);
    return plans.where((plan) => plan.isActive == true).firstOrNull;
  }

  @override
  Future<void> setActiveWorkoutPlan(String userId, String planId) async {
    // Deactivate all other plans
    final userPlans = await getWorkoutPlansForUser(userId);
    for (final plan in userPlans) {
      if (plan.isActive == true && plan.id != planId) {
        await updateWorkoutPlan(plan.copyWith(isActive: false));
      }
    }

    // Activate the selected plan
    final plan = await getWorkoutPlan(planId);
    if (plan != null) {
      await updateWorkoutPlan(plan.copyWith(isActive: true));
    }
  }

  @override
  Future<WorkoutSession?> getWorkoutSession(String sessionId) async {
    return _sessions[sessionId];
  }

  @override
  Future<List<WorkoutSession>> getWorkoutSessionsForUser(
    String userId, {
    int? limit,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    var sessions = _sessions.values.where(
      (session) => session.userId == userId,
    );

    if (startDate != null) {
      sessions = sessions.where(
        (session) =>
            session.startedAt.isAfter(startDate) ||
            session.startedAt.isAtSameMomentAs(startDate),
      );
    }

    if (endDate != null) {
      sessions = sessions.where(
        (session) =>
            session.startedAt.isBefore(endDate) ||
            session.startedAt.isAtSameMomentAs(endDate),
      );
    }

    final sessionsList = sessions.toList();
    sessionsList.sort((a, b) => b.startedAt.compareTo(a.startedAt));

    if (limit != null && sessionsList.length > limit) {
      return sessionsList.take(limit).toList();
    }

    return sessionsList;
  }

  @override
  Future<WorkoutSession> createWorkoutSession(WorkoutSession session) async {
    final id = 'session_${DateTime.now().millisecondsSinceEpoch}';
    final sessionWithId = session.copyWith(id: id);
    _sessions[id] = sessionWithId;
    _notifySessionsChanged();
    return sessionWithId;
  }

  @override
  Future<WorkoutSession> updateWorkoutSession(WorkoutSession session) async {
    _sessions[session.id] = session;
    _notifySessionsChanged();
    return session;
  }

  @override
  Future<void> deleteWorkoutSession(String sessionId) async {
    _sessions.remove(sessionId);
    _notifySessionsChanged();
  }

  @override
  Future<WorkoutSession?> getActiveWorkoutSession(String userId) async {
    final sessions = await getWorkoutSessionsForUser(userId, limit: 10);
    return sessions.where((session) => session.isActive).firstOrNull;
  }

  @override
  Future<WorkoutSession> completeWorkoutSession(
    String sessionId,
    Map<String, dynamic> completionData,
  ) async {
    final session = await getWorkoutSession(sessionId);
    if (session == null) {
      throw Exception('Session not found: $sessionId');
    }

    final completedSession = session.copyWith(
      status: SessionStatus.completed,
      completedAt: DateTime.now(),
      totalDurationSeconds: completionData['totalDurationSeconds'] as int?,
      completionPercentage: completionData['completionPercentage'] as double?,
      totalCaloriesBurned: completionData['totalCaloriesBurned'] as int?,
      sessionData: completionData,
    );

    return await updateWorkoutSession(completedSession);
  }

  @override
  Future<WorkoutSession> abandonWorkoutSession(
    String sessionId,
    String reason,
  ) async {
    final session = await getWorkoutSession(sessionId);
    if (session == null) {
      throw Exception('Session not found: $sessionId');
    }

    final abandonedSession = session.copyWith(
      status: SessionStatus.abandoned,
      completedAt: DateTime.now(),
      userNotes: reason,
      sessionData: {'abandonReason': reason},
    );

    return await updateWorkoutSession(abandonedSession);
  }

  @override
  Future<Map<String, dynamic>> getUserWorkoutStats(String userId) async {
    final sessions = await getWorkoutSessionsForUser(userId);
    final completedSessions = sessions.where((s) => s.isCompleted).toList();
    final totalSessions = sessions.length;
    final completionRate =
        totalSessions > 0
            ? (completedSessions.length / totalSessions) * 100
            : 0.0;

    final totalWorkoutTime = completedSessions.fold<int>(
      0,
      (sum, session) => sum + (session.totalDurationSeconds ?? 0),
    );

    final totalCalories = completedSessions.fold<int>(
      0,
      (sum, session) => sum + (session.totalCaloriesBurned ?? 0),
    );

    return {
      'totalSessions': totalSessions,
      'completedSessions': completedSessions.length,
      'completionRate': completionRate,
      'totalWorkoutTimeSeconds': totalWorkoutTime,
      'totalCaloriesBurned': totalCalories,
      'averageSessionDuration':
          completedSessions.isNotEmpty
              ? totalWorkoutTime / completedSessions.length
              : 0,
      'lastWorkoutDate':
          sessions.isNotEmpty
              ? sessions.first.startedAt.toIso8601String()
              : null,
    };
  }

  @override
  Future<List<Map<String, dynamic>>> getUserProgressData(
    String userId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final sessions = await getWorkoutSessionsForUser(
      userId,
      startDate: startDate,
      endDate: endDate,
    );

    return sessions
        .map(
          (session) => {
            'date': session.startedAt.toIso8601String(),
            'completed': session.isCompleted,
            'completionPercentage': session.actualCompletionPercentage,
            'duration': session.sessionDurationMinutes,
            'caloriesBurned': session.totalCaloriesBurned ?? 0,
            'exercisesCompleted': session.completedExercisesCount,
            'totalExercises': session.totalExercisesCount,
          },
        )
        .toList();
  }

  @override
  Future<double> getWorkoutCompletionRate(String userId) async {
    final stats = await getUserWorkoutStats(userId);
    return (stats['completionRate'] as double?) ?? 0.0;
  }

  @override
  Stream<List<WorkoutPlan>> watchWorkoutPlansForUser(String userId) {
    return _plansController.stream.map(
      (plans) => plans.where((plan) => plan.userId == userId).toList(),
    );
  }

  @override
  Stream<List<WorkoutSession>> watchWorkoutSessionsForUser(String userId) {
    return _sessionsController.stream.map(
      (sessions) =>
          sessions.where((session) => session.userId == userId).toList(),
    );
  }

  @override
  Stream<WorkoutSession?> watchActiveWorkoutSession(String userId) {
    return _sessionsController.stream.map((sessions) {
      final userSessions = sessions.where(
        (session) => session.userId == userId && session.isActive,
      );
      return userSessions.isNotEmpty ? userSessions.first : null;
    });
  }

  @override
  Future<bool> isAvailableOffline(String userId) async {
    return true; // Always available since it's in-memory
  }

  @override
  Future<void> refreshFromRemote(String userId) async {
    // No-op for simple repository
  }

  @override
  Future<Map<String, dynamic>> getCacheStatus(String userId) async {
    return {
      'plansCount': _plans.values.where((p) => p.userId == userId).length,
      'sessionsCount': _sessions.values.where((s) => s.userId == userId).length,
      'lastSync': DateTime.now().toIso8601String(),
    };
  }

  @override
  Future<List<Map<String, dynamic>>> getPendingSyncOperations(
    String userId,
  ) async {
    return []; // No sync operations for simple repository
  }

  void _notifyPlansChanged() {
    _plansController.add(_plans.values.toList());
  }

  void _notifySessionsChanged() {
    _sessionsController.add(_sessions.values.toList());
  }

  void dispose() {
    _plansController.close();
    _sessionsController.close();
  }
}
