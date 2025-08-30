import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import 'package:fitness_training_app/shared/data/services/workout_session_manager.dart';
import 'package:fitness_training_app/shared/domain/entities/exercise.dart';
import 'package:fitness_training_app/shared/domain/entities/workout_session.dart';
import 'package:fitness_training_app/shared/presentation/providers/exercise_providers.dart';
import 'package:fitness_training_app/shared/presentation/providers/workout_session_providers.dart';
import 'package:fitness_training_app/shared/presentation/widgets/custom_button.dart';
import 'package:fitness_training_app/shared/presentation/widgets/loading_overlay.dart';

/// Main workout session screen
class WorkoutSessionScreen extends ConsumerStatefulWidget {
  const WorkoutSessionScreen({super.key});

  static const routeName = '/workout-session';

  @override
  ConsumerState<WorkoutSessionScreen> createState() =>
      _WorkoutSessionScreenState();
}

class _WorkoutSessionScreenState extends ConsumerState<WorkoutSessionScreen> {
  bool _isLoading = false;
  late CardSwiperController _cardController;

  @override
  void initState() {
    super.initState();
    _cardController = CardSwiperController();
  }

  @override
  void dispose() {
    _cardController.dispose();
    super.dispose();
  }

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
            const LoadingOverlay(isLoading: true, child: SizedBox.shrink()),
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
        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
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
    final session = state.session;
    final exercises = session.exerciseExecutions;
    final currentIndex = state.currentExerciseIndex;

