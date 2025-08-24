import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitness_training_app/core/utils/logger.dart';
import 'package:fitness_training_app/shared/domain/entities/exercise.dart';
import 'package:fitness_training_app/shared/presentation/themes/app_theme.dart';
import 'package:fitness_training_app/shared/presentation/widgets/custom_button.dart';

/// Widget for displaying recovery timer with visual feedback
class RecoveryTimerWidget extends ConsumerStatefulWidget {
  const RecoveryTimerWidget({
    required this.duration,
    required this.onTimerComplete,
    required this.onSkip,
    this.exercise,
    this.showSkipButton = true,
    this.showProgressRing = true,
    this.autoStart = true,
    super.key,
  });

  final Duration duration;
  final VoidCallback onTimerComplete;
  final VoidCallback onSkip;
  final Exercise? exercise;
  final bool showSkipButton;
  final bool showProgressRing;
  final bool autoStart;

  @override
  ConsumerState<RecoveryTimerWidget> createState() =>
      _RecoveryTimerWidgetState();
}

class _RecoveryTimerWidgetState extends ConsumerState<RecoveryTimerWidget>
    with TickerProviderStateMixin {
  Timer? _timer;
  late Duration _remainingTime;
  late Duration _totalDuration;
  bool _isRunning = false;
  bool _isPaused = false;

  late AnimationController _progressController;
  late AnimationController _pulseController;
  late AnimationController _breathingController;

  late Animation<double> _progressAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _breathingAnimation;

  @override
  void initState() {
    super.initState();
    _totalDuration = widget.duration;
    _remainingTime = widget.duration;

    _initializeAnimations();

    if (widget.autoStart) {
      _startTimer();
    }
  }

  void _initializeAnimations() {
    // Progress ring animation
    _progressController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _progressAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.linear),
    );

    // Pulse animation for urgency
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Breathing animation for relaxation
    _breathingController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );
    _breathingAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _breathingController, curve: Curves.easeInOut),
    );
  }

  void _startTimer() {
    if (_isRunning) return;

    setState(() {
      _isRunning = true;
      _isPaused = false;
    });

    _progressController.forward();
    _breathingController.repeat(reverse: true);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime.inSeconds <= 0) {
        _completeTimer();
      } else {
        setState(() {
          _remainingTime = Duration(seconds: _remainingTime.inSeconds - 1);
        });

        // Start pulsing when less than 10 seconds remain
        if (_remainingTime.inSeconds <= 10 && !_pulseController.isAnimating) {
          _pulseController.repeat(reverse: true);
        }
      }
    });

    AppLogger.info('Recovery timer started: ${widget.duration.inSeconds}s');
  }

  void _pauseTimer() {
    if (!_isRunning || _isPaused) return;

    setState(() {
      _isPaused = true;
    });

    _timer?.cancel();
    _progressController.stop();
    _pulseController.stop();
    _breathingController.stop();

    AppLogger.info('Recovery timer paused');
  }

  void _resumeTimer() {
    if (!_isRunning || !_isPaused) return;

    setState(() {
      _isPaused = false;
    });

    _startTimer();
    AppLogger.info('Recovery timer resumed');
  }

  void _completeTimer() {
    _timer?.cancel();
    _progressController.stop();
    _pulseController.stop();
    _breathingController.stop();

    setState(() {
      _isRunning = false;
      _remainingTime = Duration.zero;
    });

    AppLogger.info('Recovery timer completed');
    widget.onTimerComplete();
  }

  void _skipTimer() {
    _timer?.cancel();
    _progressController.stop();
    _pulseController.stop();
    _breathingController.stop();

    setState(() {
      _isRunning = false;
    });

    AppLogger.info('Recovery timer skipped');
    widget.onSkip();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _progressController.dispose();
    _pulseController.dispose();
    _breathingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Recovery title
          Text(
            'Recovery Time',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),

          const SizedBox(height: 8),

          // Exercise name (if provided)
          if (widget.exercise != null) ...[
            Text(
              'After ${widget.exercise!.name}',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppTheme.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
          ] else
            const SizedBox(height: 24),

          // Timer display with progress ring
          _buildTimerDisplay(),

          const SizedBox(height: 32),

          // Recovery tips
          _buildRecoveryTips(),

          const SizedBox(height: 32),

          // Control buttons
          _buildControlButtons(),
        ],
      ),
    );
  }

  Widget _buildTimerDisplay() {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _progressAnimation,
        _pulseAnimation,
        _breathingAnimation,
      ]),
      builder: (context, child) {
        final scale =
            _remainingTime.inSeconds <= 10
                ? _pulseAnimation.value
                : _breathingAnimation.value;

        return Transform.scale(
          scale: scale,
          child: SizedBox(
            width: 200,
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background circle
                if (widget.showProgressRing)
                  CustomPaint(
                    size: const Size(200, 200),
                    painter: ProgressRingPainter(
                      progress: _progressAnimation.value,
                      backgroundColor: AppTheme.textLight.withValues(
                        alpha: 0.2,
                      ),
                      progressColor: _getProgressColor(),
                      strokeWidth: 8,
                    ),
                  ),

                // Timer text
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _formatTime(_remainingTime),
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _getTimerTextColor(),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getTimerSubtext(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecoveryTips() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: AppTheme.primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Recovery Tips',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _getRecoveryTip(),
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Pause/Resume button
        if (_isRunning) ...[
          OutlinedButton.icon(
            onPressed: _isPaused ? _resumeTimer : _pauseTimer,
            icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
            label: Text(_isPaused ? 'Resume' : 'Pause'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.textSecondary,
              side: BorderSide(color: AppTheme.textLight),
            ),
          ),
        ] else ...[
          OutlinedButton.icon(
            onPressed: _startTimer,
            icon: const Icon(Icons.play_arrow),
            label: const Text('Start'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.primaryColor,
              side: const BorderSide(color: AppTheme.primaryColor),
            ),
          ),
        ],

        // Skip button
        if (widget.showSkipButton)
          CustomButton(
            text: 'Skip Rest',
            onPressed: _skipTimer,
            color: AppTheme.secondaryColor,
            textColor: Colors.white,
            borderRadius: 25,
            height: 48,
          ),
      ],
    );
  }

  String _formatTime(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;

    if (minutes > 0) {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return seconds.toString();
    }
  }

  Color _getProgressColor() {
    final progress = _remainingTime.inSeconds / _totalDuration.inSeconds;

    if (progress > 0.5) {
      return AppTheme.successColor;
    } else if (progress > 0.2) {
      return AppTheme.warningColor;
    } else {
      return AppTheme.errorColor;
    }
  }

  Color _getTimerTextColor() {
    if (_remainingTime.inSeconds <= 10) {
      return AppTheme.errorColor;
    } else if (_remainingTime.inSeconds <= 30) {
      return AppTheme.warningColor;
    } else {
      return AppTheme.textPrimary;
    }
  }

  String _getTimerSubtext() {
    if (_isPaused) {
      return 'Paused';
    } else if (!_isRunning) {
      return 'Ready to start';
    } else if (_remainingTime.inSeconds <= 10) {
      return 'Almost ready!';
    } else {
      return 'Take a breather';
    }
  }

  String _getRecoveryTip() {
    final tips = [
      'Take deep breaths to help your heart rate recover',
      'Stay hydrated during your rest period',
      'Gently stretch the muscles you just worked',
      'Focus on your breathing and relax',
      'Prepare mentally for your next exercise',
      'Listen to your body and rest as needed',
    ];

    final random = math.Random();
    return tips[random.nextInt(tips.length)];
  }
}

