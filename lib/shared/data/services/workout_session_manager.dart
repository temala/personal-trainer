import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitness_training_app/core/utils/logger.dart';
import 'package:fitness_training_app/shared/data/services/exercise_alternative_service.dart';
import 'package:fitness_training_app/shared/domain/entities/exercise.dart';
import 'package:fitness_training_app/shared/domain/entities/workout_plan.dart';
import 'package:fitness_training_app/shared/domain/entities/workout_session.dart';
import 'package:fitness_training_app/shared/domain/repositories/exercise_repository.dart';
import 'package:fitness_training_app/shared/domain/repositories/workout_repository.dart';

/// Manages workout session state and execution
class WorkoutSessionManager {
  final WorkoutRepository _workoutRepository;
  final ExerciseRepository _exerciseRepository;

  // State management
  final StreamController<WorkoutSessionState> _stateController =
      StreamController<WorkoutSessionState>.broadcast();

  WorkoutSessionState _currentState = const WorkoutSessionState.idle();
  Timer? _sessionTimer;
  Timer? _recoveryTimer;

  WorkoutSessionManager({
    required WorkoutRepository workoutRepository,
    required ExerciseRepository exerciseRepository,
  }) : _workoutRepository = workoutRepository,
       _exerciseRepository = exerciseRepository;

  /// Current session state stream
  Stream<WorkoutSessionState> get sessionState => _stateController.stream;

  /// Current session state
  WorkoutSessionState get currentState => _currentState;

  /// Start a new workout session
  Future<void> startSession(WorkoutPlan plan) async {
    try {
      AppLogger.info('Starting workout session for plan: ${plan.id}');

      // Create new session from plan
      final session = WorkoutSessionHelper.createFromPlan(
        userId: plan.userId ?? '',
        workoutPlan: plan,
      );

      // Save session to repository
      final createdSession = await _workoutRepository.createWorkoutSession(
        session,
      );

      // Update state to active session
      _updateState(
        WorkoutSessionState.active(
          session: createdSession,
          currentExerciseIndex: 0,
          isRecovering: false,
          recoveryTimeRemaining: 0,
        ),
      );

      // Start session timer
      _startSessionTimer();

      AppLogger.info('Workout session started: ${createdSession.id}');
    } catch (e, stackTrace) {
      AppLogger.error('Error starting workout session', e, stackTrace);
      _updateState(
        WorkoutSessionState.error(
          message: 'Failed to start workout session: $e',
          session: null,
        ),
      );
      rethrow;
    }
  }

  /// Complete current exercise and move to next
  Future<void> completeExercise(String exerciseId) async {
    try {
      final state = _currentState;
      if (state is! ActiveWorkoutSessionState) {
        throw StateError('No active workout session');
      }

      AppLogger.info('Completing exercise: $exerciseId');

      final session = state.session;
      final currentIndex = state.currentExerciseIndex;

      if (currentIndex >= session.exerciseExecutions.length) {
        throw StateError('Invalid exercise index');
      }

      final currentExecution = session.exerciseExecutions[currentIndex];
      if (currentExecution.exerciseId != exerciseId) {
        throw StateError('Exercise ID mismatch');
      }

      // Mark exercise as completed
      final completedExecution = currentExecution.copyWith(
        status: ExecutionStatus.completed,
        completedAt: DateTime.now(),
        totalDurationSeconds:
            DateTime.now().difference(currentExecution.startedAt).inSeconds,
        setExecutions:
            currentExecution.setExecutions
                .map(
                  (set) => set.copyWith(
                    status: SetStatus.completed,
                    completedAt: DateTime.now(),
                    actualReps: set.plannedReps,
                  ),
                )
                .toList(),
      );

      // Update session with completed exercise
      final updatedExecutions = List<ExerciseExecution>.from(
        session.exerciseExecutions,
      );
      updatedExecutions[currentIndex] = completedExecution;

      final updatedSession = session.copyWith(
        exerciseExecutions: updatedExecutions,
        completionPercentage: _calculateCompletionPercentage(updatedExecutions),
      );

      // Save updated session
      await _workoutRepository.updateWorkoutSession(updatedSession);

      // Check if this was the last exercise
      if (currentIndex >= session.exerciseExecutions.length - 1) {
        await _completeSession(updatedSession);
        return;
      }

      // Move to recovery state
      await _startRecovery(updatedSession, currentIndex);

      AppLogger.info('Exercise completed: $exerciseId');
    } catch (e, stackTrace) {
      AppLogger.error('Error completing exercise: $exerciseId', e, stackTrace);
      _updateState(
        WorkoutSessionState.error(
          message: 'Failed to complete exercise: $e',
          session: _currentState.session,
        ),
      );
      rethrow;
    }
  }

