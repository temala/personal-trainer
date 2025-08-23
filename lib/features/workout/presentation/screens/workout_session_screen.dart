import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitness_training_app/shared/data/services/workout_session_manager.dart';
import 'package:fitness_training_app/shared/domain/entities/exercise.dart';
import 'package:fitness_training_app/shared/domain/entities/workout_session.dart';
import 'package:fitness_training_app/shared/presentation/providers/exercise_providers.dart';
import 'package:fitness_training_app/shared/presentation/providers/workout_session_providers.dart';
import 'package:fitness_training_app/shared/presentation/widgets/custom_button.dart';
import 'package:fitness_training_app/shared/presentation/widgets/exercise_demonstration_widget.dart';
import 'package:fitness_training_app/shared/presentation/widgets/loading_overlay.dart';

/// Main workout session screen
class WorkoutSessionScreen extends ConsumerStatefulWidget {
  const WorkoutSessionScreen({super.key});

  @override
  ConsumerState<WorkoutSessionScreen> createState() =>
      _WorkoutSessionScreenState();
}

class _WorkoutSessionScreenState extends ConsumerState<WorkoutSessionScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final sessionState = ref.watch(workoutSessionStateProvider);
    final sessionActions = ref.watch(workoutSessionActionsProvider);

    return Scaffold(
      body: Stack(
        children: [
          sessionState.when(
            data:
                (state) => _buildSessionContent(context, state, sessionActions),
            loading: () => const Center(child: CircularProgressIndicator()),
            error:
                (error, stackTrace) =>
                    _buildErrorContent(context, error.toString()),
          ),
          if (_isLoading)
            const LoadingOverlay(child: SizedBox.shrink(), isLoading: true),
        ],
      ),
    );
  }

  Widget _buildSessionContent(
    BuildContext context,
    WorkoutSessionState state,
    NullableWorkoutSessionActions actions,
  ) {
    switch (state) {
      case IdleWorkoutSessionState():
        return _buildIdleContent(context);

      case ActiveWorkoutSessionState():
        return _buildActiveSessionContent(context, state, actions);

      case PausedWorkoutSessionState():
        return _buildPausedSessionContent(context, state, actions);

      case CompletedWorkoutSessionState():
        return _buildCompletedSessionContent(context, state);

      case AbandonedWorkoutSessionState():
        return _buildAbandonedSessionContent(context, state);

      case ErrorWorkoutSessionState():
        return _buildErrorContent(context, state.message);
    }
  }

  Widget _buildIdleContent(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.fitness_center, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No active workout session',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            'Start a workout to begin exercising',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveSessionContent(
    BuildContext context,
    ActiveWorkoutSessionState state,
    NullableWorkoutSessionActions actions,
  ) {
    final session = state.session;
    final currentIndex = state.currentExerciseIndex;

    if (currentIndex >= session.exerciseExecutions.length) {
      return _buildErrorContent(context, 'Invalid exercise index');
    }

    final currentExecution = session.exerciseExecutions[currentIndex];

    return SafeArea(
      child: Column(
        children: [
          // Header with progress
          _buildSessionHeader(context, state, actions),

          // Main content area
          Expanded(
            child:
                state.isRecovering
                    ? _buildRecoveryContent(context, state, actions)
                    : _buildExerciseContent(
                      context,
                      currentExecution,
                      actions,
                      state,
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildPausedSessionContent(
    BuildContext context,
    PausedWorkoutSessionState state,
    NullableWorkoutSessionActions actions,
  ) {
    return SafeArea(
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              border: Border(bottom: BorderSide(color: Colors.orange.shade300)),
            ),
            child: Row(
              children: [
                Icon(Icons.pause_circle, color: Colors.orange.shade700),
                const SizedBox(width: 8),
                Text(
                  'Workout Paused',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade700,
                  ),
                ),
              ],
            ),
          ),

          // Paused content
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.pause_circle_outline,
                    size: 80,
                    color: Colors.orange.shade400,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Your workout is paused',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Exercise ${state.currentExerciseIndex + 1} of ${state.session.exerciseExecutions.length}',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomButton(
                        text: 'Resume',
                        onPressed: () => _handleResumeSession(actions),
                        color: Colors.green,
                      ),
                      CustomButton(
                        text: 'End Workout',
                        onPressed: () => _handleEndSession(actions),
                        color: Colors.red,
                        variant: ButtonVariant.outlined,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedSessionContent(
    BuildContext context,
    CompletedWorkoutSessionState state,
  ) {
    final session = state.session;

    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.celebration, size: 80, color: Colors.green.shade400),
            const SizedBox(height: 24),
            const Text(
              'Workout Complete!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Great job! You completed ${session.completedExercisesCount} exercises',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Duration: ${session.formattedDuration}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: 'Done',
              onPressed: () => Navigator.of(context).pop(),
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAbandonedSessionContent(
    BuildContext context,
    AbandonedWorkoutSessionState state,
  ) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cancel_outlined,
              size: 80,
              color: Colors.orange.shade400,
            ),
            const SizedBox(height: 24),
            const Text(
              'Workout Ended',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Your workout session was ended early',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: 'Done',
              onPressed: () => Navigator.of(context).pop(),
              color: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorContent(BuildContext context, String message) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: Colors.red.shade400),
            const SizedBox(height: 24),
            const Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                message,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: 'Go Back',
              onPressed: () => Navigator.of(context).pop(),
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionHeader(
    BuildContext context,
    ActiveWorkoutSessionState state,
    NullableWorkoutSessionActions actions,
  ) {
    final progress = ref.watch(sessionProgressProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
          ),
        ),
      ),
      child: Column(
        children: [
          // Top row with pause and progress
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => _handlePauseSession(actions),
                icon: const Icon(Icons.pause),
                iconSize: 28,
              ),
              if (progress != null) ...[
                Text(
                  progress.progressText,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
              IconButton(
                onPressed: () => _showEndSessionDialog(context, actions),
                icon: const Icon(Icons.close),
                iconSize: 28,
              ),
            ],
          ),

          // Progress bar
          if (progress != null) ...[
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress.completionPercentage / 100,
              color: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              progress.formattedCompletionPercentage,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildExerciseContent(
    BuildContext context,
    ExerciseExecution execution,
    NullableWorkoutSessionActions actions,
    ActiveWorkoutSessionState state,
  ) {
    return Column(
      children: [
        // Exercise demonstration
        Expanded(
          flex: 3,
          child: Consumer(
            builder: (context, ref, child) {
              final exerciseAsync = ref.watch(
                exerciseByIdProvider(execution.exerciseId),
              );
              return exerciseAsync.when(
                data: (exercise) {
                  if (exercise == null) {
                    return const Center(child: Text('Exercise not found'));
                  }
                  return ExerciseDemonstrationWidget(
                    exercise: exercise,
                    userId: state.session.userId,
                    sessionId: state.session.id,
                    onExerciseCompleted:
                        () => _handleCompleteExercise(
                          execution.exerciseId,
                          actions,
                        ),
                    onAlternativeRequested: (alternative, direction) {
                      if (alternative != null) {
                        _handleRequestAlternative(
                          execution.exerciseId,
                          AlternativeType.similar,
                          actions,
                        );
                      }
                    },
                    onExerciseSkipped:
                        () => _handleSkipExercise(
                          execution.exerciseId,
                          'Skipped by user',
                          actions,
                        ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error:
                    (error, stackTrace) =>
                        Center(child: Text('Error loading exercise: $error')),
              );
            },
          ),
        ),

        // Exercise info and controls
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Exercise name
                Text(
                  execution.exerciseName ?? 'Exercise',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                // Sets info
                Text(
                  '${execution.setExecutions.length} sets',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),

                const Spacer(),

                // Complete button
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: 'Complete Exercise',
                    onPressed:
                        () => _handleCompleteExercise(
                          execution.exerciseId,
                          actions,
                        ),
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecoveryContent(
    BuildContext context,
    ActiveWorkoutSessionState state,
    NullableWorkoutSessionActions actions,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Recovery animation/icon
          Icon(Icons.timer, size: 80, color: Colors.blue.shade400),

          const SizedBox(height: 24),

          const Text(
            'Recovery Time',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          // Countdown timer
          Text(
            _formatRecoveryTime(state.recoveryTimeRemaining),
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade600,
            ),
          ),

          const SizedBox(height: 32),

          // Skip recovery button
          CustomButton(
            text: 'Skip Recovery',
            onPressed: () => _handleSkipRecovery(actions),
            color: Colors.blue,
            variant: ButtonVariant.outlined,
          ),
        ],
      ),
    );
  }

  String _formatRecoveryTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    if (minutes > 0) {
      return '${minutes}:${remainingSeconds.toString().padLeft(2, '0')}';
    }
    return '${seconds}s';
  }

  void _showEndSessionDialog(
    BuildContext context,
    NullableWorkoutSessionActions actions,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('End Workout'),
            content: const Text(
              'Are you sure you want to end this workout session?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _handleEndSession(actions);
                },
                child: const Text('End Workout'),
              ),
            ],
          ),
    );
  }

  Future<void> _handleCompleteExercise(
    String exerciseId,
    NullableWorkoutSessionActions actions,
  ) async {
    setState(() => _isLoading = true);
    try {
      await actions.completeExercise(exerciseId);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error completing exercise: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleRequestAlternative(
    String exerciseId,
    AlternativeType type,
    NullableWorkoutSessionActions actions,
  ) async {
    setState(() => _isLoading = true);
    try {
      await actions.requestAlternative(exerciseId, type);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error getting alternative: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleSkipExercise(
    String exerciseId,
    String reason,
    NullableWorkoutSessionActions actions,
  ) async {
    setState(() => _isLoading = true);
    try {
      await actions.skipExercise(exerciseId, reason);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error skipping exercise: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handlePauseSession(
    NullableWorkoutSessionActions actions,
  ) async {
    setState(() => _isLoading = true);
    try {
      await actions.pauseSession();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error pausing session: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleResumeSession(
    NullableWorkoutSessionActions actions,
  ) async {
    setState(() => _isLoading = true);
    try {
      await actions.resumeSession();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error resuming session: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleEndSession(NullableWorkoutSessionActions actions) async {
    setState(() => _isLoading = true);
    try {
      await actions.endSession();
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error ending session: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleSkipRecovery(
    NullableWorkoutSessionActions actions,
  ) async {
    setState(() => _isLoading = true);
    try {
      await actions.skipRecovery();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error skipping recovery: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
