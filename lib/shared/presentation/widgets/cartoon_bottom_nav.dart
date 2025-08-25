import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import '../themes/app_theme.dart';

/// Cartoon-style bottom navigation bar with animated icons
class CartoonBottomNav extends StatelessWidget {
  const CartoonBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<CartoonBottomNavItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppTheme.radiusXL),
          topRight: Radius.circular(AppTheme.radiusXL),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowMedium,
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingM,
            vertical: AppTheme.spacingS,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:
                items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final isSelected = index == currentIndex;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () => onTap(index),
                      child: AnimatedContainer(
                        duration: AppTheme.animationMedium,
                        curve: Curves.easeInOut,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppTheme.spacingS,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? AppColors.primary.withValues(alpha: 0.1)
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(AppTheme.radiusM),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedContainer(
                              duration: AppTheme.animationMedium,
                              curve: Curves.easeInOut,
                              padding: const EdgeInsets.all(AppTheme.spacingS),
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? AppColors.primary
                                        : Colors.transparent,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isSelected ? item.activeIcon : item.icon,
                                color:
                                    isSelected
                                        ? AppColors.white
                                        : AppColors.textSecondary,
                                size: 24,
                              ),
                            ),
                            const SizedBox(height: AppTheme.spacingXS),
                            AnimatedDefaultTextStyle(
                              duration: AppTheme.animationMedium,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight:
                                    isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                color:
                                    isSelected
                                        ? AppColors.primary
                                        : AppColors.textSecondary,
                              ),
                              child: Text(item.label),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
        ),
      ),
    );
  }
}

/// Bottom navigation item with active and inactive icons
class CartoonBottomNavItem {
  const CartoonBottomNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
}

/// Floating action button for the bottom navigation
class CartoonFloatingActionButton extends StatelessWidget {
  const CartoonFloatingActionButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.heroTag,
    this.tooltip,
    this.mini = false,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Object? heroTag;
  final String? tooltip;
  final bool mini;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.secondary, AppColors.secondaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: Colors.transparent,
        foregroundColor: foregroundColor ?? AppColors.white,
        elevation: 0,
        heroTag: heroTag,
        tooltip: tooltip,
        mini: mini,
        child: Icon(icon, size: mini ? 20 : 28),
      ),
    );
  }
}

/// Specialized bottom navigation for workout screens
class WorkoutBottomNav extends StatelessWidget {
  const WorkoutBottomNav({
    super.key,
    required this.onPrevious,
    required this.onNext,
    required this.onComplete,
    this.canGoPrevious = true,
    this.canGoNext = true,
    this.isLastExercise = false,
  });

  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onComplete;
  final bool canGoPrevious;
  final bool canGoNext;
  final bool isLastExercise;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppTheme.radiusXL),
          topRight: Radius.circular(AppTheme.radiusXL),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowMedium,
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          child: Row(
            children: [
              // Previous button
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: canGoPrevious ? onPrevious : null,
                  icon: const Icon(Icons.arrow_back_ios_rounded),
                  label: const Text('Previous'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppTheme.spacingM,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusM),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.spacingM),
              // Next/Complete button
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: isLastExercise ? onComplete : onNext,
                  icon: Icon(
                    isLastExercise
                        ? Icons.check_circle_rounded
                        : Icons.arrow_forward_ios_rounded,
                  ),
                  label: Text(isLastExercise ? 'Complete' : 'Next'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isLastExercise ? AppColors.success : AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppTheme.spacingM,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusM),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