  /// Request alternative exercise
  Future<void> requestAlternative(
    String exerciseId,
    AlternativeType type,
  ) async {
    try {
      final state = _currentState;
      if (state is! ActiveWorkoutSessionState) {
        throw StateError('No active workout session');
      }

      AppLogger.info(
        'Requesting alternative for exercise: $exerciseId, type: $type',
      );

      final session = state.session;
      final currentIndex = state.currentExerciseIndex;

      if (currentIndex >= session.exerciseExecutions.length) {
        throw StateError('Invalid exercise index');
      }

      final currentExecution = session.exerciseExecutions[currentIndex];
      if (currentExecution.exerciseId != exerciseId) {
        throw StateError('Exercise ID mismatch');
      }

      // Get alternative exercises
      final alternatives = await _exerciseRepository.getAlternativeExercises(
        exerciseId,
      );

      if (alternatives.isEmpty) {
        // No alternatives available, skip to next exercise
        await _skipExercise(exerciseId, 'No alternatives available');
        return;
      }

      // Select first alternative (in real implementation, this could be smarter)
      final alternativeExercise = alternatives.first;

      // Update execution with alternative
      final updatedExecution = currentExecution.copyWith(
        exerciseId: alternativeExercise.id,
        exerciseName: alternativeExercise.name,
        status: ExecutionStatus.alternativeUsed,
        alternativeExerciseId: exerciseId, // Store original exercise ID
      );

      // Update session
      final updatedExecutions = List<ExerciseExecution>.from(
        session.exerciseExecutions,
      );
      updatedExecutions[currentIndex] = updatedExecution;

      final updatedSession = session.copyWith(
        exerciseExecutions: updatedExecutions,
      );

      // Save updated session
      await _workoutRepository.updateWorkoutSession(updatedSession);

      // Update state with new exercise
      _updateState(state.copyWith(session: updatedSession));

      AppLogger.info(
        'Alternative exercise selected: ${alternativeExercise.id}',
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error requesting alternative for exercise: $exerciseId',
        e,
        stackTrace,
      );
      _updateState(
        WorkoutSessionState.error(
          message: 'Failed to get alternative exercise: $e',
          session: _currentState.session,
        ),
      );
      rethrow;
    }
  }

  /// Skip current exercise
  Future<void> skipExercise(String exerciseId, String reason) async {
    try {
      final state = _currentState;
      if (state is! ActiveWorkoutSessionState) {
        throw StateError('No active workout session');
      }

      AppLogger.info('Skipping exercise: $exerciseId, reason: $reason');

      await _skipExercise(exerciseId, reason);

      AppLogger.info('Exercise skipped: $exerciseId');
    } catch (e, stackTrace) {
      AppLogger.error('Error skipping exercise: $exerciseId', e, stackTrace);
      _updateState(
        WorkoutSessionState.error(
          message: 'Failed to skip exercise: $e',
          session: _currentState.session,
        ),
      );
      rethrow;
    }
  }

  /// Pause current session
  Future<void> pauseSession() async {
    try {
      final state = _currentState;
      if (state is! ActiveWorkoutSessionState) {
        throw StateError('No active workout session');
      }

      AppLogger.info('Pausing workout session: ${state.session.id}');

      // Stop timers
      _sessionTimer?.cancel();
      _recoveryTimer?.cancel();

      // Update session status
      final pausedSession = state.session.copyWith(
        status: SessionStatus.paused,
        pausedAt: DateTime.now(),
      );

      await _workoutRepository.updateWorkoutSession(pausedSession);

      // Update state
      _updateState(
        WorkoutSessionState.paused(
          session: pausedSession,
          currentExerciseIndex: state.currentExerciseIndex,
          wasRecovering: state.isRecovering,
          recoveryTimeRemaining: state.recoveryTimeRemaining,
        ),
      );

      AppLogger.info('Workout session paused: ${pausedSession.id}');
    } catch (e, stackTrace) {
      AppLogger.error('Error pausing workout session', e, stackTrace);
      _updateState(
        WorkoutSessionState.error(
          message: 'Failed to pause session: $e',
          session: _currentState.session,
        ),
      );
      rethrow;
    }
  }

