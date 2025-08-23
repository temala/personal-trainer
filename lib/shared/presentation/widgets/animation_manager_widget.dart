import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitness_training_app/core/utils/logger.dart';
import 'package:fitness_training_app/shared/data/services/animation_transition_service.dart';
import 'package:fitness_training_app/shared/data/services/exercise_animation_service.dart';
import 'package:fitness_training_app/shared/domain/entities/exercise.dart';
import 'package:fitness_training_app/shared/presentation/providers/exercise_providers.dart';
import 'package:fitness_training_app/shared/presentation/themes/app_theme.dart';
import 'package:fitness_training_app/shared/presentation/widgets/exercise_animation_widget.dart';

/// Comprehensive animation manager for workout sessions
class AnimationManagerWidget extends ConsumerStatefulWidget {
  const AnimationManagerWidget({
    required this.exercises,
    required this.currentExerciseIndex,
    required this.onExerciseCompleted,
    this.userId,
    this.avatarData,
    this.showTransitions = true,
    this.preloadCount = 3,
    super.key,
  });

  final List<Exercise> exercises;
  final int currentExerciseIndex;
  final void Function(Exercise exercise) onExerciseCompleted;
  final String? userId;
  final AvatarData? avatarData;
  final bool showTransitions;
  final int preloadCount;

  @override
  ConsumerState<AnimationManagerWidget> createState() =>
      _AnimationManagerWidgetState();
}

