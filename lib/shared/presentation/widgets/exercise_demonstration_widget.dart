import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import 'package:fitness_training_app/core/utils/logger.dart';
import 'package:fitness_training_app/shared/data/services/exercise_alternative_service.dart';
import 'package:fitness_training_app/shared/data/services/exercise_animation_service.dart';
import 'package:fitness_training_app/shared/domain/entities/exercise.dart';
import 'package:fitness_training_app/shared/presentation/providers/exercise_providers.dart';
import 'package:fitness_training_app/shared/presentation/themes/app_theme.dart';

/// Widget for demonstrating exercises with swipe gesture support
class ExerciseDemonstrationWidget extends ConsumerStatefulWidget {
  const ExerciseDemonstrationWidget({
    required this.exercise,
    required this.userId,
    required this.sessionId,
    this.onExerciseCompleted,
    this.onAlternativeRequested,
    this.onExerciseSkipped,
    super.key,
  });

  final Exercise exercise;
  final String userId;
  final String sessionId;
  final VoidCallback? onExerciseCompleted;
  final void Function(Exercise? alternative, SwipeDirection direction)?
  onAlternativeRequested;
  final VoidCallback? onExerciseSkipped;

  @override
  ConsumerState<ExerciseDemonstrationWidget> createState() =>
      _ExerciseDemonstrationWidgetState();
}