  /// Resume paused session
  Future<void> resumeSession() async {
    try {
      final state = _currentState;
      if (state is! PausedWorkoutSessionState) {
        throw StateError('No paused workout session');
      }

      AppLogger.info('Resuming workout session: ${state.session.id}');

      // Update session status
      final resumedSession = state.session.copyWith(
        status: SessionStatus.inProgress,
        pausedAt: null,
      );

      await _workoutRepository.updateWorkoutSession(resumedSession);

      // Update state
      _updateState(
        WorkoutSessionState.active(
          session: resumedSession,
          currentExerciseIndex: state.currentExerciseIndex,
          isRecovering: state.wasRecovering,
          recoveryTimeRemaining: state.recoveryTimeRemaining,
        ),
      );

      // Restart timers
      _startSessionTimer();
      if (state.wasRecovering && state.recoveryTimeRemaining > 0) {
        _startRecoveryTimer(state.recoveryTimeRemaining);
      }

      AppLogger.info('Workout session resumed: ${resumedSession.id}');
    } catch (e, stackTrace) {
      AppLogger.error('Error resuming workout session', e, stackTrace);
      _updateState(
        WorkoutSessionState.error(
          message: 'Failed to resume session: $e',
          session: _currentState.session,
        ),
      );
      rethrow;
    }
  }

  /// End current session
  Future<void> endSession() async {
    try {
      final state = _currentState;
      if (state.session == null) {
        throw StateError('No active workout session');
      }

      AppLogger.info('Ending workout session: ${state.session!.id}');

      // Stop timers
      _sessionTimer?.cancel();
      _recoveryTimer?.cancel();

      // Mark session as abandoned if not completed
      final session = state.session!;
      if (session.status != SessionStatus.completed) {
        await _workoutRepository.abandonWorkoutSession(
          session.id,
          'Session ended by user',
        );
      }

      // Update state to idle
      _updateState(const WorkoutSessionState.idle());

      AppLogger.info('Workout session ended: ${session.id}');
    } catch (e, stackTrace) {
      AppLogger.error('Error ending workout session', e, stackTrace);
      _updateState(
        WorkoutSessionState.error(
          message: 'Failed to end session: $e',
          session: _currentState.session,
        ),
      );
      rethrow;
    }
  }

  /// Skip recovery and move to next exercise
  Future<void> skipRecovery() async {
    try {
      final state = _currentState;
      if (state is! ActiveWorkoutSessionState || !state.isRecovering) {
        throw StateError('Not in recovery state');
      }

      AppLogger.info('Skipping recovery');

      // Cancel recovery timer
      _recoveryTimer?.cancel();

      // Move to next exercise
      await _moveToNextExercise(state.session, state.currentExerciseIndex);

      AppLogger.info('Recovery skipped');
    } catch (e, stackTrace) {
      AppLogger.error('Error skipping recovery', e, stackTrace);
      _updateState(
        WorkoutSessionState.error(
          message: 'Failed to skip recovery: $e',
          session: _currentState.session,
        ),
      );
      rethrow;
    }
  }

