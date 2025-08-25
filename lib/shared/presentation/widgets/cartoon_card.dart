import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import '../themes/app_theme.dart';
import '../themes/app_decorations.dart';

/// Card variants for different visual styles
enum CardVariant { surface, primary, secondary, accent, gradient, celebration }

/// Cartoon-style card widget with various visual options
class CartoonCard extends StatelessWidget {
  const CartoonCard({
    super.key,
    required this.child,
    this.variant = CardVariant.surface,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.borderRadius,
    this.onTap,
    this.gradient,
    this.shadowColor,
    this.elevation,
  });

  final Widget child;
  final CardVariant variant;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final double? borderRadius;
  final VoidCallback? onTap;
  final Gradient? gradient;
  final Color? shadowColor;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = borderRadius ?? AppTheme.radiusL;
    final effectivePadding = padding ?? const EdgeInsets.all(AppTheme.spacingM);
    final effectiveMargin = margin ?? const EdgeInsets.all(AppTheme.spacingS);

    BoxDecoration decoration;
    switch (variant) {
      case CardVariant.surface:
        decoration = AppDecorations.surfaceCard;
        break;
      case CardVariant.primary:
        decoration = AppDecorations.primaryCard;
        break;
      case CardVariant.secondary:
        decoration = AppDecorations.secondaryCard;
        break;
      case CardVariant.accent:
        decoration = AppDecorations.accentCard;
        break;
      case CardVariant.gradient:
        decoration = AppDecorations.customGradientCard(
          colors:
              gradient?.colors ?? [AppColors.primary, AppColors.primaryLight],
          borderRadius: effectiveBorderRadius,
        );
        break;
      case CardVariant.celebration:
        decoration = AppDecorations.celebrationCard;
        break;
    }

    // Override decoration properties if specified
    if (shadowColor != null || elevation != null) {
      decoration = decoration.copyWith(
        boxShadow: [
          BoxShadow(
            color: shadowColor ?? AppColors.shadowMedium,
            blurRadius: elevation ?? AppTheme.elevationMedium,
            offset: Offset(0, (elevation ?? AppTheme.elevationMedium) / 2),
          ),
        ],
      );
    }

    Widget card = Container(
      width: width,
      height: height,
      margin: effectiveMargin,
      decoration: decoration,
      child: Padding(padding: effectivePadding, child: child),
    );

    if (onTap != null) {
      card = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(effectiveBorderRadius),
          child: card,
        ),
      );
    }

    return card;
  }
}

/// Specialized card for exercise categories
class ExerciseCategoryCard extends StatelessWidget {
  const ExerciseCategoryCard({
    super.key,
    required this.category,
    required this.title,
    required this.icon,
    this.subtitle,
    this.onTap,
    this.width,
    this.height,
  });

  final String category;
  final String title;
  final IconData icon;
  final String? subtitle;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final categoryColor = AppColors.getExerciseCategoryColor(category);

    return CartoonCard(
      variant: CardVariant.gradient,
      gradient: LinearGradient(
        colors: [categoryColor, categoryColor.withValues(alpha: 0.8)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      width: width,
      height: height,
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: AppColors.white),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
            textAlign: TextAlign.center,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: AppTheme.spacingXS),
            Text(
              subtitle!,
              style: const TextStyle(fontSize: 12, color: AppColors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// Specialized card for achievements
class AchievementCard extends StatelessWidget {
  const AchievementCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.isUnlocked = false,
    this.progress,
    this.onTap,
  });

  final String title;
  final String description;
  final IconData icon;
  final bool isUnlocked;
  final double? progress;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return CartoonCard(
      variant: isUnlocked ? CardVariant.celebration : CardVariant.surface,
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: isUnlocked ? AppColors.sunnyYellow : AppColors.grey300,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 32,
              color: isUnlocked ? AppColors.white : AppColors.grey500,
            ),
          ),
          const SizedBox(width: AppTheme.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color:
                        isUnlocked
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingXS),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        isUnlocked
                            ? AppColors.textSecondary
                            : AppColors.textTertiary,
                  ),
                ),
                if (progress != null && !isUnlocked) ...[
                  const SizedBox(height: AppTheme.spacingS),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppColors.grey200,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
