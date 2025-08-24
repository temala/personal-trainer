import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitness_training_app/core/utils/logger.dart';
import 'package:fitness_training_app/features/workout/presentation/screens/celebration_screen.dart';
import 'package:fitness_training_app/shared/data/services/exercise_animation_service.dart';
import 'package:fitness_training_app/shared/domain/entities/exercise.dart';
import 'package:fitness_training_app/shared/domain/entities/user_profile.dart';
import 'package:fitness_training_app/shared/domain/entities/workout_session.dart';
import 'package:fitness_training_app/shared/presentation/providers/recovery_timer_providers.dart';
import 'package:fitness_training_app/shared/presentation/themes/app_theme.dart';
import 'package:fitness_training_app/shared/presentation/widgets/recovery_timer_widget.dart';

/// Screen that handles the complete exercise recovery flow
/// Shows celebration followed by recovery timer
class ExerciseRecoveryScreen extends ConsumerStatefulWidget {
  const ExerciseRecoveryScreen({
    required this.exercise,
    required this.session,
    required this.onContinue,
    this.userProfile,
    this.achievementData,
    this.celebrationType = CelebrationType.exerciseComplete,
    super.key,
  });

  final Exercise exercise;
  final WorkoutSession session;
  final VoidCallback onContinue;
  final UserProfile? userProfile;
  final Map<String, dynamic>? achievementData;
  final CelebrationType celebrationType;

  @override
  ConsumerState<ExerciseRecoveryScreen> createState() =>
      _ExerciseRecoveryScreenState();
}

class _ExerciseRecoveryScreenState
    extends ConsumerState<ExerciseRecoveryScreen> {
  bool _showRecoveryTimer = false;
  bool _celebrationCompleted = false;

  @override
  void initState() {
    super.initState();

    // Auto-advance to recovery timer after celebration
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted && !_celebrationCompleted) {
        _startRecoveryTimer();
      }
    });
  }

  void _startRecoveryTimer() {
    setState(() {
      _showRecoveryTimer = true;
      _celebrationCompleted = true;
    });
    AppLogger.info('Started recovery timer for ${widget.exercise.name}');
  }

  void _onRecoveryComplete() {
    AppLogger.info('Recovery completed for ${widget.exercise.name}');
    widget.onContinue();
  }

  void _onRecoverySkipped() {
    AppLogger.info('Recovery skipped for ${widget.exercise.name}');
    widget.onContinue();
  }

  @override
  Widget build(BuildContext context) {
    if (!_showRecoveryTimer) {
      return CelebrationScreen(
        exercise: widget.exercise,
        celebrationType: widget.celebrationType,
        achievementData: widget.achievementData,
        onContinue: _startRecoveryTimer,
      );
    }

    return _buildRecoveryScreen();
  }

  Widget _buildRecoveryScreen() {
    // Calculate recovery time based on exercise and user profile
    final recoveryTimeParams = RecoveryTimeParams(
      exercise: widget.exercise,
      userProfile: widget.userProfile,
      sessionData: _getSessionData(),
    );

    final recoveryTime = ref.watch(recoveryTimeProvider(recoveryTimeParams));
    final recoveryActivities = ref.watch(
      recoveryActivitiesProvider(widget.exercise),
    );
    final recoveryTips = ref.watch(
      recoveryTipsProvider(widget.exercise.difficulty),
    );

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Header
              _buildHeader(),

              const SizedBox(height: 32),

              // Recovery Timer
              RecoveryTimerWidget(
                duration: recoveryTime,
                exercise: widget.exercise,
                onTimerComplete: _onRecoveryComplete,
                onSkip: _onRecoverySkipped,
                showSkipButton: true,
                showProgressRing: true,
              ),

              const SizedBox(height: 32),

              // Recovery Activities
              _buildRecoveryActivities(recoveryActivities),

              const SizedBox(height: 24),

              // Recovery Tips
              _buildRecoveryTips(recoveryTips),

              const SizedBox(height: 32),

              // Next Exercise Preview (if available)
              _buildNextExercisePreview(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Back button
        Row(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back),
              color: AppTheme.textSecondary,
            ),
            const Spacer(),
            Text(
              'Recovery',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const Spacer(),
            const SizedBox(width: 48), // Balance the back button
          ],
        ),

        const SizedBox(height: 16),

        // Exercise completion indicator
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.successColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.successColor.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                color: AppTheme.successColor,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                '${widget.exercise.name} Completed',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.successColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecoveryActivities(List<String> activities) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.self_improvement,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Recovery Activities',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          ...activities
              .take(3)
              .map(
                (activity) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(top: 6, right: 12),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          activity,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildRecoveryTips(List<String> tips) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.accentColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.tips_and_updates,
                color: AppTheme.accentColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Recovery Tips',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.accentColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            tips.first,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildNextExercisePreview() {
    final nextExercise = _getNextExercise();
    if (nextExercise == null) {
      return _buildWorkoutCompletePreview();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.next_plan,
                color: AppTheme.primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Next Exercise',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            nextExercise.name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            nextExercise.description,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondary),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              _buildExerciseTag(nextExercise.category.name),
              const SizedBox(width: 8),
              _buildExerciseTag(nextExercise.difficulty.name),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutCompletePreview() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.successColor, AppTheme.accentColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(Icons.emoji_events, color: Colors.white, size: 32),
          const SizedBox(height: 8),
          Text(
            'Workout Complete!',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Great job finishing your workout!',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: AppTheme.primaryColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Exercise? _getNextExercise() {
    // For now, return null since we don't have access to the workout plan
    // This would need to be passed from the parent widget or fetched from a provider
    return null;
  }

  Map<String, dynamic> _getSessionData() {
    return {
      'exercisesCompleted': widget.session.completedExercisesCount,
      'sessionDuration': widget.session.sessionDurationMinutes,
      'recentPerformance':
          1.0, // This would be calculated based on actual performance
    };
  }
}
