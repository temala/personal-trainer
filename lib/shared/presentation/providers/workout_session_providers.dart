import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fitness_training_app/shared/data/repositories/firebase_workout_repository.dart';
import 'package:fitness_training_app/shared/data/services/workout_session_manager.dart';
import 'package:fitness_training_app/shared/data/services/workout_session_persistence_service.dart';
import 'package:fitness_training_app/shared/domain/entities/workout_plan.dart';
import 'package:fitness_training_app/shared/domain/entities/workout_session.dart';
import 'package:fitness_training_app/shared/domain/repositories/exercise_repository.dart';
import 'package:fitness_training_app/shared/domain/repositories/workout_repository.dart';
import 'package:fitness_training_app/shared/presentation/providers/exercise_providers.dart';

/// Workout repository provider
final workoutRepositoryProvider = Provider<WorkoutRepository>((ref) {
  return FirebaseWorkoutRepository();
});

/// Shared preferences provider
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((
  ref,
) async {
  return SharedPreferences.getInstance();
});

/// Session persistence box provider
final sessionPersistenceBoxProvider = FutureProvider<Box<Map<String, dynamic>>>(
  (ref) async {
    return Hive.openBox<Map<String, dynamic>>('session_persistence');
  },
);

/// Workout session persistence service provider
final workoutSessionPersistenceServiceProvider =
    FutureProvider<WorkoutSessionPersistenceService>((ref) async {
      final prefs = await ref.watch(sharedPreferencesProvider.future);
      final box = await ref.watch(sessionPersistenceBoxProvider.future);

      return WorkoutSessionPersistenceService(prefs: prefs, sessionBox: box);
    });

/// Workout session manager provider
final workoutSessionManagerProvider =
    FutureProvider<PersistentWorkoutSessionManager>((ref) async {
      final workoutRepository = ref.watch(workoutRepositoryProvider);
      final exerciseRepository = ref.watch(exerciseRepositoryProvider);
      final persistenceService = await ref.watch(
        workoutSessionPersistenceServiceProvider.future,
      );

      return PersistentWorkoutSessionManager(
        workoutRepository: workoutRepository,
        exerciseRepository: exerciseRepository,
        persistenceService: persistenceService,
      );
    });

/// Current workout session manager provider (synchronous access)
final currentWorkoutSessionManagerProvider =
    Provider<PersistentWorkoutSessionManager?>((ref) {
      final managerAsync = ref.watch(workoutSessionManagerProvider);
      return managerAsync.when(
        data: (manager) => manager,
        loading: () => null,
        error: (_, __) => null,
      );
    });

/// Current workout session state provider
final workoutSessionStateProvider = StreamProvider<WorkoutSessionState>((ref) {
  final manager = ref.watch(currentWorkoutSessionManagerProvider);
  if (manager != null) {
    return manager.sessionState;
  }
  return Stream.value(const WorkoutSessionState.idle());
});

/// Current workout session provider
final currentWorkoutSessionProvider = Provider<WorkoutSession?>((ref) {
  final sessionState = ref.watch(workoutSessionStateProvider);
  return sessionState.when(
    data: (state) => state.session,
    loading: () => null,
    error: (_, __) => null,
  );
});

/// Active workout session provider for a user
final activeWorkoutSessionProvider =
    FutureProvider.family<WorkoutSession?, String>((ref, userId) async {
      final repository = ref.watch(workoutRepositoryProvider);
      return repository.getActiveWorkoutSession(userId);
    });

/// Workout sessions for user provider
final workoutSessionsProvider =
    FutureProvider.family<List<WorkoutSession>, WorkoutSessionsParams>((
      ref,
      params,
    ) async {
      final repository = ref.watch(workoutRepositoryProvider);
      return repository.getWorkoutSessionsForUser(
        params.userId,
        limit: params.limit,
        startDate: params.startDate,
        endDate: params.endDate,
      );
    });

/// Workout session by ID provider
final workoutSessionByIdProvider =
    FutureProvider.family<WorkoutSession?, String>((ref, sessionId) async {
      final repository = ref.watch(workoutRepositoryProvider);
      return repository.getWorkoutSession(sessionId);
    });

/// User workout statistics provider
final userWorkoutStatsProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, userId) async {
      final repository = ref.watch(workoutRepositoryProvider);
      return repository.getUserWorkoutStats(userId);
    });

/// User progress data provider
final userProgressDataProvider =
    FutureProvider.family<List<Map<String, dynamic>>, ProgressDataParams>((
      ref,
      params,
    ) async {
      final repository = ref.watch(workoutRepositoryProvider);
      return repository.getUserProgressData(
        params.userId,
        startDate: params.startDate,
        endDate: params.endDate,
      );
    });

/// Workout completion rate provider
final workoutCompletionRateProvider = FutureProvider.family<double, String>((
  ref,
  userId,
) async {
  final repository = ref.watch(workoutRepositoryProvider);
  return repository.getWorkoutCompletionRate(userId);
});