/// Custom painter for progress ring
class ProgressRingPainter extends CustomPainter {
  ProgressRingPainter({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  final double progress;
  final Color backgroundColor;
  final Color progressColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background circle
    final backgroundPaint =
        Paint()
          ..color = backgroundColor
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc
    final progressPaint =
        Paint()
          ..color = progressColor
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // Start from top
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(ProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

/// Recovery timer configuration
class RecoveryTimerConfig {
  const RecoveryTimerConfig({
    required this.baseDuration,
    this.intensityMultiplier = 1.0,
    this.difficultyMultiplier = 1.0,
    this.userFitnessMultiplier = 1.0,
    this.minDuration = const Duration(seconds: 15),
    this.maxDuration = const Duration(minutes: 3),
  });

  final Duration baseDuration;
  final double intensityMultiplier;
  final double difficultyMultiplier;
  final double userFitnessMultiplier;
  final Duration minDuration;
  final Duration maxDuration;

  /// Calculate adaptive recovery time
  Duration calculateRecoveryTime() {
    final totalMultiplier =
        intensityMultiplier * difficultyMultiplier * userFitnessMultiplier;

    final calculatedDuration = Duration(
      milliseconds: (baseDuration.inMilliseconds * totalMultiplier).round(),
    );

    // Clamp to min/max bounds
    if (calculatedDuration < minDuration) {
      return minDuration;
    } else if (calculatedDuration > maxDuration) {
      return maxDuration;
    } else {
      return calculatedDuration;
    }
  }
}
