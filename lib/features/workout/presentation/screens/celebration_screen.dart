import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import 'package:fitness_training_app/core/utils/logger.dart';
import 'package:fitness_training_app/shared/data/services/exercise_animation_service.dart';
import 'package:fitness_training_app/shared/domain/entities/exercise.dart';
import 'package:fitness_training_app/shared/presentation/providers/celebration_providers.dart';
import 'package:fitness_training_app/shared/presentation/themes/app_theme.dart';
import 'package:fitness_training_app/shared/presentation/widgets/custom_button.dart';

/// Screen that displays celebration animations after exercise completion
class CelebrationScreen extends ConsumerStatefulWidget {
  const CelebrationScreen({
    required this.exercise,
    required this.onContinue,
    this.celebrationType = CelebrationType.exerciseComplete,
    this.achievementData,
    super.key,
  });

  final Exercise exercise;
  final VoidCallback onContinue;
  final CelebrationType celebrationType;
  final Map<String, dynamic>? achievementData;

  @override
  ConsumerState<CelebrationScreen> createState() => _CelebrationScreenState();
}

class _CelebrationScreenState extends ConsumerState<CelebrationScreen>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _rotationController;
  late AnimationController _confettiController;
  late AnimationController _slideController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _confettiAnimation;
  late Animation<Offset> _slideAnimation;

  bool _showContinueButton = false;
  bool _animationCompleted = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startCelebrationSequence();
  }

  void _initializeAnimations() {
    // Scale animation for main celebration
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    // Rotation animation for celebration icon
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.easeInOut),
    );

    // Confetti animation
    _confettiController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _confettiAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _confettiController, curve: Curves.easeOut),
    );

    // Slide animation for continue button
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack),
    );
  }

  Future<void> _startCelebrationSequence() async {
    try {
      // Start scale animation
      await _scaleController.forward();

      // Start rotation and confetti simultaneously
      unawaited(_rotationController.forward());
      unawaited(_confettiController.forward());

      // Wait for main animations to complete
      await Future<void>.delayed(const Duration(milliseconds: 1500));

      // Show continue button
      if (mounted) {
        setState(() {
          _showContinueButton = true;
          _animationCompleted = true;
        });
        unawaited(_slideController.forward());
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error in celebration sequence', e, stackTrace);
      // Fallback: show continue button immediately
      if (mounted) {
        setState(() {
          _showContinueButton = true;
          _animationCompleted = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotationController.dispose();
    _confettiController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Background gradient
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                  stops: [0.0, 1.0],
                ),
              ),
            ),

            // Confetti particles
            if (_confettiAnimation.value > 0) _buildConfettiParticles(),

            // Main celebration content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Celebration animation
                  _buildCelebrationAnimation(),

                  const SizedBox(height: 32),

                  // Exercise name
                  AnimatedBuilder(
                    animation: _scaleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Text(
                          widget.exercise.name,
                          style: Theme.of(
                            context,
                          ).textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  // Celebration message
                  AnimatedBuilder(
                    animation: _scaleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value * 0.8,
                        child: Text(
                          _getCelebrationMessage(),
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // Achievement data (if available)
                  if (widget.achievementData != null) _buildAchievementInfo(),

                  const SizedBox(height: 80),
                ],
              ),
            ),

            // Continue button
            if (_showContinueButton)
              Positioned(
                bottom: 40,
                left: 24,
                right: 24,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: CustomButton(
                    text: 'Continue',
                    onPressed: widget.onContinue,
                    color: Colors.white,
                    textColor: AppTheme.primaryColor,
                    borderRadius: 25,
                  ),
                ),
              ),

            // Skip button (top right)
            if (!_animationCompleted)
              Positioned(
                top: 16,
                right: 16,
                child: TextButton(
                  onPressed: () {
                    _skipAnimation();
                    widget.onContinue();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white.withValues(alpha: 0.8),
                  ),
                  child: const Text('Skip'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCelebrationAnimation() {
    final animationAsync = ref.watch(
      celebrationAnimationProvider(widget.celebrationType),
    );

    return SizedBox(
      height: 200,
      width: 200,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: animationAsync.when(
              data: _buildLottieAnimation,
              loading: _buildDefaultCelebration,
              error: (error, stack) => _buildDefaultCelebration(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLottieAnimation(ExerciseAnimationData? animationData) {
    if (animationData == null) {
      return _buildDefaultCelebration();
    }

    try {
      return Lottie.asset(
        'assets/animations/celebrations/${widget.celebrationType.name}.json',
        fit: BoxFit.contain,
        repeat: false,

        onLoaded: (composition) {
          AppLogger.info(
            'Celebration animation loaded: ${widget.celebrationType.name}',
          );
        },
        errorBuilder: (context, error, stackTrace) {
          AppLogger.warning('Failed to load celebration animation: $error');
          return _buildDefaultCelebration();
        },
      );
    } catch (e) {
      AppLogger.warning('Error building celebration animation: $e');
      return _buildDefaultCelebration();
    }
  }

  Widget _buildDefaultCelebration() {
    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.9),
                  Colors.white.withValues(alpha: 0.7),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Icon(
              _getCelebrationIcon(),
              size: 80,
              color: AppTheme.primaryColor,
            ),
          ),
        );
      },
    );
  }

  Widget _buildConfettiParticles() {
    return AnimatedBuilder(
      animation: _confettiAnimation,
      builder: (context, child) {
        return CustomPaint(
          painter: ConfettiPainter(_confettiAnimation.value),
          size: MediaQuery.of(context).size,
        );
      },
    );
  }

  Widget _buildAchievementInfo() {
    final achievementData = widget.achievementData!;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value * 0.9,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                if (achievementData['streak'] != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.local_fire_department,
                        color: Colors.orange,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${achievementData['streak']} day streak!',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
                if (achievementData['personalRecord'] == true) ...[
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, color: Colors.yellow, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'New Personal Record!',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
                if (achievementData['score'] != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    '+${achievementData['score']} points',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  String _getCelebrationMessage() {
    switch (widget.celebrationType) {
      case CelebrationType.exerciseComplete:
        return 'Exercise Complete!';
      case CelebrationType.workoutComplete:
        return 'Workout Complete!';
      case CelebrationType.personalRecord:
        return 'New Personal Record!';
      case CelebrationType.streakAchieved:
        return 'Streak Achievement!';
      case CelebrationType.goalReached:
        return 'Goal Achieved!';
    }
  }

  IconData _getCelebrationIcon() {
    switch (widget.celebrationType) {
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

  void _skipAnimation() {
    _scaleController.stop();
    _rotationController.stop();
    _confettiController.stop();

    setState(() {
      _showContinueButton = true;
      _animationCompleted = true;
    });
  }
}

/// Custom painter for confetti particles
class ConfettiPainter extends CustomPainter {
  ConfettiPainter(this.animationValue);

  final double animationValue;
  final List<ConfettiParticle> particles = _generateParticles();

  static List<ConfettiParticle> _generateParticles() {
    final random = math.Random();
    return List.generate(50, (index) {
      return ConfettiParticle(
        x: random.nextDouble(),
        y: random.nextDouble() * 0.3, // Start from top 30%
        color: _getRandomColor(random),
        size: random.nextDouble() * 8 + 4,
        rotation: random.nextDouble() * 2 * math.pi,
        velocity: random.nextDouble() * 2 + 1,
      );
    });
  }

  static Color _getRandomColor(math.Random random) {
    final colors = [
      AppTheme.primaryColor,
      AppTheme.secondaryColor,
      AppTheme.accentColor,
      Colors.yellow,
      Colors.orange,
      Colors.pink,
    ];
    return colors[random.nextInt(colors.length)];
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final particle in particles) {
      final x = particle.x * size.width;
      final y =
          particle.y * size.height +
          (animationValue * particle.velocity * size.height);

      // Skip particles that have fallen off screen
      if (y > size.height + 20) continue;

      paint.color = particle.color.withValues(
        alpha: (1 - animationValue * 0.5).clamp(0.0, 1.0),
      );

      canvas
        ..save()
        ..translate(x, y)
        ..rotate(particle.rotation + animationValue * 4);

      // Draw different shapes
      if (particle.size > 6) {
        // Draw star
        _drawStar(canvas, paint, particle.size);
      } else {
        // Draw circle
        canvas.drawCircle(Offset.zero, particle.size / 2, paint);
      }

      canvas.restore();
    }
  }

  void _drawStar(Canvas canvas, Paint paint, double size) {
    final path = Path();
    final radius = size / 2;
    final innerRadius = radius * 0.5;

    for (var i = 0; i < 10; i++) {
      final angle = (i * math.pi) / 5;
      final r = i.isEven ? radius : innerRadius;
      final x = r * math.cos(angle - math.pi / 2);
      final y = r * math.sin(angle - math.pi / 2);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(ConfettiPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

/// Data class for confetti particles
class ConfettiParticle {
  const ConfettiParticle({
    required this.x,
    required this.y,
    required this.color,
    required this.size,
    required this.rotation,
    required this.velocity,
  });

  final double x;
  final double y;
  final Color color;
  final double size;
  final double rotation;
  final double velocity;
}