/// Workout plans for user provider
final workoutPlansProvider = FutureProvider.family<List<WorkoutPlan>, String>((
  ref,
  userId,
) async {
  final repository = ref.watch(workoutRepositoryProvider);
  return repository.getWorkoutPlansForUser(userId);
});

/// Active workout plan provider
final activeWorkoutPlanProvider = FutureProvider.family<WorkoutPlan?, String>((
  ref,
  userId,
) async {
  final repository = ref.watch(workoutRepositoryProvider);
  return repository.getActiveWorkoutPlan(userId);
});

/// Workout plan by ID provider
final workoutPlanByIdProvider = FutureProvider.family<WorkoutPlan?, String>((
  ref,
  planId,
) async {
  final repository = ref.watch(workoutRepositoryProvider);
  return repository.getWorkoutPlan(planId);
});

/// Stream workout sessions for user provider
final streamWorkoutSessionsProvider =
    StreamProvider.family<List<WorkoutSession>, String>((ref, userId) {
      final repository = ref.watch(workoutRepositoryProvider);
      return repository.watchWorkoutSessionsForUser(userId);
    });

/// Stream active workout session provider
final streamActiveWorkoutSessionProvider =
    StreamProvider.family<WorkoutSession?, String>((ref, userId) {
      final repository = ref.watch(workoutRepositoryProvider);
      return repository.watchActiveWorkoutSession(userId);
    });

/// Stream workout plans for user provider
final streamWorkoutPlansProvider =
    StreamProvider.family<List<WorkoutPlan>, String>((ref, userId) {
      final repository = ref.watch(workoutRepositoryProvider);
      return repository.watchWorkoutPlansForUser(userId);
    });

// Remove duplicate provider - it's defined later

