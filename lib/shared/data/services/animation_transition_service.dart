import 'dart:async';

import 'package:flutter/material.dart';

import 'package:fitness_training_app/core/utils/logger.dart';
import 'package:fitness_training_app/shared/data/services/exercise_animation_service.dart';
import 'package:fitness_training_app/shared/domain/entities/exercise.dart';

/// Service for managing smooth animation transitions and preloading
class AnimationTransitionService {
  AnimationTransitionService({
    required ExerciseAnimationService animationService,
  }) : _animationService = animationService;

  final ExerciseAnimationService _animationService;
  final Map<String, ExerciseAnimationData> _preloadedAnimations = {};
  final Map<String, Completer<ExerciseAnimationData?>> _loadingAnimations = {};

  /// Preload animations for a list of exercises
  Future<void> preloadAnimations(List<Exercise> exercises) async {
    try {
      AppLogger.info('Preloading animations for ${exercises.length} exercises');

      final preloadTasks = exercises.map((exercise) async {
        try {
          final animationData = await _animationService.getExerciseAnimation(
            exercise.id,
          );
          if (animationData != null) {
            _preloadedAnimations[exercise.id] = animationData;
            AppLogger.debug('Preloaded animation for ${exercise.name}');
          }
        } catch (e) {
          AppLogger.warning(
            'Failed to preload animation for ${exercise.name}: $e',
          );
        }
      });

      await Future.wait(preloadTasks);
      AppLogger.info(
        'Completed preloading ${_preloadedAnimations.length} animations',
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error preloading animations', e, stackTrace);
    }
  }

  /// Get animation data with caching and preloading
  Future<ExerciseAnimationData?> getAnimationData(String exerciseId) async {
    // Return preloaded animation if available
    if (_preloadedAnimations.containsKey(exerciseId)) {
      return _preloadedAnimations[exerciseId];
    }

    // Check if already loading
    if (_loadingAnimations.containsKey(exerciseId)) {
      return _loadingAnimations[exerciseId]!.future;
    }

    // Start loading
    final completer = Completer<ExerciseAnimationData?>();
    _loadingAnimations[exerciseId] = completer;

    try {
      final animationData = await _animationService.getExerciseAnimation(
        exerciseId,
      );
      if (animationData != null) {
        _preloadedAnimations[exerciseId] = animationData;
      }
      completer.complete(animationData);
    } catch (e) {
      completer.complete(null);
    } finally {
      _loadingAnimations.remove(exerciseId);
    }

    return completer.future;
  }

  /// Create smooth transition between exercises
  Widget createTransition({
    required Widget child,
    required String exerciseId,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return AnimatedSwitcher(
      duration: duration,
      transitionBuilder: (child, animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          ),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      child: Container(key: ValueKey(exerciseId), child: child),
    );
  }

  /// Create celebration transition
  Widget createCelebrationTransition({
    required Widget child,
    required CelebrationType type,
    Duration duration = const Duration(milliseconds: 800),
  }) {
    return AnimatedSwitcher(
      duration: duration,
      transitionBuilder: (child, animation) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.elasticOut),
          ),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      child: Container(key: ValueKey(type.name), child: child),
    );
  }

  /// Clear preloaded animations to free memory
  void clearPreloadedAnimations() {
    _preloadedAnimations.clear();
    AppLogger.info('Cleared preloaded animations');
  }

  /// Get cache status
  Map<String, dynamic> getCacheStatus() {
    return {
      'preloadedCount': _preloadedAnimations.length,
      'loadingCount': _loadingAnimations.length,
      'preloadedExercises': _preloadedAnimations.keys.toList(),
    };
  }
}

/// Widget for managing animation transitions in workout sessions
class WorkoutAnimationManager extends StatefulWidget {
  const WorkoutAnimationManager({
    required this.exercises,
    required this.currentExerciseIndex,
    required this.onAnimationReady,
    this.preloadCount = 3,
    super.key,
  });

  final List<Exercise> exercises;
  final int currentExerciseIndex;
  final void Function(String exerciseId, ExerciseAnimationData? animationData)
  onAnimationReady;
  final int preloadCount;

  @override
  State<WorkoutAnimationManager> createState() =>
      _WorkoutAnimationManagerState();
}

class _WorkoutAnimationManagerState extends State<WorkoutAnimationManager> {
  late AnimationTransitionService _transitionService;
  final Set<String> _preloadedExercises = {};

  @override
  void initState() {
    super.initState();
    _transitionService = AnimationTransitionService(
      animationService: ExerciseAnimationService(),
    );
    _preloadUpcomingAnimations();
  }