    return Consumer(
      builder: (context, ref, child) {
        return Column(
          children: [
            // Fullscreen card swiper for exercises
            Expanded(
              child: CardSwiper(
                controller: _cardController,
                cardsCount: exercises.length,
                initialIndex: currentIndex,
                numberOfCardsDisplayed: 1, // Only show current card
                onSwipe:
                    (previousIndex, currentIndex, direction) =>
                        _handleCardSwipe(
                          previousIndex,
                          currentIndex,
                          direction,
                          exercises,
                          actions,
                        ),
                onUndo: _handleCardUndo,
                cardBuilder:
                    (
                      context,
                      index,
                      horizontalThresholdPercentage,
                      verticalThresholdPercentage,
                    ) => _buildSwipeableExerciseCard(
                      context,
                      exercises[index],
                      ref,
                      index == state.currentExerciseIndex,
                      horizontalThresholdPercentage.toDouble(),
                      verticalThresholdPercentage.toDouble(),
                    ),
                allowedSwipeDirection: const AllowedSwipeDirection.all(),
                threshold: 50,
                maxAngle: 30,
                scale: 1.0, // No scaling for fullscreen
                isLoop: false,
              ),
            ),

            // Bottom action area
            Transform.translate(
              offset: const Offset(0, -16),
              child: Container(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Action buttons row
                    Row(
                      children: [
                        // Undo button
                        Expanded(
                          child: CustomButton(
                            text: 'Undo',
                            onPressed: () => _cardController.undo(),
                            color: Colors.orange,
                            variant: ButtonVariant.outlined,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Complete button
                        Expanded(
                          flex: 2,
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
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSwipeableExerciseCard(
    BuildContext context,
    ExerciseExecution execution,
    WidgetRef ref,
    bool isActive,
    double horizontalThresholdPercentage,
    double verticalThresholdPercentage,
  ) {
    final exerciseAsync = ref.watch(exerciseByIdProvider(execution.exerciseId));
    final sessionState = ref.watch(workoutSessionStateProvider);

    // Get current index and total count for page number
    int currentIndex = 0;
    int totalCount = 1;
    if (sessionState.hasValue &&
        sessionState.value is ActiveWorkoutSessionState) {
      final state = sessionState.value as ActiveWorkoutSessionState;
      currentIndex = state.currentExerciseIndex;
      totalCount = state.session.exerciseExecutions.length;
    }

    return Stack(
      children: [
        // Main exercise card - Enlarged with margin
        Container(
          margin: const EdgeInsets.fromLTRB(8, 2, 8, 0),
          child: Card(
            elevation: isActive ? 12 : 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blue.shade50, Colors.purple.shade50],
                ),
              ),
              child: exerciseAsync.when(
                data: (exercise) {
                  if (exercise == null) {
                    return const Center(
                      child: Text(
                        'Exercise not found',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    );
                  }
                  return _buildExerciseCardContent(
                    exercise,
                    ref,
                    execution,
                    currentIndex + 1,
                    totalCount,
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error:
                    (error, stackTrace) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error loading exercise',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.red.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
              ),
            ),
          ),
        ),

        // Swipe direction indicators (on top of card)
        _buildSwipeIndicators(
          horizontalThresholdPercentage,
          verticalThresholdPercentage,
        ),
      ],
    );
  }

  Widget _buildSwipeIndicators(
    double horizontalThresholdPercentage,
    double verticalThresholdPercentage,
  ) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
        child: Stack(
          children: [
            // Stamp-style swipe labels that appear in center of card
            // Only show one stamp at a time based on dominant swipe direction

            // Determine dominant swipe direction
            ...() {
              final horizontalAbs = horizontalThresholdPercentage.abs();
              final verticalAbs = verticalThresholdPercentage.abs();

              // Only show stamp if one direction is clearly dominant
              if (horizontalAbs > 0.02 || verticalAbs > 0.02) {
                if (horizontalAbs > verticalAbs) {
                  // Horizontal swipe is dominant
                  if (horizontalThresholdPercentage < -0.02) {
                    // Left swipe stamp (Don't like)
                    return [
                      Positioned.fill(
                        child: Center(
                          child: Transform.rotate(
                            angle: -0.2, // Slight rotation for stamp effect
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: 0.9),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.red, width: 3),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Text(
                                'DON\'T LIKE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      horizontalThresholdPercentage < -0.3
                                          ? 24
                                          : 20,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ];
                  } else if (horizontalThresholdPercentage > 0.02) {
                    // Right swipe stamp (Can't do)
                    return [
                      Positioned.fill(
                        child: Center(
                          child: Transform.rotate(
                            angle: 0.2, // Slight rotation for stamp effect
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange.withValues(alpha: 0.9),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.orange,
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Text(
                                'CAN\'T DO',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      horizontalThresholdPercentage > 0.3
                                          ? 24
                                          : 20,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ];
                  }
                } else {
                  // Vertical swipe is dominant
                  if (verticalThresholdPercentage < -0.02) {
                    // Up swipe stamp (Too easy)
                    return [
                      Positioned.fill(
                        child: Center(
                          child: Transform.rotate(
                            angle: -0.1, // Slight rotation for stamp effect
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.9),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.green,
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Text(
                                'TOO EASY',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      verticalThresholdPercentage < -0.3
                                          ? 24
                                          : 20,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ];
                  } else if (verticalThresholdPercentage > 0.02) {
                    // Down swipe stamp (No equipment)
                    return [
                      Positioned.fill(
                        child: Center(
                          child: Transform.rotate(
                            angle: 0.1, // Slight rotation for stamp effect
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.purple.withValues(alpha: 0.9),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.purple,
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Text(
                                'NO EQUIPMENT',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      verticalThresholdPercentage > 0.3
                                          ? 22
                                          : 18,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ];
                  }
                }
              }
              return <Widget>[];
            }(),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseCardContent(
    Exercise exercise,
    WidgetRef ref,
    ExerciseExecution execution,
    int pageNumber,
    int totalPages,
  ) {
    final animationAsync = ref.watch(exerciseAnimationProvider(exercise.id));

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          // Top row with category badge and page number
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Exercise category badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: _getCategoryColor(exercise.category),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  exercise.category.name.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Page number indicator
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  '$pageNumber of $totalPages',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Exercise name
          Text(
            exercise.name,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 12),

          // Sets information
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.repeat, size: 18, color: Colors.blue.shade700),
                const SizedBox(width: 6),
                Text(
                  '${execution.setExecutions.length} Sets',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Animation area - only show if animation exists
          animationAsync.when(
            data: (animationData) {
              if (animationData != null) {
                return Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white.withValues(alpha: 0.8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: _buildExerciseAnimation(),
                  ),
                );
              }
              return const SizedBox.shrink(); // No animation, no space
            },
            loading:
                () => const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                ),
            error: (error, stackTrace) => const SizedBox.shrink(),
          ),

          // Exercise description (if no animation) - Made more compact
          if (exercise.instructions.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              constraints: const BoxConstraints(maxHeight: 70),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: SingleChildScrollView(
                child: Text(
                  exercise.instructions.first,
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildExerciseAnimation() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Lottie.asset(
        'assets/animations/default_exercise.json',
        fit: BoxFit.contain,
        repeat: true,
        errorBuilder: (context, error, stackTrace) {
          return _buildAnimationPlaceholder();
        },
      ),
    );
  }

  Widget _buildExercisePlaceholder(Exercise exercise) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            Colors.blue.withValues(alpha: 0.1),
            Colors.purple.withValues(alpha: 0.1),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getExerciseIcon(exercise.category),
            size: 100,
            color: Colors.blue.shade400,
          ),
          const SizedBox(height: 20),
          Text(
            exercise.formattedDuration,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimationPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey.shade100,
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.fitness_center, size: 80, color: Colors.grey),
          SizedBox(height: 20),
          Text(
            'Exercise Animation',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  bool _handleCardSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
    List<ExerciseExecution> exercises,
    NullableWorkoutSessionActions actions,
  ) {
    if (previousIndex >= exercises.length) return false;

    final execution = exercises[previousIndex];

    // Handle different swipe directions
    switch (direction) {
      case CardSwiperDirection.left:
        // Don't like - get similar exercise
        _handleRequestAlternative(
          execution.exerciseId,
          AlternativeType.similar,
          actions,
        );
      case CardSwiperDirection.right:
        // Can't do - get easier exercise
        _handleRequestAlternative(
          execution.exerciseId,
          AlternativeType.easier,
          actions,
        );
      case CardSwiperDirection.top:
        // Too easy - get harder exercise
        _handleRequestAlternative(
          execution.exerciseId,
          AlternativeType.harder,
          actions,
        );
      case CardSwiperDirection.bottom:
        // No equipment - get different exercise
        _handleRequestAlternative(
          execution.exerciseId,
          AlternativeType.different,
          actions,
        );
      case CardSwiperDirection.none:
        // No action needed for no direction
        break;
    }

    return true;
  }

  bool _handleCardUndo(
    int? previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    // Allow undo for all swipe actions
    return true;
  }

  Color _getCategoryColor(ExerciseCategory category) {
    switch (category) {
      case ExerciseCategory.cardio:
        return Colors.red;
      case ExerciseCategory.strength:
        return Colors.blue;
      case ExerciseCategory.flexibility:
        return Colors.green;
      case ExerciseCategory.balance:
        return Colors.orange;
      case ExerciseCategory.sports:
        return Colors.purple;
      case ExerciseCategory.rehabilitation:
        return Colors.teal;
    }
  }

  IconData _getExerciseIcon(ExerciseCategory category) {
    switch (category) {
      case ExerciseCategory.cardio:
        return Icons.directions_run;
      case ExerciseCategory.strength:
        return Icons.fitness_center;
      case ExerciseCategory.flexibility:
        return Icons.self_improvement;
      case ExerciseCategory.balance:
        return Icons.balance;
      case ExerciseCategory.sports:
        return Icons.sports_gymnastics;
      case ExerciseCategory.rehabilitation:
        return Icons.healing;
    }
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
      return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
    }
    return '${seconds}s';
  }

  void _showEndSessionDialog(
    BuildContext context,
    NullableWorkoutSessionActions actions,
  ) {
    showDialog<void>(
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
