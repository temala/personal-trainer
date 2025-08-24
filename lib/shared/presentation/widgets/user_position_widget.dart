import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitness_training_app/shared/domain/entities/user_score.dart';
import 'package:fitness_training_app/shared/presentation/providers/scoring_providers.dart';

/// Widget for displaying user's position and ranking
class UserPositionWidget extends ConsumerWidget {
  final String userId;
  final UserScore userScore;
  final bool showLeaderboard;

  const UserPositionWidget({
    super.key,
    required this.userId,
    required this.userScore,
    this.showLeaderboard = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final userRankAsync = ref.watch(userRankProvider(userId));
    final similarScoresAsync = ref.watch(similarScoresProvider(userId));

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, theme),
            const SizedBox(height: 16),
            _buildUserStats(context, theme),
            const SizedBox(height: 16),
            _buildRankSection(context, theme, userRankAsync),
            if (showLeaderboard) ...[
              const SizedBox(height: 16),
              _buildSimilarUsersSection(context, theme, similarScoresAsync),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [theme.primaryColor, theme.primaryColor.withOpacity(0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '${userScore.currentLevel}',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Level ${userScore.currentLevel}',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${userScore.totalScore} points',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        _buildCommitmentBadge(context, theme),
      ],
    );
  }

  Widget _buildCommitmentBadge(BuildContext context, ThemeData theme) {
    final commitmentLevel = userScore.commitmentPercentage;
    final badgeColor = _getCommitmentColor(commitmentLevel);
    final badgeText = _getCommitmentText(commitmentLevel);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: badgeColor.withOpacity(0.3)),
      ),
      child: Text(
        badgeText,
        style: theme.textTheme.bodySmall?.copyWith(
          color: badgeColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildUserStats(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            context,
            theme,
            'Workouts',
            '${userScore.workoutsCompleted}',
            Icons.fitness_center,
          ),
        ),
        Expanded(
          child: _buildStatItem(
            context,
            theme,
            'Streak',
            '${userScore.currentStreak}',
            Icons.local_fire_department,
          ),
        ),
        Expanded(
          child: _buildStatItem(
            context,
            theme,
            'Completion',
            '${userScore.completionRate.toStringAsFixed(1)}%',
            Icons.check_circle,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    ThemeData theme,
    String label,
    String value,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, color: theme.primaryColor, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildRankSection(
    BuildContext context,
    ThemeData theme,
    AsyncValue<int> userRankAsync,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.emoji_events, color: theme.primaryColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Rank',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                userRankAsync.when(
                  data:
                      (rank) => Text(
                        rank > 0 ? '#$rank' : 'Unranked',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  loading:
                      () => const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                  error:
                      (_, __) => Text(
                        'Unable to load',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      ),
                ),
              ],
            ),
          ),
          _buildProgressToNextLevel(context, theme),
        ],
      ),
    );
  }

  Widget _buildProgressToNextLevel(BuildContext context, ThemeData theme) {
    final progressToNext = userScore.progressToNextLevel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'Next Level',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 60,
          child: LinearProgressIndicator(
            value: progressToNext / 100,
            backgroundColor: theme.primaryColor.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '${progressToNext.toStringAsFixed(0)}%',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSimilarUsersSection(
    BuildContext context,
    ThemeData theme,
    AsyncValue<List<UserScore>> similarScoresAsync,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Similar Users',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        similarScoresAsync.when(
          data: (similarScores) {
            if (similarScores.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    'No similar users found',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(
                        0.7,
                      ),
                    ),
                  ),
                ),
              );
            }

            return Column(
              children:
                  similarScores.take(3).map((score) {
                    return _buildSimilarUserItem(context, theme, score);
                  }).toList(),
            );
          },
          loading:
              () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              ),
          error:
              (error, _) => Container(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    'Unable to load similar users',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ),
              ),
        ),
      ],
    );
  }

  Widget _buildSimilarUserItem(
    BuildContext context,
    ThemeData theme,
    UserScore score,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.dividerColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${score.currentLevel}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Level ${score.currentLevel} User',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${score.totalScore} points',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getCommitmentColor(
                score.commitmentPercentage,
              ).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${score.commitmentPercentage.toStringAsFixed(0)}%',
              style: theme.textTheme.bodySmall?.copyWith(
                color: _getCommitmentColor(score.commitmentPercentage),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getCommitmentColor(double commitmentPercentage) {
    if (commitmentPercentage >= 80) {
      return Colors.green;
    } else if (commitmentPercentage >= 60) {
      return Colors.orange;
    } else if (commitmentPercentage >= 40) {
      return Colors.amber;
    } else {
      return Colors.red;
    }
  }

  String _getCommitmentText(double commitmentPercentage) {
    if (commitmentPercentage >= 80) {
      return 'Highly Committed';
    } else if (commitmentPercentage >= 60) {
      return 'Committed';
    } else if (commitmentPercentage >= 40) {
      return 'Moderately Committed';
    } else {
      return 'Getting Started';
    }
  }
}