  @override
  void didUpdateWidget(WorkoutAnimationManager oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentExerciseIndex != widget.currentExerciseIndex) {
      _preloadUpcomingAnimations();
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink(); // This is a manager widget, no UI
  }

  Future<void> _preloadUpcomingAnimations() async {
    final startIndex = widget.currentExerciseIndex;
    final endIndex = (startIndex + widget.preloadCount).clamp(
      0,
      widget.exercises.length,
    );

    final exercisesToPreload =
        widget.exercises
            .sublist(startIndex, endIndex)
            .where((exercise) => !_preloadedExercises.contains(exercise.id))
            .toList();

    if (exercisesToPreload.isEmpty) return;

    try {
      await _transitionService.preloadAnimations(exercisesToPreload);

      // Notify about ready animations
      for (final exercise in exercisesToPreload) {
        final animationData = await _transitionService.getAnimationData(
          exercise.id,
        );
        widget.onAnimationReady(exercise.id, animationData);
        _preloadedExercises.add(exercise.id);
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error preloading upcoming animations', e, stackTrace);
    }
  }
}

/// Custom page route for smooth exercise transitions
class ExerciseTransitionRoute<T> extends PageRouteBuilder<T> {
  ExerciseTransitionRoute({
    required this.child,
    required this.exerciseId,
    this.transitionDuration = const Duration(milliseconds: 300),
  }) : super(
         pageBuilder: (context, animation, secondaryAnimation) => child,
         transitionDuration: transitionDuration,
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           return SlideTransition(
             position: Tween<Offset>(
               begin: const Offset(1.0, 0.0),
               end: Offset.zero,
             ).animate(
               CurvedAnimation(parent: animation, curve: Curves.easeInOut),
             ),
             child: FadeTransition(opacity: animation, child: child),
           );
         },
       );

  final Widget child;
  final String exerciseId;
  final Duration transitionDuration;
}

/// Animation controller for managing multiple animation states
class MultiAnimationController {
  MultiAnimationController({required TickerProvider vsync}) : _vsync = vsync;

  final TickerProvider _vsync;
  final Map<String, AnimationController> _controllers = {};
  final Map<String, Animation<double>> _animations = {};

  /// Create or get animation controller for a specific key
  AnimationController getController(
    String key, {
    Duration duration = const Duration(milliseconds: 300),
  }) {
    if (!_controllers.containsKey(key)) {
      _controllers[key] = AnimationController(
        duration: duration,
        vsync: _vsync,
      );
    }
    return _controllers[key]!;
  }

  /// Create or get animation for a specific key
  Animation<double> getAnimation(
    String key, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    if (!_animations.containsKey(key)) {
      final controller = getController(key, duration: duration);
      _animations[key] = CurvedAnimation(parent: controller, curve: curve);
    }
    return _animations[key]!;
  }

  /// Start animation for a specific key
  void startAnimation(String key) {
    _controllers[key]?.forward();
  }

  /// Stop animation for a specific key
  void stopAnimation(String key) {
    _controllers[key]?.stop();
  }

  /// Reset animation for a specific key
  void resetAnimation(String key) {
    _controllers[key]?.reset();
  }

  /// Dispose all controllers
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
    _animations.clear();
  }
}

/// Mixin for widgets that need animation transition capabilities
mixin AnimationTransitionMixin<T extends StatefulWidget>
    on State<T>, TickerProviderStateMixin<T> {
  late MultiAnimationController _multiController;
  late AnimationTransitionService _transitionService;

  @override
  void initState() {
    super.initState();
    _multiController = MultiAnimationController(vsync: this);
    _transitionService = AnimationTransitionService(
      animationService: ExerciseAnimationService(),
    );
  }

  @override
  void dispose() {
    _multiController.dispose();
    super.dispose();
  }

  /// Get animation controller for a specific key
  AnimationController getAnimationController(
    String key, {
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return _multiController.getController(key, duration: duration);
  }

  /// Get animation for a specific key
  Animation<double> getAnimation(
    String key, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    return _multiController.getAnimation(key, duration: duration, curve: curve);
  }

  /// Create smooth transition widget
  Widget createTransition({
    required Widget child,
    required String key,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return _transitionService.createTransition(
      child: child,
      exerciseId: key,
      duration: duration,
    );
  }

  /// Start animation
  void startAnimation(String key) {
    _multiController.startAnimation(key);
  }

  /// Stop animation
  void stopAnimation(String key) {
    _multiController.stopAnimation(key);
  }

  /// Reset animation
  void resetAnimation(String key) {
    _multiController.resetAnimation(key);
  }
}
