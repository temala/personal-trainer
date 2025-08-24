import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitness_training_app/shared/domain/entities/user_score.dart';

/// Widget for displaying achievement milestones and progress
class AchievementMilestonesWidget extends ConsumerWidget {
  const AchievementMilestonesWidget({
    super.key,
    required this.userId,
    required this.userScore,
    this.showRecentOnly = false,
  });

  final String userId;
  final UserScore userScore;
  final bool showRecentOnly;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, theme),
            const SizedBox(height: 16),
            if (showRecentOnly)
              _buildRecentAchievements(context, theme)
            else
              _buildAllAchievements(context, theme),
            const SizedBox(height: 16),
            _buildUpcomingMilestones(context, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    final recentCount = userScore.recentAchievementsList.length;

    return Row(
      children: [
        Icon(Icons.emoji_events, color: theme.primaryColor, size: 24),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            showRecentOnly ? 'Recent Achievements' : 'All Achievements',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (recentCount > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: theme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$recentCount new',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildRecentAchievements(BuildContext context, ThemeData theme) {
    final recentAchievements = userScore.recentAchievementsList;

    if (recentAchievements.isEmpty) {
      return _buildEmptyState(context, theme, 'No recent achievements');
    }

    return Column(
      children:
          recentAchievements.map((achievement) {
            return _buildAchievementItem(
              context,
              theme,
              achievement,
              isRecent: true,
            );
          }).toList(),
    );
  }

  Widget _buildAllAchievements(BuildContext context, ThemeData theme) {
    final achievements = userScore.achievements;

    if (achievements.isEmpty) {
      return _buildEmptyState(context, theme, 'No achievements yet');
    }

    // Group achievements by type
    final groupedAchievements = <AchievementType, List<Achievement>>{};
    for (final achievement in achievements) {
      groupedAchievements
          .putIfAbsent(achievement.type, () => [])
          .add(achievement);
    }

    return Column(
      children:
          groupedAchievements.entries.map((entry) {
            return _buildAchievementGroup(
              context,
              theme,
              entry.key,
              entry.value,
            );
          }).toList(),
    );
  }

  Widget _buildAchievementGroup(
    BuildContext context,
    ThemeData theme,
    AchievementType type,
    List<Achievement> achievements,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            _getAchievementTypeDisplayName(type),
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.primaryColor,
            ),
          ),
        ),
        ...achievements.map((achievement) {
          return _buildAchievementItem(context, theme, achievement);
        }),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildAchievementItem(
    BuildContext context,
    ThemeData theme,
    Achievement achievement, {
    bool isRecent = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:
            isRecent
                ? theme.primaryColor.withValues(alpha: 0.05)
                : theme.cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color:
              isRecent
                  ? theme.primaryColor.withValues(alpha: 0.3)
                  : theme.dividerColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          _buildAchievementIcon(context, theme, achievement),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        achievement.name,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    _buildTierBadge(context, theme, achievement.tier),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  achievement.description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color?.withValues(
                      alpha: 0.7,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      '${achievement.pointsAwarded} points',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.amber.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    if (isRecent)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'NEW',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementIcon(
    BuildContext context,
    ThemeData theme,
    Achievement achievement,
  ) {
    final tierColor = _getTierColor(achievement.tier);
    final typeIcon = _getAchievementTypeIcon(achievement.type);

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [tierColor, tierColor.withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
      ),
      child: Icon(typeIcon, color: Colors.white, size: 24),
    );
  }

  Widget _buildTierBadge(
    BuildContext context,
    ThemeData theme,
    AchievementTier tier,
  ) {
    final tierColor = _getTierColor(tier);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: tierColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: tierColor.withValues(alpha: 0.3)),
      ),
      child: Text(
        _getTierDisplayName(tier),
        style: theme.textTheme.bodySmall?.copyWith(
          color: tierColor,
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildUpcomingMilestones(BuildContext context, ThemeData theme) {
    final upcomingMilestones = _getUpcomingMilestones();

    if (upcomingMilestones.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upcoming Milestones',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        ...upcomingMilestones.map((milestone) {
          return _buildMilestoneItem(context, theme, milestone);
        }),
      ],
    );
  }

  Widget _buildMilestoneItem(
    BuildContext context,
    ThemeData theme,
    UpcomingMilestone milestone,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.primaryColor.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: theme.primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getAchievementTypeIcon(milestone.type),
              color: theme.primaryColor,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  milestone.name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  milestone.description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color?.withValues(
                      alpha: 0.7,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: milestone.progress,
                  backgroundColor: theme.primaryColor.withValues(alpha: 0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
                ),
                const SizedBox(height: 2),
                Text(
                  '${(milestone.progress * 100).toStringAsFixed(0)}% complete',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    ThemeData theme,
    String message,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.emoji_events_outlined,
              size: 48,
              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withValues(
                  alpha: 0.7,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Complete workouts to earn achievements!',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<UpcomingMilestone> _getUpcomingMilestones() {
    final milestones = <UpcomingMilestone>[];
    final existingAchievementIds =
        userScore.achievements.map((a) => a.id).toSet();

    // Check for upcoming workout completion milestones
    if (!existingAchievementIds.contains('ten_workouts') &&
        userScore.workoutsCompleted < 10) {
      milestones.add(
        UpcomingMilestone(
          name: 'Getting Started',
          description: 'Complete 10 workouts',
          type: AchievementType.workoutCompletion,
          progress: userScore.workoutsCompleted / 10.0,
        ),
      );
    } else if (!existingAchievementIds.contains('fifty_workouts') &&
        userScore.workoutsCompleted < 50) {
      milestones.add(
        UpcomingMilestone(
          name: 'Dedicated Trainer',
          description: 'Complete 50 workouts',
          type: AchievementType.workoutCompletion,
          progress: userScore.workoutsCompleted / 50.0,
        ),
      );
    } else if (!existingAchievementIds.contains('hundred_workouts') &&
        userScore.workoutsCompleted < 100) {
      milestones.add(
        UpcomingMilestone(
          name: 'Fitness Champion',
          description: 'Complete 100 workouts',
          type: AchievementType.workoutCompletion,
          progress: userScore.workoutsCompleted / 100.0,
        ),
      );
    }

    // Check for upcoming streak milestones
    if (!existingAchievementIds.contains('week_streak') &&
        userScore.currentStreak < 7) {
      milestones.add(
        UpcomingMilestone(
          name: 'Weekly Warrior',
          description: 'Complete workouts for 7 consecutive days',
          type: AchievementType.streak,
          progress: userScore.currentStreak / 7.0,
        ),
      );
    } else if (!existingAchievementIds.contains('month_streak') &&
        userScore.currentStreak < 30) {
      milestones.add(
        UpcomingMilestone(
          name: 'Unstoppable',
          description: 'Complete workouts for 30 consecutive days',
          type: AchievementType.streak,
          progress: userScore.currentStreak / 30.0,
        ),
      );
    }

    // Check for level milestones
    if (!existingAchievementIds.contains('level_five') &&
        userScore.currentLevel < 5) {
      milestones.add(
        UpcomingMilestone(
          name: 'Level 5 Achiever',
          description: 'Reach level 5',
          type: AchievementType.milestone,
          progress: userScore.currentLevel / 5.0,
        ),
      );
    } else if (!existingAchievementIds.contains('level_ten') &&
        userScore.currentLevel < 10) {
      milestones.add(
        UpcomingMilestone(
          name: 'Master Trainer',
          description: 'Reach level 10',
          type: AchievementType.milestone,
          progress: userScore.currentLevel / 10.0,
        ),
      );
    }

    return milestones;
  }

  Color _getTierColor(AchievementTier tier) {
    switch (tier) {
      case AchievementTier.bronze:
        return const Color(0xFFCD7F32);
      case AchievementTier.silver:
        return const Color(0xFFC0C0C0);
      case AchievementTier.gold:
        return const Color(0xFFFFD700);
      case AchievementTier.platinum:
        return const Color(0xFFE5E4E2);
      case AchievementTier.diamond:
        return const Color(0xFFB9F2FF);
    }
  }

  IconData _getAchievementTypeIcon(AchievementType type) {
    switch (type) {
      case AchievementType.workoutCompletion:
        return Icons.fitness_center;
      case AchievementType.streak:
        return Icons.local_fire_department;
      case AchievementType.consistency:
        return Icons.schedule;
      case AchievementType.improvement:
        return Icons.trending_up;
      case AchievementType.milestone:
        return Icons.flag;
      case AchievementType.special:
        return Icons.star;
    }
  }

  String _getAchievementTypeDisplayName(AchievementType type) {
    switch (type) {
      case AchievementType.workoutCompletion:
        return 'Workout Completion';
      case AchievementType.streak:
        return 'Streaks';
      case AchievementType.consistency:
        return 'Consistency';
      case AchievementType.improvement:
        return 'Improvement';
      case AchievementType.milestone:
        return 'Milestones';
      case AchievementType.special:
        return 'Special';
    }
  }

  String _getTierDisplayName(AchievementTier tier) {
    switch (tier) {
      case AchievementTier.bronze:
        return 'Bronze';
      case AchievementTier.silver:
        return 'Silver';
      case AchievementTier.gold:
        return 'Gold';
      case AchievementTier.platinum:
        return 'Platinum';
      case AchievementTier.diamond:
        return 'Diamond';
    }
  }
}

/// Represents an upcoming milestone
class UpcomingMilestone {
  UpcomingMilestone({
    required this.name,
    required this.description,
    required this.type,
    required this.progress,
  });

  final String name;
  final String description;
  final AchievementType type;
  final double progress; // 0.0 to 1.0
}
