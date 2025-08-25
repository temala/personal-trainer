import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitness_training_app/core/utils/logger.dart';
import 'package:fitness_training_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:fitness_training_app/features/workout/presentation/screens/workout_session_screen.dart';
import 'package:fitness_training_app/shared/data/services/simple_workout_generator.dart';
import 'package:fitness_training_app/shared/domain/entities/workout_plan.dart';
import 'package:fitness_training_app/shared/presentation/providers/ai_providers.dart';
import 'package:fitness_training_app/shared/presentation/providers/exercise_providers.dart';
import 'package:fitness_training_app/shared/presentation/providers/workout_session_providers.dart';
import 'package:fitness_training_app/shared/presentation/themes/app_colors.dart';
import 'package:fitness_training_app/shared/presentation/themes/app_text_styles.dart';
import 'package:fitness_training_app/shared/presentation/themes/app_theme.dart';
import 'package:fitness_training_app/shared/presentation/widgets/cartoon_card.dart';
import 'package:fitness_training_app/shared/presentation/widgets/custom_button.dart';
import 'package:fitness_training_app/shared/presentation/widgets/stats_card.dart';

/// Home screen with dashboard and workout preview
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  static const routeName = '/home';

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isGeneratingWorkout = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.background, AppColors.surfaceTint],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.spacingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with greeting
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Good Morning!',
                            style: AppTextStyles.headlineMedium.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: AppTheme.spacingXS),
                          Text(
                            'Ready for your workout?',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Profile avatar
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryLight],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        color: AppColors.white,
                        size: 28,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppTheme.spacingXL),

                // Today's workout card
                CartoonCard(
                  variant: CardVariant.gradient,
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.fitness_center_rounded,
                            color: AppColors.white,
                            size: 32,
                          ),
                          const SizedBox(width: AppTheme.spacingM),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Today's Workout",
                                  style: AppTextStyles.titleLarge.copyWith(
                                    color: AppColors.white,
                                  ),
                                ),
                                Text(
                                  'Full Body Strength',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.white.withValues(
                                      alpha: 0.9,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.spacingL),
                      const Row(
                        children: [
                          _WorkoutStat(
                            icon: Icons.timer_outlined,
                            label: 'Duration',
                            value: '30 min',
                          ),
                          SizedBox(width: AppTheme.spacingL),
                          _WorkoutStat(
                            icon: Icons.local_fire_department_outlined,
                            label: 'Calories',
                            value: '250 kcal',
                          ),
                          SizedBox(width: AppTheme.spacingL),
                          _WorkoutStat(
                            icon: Icons.fitness_center_outlined,
                            label: 'Exercises',
                            value: '8',
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.spacingL),
                      CustomButton(
                        onPressed: _isGeneratingWorkout ? null : _startWorkout,
                        text:
                            _isGeneratingWorkout
                                ? 'Generating...'
                                : 'Start Workout',
                        color: AppColors.white,
                        textColor: AppColors.primary,
                        width: double.infinity,
                        height: 48,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppTheme.spacingXL),

                // Quick stats
                const Text('Your Progress', style: AppTextStyles.headlineSmall),
                const SizedBox(height: AppTheme.spacingM),

                const Row(
                  children: [
                    Expanded(
                      child: StatsCard(
                        title: 'Streak',
                        value: '7',
                        icon: Icons.local_fire_department_rounded,
                        subtitle: 'days',
                        color: AppColors.energyOrange,
                      ),
                    ),
                    SizedBox(width: AppTheme.spacingM),
                    Expanded(
                      child: StatsCard(
                        title: 'Workouts',
                        value: '24',
                        icon: Icons.fitness_center_rounded,
                        subtitle: 'completed',
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppTheme.spacingM),

                const Row(
                  children: [
                    Expanded(
                      child: StatsCard(
                        title: 'Calories',
                        value: '1.2k',
                        icon: Icons.local_fire_department_outlined,
                        subtitle: 'burned',
                        color: AppColors.secondary,
                      ),
                    ),
                    SizedBox(width: AppTheme.spacingM),
                    Expanded(
                      child: StatsCard(
                        title: 'Score',
                        value: '850',
                        icon: Icons.emoji_events_rounded,
                        subtitle: 'points',
                        color: AppColors.sunnyYellow,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppTheme.spacingXL),

                // Recent achievements
                const Text(
                  'Recent Achievements',
                  style: AppTextStyles.headlineSmall,
                ),
                const SizedBox(height: AppTheme.spacingM),

                const CartoonCard(
                  child: Column(
                    children: [
                      _AchievementItem(
                        icon: Icons.emoji_events_rounded,
                        title: 'Week Warrior',
                        description: 'Completed 7 workouts this week',
                        color: AppColors.sunnyYellow,
                      ),
                      Divider(height: AppTheme.spacingL),
                      _AchievementItem(
                        icon: Icons.local_fire_department_rounded,
                        title: 'Calorie Crusher',
                        description: 'Burned 1000+ calories this week',
                        color: AppColors.energyOrange,
                      ),
                      Divider(height: AppTheme.spacingL),
                      _AchievementItem(
                        icon: Icons.trending_up_rounded,
                        title: 'Progress Master',
                        description: 'Improved strength by 15%',
                        color: AppColors.freshGreen,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppTheme.spacingXL),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _startWorkout() async {
    setState(() {
      _isGeneratingWorkout = true;
    });

    try {
      // Get current user profile
      final userProfile = await ref.read(currentUserProfileProvider.future);
      if (userProfile == null) {
        _showError('Please complete your profile setup first');
        return;
      }

      // Get available exercises
      final exercises = await ref.read(allExercisesProvider.future);
      if (exercises.isEmpty) {
        _showError('No exercises available. Please check your connection.');
        return;
      }

      // Try to generate workout plan using AI first
      WorkoutPlan? workoutPlan;

      try {
        final workoutPlanParams = WorkoutPlanGenerationParams(
          userProfile: userProfile,
          availableExercises: exercises,
          preferences: {
            'duration': 30, // 30 minutes
            'difficulty': userProfile.fitnessLevel ?? 'beginner',
            'equipment': 'none', // No equipment for now
          },
        );

        workoutPlan = await ref.read(
          workoutPlanGenerationProvider(workoutPlanParams).future,
        );
      } catch (e) {
        // AI generation failed, fall back to simple generator
        AppLogger.warning('AI workout generation failed: $e');
      }

      // If AI generation failed, use simple workout generator
      workoutPlan ??= SimpleWorkoutGenerator.generateSimpleWorkout(
        userProfile: userProfile,
        availableExercises: exercises,
        preferences: {'duration': 30, 'equipment': 'none'},
      );

      // Start workout session
      final sessionActions = ref.read(workoutSessionActionsProvider);
      await sessionActions.startSession(workoutPlan);

      // Navigate to workout session screen
      if (mounted) {
        await Navigator.of(context).pushNamed(WorkoutSessionScreen.routeName);
      }
    } catch (e) {
      _showError('Error starting workout: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isGeneratingWorkout = false;
        });
      }
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

/// Workout stat widget
class _WorkoutStat extends StatelessWidget {
  const _WorkoutStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.white.withValues(alpha: 0.8), size: 20),
        const SizedBox(height: AppTheme.spacingXS),
        Text(
          value,
          style: AppTextStyles.labelLarge.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}

/// Achievement item widget
class _AchievementItem extends StatelessWidget {
  const _AchievementItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: AppTheme.spacingM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.titleMedium),
              const SizedBox(height: AppTheme.spacingXS),
              Text(
                description,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
