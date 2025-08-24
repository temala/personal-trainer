import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fitness_training_app/shared/domain/entities/user_score.dart';

/// Widget for displaying user progress charts
class ProgressChartWidget extends StatelessWidget {
  final UserScore userScore;
  final ProgressChartType chartType;
  final Duration animationDuration;

  const ProgressChartWidget({
    super.key,
    required this.userScore,
    required this.chartType,
    this.animationDuration = const Duration(milliseconds: 1500),
  });

  @override
  Widget build(BuildContext context) {
    switch (chartType) {
      case ProgressChartType.scoreOverTime:
        return _buildScoreOverTimeChart(context);
      case ProgressChartType.categoryBreakdown:
        return _buildCategoryBreakdownChart(context);
      case ProgressChartType.levelProgress:
        return _buildLevelProgressChart(context);
      case ProgressChartType.streakHistory:
        return _buildStreakHistoryChart(context);
    }
  }

  Widget _buildScoreOverTimeChart(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Score Progress',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 100,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: theme.dividerColor.withOpacity(0.3),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                        );
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(
                            _getWeekLabel(value.toInt()),
                            style: style,
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 200,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                        );
                        return Text(value.toInt().toString(), style: style);
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: theme.dividerColor.withOpacity(0.3),
                  ),
                ),
                minX: 0,
                maxX: 7,
                minY: 0,
                maxY: (userScore.totalScore + 200).toDouble(),
                lineBarsData: [
                  LineChartBarData(
                    spots: _generateScoreSpots(),
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: [
                        theme.primaryColor.withOpacity(0.8),
                        theme.primaryColor,
                      ],
                    ),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: theme.primaryColor,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          theme.primaryColor.withOpacity(0.3),
                          theme.primaryColor.withOpacity(0.1),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
              duration: animationDuration,
              curve: Curves.easeInOut,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBreakdownChart(BuildContext context) {
    final theme = Theme.of(context);
    final breakdown = userScore.scoreCategoryBreakdown;

    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Score Breakdown',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          // Handle touch events if needed
                        },
                      ),
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      sections: _generatePieChartSections(breakdown, theme),
                    ),
                    duration: animationDuration,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        breakdown.entries.map((entry) {
                          return _buildLegendItem(
                            context,
                            entry.key.name,
                            entry.value,
                            _getCategoryColor(entry.key),
                          );
                        }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelProgressChart(BuildContext context) {
    final theme = Theme.of(context);
    final currentLevel = userScore.currentLevel;
    final progressToNext = userScore.progressToNextLevel;

    return Container(
      height: 120,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Level $currentLevel',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ),
              Text(
                '${userScore.pointsToNextLevel} pts to next level',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: progressToNext / 100,
            backgroundColor: theme.primaryColor.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
            minHeight: 8,
          ),
          const SizedBox(height: 8),
          Text(
            '${progressToNext.toStringAsFixed(1)}% to Level ${currentLevel + 1}',
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildStreakHistoryChart(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 180,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Streak History',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Current: ${userScore.currentStreak} days',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: userScore.longestStreak.toDouble() + 5,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(fontSize: 10);
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(
                            _getWeekLabel(value.toInt()),
                            style: style,
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: _generateStreakBars(theme),
                gridData: const FlGridData(show: false),
              ),
              duration: animationDuration,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(
    BuildContext context,
    String label,
    double percentage,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodySmall),
          ),
          Text(
            '${percentage.toStringAsFixed(1)}%',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _generateScoreSpots() {
    // Generate mock data for the last 8 weeks
    // In a real app, this would come from historical data
    final spots = <FlSpot>[];
    final currentScore = userScore.totalScore;

    for (int i = 0; i <= 7; i++) {
      final score = (currentScore * (0.3 + (i * 0.1))).toDouble();
      spots.add(FlSpot(i.toDouble(), score));
    }

    return spots;
  }

  List<PieChartSectionData> _generatePieChartSections(
    Map<ScoreCategory, double> breakdown,
    ThemeData theme,
  ) {
    return breakdown.entries.map((entry) {
      final category = entry.key;
      final percentage = entry.value;

      return PieChartSectionData(
        color: _getCategoryColor(category),
        value: percentage,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  List<BarChartGroupData> _generateStreakBars(ThemeData theme) {
    // Generate mock streak data for the last 8 weeks
    // In a real app, this would come from historical data
    final bars = <BarChartGroupData>[];

    for (int i = 0; i < 8; i++) {
      final streakValue =
          (userScore.currentStreak * (0.5 + (i * 0.1))).toDouble();

      bars.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: streakValue,
              color: theme.primaryColor,
              width: 16,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(4),
              ),
            ),
          ],
        ),
      );
    }

    return bars;
  }

  Color _getCategoryColor(ScoreCategory category) {
    switch (category) {
      case ScoreCategory.consistency:
        return Colors.blue;
      case ScoreCategory.completion:
        return Colors.green;
      case ScoreCategory.improvement:
        return Colors.orange;
      case ScoreCategory.engagement:
        return Colors.purple;
      case ScoreCategory.challenge:
        return Colors.red;
    }
  }

  String _getWeekLabel(int week) {
    switch (week) {
      case 0:
        return 'W1';
      case 1:
        return 'W2';
      case 2:
        return 'W3';
      case 3:
        return 'W4';
      case 4:
        return 'W5';
      case 5:
        return 'W6';
      case 6:
        return 'W7';
      case 7:
        return 'W8';
      default:
        return 'W${week + 1}';
    }
  }
}

/// Types of progress charts available
enum ProgressChartType {
  scoreOverTime,
  categoryBreakdown,
  levelProgress,
  streakHistory,
}
