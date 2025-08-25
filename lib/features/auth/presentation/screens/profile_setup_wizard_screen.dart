import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/presentation/themes/app_colors.dart';
import '../../../../shared/presentation/themes/app_text_styles.dart';
import '../../../../shared/presentation/themes/app_theme.dart';
import '../../../../shared/presentation/widgets/cartoon_app_bar.dart';
import '../../../../shared/presentation/widgets/cartoon_card.dart';
import '../../../../shared/presentation/widgets/custom_button.dart';
import '../../../../shared/presentation/widgets/custom_text_field.dart';
import '../../../../shared/presentation/widgets/loading_overlay.dart';
import '../../../../shared/domain/entities/fitness_enums.dart';
import '../../../profile/presentation/providers/profile_providers.dart';

/// Step-by-step profile setup wizard with cartoon design
class ProfileSetupWizardScreen extends ConsumerStatefulWidget {
  const ProfileSetupWizardScreen({super.key});

  static const routeName = '/profile-setup-wizard';

  @override
  ConsumerState<ProfileSetupWizardScreen> createState() =>
      _ProfileSetupWizardScreenState();
}

class _ProfileSetupWizardScreenState
    extends ConsumerState<ProfileSetupWizardScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 4;

  // Form controllers
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _targetWeightController = TextEditingController();

  // Form keys
  final _basicInfoFormKey = GlobalKey<FormState>();
  final _physicalInfoFormKey = GlobalKey<FormState>();

  // Selected values
  FitnessGoal _selectedGoal = FitnessGoal.weightLoss;
  ActivityLevel _selectedActivityLevel = ActivityLevel.moderatelyActive;
  final List<String> _selectedExerciseTypes = [];

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _targetWeightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(profileLoadingProvider);

    return Scaffold(
      appBar: CartoonAppBar(
        title: 'Setup Profile',
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppTheme.spacingM),
            child: Center(
              child: Text(
                '${_currentStep + 1}/$_totalSteps',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
      body: LoadingOverlay(
        isLoading: isLoading,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.background, AppColors.surfaceTint],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              // Progress indicator
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingM),
                child: LinearProgressIndicator(
                  value: (_currentStep + 1) / _totalSteps,
                  backgroundColor: AppColors.grey200,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primary,
                  ),
                  minHeight: 6,
                ),
              ),

              // Page view
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentStep = index;
                    });
                  },
                  children: [
                    _buildBasicInfoStep(),
                    _buildPhysicalInfoStep(),
                    _buildGoalsStep(),
                    _buildPreferencesStep(),
                  ],
                ),
              ),

              // Navigation buttons
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingL),
                child: Row(
                  children: [
                    if (_currentStep > 0)
                      Expanded(
                        child: CustomButton(
                          onPressed: _previousStep,
                          text: 'Previous',
                          variant: ButtonVariant.outlined,
                          height: 48,
                        ),
                      ),
                    if (_currentStep > 0)
                      const SizedBox(width: AppTheme.spacingM),
                    Expanded(
                      flex: _currentStep == 0 ? 1 : 2,
                      child: CustomButton(
                        onPressed: _nextStep,
                        text:
                            _currentStep == _totalSteps - 1
                                ? 'Complete Setup'
                                : 'Next',
                        variant: ButtonVariant.gradient,
                        height: 48,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      child: Column(
        children: [
          // Step illustration
          Container(
            width: 100,
            height: 100,
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
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.person_rounded,
              size: 50,
              color: AppColors.white,
            ),
          ),

          const SizedBox(height: AppTheme.spacingXL),

          Text(
            'Tell us about yourself',
            style: AppTextStyles.displaySmall.copyWith(
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppTheme.spacingS),

          Text(
            'We need some basic information to personalize your experience',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppTheme.spacingXXL),

          CartoonCard(
            variant: CardVariant.surface,
            padding: const EdgeInsets.all(AppTheme.spacingL),
            child: Form(
              key: _basicInfoFormKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _nameController,
                    labelText: 'Full Name',
                    prefixIcon: Icons.person_outline_rounded,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your name';
                      }
                      if (value.trim().length < 2) {
                        return 'Name must be at least 2 characters';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: AppTheme.spacingM),

                  CustomTextField(
                    controller: _ageController,
                    labelText: 'Age',
                    prefixIcon: Icons.cake_outlined,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your age';
                      }
                      final age = int.tryParse(value);
                      if (age == null || age < 13 || age > 120) {
                        return 'Please enter a valid age (13-120)';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhysicalInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      child: Column(
        children: [
          // Step illustration
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.secondary, AppColors.secondaryLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.secondary.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.monitor_weight_rounded,
              size: 50,
              color: AppColors.white,
            ),
          ),

          const SizedBox(height: AppTheme.spacingXL),

          Text(
            'Physical Information',
            style: AppTextStyles.displaySmall.copyWith(
              color: AppColors.secondary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppTheme.spacingS),

          Text(
            'Help us create the perfect workout plan for your body',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppTheme.spacingXXL),

          CartoonCard(
            variant: CardVariant.surface,
            padding: const EdgeInsets.all(AppTheme.spacingL),
            child: Form(
              key: _physicalInfoFormKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: _heightController,
                          labelText: 'Height (cm)',
                          prefixIcon: Icons.height_rounded,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your height';
                            }
                            final height = double.tryParse(value);
                            if (height == null ||
                                height < 100 ||
                                height > 250) {
                              return 'Please enter a valid height';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingM),
                      Expanded(
                        child: CustomTextField(
                          controller: _weightController,
                          labelText: 'Weight (kg)',
                          prefixIcon: Icons.monitor_weight_outlined,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your weight';
                            }
                            final weight = double.tryParse(value);
                            if (weight == null || weight < 30 || weight > 300) {
                              return 'Please enter a valid weight';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppTheme.spacingM),

                  CustomTextField(
                    controller: _targetWeightController,
                    labelText: 'Target Weight (kg)',
                    prefixIcon: Icons.flag_outlined,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your target weight';
                      }
                      final targetWeight = double.tryParse(value);
                      if (targetWeight == null ||
                          targetWeight < 30 ||
                          targetWeight > 300) {
                        return 'Please enter a valid target weight';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      child: Column(
        children: [
          // Step illustration
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.accent, AppColors.accentLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.emoji_events_rounded,
              size: 50,
              color: AppColors.white,
            ),
          ),

          const SizedBox(height: AppTheme.spacingXL),

          Text(
            'What\'s your goal?',
            style: AppTextStyles.displaySmall.copyWith(color: AppColors.accent),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppTheme.spacingS),

          Text(
            'Choose your primary fitness goal to get personalized workouts',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppTheme.spacingXXL),

          // Fitness goals
          ...FitnessGoal.values.map(
            (goal) => Padding(
              padding: const EdgeInsets.only(bottom: AppTheme.spacingM),
              child: CartoonCard(
                variant:
                    _selectedGoal == goal
                        ? CardVariant.primary
                        : CardVariant.surface,
                onTap: () {
                  setState(() {
                    _selectedGoal = goal;
                  });
                },
                child: Row(
                  children: [
                    Icon(
                      _getGoalIcon(goal),
                      color:
                          _selectedGoal == goal
                              ? AppColors.white
                              : AppColors.primary,
                      size: 32,
                    ),
                    const SizedBox(width: AppTheme.spacingM),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getGoalTitle(goal),
                            style: AppTextStyles.titleLarge.copyWith(
                              color:
                                  _selectedGoal == goal
                                      ? AppColors.white
                                      : AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: AppTheme.spacingXS),
                          Text(
                            _getGoalDescription(goal),
                            style: AppTextStyles.bodySmall.copyWith(
                              color:
                                  _selectedGoal == goal
                                      ? AppColors.white.withValues(alpha: 0.8)
                                      : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      child: Column(
        children: [
          // Step illustration
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.sunnyYellow, AppColors.energyOrange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.sunnyYellow.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.favorite_rounded,
              size: 50,
              color: AppColors.white,
            ),
          ),

          const SizedBox(height: AppTheme.spacingXL),

          Text(
            'Almost done!',
            style: AppTextStyles.displaySmall.copyWith(
              color: AppColors.sunnyYellow,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppTheme.spacingS),

          Text(
            'Tell us about your activity level and exercise preferences',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppTheme.spacingXXL),

          // Activity level
          CartoonCard(
            variant: CardVariant.surface,
            padding: const EdgeInsets.all(AppTheme.spacingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Activity Level', style: AppTextStyles.titleLarge),
                const SizedBox(height: AppTheme.spacingM),
                ...ActivityLevel.values.map(
                  (level) => RadioListTile<ActivityLevel>(
                    title: Text(_getActivityLevelTitle(level)),
                    subtitle: Text(_getActivityLevelDescription(level)),
                    value: level,
                    groupValue: _selectedActivityLevel,
                    onChanged: (value) {
                      setState(() {
                        _selectedActivityLevel = value!;
                      });
                    },
                    activeColor: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      if (_validateCurrentStep()) {
        _pageController.nextPage(
          duration: AppTheme.animationMedium,
          curve: Curves.easeInOut,
        );
      }
    } else {
      _completeSetup();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: AppTheme.animationMedium,
        curve: Curves.easeInOut,
      );
    }
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _basicInfoFormKey.currentState?.validate() ?? false;
      case 1:
        return _physicalInfoFormKey.currentState?.validate() ?? false;
      case 2:
      case 3:
        return true;
      default:
        return false;
    }
  }

  Future<void> _completeSetup() async {
    // TODO: Save profile data using the profile provider
    // This would integrate with the existing profile setup logic

    // For now, just show a success message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile setup completed!'),
          backgroundColor: AppColors.success,
        ),
      );

      // Navigate to main app
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  IconData _getGoalIcon(FitnessGoal goal) {
    switch (goal) {
      case FitnessGoal.weightLoss:
        return Icons.trending_down_rounded;
      case FitnessGoal.muscleGain:
        return Icons.fitness_center_rounded;
      case FitnessGoal.endurance:
        return Icons.directions_run_rounded;
      case FitnessGoal.strength:
        return Icons.sports_gymnastics_rounded;
      case FitnessGoal.flexibility:
        return Icons.self_improvement_rounded;
    }
  }

  String _getGoalTitle(FitnessGoal goal) {
    return goal.displayName;
  }

  String _getGoalDescription(FitnessGoal goal) {
    return goal.description;
  }

  String _getActivityLevelTitle(ActivityLevel level) {
    return level.displayName;
  }

  String _getActivityLevelDescription(ActivityLevel level) {
    return level.description;
  }
}
