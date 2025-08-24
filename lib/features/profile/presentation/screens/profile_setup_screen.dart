import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitness_training_app/features/profile/presentation/providers/profile_providers.dart';
import 'package:fitness_training_app/shared/domain/entities/fitness_enums.dart';
import 'package:fitness_training_app/shared/domain/entities/user_profile.dart';
import 'package:fitness_training_app/shared/presentation/widgets/custom_button.dart';
import 'package:fitness_training_app/shared/presentation/widgets/custom_text_field.dart';
import 'package:fitness_training_app/shared/presentation/widgets/loading_overlay.dart';

/// Profile setup screen for new users
class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  static const routeName = '/profile-setup';

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _basicInfoFormKey = GlobalKey<FormState>();
  final _physicalInfoFormKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _targetWeightController = TextEditingController();

  FitnessGoal _selectedGoal = FitnessGoal.weightLoss;
  ActivityLevel _selectedActivityLevel = ActivityLevel.moderatelyActive;
  final List<String> _selectedExerciseTypes = [];
  int _currentStep = 0;

  // Track validation state for each step
  bool _basicInfoValid = false;
  bool _physicalInfoValid = false;

  final List<String> _exerciseTypes = [
    'Cardio',
    'Strength Training',
    'Yoga',
    'Pilates',
    'HIIT',
    'Running',
    'Swimming',
    'Cycling',
    'Dancing',
    'Martial Arts',
    'Stretching',
    'Bodyweight',
  ];

  @override
  void dispose() {
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
    final error = ref.watch(profileErrorProvider);

    return Scaffold(
      body: LoadingOverlay(
        isLoading: isLoading,
        child: SafeArea(
          child: Column(
            children: [
              // Progress indicator
              _buildProgressIndicator(),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: _buildCurrentStep(),
                ),
              ),

              // Error message
              if (error != null) ...[
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red[200]!),
                  ),
                  child: Text(
                    error,
                    style: TextStyle(color: Colors.red[700], fontSize: 14),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Navigation buttons
              _buildNavigationButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: List.generate(4, (index) {
          final isActive = index <= _currentStep;

          return Expanded(
            child: Container(
              height: 4,
              margin: EdgeInsets.only(right: index < 3 ? 8 : 0),
              decoration: BoxDecoration(
                color:
                    isActive
                        ? Theme.of(context).primaryColor
                        : Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildBasicInfoStep();
      case 1:
        return _buildPhysicalInfoStep();
      case 2:
        return _buildGoalsStep();
      case 3:
        return _buildPreferencesStep();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildBasicInfoStep() {
    return Form(
      key: _basicInfoFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Tell us about yourself',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          Text(
            "Let's start with some basic information",
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 40),

          CustomTextField(
            controller: _nameController,
            labelText: 'Full Name',
            prefixIcon: Icons.person_outline,
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

          const SizedBox(height: 16),

          CustomTextField(
            controller: _ageController,
            labelText: 'Age',
            prefixIcon: Icons.cake_outlined,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
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
    );
  }

  Widget _buildPhysicalInfoStep() {
    return Form(
      key: _physicalInfoFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Physical Information',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          Text(
            'Help us create a personalized plan for you',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 40),

          CustomTextField(
            controller: _heightController,
            labelText: 'Height (cm)',
            prefixIcon: Icons.height,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your height';
              }
              final height = double.tryParse(value);
              if (height == null || height < 100 || height > 250) {
                return 'Please enter a valid height (100-250 cm)';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          CustomTextField(
            controller: _weightController,
            labelText: 'Current Weight (kg)',
            prefixIcon: Icons.monitor_weight_outlined,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your current weight';
              }
              final weight = double.tryParse(value);
              if (weight == null || weight < 20 || weight > 500) {
                return 'Please enter a valid weight (20-500 kg)';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          CustomTextField(
            controller: _targetWeightController,
            labelText: 'Target Weight (kg)',
            prefixIcon: Icons.flag_outlined,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your target weight';
              }
              final targetWeight = double.tryParse(value);
              if (targetWeight == null ||
                  targetWeight < 20 ||
                  targetWeight > 500) {
                return 'Please enter a valid target weight (20-500 kg)';
              }

              final currentWeight = double.tryParse(_weightController.text);
              if (currentWeight != null &&
                  (currentWeight - targetWeight).abs() > 100) {
                return 'Target weight seems unrealistic';
              }

              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "What's your goal?",
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 8),

        Text(
          'Choose your primary fitness goal',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 40),

        // Fitness goals
        ...FitnessGoal.values.map(_buildGoalOption),

        const SizedBox(height: 32),

        Text(
          'Activity Level',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).primaryColor,
          ),
        ),

        const SizedBox(height: 16),

        // Activity levels
        ...ActivityLevel.values.map(_buildActivityLevelOption),
      ],
    );
  }

  Widget _buildPreferencesStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Exercise Preferences',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 8),

        Text(
          'Select the types of exercises you enjoy',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 40),

        SizedBox(
          height: 300, // Fixed height for the grid
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: _exerciseTypes.length,
            itemBuilder: (context, index) {
              final exerciseType = _exerciseTypes[index];
              final isSelected = _selectedExerciseTypes.contains(exerciseType);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedExerciseTypes.remove(exerciseType);
                    } else {
                      _selectedExerciseTypes.add(exerciseType);
                    }
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? Theme.of(
                              context,
                            ).primaryColor.withValues(alpha: 0.1)
                            : Colors.grey[100],
                    border: Border.all(
                      color:
                          isSelected
                              ? Theme.of(context).primaryColor
                              : Colors.grey[300]!,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      exerciseType,
                      style: TextStyle(
                        color:
                            isSelected
                                ? Theme.of(context).primaryColor
                                : Colors.grey[700],
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGoalOption(FitnessGoal goal) {
    final isSelected = _selectedGoal == goal;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGoal = goal;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                  : Colors.grey[100],
          border: Border.all(
            color:
                isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              _getGoalIcon(goal),
              color:
                  isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.grey[600],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _getGoalDisplayName(goal),
                style: TextStyle(
                  color:
                      isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.grey[700],
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 16,
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: Theme.of(context).primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityLevelOption(ActivityLevel level) {
    final isSelected = _selectedActivityLevel == level;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedActivityLevel = level;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                  : Colors.grey[100],
          border: Border.all(
            color:
                isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getActivityLevelDisplayName(level),
                    style: TextStyle(
                      color:
                          isSelected
                              ? Theme.of(context).primaryColor
                              : Colors.grey[700],
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getActivityLevelDescription(level),
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: Theme.of(context).primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          if (_currentStep > 0) ...[
            Expanded(
              child: CustomButton(
                onPressed: () {
                  setState(() {
                    _currentStep--;
                  });
                },
                text: 'Back',
                variant: ButtonVariant.outlined,
              ),
            ),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: CustomButton(
              onPressed: _handleNext,
              text: _currentStep == 3 ? 'Complete Setup' : 'Next',
              isLoading: ref.watch(profileLoadingProvider),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleNext() async {
    if (_currentStep < 3) {
      // Validate current step before proceeding
      bool isValid = true;

      if (_currentStep == 0) {
        // Validate basic info step
        isValid = _basicInfoFormKey.currentState?.validate() ?? false;
        _basicInfoValid = isValid; // Store validation state
      } else if (_currentStep == 1) {
        // Validate physical info step
        isValid = _physicalInfoFormKey.currentState?.validate() ?? false;
        _physicalInfoValid = isValid; // Store validation state
      }
      // Steps 2 and 3 don't require form validation (just selections)

      if (!isValid) {
        return;
      }

      setState(() {
        _currentStep++;
      });
    } else {
      // Complete profile setup
      await _handleCompleteSetup();
    }
  }

  Future<void> _handleCompleteSetup() async {
    // Use stored validation states instead of re-validating forms that may not be in the widget tree
    if (!_basicInfoValid || !_physicalInfoValid) {
      // Show error and return to the first invalid step
      ref.read(profileErrorProvider.notifier).state =
          'Please complete all required fields in previous steps';

      // Find the first invalid step and navigate back to it
      if (!_basicInfoValid) {
        setState(() => _currentStep = 0);
      } else if (!_physicalInfoValid) {
        setState(() => _currentStep = 1);
      }
      return;
    }

    try {
      // Clear any previous errors
      ref.read(profileErrorProvider.notifier).state = null;

      // Exercise types are optional - user can proceed without selecting any
      final controller = ref.read(profileControllerProvider);

      final success = await controller.createUserProfile(
        name: _nameController.text.trim(),
        age: int.parse(_ageController.text),
        height: double.parse(_heightController.text),
        weight: double.parse(_weightController.text),
        targetWeight: double.parse(_targetWeightController.text),
        fitnessGoal: _selectedGoal,
        activityLevel: _selectedActivityLevel,
        preferredExerciseTypes: _selectedExerciseTypes,
      );

      if (success && mounted) {
        // Navigate to home screen directly since profile is now created
        await Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/home', (route) => false);
      }
    } catch (e) {
      // Error is already handled by the controller and shown via profileErrorProvider
      // The error will be displayed in the UI automatically
    }
  }

  IconData _getGoalIcon(FitnessGoal goal) {
    switch (goal) {
      case FitnessGoal.weightLoss:
        return Icons.trending_down;
      case FitnessGoal.muscleGain:
        return Icons.fitness_center;
      case FitnessGoal.endurance:
        return Icons.directions_run;
      case FitnessGoal.strength:
        return Icons.fitness_center;
      case FitnessGoal.flexibility:
        return Icons.self_improvement;
    }
  }

  String _getGoalDisplayName(FitnessGoal goal) {
    switch (goal) {
      case FitnessGoal.weightLoss:
        return 'Weight Loss';
      case FitnessGoal.muscleGain:
        return 'Muscle Gain';
      case FitnessGoal.endurance:
        return 'Endurance';
      case FitnessGoal.strength:
        return 'Strength';
      case FitnessGoal.flexibility:
        return 'Flexibility';
    }
  }

  String _getActivityLevelDisplayName(ActivityLevel level) {
    switch (level) {
      case ActivityLevel.sedentary:
        return 'Sedentary';
      case ActivityLevel.lightlyActive:
        return 'Lightly Active';
      case ActivityLevel.moderatelyActive:
        return 'Moderately Active';
      case ActivityLevel.veryActive:
        return 'Very Active';
      case ActivityLevel.extremelyActive:
        return 'Extremely Active';
    }
  }

  String _getActivityLevelDescription(ActivityLevel level) {
    switch (level) {
      case ActivityLevel.sedentary:
        return 'Little to no exercise';
      case ActivityLevel.lightlyActive:
        return 'Light exercise 1-3 days/week';
      case ActivityLevel.moderatelyActive:
        return 'Moderate exercise 3-5 days/week';
      case ActivityLevel.veryActive:
        return 'Hard exercise 6-7 days/week';
      case ActivityLevel.extremelyActive:
        return 'Very hard exercise, physical job';
    }
  }
}
