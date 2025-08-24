import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import 'package:fitness_training_app/core/utils/logger.dart';
import 'package:fitness_training_app/shared/data/models/offline/offline_models.dart';
import 'package:fitness_training_app/shared/data/services/exercise_animation_service.dart';
import 'package:fitness_training_app/shared/domain/entities/exercise.dart';
import 'package:fitness_training_app/shared/presentation/providers/exercise_providers.dart';
import 'package:fitness_training_app/shared/presentation/themes/app_theme.dart';

/// Widget for displaying exercise animations with caching and controls
class ExerciseAnimationWidget extends ConsumerStatefulWidget {
  const ExerciseAnimationWidget({
    required this.exercise,
    this.userId,
    this.avatarData,
    this.showControls = true,
    this.autoPlay = true,
    this.onAnimationCompleted,
    this.height,
    this.width,
    super.key,
  });

  final Exercise exercise;
  final String? userId;
  final AvatarData? avatarData;
  final bool showControls;
  final bool autoPlay;
  final VoidCallback? onAnimationCompleted;
  final double? height;
  final double? width;

  @override
  ConsumerState<ExerciseAnimationWidget> createState() =>
      _ExerciseAnimationWidgetState();
}

class _ExerciseAnimationWidgetState
    extends ConsumerState<ExerciseAnimationWidget>
    with TickerProviderStateMixin {
  AnimationController? _lottieController;
  bool _isPlaying = false;
  bool _isLooping = true;
  double _animationSpeed = 1.0;
  ExerciseAnimationData? _currentAnimationData;

  @override
  void initState() {
    super.initState();
    _isPlaying = widget.autoPlay;
  }

  @override
  void dispose() {
    _lottieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine which animation to load
    final animationProvider =
        widget.userId != null && widget.avatarData != null
            ? userAvatarAnimationProvider(
              UserAvatarAnimationParams(
                exerciseId: widget.exercise.id,
                userId: widget.userId!,
                avatarData: widget.avatarData!,
              ),
            )
            : exerciseAnimationProvider(widget.exercise.id);

    final animationAsync = ref.watch(animationProvider);

    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[50],
      ),
      child: Column(
        children: [
          Expanded(
            child: animationAsync.when(
              data: (animationData) => _buildAnimationPlayer(animationData),
              loading: () => _buildLoadingState(),
              error: (error, stack) => _buildErrorState(error),
            ),
          ),
          if (widget.showControls) _buildAnimationControls(),
        ],
      ),
    );
  }

  Widget _buildAnimationPlayer(ExerciseAnimationData? animationData) {
    if (animationData == null) {
      return _buildPlaceholder();
    }

    _currentAnimationData = animationData;
    _isLooping = animationData.isLooping;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: _buildLottiePlayer(animationData),
    );
  }

  Widget _buildLottiePlayer(ExerciseAnimationData animationData) {
    try {
      // Handle different animation sources
      Widget lottieWidget;

      switch (animationData.source) {
        case AnimationSource.assets:
          // Try to load from assets first
          final assetPath = animationData.metadata['assetPath'] as String?;
          if (assetPath != null) {
            lottieWidget = Lottie.asset(
              assetPath,
              controller: _lottieController,
              onLoaded: _onLottieLoaded,
              fit: BoxFit.contain,
              repeat: _isLooping,
              animate: _isPlaying,
              errorBuilder: (context, error, stackTrace) {
                AppLogger.warning('Failed to load Lottie from assets: $error');
                return _buildFromJsonData(animationData);
              },
            );
          } else {
            lottieWidget = _buildFromJsonData(animationData);
          }
          break;

        case AnimationSource.storage:
        case AnimationSource.cache:
        case AnimationSource.generated:
          lottieWidget = _buildFromJsonData(animationData);
          break;
      }

      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: lottieWidget,
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error building Lottie player', e, stackTrace);
      return _buildPlaceholder();
    }
  }

  Widget _buildFromJsonData(ExerciseAnimationData animationData) {
    try {
      // Parse JSON data
      final jsonData = jsonDecode(animationData.data);

      return Lottie.memory(
        Uint8List.fromList(utf8.encode(jsonEncode(jsonData))),
        controller: _lottieController,
        onLoaded: _onLottieLoaded,
        fit: BoxFit.contain,
        repeat: _isLooping,
        animate: _isPlaying,
        errorBuilder: (context, error, stackTrace) {
          AppLogger.warning('Failed to load Lottie from JSON: $error');
          return _buildPlaceholder();
        },
      );
    } catch (e) {
      AppLogger.warning('Error parsing animation JSON: $e');
      return _buildPlaceholder();
    }
  }

  Widget _buildLoadingState() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[100],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading animation...',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(Object error) {
    AppLogger.error('Animation loading error', error);
    return _buildPlaceholder(showError: true);
  }

  Widget _buildPlaceholder({bool showError = false}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor.withOpacity(0.1),
            AppTheme.secondaryColor.withOpacity(0.1),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            showError ? Icons.error_outline : Icons.fitness_center,
            size: 64,
            color:
                showError
                    ? AppTheme.errorColor.withOpacity(0.5)
                    : AppTheme.primaryColor.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            showError ? 'Animation Error' : widget.exercise.name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          if (!showError) ...[
            const SizedBox(height: 8),
            Text(
              'Exercise Demonstration',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAnimationControls() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Play controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: _restart,
                icon: const Icon(Icons.replay),
                tooltip: 'Restart',
              ),
              IconButton(
                onPressed: _togglePlayPause,
                icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                tooltip: _isPlaying ? 'Pause' : 'Play',
              ),
              IconButton(
                onPressed: _toggleLoop,
                icon: Icon(
                  _isLooping ? Icons.repeat : Icons.repeat_one,
                  color: _isLooping ? AppTheme.primaryColor : null,
                ),
                tooltip: _isLooping ? 'Disable Loop' : 'Enable Loop',
              ),
            ],
          ),

          // Speed control
          Row(
            children: [
              const Icon(Icons.speed, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Slider(
                  value: _animationSpeed,
                  min: 0.25,
                  max: 2.0,
                  divisions: 7,
                  label: '${_animationSpeed.toStringAsFixed(2)}x',
                  onChanged: _changeSpeed,
                ),
              ),
              Text(
                '${_animationSpeed.toStringAsFixed(2)}x',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onLottieLoaded(LottieComposition composition) {
    _lottieController = AnimationController(
      duration: composition.duration,
      vsync: this,
    );

    _lottieController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onAnimationCompleted?.call();
        if (!_isLooping) {
          setState(() {
            _isPlaying = false;
          });
        }
      }
    });

    // Set initial speed
    _lottieController!.duration = Duration(
      milliseconds:
          (composition.duration.inMilliseconds / _animationSpeed).round(),
    );

    if (_isPlaying) {
      if (_isLooping) {
        _lottieController!.repeat();
      } else {
        _lottieController!.forward();
      }
    }

    setState(() {});
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });

    if (_lottieController != null) {
      if (_isPlaying) {
        if (_isLooping) {
          _lottieController!.repeat();
        } else {
          _lottieController!.forward();
        }
      } else {
        _lottieController!.stop();
      }
    }
  }

  void _restart() {
    _lottieController?.reset();
    if (_isPlaying) {
      if (_isLooping) {
        _lottieController!.repeat();
      } else {
        _lottieController!.forward();
      }
    }
  }

  void _toggleLoop() {
    setState(() {
      _isLooping = !_isLooping;
    });

    if (_lottieController != null && _isPlaying) {
      _lottieController!.reset();
      if (_isLooping) {
        _lottieController!.repeat();
      } else {
        _lottieController!.forward();
      }
    }
  }

  void _changeSpeed(double speed) {
    setState(() {
      _animationSpeed = speed;
    });

    if (_lottieController != null && _currentAnimationData != null) {
      final originalDuration = Duration(
        milliseconds: _currentAnimationData!.duration,
      );
      _lottieController!.duration = Duration(
        milliseconds: (originalDuration.inMilliseconds / speed).round(),
      );

      if (_isPlaying) {
        _lottieController!.reset();
        if (_isLooping) {
          _lottieController!.repeat();
        } else {
          _lottieController!.forward();
        }
      }
    }
  }
}

