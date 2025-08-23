import 'package:flutter/material.dart';

/// Progress bar widget for workout sessions
class WorkoutProgressBar extends StatelessWidget {
  const WorkoutProgressBar({
    super.key,
    required this.currentExercise,
    required this.totalExercises,
    required this.completionPercentage,
    this.height = 8.0,
    this.backgroundColor,
    this.progressColor,
    this.showText = true,
    this.textStyle,
  });

  final int currentExercise;
  final int totalExercises;
  final double completionPercentage;
  final double height;
  final Color? backgroundColor;
  final Color? progressColor;
  final bool showText;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBackgroundColor = backgroundColor ?? Colors.grey.shade300;
    final effectiveProgressColor = progressColor ?? theme.primaryColor;
    final effectiveTextStyle = textStyle ?? theme.textTheme.bodySmall;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showText) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Exercise $currentExercise of $totalExercises',
                style: effectiveTextStyle,
              ),
              Text(
                '${completionPercentage.toStringAsFixed(1)}%',
                style: effectiveTextStyle,
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        Container(
          height: height,
          decoration: BoxDecoration(
            color: effectiveBackgroundColor,
            borderRadius: BorderRadius.circular(height / 2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(height / 2),
            child: LinearProgressIndicator(
              value: completionPercentage / 100,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(effectiveProgressColor),
            ),
          ),
        ),
      ],
    );
  }
}

/// Circular progress indicator for workout sessions
class WorkoutCircularProgress extends StatelessWidget {
  const WorkoutCircularProgress({
    super.key,
    required this.completionPercentage,
    this.size = 100.0,
    this.strokeWidth = 8.0,
    this.backgroundColor,
    this.progressColor,
    this.showPercentage = true,
    this.centerChild,
  });

  final double completionPercentage;
  final double size;
  final double strokeWidth;
  final Color? backgroundColor;
  final Color? progressColor;
  final bool showPercentage;
  final Widget? centerChild;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBackgroundColor = backgroundColor ?? Colors.grey.shade300;
    final effectiveProgressColor = progressColor ?? theme.primaryColor;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: completionPercentage / 100,
            strokeWidth: strokeWidth,
            backgroundColor: effectiveBackgroundColor,
            valueColor: AlwaysStoppedAnimation<Color>(effectiveProgressColor),
          ),
          if (centerChild != null)
            centerChild!
          else if (showPercentage)
            Text(
              '${completionPercentage.toStringAsFixed(0)}%',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: effectiveProgressColor,
              ),
            ),
        ],
      ),
    );
  }
}

/// Exercise step indicator
class ExerciseStepIndicator extends StatelessWidget {
  const ExerciseStepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.completedColor,
    this.currentColor,
    this.inactiveColor,
    this.size = 32.0,
    this.spacing = 8.0,
  });

  final int currentStep;
  final int totalSteps;
  final Color? completedColor;
  final Color? currentColor;
  final Color? inactiveColor;
  final double size;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveCompletedColor = completedColor ?? Colors.green;
    final effectiveCurrentColor = currentColor ?? theme.primaryColor;
    final effectiveInactiveColor = inactiveColor ?? Colors.grey.shade300;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        final stepNumber = index + 1;
        Color stepColor;
        IconData stepIcon;

        if (stepNumber < currentStep) {
          stepColor = effectiveCompletedColor;
          stepIcon = Icons.check;
        } else if (stepNumber == currentStep) {
          stepColor = effectiveCurrentColor;
          stepIcon = Icons.play_arrow;
        } else {
          stepColor = effectiveInactiveColor;
          stepIcon = Icons.circle_outlined;
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: spacing / 2),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(color: stepColor, shape: BoxShape.circle),
            child: Icon(stepIcon, color: Colors.white, size: size * 0.6),
          ),
        );
      }),
    );
  }
}

/// Recovery timer widget
class RecoveryTimer extends StatelessWidget {
  const RecoveryTimer({
    super.key,
    required this.remainingSeconds,
    required this.totalSeconds,
    this.size = 120.0,
    this.strokeWidth = 8.0,
    this.backgroundColor,
    this.progressColor,
    this.textStyle,
  });

  final int remainingSeconds;
  final int totalSeconds;
  final double size;
  final double strokeWidth;
  final Color? backgroundColor;
  final Color? progressColor;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBackgroundColor = backgroundColor ?? Colors.grey.shade300;
    final effectiveProgressColor = progressColor ?? Colors.blue;
    final effectiveTextStyle =
        textStyle ??
        theme.textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: effectiveProgressColor,
        );

    final progress =
        totalSeconds > 0
            ? (totalSeconds - remainingSeconds) / totalSeconds
            : 0.0;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress,
            strokeWidth: strokeWidth,
            backgroundColor: effectiveBackgroundColor,
            valueColor: AlwaysStoppedAnimation<Color>(effectiveProgressColor),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_formatTime(remainingSeconds), style: effectiveTextStyle),
              Text(
                'Rest',
                style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    if (minutes > 0) {
      return '${minutes}:${remainingSeconds.toString().padLeft(2, '0')}';
    }
    return '${seconds}s';
  }
}

/// Workout session summary widget
class WorkoutSessionSummary extends StatelessWidget {
  const WorkoutSessionSummary({
    super.key,
    required this.completedExercises,
    required this.totalExercises,
    required this.duration,
    required this.caloriesBurned,
    this.backgroundColor,
    this.textColor,
  });

  final int completedExercises;
  final int totalExercises;
  final Duration duration;
  final int caloriesBurned;
  final Color? backgroundColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBackgroundColor = backgroundColor ?? theme.cardColor;
    final effectiveTextColor = textColor ?? theme.textTheme.bodyLarge?.color;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Workout Summary',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: effectiveTextColor,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryItem(
                context,
                'Exercises',
                '$completedExercises/$totalExercises',
                Icons.fitness_center,
                effectiveTextColor,
              ),
              _buildSummaryItem(
                context,
                'Duration',
                _formatDuration(duration),
                Icons.timer,
                effectiveTextColor,
              ),
              _buildSummaryItem(
                context,
                'Calories',
                '$caloriesBurned',
                Icons.local_fire_department,
                effectiveTextColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color? textColor,
  ) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Icon(icon, size: 32, color: theme.primaryColor),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }
}