class _ExerciseDemonstrationWidgetState
    extends ConsumerState<ExerciseDemonstrationWidget>
    with TickerProviderStateMixin {
  late AnimationController _swipeAnimationController;
  late Animation<Offset> _swipeAnimation;

  bool _isProcessingSwipe = false;

  @override
  void initState() {
    super.initState();
    _swipeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _swipeAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _swipeAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _swipeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animationAsync = ref.watch(
      exerciseAnimationProvider(widget.exercise.id),
    );

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: AppTheme.cardGradient,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Exercise header
            _buildExerciseHeader(),
            const SizedBox(height: 16),

            // Animation area with swipe detection
            Expanded(child: _buildAnimationArea(animationAsync)),

            const SizedBox(height: 16),

            // Exercise instructions
            _buildInstructions(),

            const SizedBox(height: 16),

            // Swipe hints
            _buildSwipeHints(),

            const SizedBox(height: 16),

            // Action buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _getCategoryColor(widget.exercise.category),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            widget.exercise.category.name.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
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
                widget.exercise.name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.exercise.formattedDuration,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getDifficultyColor(widget.exercise.difficulty),
            shape: BoxShape.circle,
          ),
          child: Text(
            widget.exercise.difficulty.name[0].toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnimationArea(
    AsyncValue<ExerciseAnimationData?> animationAsync,
  ) {
    return GestureDetector(
      onPanUpdate: _handlePanUpdate,
      onPanEnd: _handlePanEnd,
      child: AnimatedBuilder(
        animation: _swipeAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: _swipeAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[100],
              ),
              child: animationAsync.when(
                data: (animationData) {
                  if (animationData != null) {
                    return _buildLottieAnimation(animationData);
                  }
                  return _buildPlaceholderAnimation();
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) {
                  AppLogger.error('Error loading animation', error, stack);
                  return _buildPlaceholderAnimation();
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLottieAnimation(ExerciseAnimationData animationData) {
    try {
      return Lottie.asset(
        'assets/animations/default_exercise.json', // Fallback to default
        fit: BoxFit.contain,
        repeat: animationData.isLooping,
        errorBuilder: (context, error, stackTrace) {
          AppLogger.warning('Failed to load Lottie animation: $error');
          return _buildPlaceholderAnimation();
        },
      );
    } catch (e) {
      AppLogger.warning('Error creating Lottie animation: $e');
      return _buildPlaceholderAnimation();
    }
  }

  Widget _buildPlaceholderAnimation() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor.withValues(alpha: 0.1),
            AppTheme.secondaryColor.withValues(alpha: 0.1),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.fitness_center,
            size: 80,
            color: AppTheme.primaryColor.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Exercise Animation',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructions() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Instructions',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...widget.exercise.instructions.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${entry.key + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSwipeHints() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            'Swipe Gestures',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildSwipeHint(
                  '← Don\'t like',
                  'Get similar exercise',
                  Icons.thumb_down,
                ),
              ),
              Expanded(
                child: _buildSwipeHint(
                  'Can\'t do →',
                  'Get easier exercise',
                  Icons.accessibility_new,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildSwipeHint(
                  '↑ Too easy',
                  'Get harder exercise',
                  Icons.trending_up,
                ),
              ),
              Expanded(
                child: _buildSwipeHint(
                  '↓ No equipment',
                  'Get bodyweight exercise',
                  Icons.home,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSwipeHint(String gesture, String description, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          Icon(icon, size: 16, color: AppTheme.primaryColor),
          const SizedBox(height: 4),
          Text(
            gesture,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(
            description,
            style: const TextStyle(fontSize: 8),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed:
                _isProcessingSwipe
                    ? null
                    : () => widget.onExerciseSkipped?.call(),
            icon: const Icon(Icons.skip_next),
            label: const Text('Skip'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[300],
              foregroundColor: Colors.grey[700],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed:
                _isProcessingSwipe
                    ? null
                    : () => widget.onExerciseCompleted?.call(),
            icon: const Icon(Icons.check),
            label: const Text('Complete'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    if (_isProcessingSwipe) return;

    final delta = details.delta;
    final sensitivity = 2.0;

    setState(() {
      _swipeAnimation = Tween<Offset>(
        begin: Offset.zero,
        end: Offset(delta.dx * sensitivity, delta.dy * sensitivity),
      ).animate(_swipeAnimationController);
    });
  }

  void _handlePanEnd(DragEndDetails details) {
    if (_isProcessingSwipe) return;

    final velocity = details.velocity.pixelsPerSecond;
    const threshold = 500.0;

    SwipeDirection? direction;

    if (velocity.dx.abs() > velocity.dy.abs()) {
      // Horizontal swipe
      if (velocity.dx > threshold) {
        direction = SwipeDirection.right; // Can't do now
      } else if (velocity.dx < -threshold) {
        direction = SwipeDirection.left; // Don't like
      }
    } else {
      // Vertical swipe
      if (velocity.dy > threshold) {
        direction = SwipeDirection.down; // No equipment
      } else if (velocity.dy < -threshold) {
        direction = SwipeDirection.up; // Want harder
      }
    }

    // Reset animation
    _swipeAnimationController.reset();
    setState(() {
      _swipeAnimation = Tween<Offset>(
        begin: Offset.zero,
        end: Offset.zero,
      ).animate(_swipeAnimationController);
    });

    if (direction != null) {
      _handleSwipe(direction);
    }
  }

  Future<void> _handleSwipe(SwipeDirection direction) async {
    if (_isProcessingSwipe) return;

    setState(() {
      _isProcessingSwipe = true;
    });

    try {
      // Show loading indicator
      _showSwipeProcessingDialog(direction);

      // Request alternative through the service
      final alternativeService = ref.read(exerciseAlternativeServiceProvider);
      final result = await alternativeService.handleExerciseSwipe(
        userId: widget.userId,
        exerciseId: widget.exercise.id,
        direction: direction,
        sessionId: widget.sessionId,
      );

      // Hide loading dialog
      if (mounted) {
        Navigator.of(context).pop();
      }

      // Notify parent about the alternative
      widget.onAlternativeRequested?.call(result.alternative, direction);

      if (result.alternative == null) {
        _showNoAlternativeDialog(direction);
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error handling swipe gesture', e, stackTrace);

      if (mounted) {
        Navigator.of(context).pop();
        _showErrorDialog();
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessingSwipe = false;
        });
      }
    }
  }

  void _showSwipeProcessingDialog(SwipeDirection direction) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  _getSwipeProcessingMessage(direction),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
    );
  }

  void _showNoAlternativeDialog(SwipeDirection direction) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('No Alternative Found'),
            content: Text(_getNoAlternativeMessage(direction)),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text(
              'Sorry, we couldn\'t find an alternative exercise right now. Please try again or continue with the current exercise.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  String _getSwipeProcessingMessage(SwipeDirection direction) {
    switch (direction) {
      case SwipeDirection.left:
        return 'Finding a similar exercise you might prefer...';
      case SwipeDirection.right:
        return 'Finding an easier exercise you can do...';
      case SwipeDirection.up:
        return 'Finding a more challenging exercise...';
      case SwipeDirection.down:
        return 'Finding an exercise without equipment...';
    }
  }

  String _getNoAlternativeMessage(SwipeDirection direction) {
    switch (direction) {
      case SwipeDirection.left:
        return 'We couldn\'t find a similar exercise right now. You can skip this exercise or try to complete it.';
      case SwipeDirection.right:
        return 'We couldn\'t find an easier alternative. You can skip this exercise or try to complete it.';
      case SwipeDirection.up:
        return 'We couldn\'t find a more challenging exercise. You can skip this exercise or try to complete it.';
      case SwipeDirection.down:
        return 'We couldn\'t find an equipment-free alternative. You can skip this exercise or try to complete it.';
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