/// Widget for preloading animations in the background
class AnimationPreloader extends ConsumerWidget {
  const AnimationPreloader({
    required this.exercises,
    this.onPreloadCompleted,
    super.key,
  });

  final List<Exercise> exercises;
  final VoidCallback? onPreloadCompleted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<void>(
      future: _preloadAnimations(ref),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            onPreloadCompleted?.call();
          });
        }

        return const SizedBox.shrink();
      },
    );
  }

  Future<void> _preloadAnimations(WidgetRef ref) async {
    try {
      final animationService = ref.read(exerciseAnimationServiceProvider);
      await animationService.preloadExerciseAnimations(exercises);
      AppLogger.info('Preloaded animations for ${exercises.length} exercises');
    } catch (e, stackTrace) {
      AppLogger.error('Error preloading animations', e, stackTrace);
    }
  }
}

/// Widget for displaying celebration animations
class CelebrationAnimationWidget extends ConsumerStatefulWidget {
  const CelebrationAnimationWidget({
    required this.type,
    this.onAnimationCompleted,
    this.autoPlay = true,
    super.key,
  });

  final CelebrationType type;
  final VoidCallback? onAnimationCompleted;
  final bool autoPlay;

  @override
  ConsumerState<CelebrationAnimationWidget> createState() =>
      _CelebrationAnimationWidgetState();
}

