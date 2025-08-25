import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/presentation/themes/app_colors.dart';
import '../../../../shared/presentation/themes/app_text_styles.dart';
import '../../../../shared/presentation/themes/app_theme.dart';
import '../../../../shared/presentation/widgets/custom_button.dart';
import '../../../../shared/presentation/widgets/cartoon_card.dart';
import 'registration_screen.dart';
import 'sign_in_screen.dart';

/// Welcome screen with app introduction and cartoon design
class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  static const routeName = '/welcome';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primaryLight],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingL),
            child: Column(
              children: [
                const Spacer(),

                // App logo and title
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadowMedium,
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.fitness_center_rounded,
                    size: 60,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(height: AppTheme.spacingXL),

                // App title
                Text(
                  'FitTrainer AI',
                  style: AppTextStyles.displayLarge.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: AppTheme.spacingM),

                // Subtitle
                Text(
                  'Your AI-powered fitness companion',
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: AppColors.white.withValues(alpha: 0.9),
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppTheme.spacingXXL),

                // Feature highlights
                Row(
                  children: [
                    Expanded(
                      child: _FeatureCard(
                        icon: Icons.psychology_rounded,
                        title: 'AI Powered',
                        description: 'Personalized workouts created by AI',
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingM),
                    Expanded(
                      child: _FeatureCard(
                        icon: Icons.animation_rounded,
                        title: 'Fun Animations',
                        description: 'Cartoon characters guide your workouts',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppTheme.spacingM),

                Row(
                  children: [
                    Expanded(
                      child: _FeatureCard(
                        icon: Icons.trending_up_rounded,
                        title: 'Track Progress',
                        description: 'Monitor your fitness journey',
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingM),
                    Expanded(
                      child: _FeatureCard(
                        icon: Icons.celebration_rounded,
                        title: 'Gamified',
                        description: 'Earn rewards and achievements',
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // Action buttons
                CustomButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RegistrationScreen.routeName);
                  },
                  text: 'Get Started',
                  variant: ButtonVariant.filled,
                  color: AppColors.white,
                  textColor: AppColors.primary,
                  width: double.infinity,
                  height: 56,
                ),

                const SizedBox(height: AppTheme.spacingM),

                CustomButton(
                  onPressed: () {
                    Navigator.pushNamed(context, SignInScreen.routeName);
                  },
                  text: 'I Already Have an Account',
                  variant: ButtonVariant.outlined,
                  borderColor: AppColors.white,
                  textColor: AppColors.white,
                  width: double.infinity,
                  height: 56,
                ),

                const SizedBox(height: AppTheme.spacingL),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Feature highlight card widget
class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return CartoonCard(
      variant: CardVariant.surface,
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            title,
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacingXS),
          Text(
            description,
            style: AppTextStyles.bodySmall,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