/// Current exercise provider
final currentExerciseProvider = Provider<ExerciseExecution?>((ref) {
  final sessionState = ref.watch(workoutSessionStateProvider);
  return sessionState.when(
    data: (state) {
      if (state is ActiveWorkoutSessionState) {
        final session = state.session;
        final index = state.currentExerciseIndex;
        if (index < session.exerciseExecutions.length) {
          return session.exerciseExecutions[index];
        }
      }
      return null;
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

/// Session progress provider
final sessionProgressProvider = Provider<SessionProgress?>((ref) {
  final sessionState = ref.watch(workoutSessionStateProvider);
  return sessionState.when(
    data: (state) {
      if (state is ActiveWorkoutSessionState) {
        final session = state.session;
        return SessionProgress(
          currentExerciseIndex: state.currentExerciseIndex,
          totalExercises: session.exerciseExecutions.length,
          completedExercises: session.completedExercisesCount,
          completionPercentage: session.actualCompletionPercentage,
          isRecovering: state.isRecovering,
          recoveryTimeRemaining: state.recoveryTimeRemaining,
        );
      }
      return null;
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

/// Offline availability provider
final workoutOfflineAvailabilityProvider = FutureProvider.family<bool, String>((
  ref,
  userId,
) async {
  final repository = ref.watch(workoutRepositoryProvider);
  return repository.isAvailableOffline(userId);
});

/// Cache status provider
final workoutCacheStatusProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, userId) async {
      final repository = ref.watch(workoutRepositoryProvider);
      return repository.getCacheStatus(userId);
    });

/// Pending sync operations provider
final pendingSyncOperationsProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>((
      ref,
      userId,
    ) async {
      final repository = ref.watch(workoutRepositoryProvider);
      return repository.getPendingSyncOperations(userId);
    });

// Parameter classes

/// Parameters for workout sessions query
class WorkoutSessionsParams {
  const WorkoutSessionsParams({
    required this.userId,
    this.limit,
    this.startDate,
    this.endDate,
  });

  final String userId;
  final int? limit;
  final DateTime? startDate;
  final DateTime? endDate;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutSessionsParams &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          limit == other.limit &&
          startDate == other.startDate &&
          endDate == other.endDate;

  @override
  int get hashCode => Object.hash(userId, limit, startDate, endDate);
}

/// Parameters for progress data query
class ProgressDataParams {
  const ProgressDataParams({
    required this.userId,
    this.startDate,
    this.endDate,
  });

  final String userId;
  final DateTime? startDate;
  final DateTime? endDate;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProgressDataParams &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          startDate == other.startDate &&
          endDate == other.endDate;

  @override
  int get hashCode => Object.hash(userId, startDate, endDate);
}

/// Session progress information
class SessionProgress {
  const SessionProgress({
    required this.currentExerciseIndex,
    required this.totalExercises,
    required this.completedExercises,
    required this.completionPercentage,
    required this.isRecovering,
    required this.recoveryTimeRemaining,
  });

  final int currentExerciseIndex;
  final int totalExercises;
  final int completedExercises;
  final double completionPercentage;
  final bool isRecovering;
  final int recoveryTimeRemaining;

  /// Get current exercise number (1-based)
  int get currentExerciseNumber => currentExerciseIndex + 1;

  /// Check if session is in progress
  bool get isInProgress => currentExerciseIndex < totalExercises;

  /// Get remaining exercises count
  int get remainingExercises => totalExercises - completedExercises;

  /// Get formatted progress text
  String get progressText => '$currentExerciseNumber/$totalExercises';

  /// Get formatted completion percentage
  String get formattedCompletionPercentage =>
      '${completionPercentage.toStringAsFixed(1)}%';

  /// Get formatted recovery time
  String get formattedRecoveryTime {
    final minutes = recoveryTimeRemaining ~/ 60;
    final seconds = recoveryTimeRemaining % 60;
    if (minutes > 0) {
      return '${minutes}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${seconds}s';
  }
}

/// Workout session actions
class WorkoutSessionActions {
  const WorkoutSessionActions(this._manager);

  final PersistentWorkoutSessionManager _manager;

  /// Start a new workout session
  Future<void> startSession(WorkoutPlan plan) => _manager.startSession(plan);

  /// Complete current exercise
  Future<void> completeExercise(String exerciseId) =>
      _manager.completeExercise(exerciseId);

  /// Request alternative exercise
  Future<void> requestAlternative(String exerciseId, AlternativeType type) =>
      _manager.requestAlternative(exerciseId, type);

  /// Skip current exercise
  Future<void> skipExercise(String exerciseId, String reason) =>
      _manager.skipExercise(exerciseId, reason);

  /// Pause current session
  Future<void> pauseSession() => _manager.pauseSession();

  /// Resume paused session
  Future<void> resumeSession() => _manager.resumeSession();

  /// End current session
  Future<void> endSession() => _manager.endSession();

  /// Skip recovery period
  Future<void> skipRecovery() => _manager.skipRecovery();

  /// Load existing session
  Future<void> loadSession(String sessionId) => _manager.loadSession(sessionId);
}

/// Workout session actions provider
final workoutSessionActionsProvider = Provider<NullableWorkoutSessionActions>((
  ref,
) {
  final manager = ref.watch(currentWorkoutSessionManagerProvider);
  final actions = manager != null ? WorkoutSessionActions(manager) : null;
  return NullableWorkoutSessionActions(actions);
});

/// Null-safe workout session actions wrapper
class NullableWorkoutSessionActions {
  const NullableWorkoutSessionActions(this._actions);

  final WorkoutSessionActions? _actions;

  /// Start a new workout session
  Future<void> startSession(WorkoutPlan plan) async {
    if (_actions != null) {
      return _actions.startSession(plan);
    }
    throw StateError('Workout session manager not available');
  }

  /// Complete current exercise
  Future<void> completeExercise(String exerciseId) async {
    if (_actions != null) {
      return _actions.completeExercise(exerciseId);
    }
    throw StateError('Workout session manager not available');
  }

  /// Request alternative exercise
  Future<void> requestAlternative(
    String exerciseId,
    AlternativeType type,
  ) async {
    if (_actions != null) {
      return _actions.requestAlternative(exerciseId, type);
    }
    throw StateError('Workout session manager not available');
  }

  /// Skip current exercise
  Future<void> skipExercise(String exerciseId, String reason) async {
    if (_actions != null) {
      return _actions.skipExercise(exerciseId, reason);
    }
    throw StateError('Workout session manager not available');
  }

  /// Pause current session
  Future<void> pauseSession() async {
    if (_actions != null) {
      return _actions.pauseSession();
    }
    throw StateError('Workout session manager not available');
  }

  /// Resume paused session
  Future<void> resumeSession() async {
    if (_actions != null) {
      return _actions.resumeSession();
    }
    throw StateError('Workout session manager not available');
  }

  /// End current session
  Future<void> endSession() async {
    if (_actions != null) {
      return _actions.endSession();
    }
    throw StateError('Workout session manager not available');
  }

  /// Skip recovery period
  Future<void> skipRecovery() async {
    if (_actions != null) {
      return _actions.skipRecovery();
    }
    throw StateError('Workout session manager not available');
  }

  /// Load existing session
  Future<void> loadSession(String sessionId) async {
    if (_actions != null) {
      return _actions.loadSession(sessionId);
    }
    throw StateError('Workout session manager not available');
  }

  /// Check if actions are available
  bool get isAvailable => _actions != null;
}

/// Session recovery data provider
final sessionRecoveryDataProvider = FutureProvider<List<SessionRecoveryData>>((
  ref,
) async {
  final persistenceService = await ref.watch(
    workoutSessionPersistenceServiceProvider.future,
  );
  return persistenceService.getPendingRecoverySessions();
});

/// Has sessions needing recovery provider
final hasSessionsNeedingRecoveryProvider = FutureProvider<bool>((ref) async {
  final persistenceService = await ref.watch(
    workoutSessionPersistenceServiceProvider.future,
  );
  return persistenceService.hasSessionsNeedingRecovery();
});

/// App lifecycle state provider
final appLifecycleStateProvider = StateProvider<AppLifecycleState?>(
  (ref) => null,
);
