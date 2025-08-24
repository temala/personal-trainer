import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitness_training_app/shared/domain/entities/user_score.dart';
import 'package:fitness_training_app/shared/domain/entities/user_profile.dart';
import 'package:fitness_training_app/shared/presentation/providers/scoring_providers.dart';

/// Widget for displaying AI-generated advice and recommendations
class AIAdviceWidget extends ConsumerWidget {
  final UserScore userScore;
  final UserProfile userProfile;
  final bool showRefreshButton;

  const AIAdviceWidget({
    super.key,
    required this.userScore,
    required this.userProfile,
    this.showRefreshButton = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final adviceParams = ScoreAdviceParams(
      userScore: userScore,
      userProfile: userProfile,
    );
    final adviceAsync = ref.watch(scoreAdviceProvider(adviceParams));

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, theme, ref, adviceParams),
            const SizedBox(height: 16),
            _buildAdviceContent(context, theme, adviceAsync),
            const SizedBox(height: 16),
            _buildQuickTips(context, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    ThemeData theme,
    WidgetRef ref,
    ScoreAdviceParams adviceParams,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.psychology, color: theme.primaryColor, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            'AI Recommendations',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (showRefreshButton)
          IconButton(
            onPressed: () {
              ref.invalidate(scoreAdviceProvider(adviceParams));
            },
            icon: Icon(Icons.refresh, color: theme.primaryColor),
            tooltip: 'Get new advice',
          ),
      ],
    );
  }

  Widget _buildAdviceContent(
    BuildContext context,
    ThemeData theme,
    AsyncValue<String> adviceAsync,
  ) {
    return adviceAsync.when(
      data: (advice) => _buildAdviceText(context, theme, advice),
      loading: () => _buildLoadingState(context, theme),
      error: (error, _) => _buildErrorState(context, theme, error),
    );
  }

  Widget _buildAdviceText(
    BuildContext context,
    ThemeData theme,
    String advice,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.primaryColor.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_outline, color: theme.primaryColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              advice,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Generating personalized advice...',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, ThemeData theme, Object error) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.error.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.error.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline, color: theme.colorScheme.error, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Unable to generate advice',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Check your connection and try again',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickTips(BuildContext context, ThemeData theme) {
    final tips = _getQuickTips();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Tips',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        ...tips.map((tip) => _buildTipItem(context, theme, tip)),
      ],
    );
  }

  Widget _buildTipItem(BuildContext context, ThemeData theme, QuickTip tip) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: tip.color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: tip.color.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(tip.icon, color: tip.color, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              tip.text,
              style: theme.textTheme.bodySmall?.copyWith(height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  List<QuickTip> _getQuickTips() {
    final tips = <QuickTip>[];

    // Commitment level tips
    if (userScore.commitmentLevel < 0.5) {
      tips.add(
        QuickTip(
          text: 'Try to maintain consistency. Even 10-minute workouts count!',
          icon: Icons.schedule,
          color: Colors.orange,
        ),
      );
    }

    // Streak tips
    if (userScore.currentStreak == 0) {
      tips.add(
        QuickTip(
          text: 'Start a new streak today. Consistency builds habits!',
          icon: Icons.local_fire_department,
          color: Colors.red,
        ),
      );
    } else if (userScore.currentStreak < 7) {
      tips.add(
        QuickTip(
          text:
              'You\'re ${7 - userScore.currentStreak} days away from a weekly streak!',
          icon: Icons.local_fire_department,
          color: Colors.orange,
        ),
      );
    }

    // Completion rate tips
    if (userScore.completionRate < 80) {
      tips.add(
        QuickTip(
          text:
              'Focus on completing your planned exercises. Use alternatives if needed!',
          icon: Icons.check_circle,
          color: Colors.blue,
        ),
      );
    }

    // Level progression tips
    if (userScore.pointsToNextLevel <= 100) {
      tips.add(
        QuickTip(
          text:
              'You\'re close to the next level! Complete a workout to level up.',
          icon: Icons.trending_up,
          color: Colors.green,
        ),
      );
    }

    // Achievement tips
    final upcomingAchievements = _getUpcomingAchievementTips();
    tips.addAll(upcomingAchievements);

    // If no specific tips, add general encouragement
    if (tips.isEmpty) {
      tips.add(
        QuickTip(
          text:
              'Great job maintaining your fitness routine! Keep up the excellent work.',
          icon: Icons.thumb_up,
          color: Colors.green,
        ),
      );
    }

    return tips.take(3).toList(); // Limit to 3 tips
  }

  List<QuickTip> _getUpcomingAchievementTips() {
    final tips = <QuickTip>[];
    final existingAchievementIds =
        userScore.achievements.map((a) => a.id).toSet();

    // Workout completion achievements
    if (!existingAchievementIds.contains('ten_workouts') &&
        userScore.workoutsCompleted >= 8) {
      tips.add(
        QuickTip(
          text:
              '${10 - userScore.workoutsCompleted} more workouts to unlock "Getting Started" achievement!',
          icon: Icons.emoji_events,
          color: Colors.amber,
        ),
      );
    }

    // Streak achievements
    if (!existingAchievementIds.contains('three_day_streak') &&
        userScore.currentStreak >= 2) {
      tips.add(
        QuickTip(
          text: '1 more day to unlock "On a Roll" streak achievement!',
          icon: Icons.emoji_events,
          color: Colors.amber,
        ),
      );
    }

    return tips;
  }
}

/// Represents a quick tip for the user
class QuickTip {
  final String text;
  final IconData icon;
  final Color color;

  QuickTip({required this.text, required this.icon, required this.color});
}
