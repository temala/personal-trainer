import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitness_training_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:fitness_training_app/shared/domain/entities/user_profile.dart';
import 'package:fitness_training_app/shared/domain/entities/user_score.dart';
import 'package:fitness_training_app/shared/presentation/providers/scoring_providers.dart';
import 'package:fitness_training_app/shared/presentation/widgets/achievement_milestones_widget.dart';
import 'package:fitness_training_app/shared/presentation/widgets/ai_advice_widget.dart';
import 'package:fitness_training_app/shared/presentation/widgets/progress_chart_widget.dart';
import 'package:fitness_training_app/shared/presentation/widgets/user_position_widget.dart';

/// Screen for displaying user progress, achievements, and AI recommendations
class ProgressScreen extends ConsumerStatefulWidget {
  const ProgressScreen({super.key});

  @override
  ConsumerState<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends ConsumerState<ProgressScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentUser = ref.watch(currentUserProvider);

    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: Text('Please sign in to view progress')),
      );
    }

    return _buildProgressContent(context, theme, currentUser.uid);
  }

  Widget _buildProgressContent(
    BuildContext context,
    ThemeData theme,
    String userId,
  ) {
    final userScoreAsync = ref.watch(userScoreStateProvider(userId));
    // For now, we'll create a mock user profile provider or handle this differently
    // final userProfileAsync = ref.watch(userProfileProvider(userId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress'),
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Overview', icon: Icon(Icons.dashboard)),
            Tab(text: 'Charts', icon: Icon(Icons.bar_chart)),
            Tab(text: 'Achievements', icon: Icon(Icons.emoji_events)),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => _refreshData(userId),
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: userScoreAsync.when(
        data: (userScore) {
          if (userScore == null) {
            return const Center(child: Text('No progress data available'));
          }

          // Create a mock user profile for now
          final mockUserProfile = UserProfile(
            id: userId,
            email: 'user@example.com',
            displayName: 'User',
            createdAt: DateTime.now(),
            lastUpdated: DateTime.now(),
          );

          return _buildTabContent(
            context,
            theme,
            userId,
            userScore,
            mockUserProfile,
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, _) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: theme.colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading progress',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _refreshData(userId),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
      ),
    );
  }

  Widget _buildTabContent(
    BuildContext context,
    ThemeData theme,
    String userId,
    UserScore userScore,
    UserProfile userProfile,
  ) {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildOverviewTab(context, theme, userId, userScore, userProfile),
        _buildChartsTab(context, theme, userScore),
        _buildAchievementsTab(context, theme, userId, userScore),
      ],
    );
  }

  Widget _buildOverviewTab(
    BuildContext context,
    ThemeData theme,
    String userId,
    UserScore userScore,
    UserProfile userProfile,
  ) {
    return RefreshIndicator(
      onRefresh: () => _refreshData(userId),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User position and stats
            UserPositionWidget(userId: userId, userScore: userScore),
            const SizedBox(height: 16),

            // Level progress
            ProgressChartWidget(
              userScore: userScore,
              chartType: ProgressChartType.levelProgress,
            ),
            const SizedBox(height: 16),

            // AI recommendations
            AIAdviceWidget(userScore: userScore, userProfile: userProfile),
            const SizedBox(height: 16),

            // Recent achievements
            AchievementMilestonesWidget(
              userId: userId,
              userScore: userScore,
              showRecentOnly: true,
            ),
            const SizedBox(height: 16),

            // Quick stats cards
            _buildQuickStatsGrid(context, theme, userScore),
          ],
        ),
      ),
    );
  }

  Widget _buildChartsTab(
    BuildContext context,
    ThemeData theme,
    UserScore userScore,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Score over time
          ProgressChartWidget(
            userScore: userScore,
            chartType: ProgressChartType.scoreOverTime,
          ),
          const SizedBox(height: 16),

          // Category breakdown
          ProgressChartWidget(
            userScore: userScore,
            chartType: ProgressChartType.categoryBreakdown,
          ),
          const SizedBox(height: 16),

          // Streak history
          ProgressChartWidget(
            userScore: userScore,
            chartType: ProgressChartType.streakHistory,
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsTab(
    BuildContext context,
    ThemeData theme,
    String userId,
    UserScore userScore,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: AchievementMilestonesWidget(userId: userId, userScore: userScore),
    );
  }

  Widget _buildQuickStatsGrid(
    BuildContext context,
    ThemeData theme,
    UserScore userScore,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Stats',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            _buildStatCard(
              context,
              theme,
              'Total Score',
              '${userScore.totalScore}',
              Icons.star,
              Colors.amber,
            ),
            _buildStatCard(
              context,
              theme,
              'Current Level',
              '${userScore.currentLevel}',
              Icons.trending_up,
              Colors.blue,
            ),
            _buildStatCard(
              context,
              theme,
              'Longest Streak',
              '${userScore.longestStreak} days',
              Icons.local_fire_department,
              Colors.red,
            ),
            _buildStatCard(
              context,
              theme,
              'Achievements',
              '${userScore.achievements.length}',
              Icons.emoji_events,
              Colors.green,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    ThemeData theme,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshData(String userId) async {
    // Refresh user score
    ref
      ..invalidate(userScoreStateProvider(userId))
      // Refresh related data
      ..invalidate(userRankProvider(userId))
      ..invalidate(similarScoresProvider(userId))
      ..invalidate(leaderboardProvider(10));

    // Show feedback
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Progress data refreshed'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