class _AnimationManagerWidgetState extends ConsumerState<AnimationManagerWidget>
    with TickerProviderStateMixin, AnimationTransitionMixin {
  late PageController _pageController;
  bool _showCelebration = false;
  CelebrationType _celebrationType = CelebrationType.exerciseComplete;

  final Map<String, ExerciseAnimationData?> _preloadedAnimations = {};
  bool _isPreloading = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.currentExerciseIndex);
    _preloadUpcomingAnimations();
  }

  @override
  void didUpdateWidget(AnimationManagerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.currentExerciseIndex != widget.currentExerciseIndex) {
      _animateToCurrentExercise();
      _preloadUpcomingAnimations();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.exercises.isEmpty) {
      return _buildEmptyState();
    }

    return Stack(
      children: [
        // Main exercise animations
        _buildExerciseAnimations(),

        // Celebration overlay
        if (_showCelebration) _buildCelebrationOverlay(),

        // Preloading indicator
        if (_isPreloading) _buildPreloadingIndicator(),
      ],
    );
  }

  Widget _buildExerciseAnimations() {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: _onPageChanged,
      itemCount: widget.exercises.length,
      itemBuilder: (context, index) {
        final exercise = widget.exercises[index];

        return Container(
          key: ValueKey('exercise_${exercise.id}'),
          child:
              widget.showTransitions
                  ? createTransition(
                    child: _buildExerciseAnimationPage(exercise, index),
                    key: exercise.id,
                  )
                  : _buildExerciseAnimationPage(exercise, index),
        );
      },
    );
  }

  Widget _buildExerciseAnimationPage(Exercise exercise, int index) {
    return Column(
      children: [
        // Exercise info header
        _buildExerciseHeader(exercise, index),

        const SizedBox(height: 16),

        // Animation widget
        Expanded(
          child: ExerciseAnimationWidget(
            exercise: exercise,
            userId: widget.userId,
            avatarData: widget.avatarData,
            showControls: true,
            autoPlay: index == widget.currentExerciseIndex,
            onAnimationCompleted: () => _onAnimationCompleted(exercise),
          ),
        ),

        const SizedBox(height: 16),

        // Exercise controls
        _buildExerciseControls(exercise),
      ],
    );
  }

  Widget _buildExerciseHeader(Exercise exercise, int index) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Progress indicator
          Row(
            children: [
              Text(
                'Exercise ${index + 1} of ${widget.exercises.length}',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
              ),
              const Spacer(),
              Text(
                '${((index + 1) / widget.exercises.length * 100).round()}%',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: (index + 1) / widget.exercises.length,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 16),

          // Exercise details
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getCategoryColor(exercise.category),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  exercise.category.name.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${exercise.formattedDuration} • ${exercise.difficulty.name}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getDifficultyColor(
                    exercise.difficulty,
                  ).withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  exercise.difficulty.name[0].toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _getDifficultyColor(exercise.difficulty),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseControls(Exercise exercise) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Previous exercise button
          if (widget.currentExerciseIndex > 0)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _goToPreviousExercise,
                icon: const Icon(Icons.arrow_back),
                label: const Text('Previous'),
              ),
            ),

          if (widget.currentExerciseIndex > 0) const SizedBox(width: 12),

          // Complete exercise button
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: () => _completeExercise(exercise),
              icon: const Icon(Icons.check),
              label: const Text('Complete Exercise'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Next exercise button
          if (widget.currentExerciseIndex < widget.exercises.length - 1)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _goToNextExercise,
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Next'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCelebrationOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.7),
        child: Center(
          child: CelebrationAnimationWidget(
            type: _celebrationType,
            onAnimationCompleted: _hideCelebration,
          ),
        ),
      ),
    );
  }

  Widget _buildPreloadingIndicator() {
    return Positioned(
      top: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Loading animations...',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.fitness_center, size: 64, color: AppTheme.textSecondary),
          const SizedBox(height: 16),
          Text(
            'No Exercises Available',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Please add exercises to your workout plan.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _onPageChanged(int index) {
    // Update current exercise if needed
    // This would typically be handled by the parent widget
  }

  void _onAnimationCompleted(Exercise exercise) {
    // Animation completed, could trigger auto-advance or other actions
    AppLogger.info('Animation completed for ${exercise.name}');
  }

  void _completeExercise(Exercise exercise) {
    _showCelebrationAnimation(CelebrationType.exerciseComplete);
    widget.onExerciseCompleted(exercise);
  }

  void _goToPreviousExercise() {
    if (widget.currentExerciseIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToNextExercise() {
    if (widget.currentExerciseIndex < widget.exercises.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _animateToCurrentExercise() {
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        widget.currentExerciseIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _showCelebrationAnimation(CelebrationType type) {
    setState(() {
      _celebrationType = type;
      _showCelebration = true;
    });
  }

  void _hideCelebration() {
    setState(() {
      _showCelebration = false;
    });
  }

  Future<void> _preloadUpcomingAnimations() async {
    if (_isPreloading) return;

    setState(() {
      _isPreloading = true;
    });

    try {
      final startIndex = widget.currentExerciseIndex;
      final endIndex = (startIndex + widget.preloadCount).clamp(
        0,
        widget.exercises.length,
      );

      final exercisesToPreload =
          widget.exercises
              .sublist(startIndex, endIndex)
              .where(
                (exercise) => !_preloadedAnimations.containsKey(exercise.id),
              )
              .toList();

      if (exercisesToPreload.isNotEmpty) {
        final animationService = ref.read(exerciseAnimationServiceProvider);
        await animationService.preloadExerciseAnimations(exercisesToPreload);

        // Cache the preloaded status
        for (final exercise in exercisesToPreload) {
          _preloadedAnimations[exercise.id] = null; // Mark as preloaded
        }

        AppLogger.info(
          'Preloaded animations for ${exercisesToPreload.length} exercises',
        );
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error preloading animations', e, stackTrace);
    } finally {
      if (mounted) {
        setState(() {
          _isPreloading = false;
        });
      }
    }
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

  Color _getDifficultyColor(DifficultyLevel difficulty) {
    switch (difficulty) {
      case DifficultyLevel.beginner:
        return Colors.green;
      case DifficultyLevel.intermediate:
        return Colors.orange;
      case DifficultyLevel.advanced:
        return Colors.red;
      case DifficultyLevel.expert:
        return Colors.purple;
    }
  }
}