  /// Load and resume existing session
  Future<void> loadSession(String sessionId) async {
    try {
      AppLogger.info('Loading workout session: $sessionId');

      final session = await _workoutRepository.getWorkoutSession(sessionId);
      if (session == null) {
        throw Exception('Session not found: $sessionId');
      }

      // Determine current exercise index
      final currentIndex = _findCurrentExerciseIndex(session);

      // Update state based on session status
      switch (session.status) {
        case SessionStatus.inProgress:
          _updateState(
            WorkoutSessionState.active(
              session: session,
              currentExerciseIndex: currentIndex,
              isRecovering: false,
              recoveryTimeRemaining: 0,
            ),
          );
          _startSessionTimer();
          break;

        case SessionStatus.paused:
          _updateState(
            WorkoutSessionState.paused(
              session: session,
              currentExerciseIndex: currentIndex,
              wasRecovering: false,
              recoveryTimeRemaining: 0,
            ),
          );
          break;

        case SessionStatus.completed:
          _updateState(WorkoutSessionState.completed(session: session));
          break;

        case SessionStatus.abandoned:
          _updateState(WorkoutSessionState.abandoned(session: session));
          break;

        default:
          _updateState(const WorkoutSessionState.idle());
      }

      AppLogger.info('Workout session loaded: $sessionId');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error loading workout session: $sessionId',
        e,
        stackTrace,
      );
      _updateState(
        WorkoutSessionState.error(
          message: 'Failed to load session: $e',
          session: null,
        ),
      );
      rethrow;
    }
  }

  /// Dispose resources
  void dispose() {
    _sessionTimer?.cancel();
    _recoveryTimer?.cancel();
    _stateController.close();
  }

  // Private methods

  void _updateState(WorkoutSessionState newState) {
    _currentState = newState;
    _stateController.add(newState);
  }

  /// Protected method for subclasses to update state
  @protected
  void updateState(WorkoutSessionState newState) {
    _updateState(newState);
  }

  void _startSessionTimer() {
    _sessionTimer?.cancel();
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Update session duration periodically
      // This could be used for real-time UI updates
    });
  }

  Future<void> _startRecovery(WorkoutSession session, int currentIndex) async {
    // Get recovery time for current exercise (default 60 seconds)
    const recoveryTimeSeconds = 60;

    _updateState(
      WorkoutSessionState.active(
        session: session,
        currentExerciseIndex: currentIndex,
        isRecovering: true,
        recoveryTimeRemaining: recoveryTimeSeconds,
      ),
    );

    _startRecoveryTimer(recoveryTimeSeconds);
  }

  void _startRecoveryTimer(int seconds) {
    _recoveryTimer?.cancel();
    var remainingTime = seconds;

    _recoveryTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      remainingTime--;

      final state = _currentState;
      if (state is ActiveWorkoutSessionState && state.isRecovering) {
        _updateState(state.copyWith(recoveryTimeRemaining: remainingTime));

        if (remainingTime <= 0) {
          timer.cancel();
          await _moveToNextExercise(state.session, state.currentExerciseIndex);
        }
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _moveToNextExercise(
    WorkoutSession session,
    int currentIndex,
  ) async {
    final nextIndex = currentIndex + 1;

    if (nextIndex >= session.exerciseExecutions.length) {
      // All exercises completed
      await _completeSession(session);
      return;
    }

    // Start next exercise
    final nextExecution = session.exerciseExecutions[nextIndex];
    final updatedExecution = nextExecution.copyWith(
      status: ExecutionStatus.inProgress,
      startedAt: DateTime.now(),
    );

    final updatedExecutions = List<ExerciseExecution>.from(
      session.exerciseExecutions,
    );
    updatedExecutions[nextIndex] = updatedExecution;

    final updatedSession = session.copyWith(
      exerciseExecutions: updatedExecutions,
    );

    await _workoutRepository.updateWorkoutSession(updatedSession);

    _updateState(
      WorkoutSessionState.active(
        session: updatedSession,
        currentExerciseIndex: nextIndex,
        isRecovering: false,
        recoveryTimeRemaining: 0,
      ),
    );
  }

  Future<void> _skipExercise(String exerciseId, String reason) async {
    final state = _currentState;
    if (state is! ActiveWorkoutSessionState) return;

    final session = state.session;
    final currentIndex = state.currentExerciseIndex;

    // Mark exercise as skipped
    final skippedExecution = session.exerciseExecutions[currentIndex].copyWith(
      status: ExecutionStatus.skipped,
      skippedAt: DateTime.now(),
      skipReason: reason,
    );

    final updatedExecutions = List<ExerciseExecution>.from(
      session.exerciseExecutions,
    );
    updatedExecutions[currentIndex] = skippedExecution;

    final updatedSession = session.copyWith(
      exerciseExecutions: updatedExecutions,
      skippedExerciseIds: [...(session.skippedExerciseIds ?? []), exerciseId],
      completionPercentage: _calculateCompletionPercentage(updatedExecutions),
    );

    await _workoutRepository.updateWorkoutSession(updatedSession);

    // Move to next exercise
    await _moveToNextExercise(updatedSession, currentIndex);
  }

  Future<void> _completeSession(WorkoutSession session) async {
    final completionData = {
      'totalDurationSeconds':
          DateTime.now().difference(session.startedAt).inSeconds,
      'completionPercentage': session.actualCompletionPercentage,
      'totalCaloriesBurned': _calculateCaloriesBurned(session),
    };

    final completedSession = await _workoutRepository.completeWorkoutSession(
      session.id,
      completionData,
    );

    _updateState(WorkoutSessionState.completed(session: completedSession));

    // Stop timers
    _sessionTimer?.cancel();
    _recoveryTimer?.cancel();
  }

  double _calculateCompletionPercentage(List<ExerciseExecution> executions) {
    if (executions.isEmpty) return 0;

    final completedCount =
        executions.where((e) => e.status == ExecutionStatus.completed).length;

    return (completedCount / executions.length) * 100;
  }

  int _calculateCaloriesBurned(WorkoutSession session) {
    // Simple calorie calculation - in real app this would be more sophisticated
    final completedExercises =
        session.exerciseExecutions
            .where((e) => e.status == ExecutionStatus.completed)
            .length;

    return completedExercises * 10; // 10 calories per completed exercise
  }

  int _findCurrentExerciseIndex(WorkoutSession session) {
    // Find the first exercise that's not completed
    for (int i = 0; i < session.exerciseExecutions.length; i++) {
      final execution = session.exerciseExecutions[i];
      if (execution.status == ExecutionStatus.notStarted ||
          execution.status == ExecutionStatus.inProgress) {
        return i;
      }
    }

    // All exercises are completed or skipped
    return session.exerciseExecutions.length - 1;
  }
}

/// Workout session state
sealed class WorkoutSessionState {
  const WorkoutSessionState();

  WorkoutSession? get session;

  const factory WorkoutSessionState.idle() = IdleWorkoutSessionState;

  const factory WorkoutSessionState.active({
    required WorkoutSession session,
    required int currentExerciseIndex,
    required bool isRecovering,
    required int recoveryTimeRemaining,
  }) = ActiveWorkoutSessionState;

  const factory WorkoutSessionState.paused({
    required WorkoutSession session,
    required int currentExerciseIndex,
    required bool wasRecovering,
    required int recoveryTimeRemaining,
  }) = PausedWorkoutSessionState;

  const factory WorkoutSessionState.completed({
    required WorkoutSession session,
  }) = CompletedWorkoutSessionState;

  const factory WorkoutSessionState.abandoned({
    required WorkoutSession session,
  }) = AbandonedWorkoutSessionState;

  const factory WorkoutSessionState.error({
    required String message,
    required WorkoutSession? session,
  }) = ErrorWorkoutSessionState;
}

/// Idle state - no active session
class IdleWorkoutSessionState extends WorkoutSessionState {
  const IdleWorkoutSessionState();

  @override
  WorkoutSession? get session => null;
}

/// Active session state
class ActiveWorkoutSessionState extends WorkoutSessionState {
  const ActiveWorkoutSessionState({
    required this.session,
    required this.currentExerciseIndex,
    required this.isRecovering,
    required this.recoveryTimeRemaining,
  });

  @override
  final WorkoutSession session;
  final int currentExerciseIndex;
  final bool isRecovering;
  final int recoveryTimeRemaining;

  ActiveWorkoutSessionState copyWith({
    WorkoutSession? session,
    int? currentExerciseIndex,
    bool? isRecovering,
    int? recoveryTimeRemaining,
  }) {
    return ActiveWorkoutSessionState(
      session: session ?? this.session,
      currentExerciseIndex: currentExerciseIndex ?? this.currentExerciseIndex,
      isRecovering: isRecovering ?? this.isRecovering,
      recoveryTimeRemaining:
          recoveryTimeRemaining ?? this.recoveryTimeRemaining,
    );
  }
}

/// Paused session state
class PausedWorkoutSessionState extends WorkoutSessionState {
  const PausedWorkoutSessionState({
    required this.session,
    required this.currentExerciseIndex,
    required this.wasRecovering,
    required this.recoveryTimeRemaining,
  });

  @override
  final WorkoutSession session;
  final int currentExerciseIndex;
  final bool wasRecovering;
  final int recoveryTimeRemaining;
}

/// Completed session state
class CompletedWorkoutSessionState extends WorkoutSessionState {
  const CompletedWorkoutSessionState({required this.session});

  @override
  final WorkoutSession session;
}

/// Abandoned session state
class AbandonedWorkoutSessionState extends WorkoutSessionState {
  const AbandonedWorkoutSessionState({required this.session});

  @override
  final WorkoutSession session;
}

/// Error state
class ErrorWorkoutSessionState extends WorkoutSessionState {
  const ErrorWorkoutSessionState({
    required this.message,
    required this.session,
  });

  final String message;

  @override
  final WorkoutSession? session;
}

/// Alternative type for exercise alternatives
enum AlternativeType { similar, easier, harder, different }