class _CelebrationAnimationWidgetState
    extends ConsumerState<CelebrationAnimationWidget>
    with TickerProviderStateMixin {
  AnimationController? _lottieController;
  AnimationController? _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController!, curve: Curves.elasticOut),
    );

    if (widget.autoPlay) {
      _scaleController!.forward();
    }
  }

  @override
  void dispose() {
    _lottieController?.dispose();
    _scaleController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animationAsync = ref.watch(celebrationAnimationProvider(widget.type));

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: RadialGradient(
                colors: [
                  AppTheme.primaryColor.withOpacity(0.1),
                  AppTheme.secondaryColor.withOpacity(0.05),
                  Colors.transparent,
                ],
              ),
            ),
            child: animationAsync.when(
              data:
                  (animationData) => _buildCelebrationAnimation(animationData),
              loading: () => _buildLoadingCelebration(),
              error: (error, stack) => _buildDefaultCelebration(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCelebrationAnimation(ExerciseAnimationData? animationData) {
    if (animationData == null) {
      return _buildDefaultCelebration();
    }

    try {
      final jsonData = jsonDecode(animationData.data);
      return Lottie.memory(
        Uint8List.fromList(utf8.encode(jsonEncode(jsonData))),
        controller: _lottieController,
        onLoaded: (composition) {
          _lottieController = AnimationController(
            duration: composition.duration,
            vsync: this,
          );

          _lottieController!.addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              widget.onAnimationCompleted?.call();
            }
          });

          if (widget.autoPlay) {
            _lottieController!.forward();
          }
        },
        fit: BoxFit.contain,
        repeat: false,
        animate: widget.autoPlay,
        errorBuilder: (context, error, stackTrace) {
          return _buildDefaultCelebration();
        },
      );
    } catch (e) {
      return _buildDefaultCelebration();
    }
  }

  Widget _buildLoadingCelebration() {
    return _buildDefaultCelebration();
  }

  Widget _buildDefaultCelebration() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 800),
            builder: (context, value, child) {
              return Transform.rotate(
                angle: value * 2 * 3.14159,
                child: Icon(
                  _getCelebrationIcon(),
                  size: 80,
                  color: AppTheme.primaryColor.withOpacity(0.8),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            _getCelebrationMessage(),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            _getCelebrationSubtitle(),
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AppTheme.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  IconData _getCelebrationIcon() {
    switch (widget.type) {
      case CelebrationType.exerciseComplete:
        return Icons.check_circle;
      case CelebrationType.workoutComplete:
        return Icons.emoji_events;
      case CelebrationType.personalRecord:
        return Icons.star;
      case CelebrationType.streakAchieved:
        return Icons.local_fire_department;
      case CelebrationType.goalReached:
        return Icons.flag;
    }
  }

  String _getCelebrationMessage() {
    switch (widget.type) {
      case CelebrationType.exerciseComplete:
        return 'Great Job!';
      case CelebrationType.workoutComplete:
        return 'Workout Complete!';
      case CelebrationType.personalRecord:
        return 'New Record!';
      case CelebrationType.streakAchieved:
        return 'Streak Achieved!';
      case CelebrationType.goalReached:
        return 'Goal Reached!';
    }
  }

  String _getCelebrationSubtitle() {
    switch (widget.type) {
      case CelebrationType.exerciseComplete:
        return 'You completed the exercise perfectly!';
      case CelebrationType.workoutComplete:
        return 'You finished your entire workout!';
      case CelebrationType.personalRecord:
        return 'You set a new personal best!';
      case CelebrationType.streakAchieved:
        return 'Keep up the amazing consistency!';
      case CelebrationType.goalReached:
        return 'You achieved your fitness goal!';
    }
  }
}
