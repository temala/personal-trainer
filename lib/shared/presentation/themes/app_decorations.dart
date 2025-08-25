import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_theme.dart';

/// Decorations and styling utilities for the cartoon fitness app
class AppDecorations {
  // Card decorations
  static BoxDecoration get primaryCard => BoxDecoration(
    gradient: const LinearGradient(
      colors: [AppColors.primary, AppColors.primaryLight],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(AppTheme.radiusL),
    boxShadow: [
      BoxShadow(
        color: AppColors.primary.withValues(alpha: 0.3),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static BoxDecoration get secondaryCard => BoxDecoration(
    gradient: const LinearGradient(
      colors: [AppColors.secondary, AppColors.secondaryLight],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(AppTheme.radiusL),
    boxShadow: [
      BoxShadow(
        color: AppColors.secondary.withValues(alpha: 0.3),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static BoxDecoration get accentCard => BoxDecoration(
    gradient: const LinearGradient(
      colors: [AppColors.accent, AppColors.accentLight],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(AppTheme.radiusL),
    boxShadow: [
      BoxShadow(
        color: AppColors.accent.withValues(alpha: 0.3),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static BoxDecoration get surfaceCard => BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(AppTheme.radiusL),
    boxShadow: [
      BoxShadow(
        color: AppColors.shadowLight,
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );

  static BoxDecoration get elevatedCard => BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(AppTheme.radiusL),
    boxShadow: [
      BoxShadow(
        color: AppColors.shadowMedium,
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],
  );

  // Exercise category cards
  static BoxDecoration exerciseCategoryCard(String category) => BoxDecoration(
    gradient: LinearGradient(
      colors: [
        AppColors.getExerciseCategoryColor(category),
        AppColors.getExerciseCategoryColor(category).withValues(alpha: 0.7),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(AppTheme.radiusL),
    boxShadow: [
      BoxShadow(
        color: AppColors.getExerciseCategoryColor(
          category,
        ).withValues(alpha: 0.3),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ],
  );

  // Button decorations
  static BoxDecoration get primaryButton => BoxDecoration(
    gradient: const LinearGradient(
      colors: [AppColors.primary, AppColors.primaryLight],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(AppTheme.radiusM),
    boxShadow: [
      BoxShadow(
        color: AppColors.primary.withValues(alpha: 0.4),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static BoxDecoration get secondaryButton => BoxDecoration(
    gradient: const LinearGradient(
      colors: [AppColors.secondary, AppColors.secondaryLight],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(AppTheme.radiusM),
    boxShadow: [
      BoxShadow(
        color: AppColors.secondary.withValues(alpha: 0.4),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static BoxDecoration get outlinedButton => BoxDecoration(
    color: AppColors.surface,
    border: Border.all(color: AppColors.primary, width: 2),
    borderRadius: BorderRadius.circular(AppTheme.radiusM),
    boxShadow: [
      BoxShadow(
        color: AppColors.shadowLight,
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ],
  );

  // Progress decorations
  static BoxDecoration get progressBackground => BoxDecoration(
    color: AppColors.grey200,
    borderRadius: BorderRadius.circular(AppTheme.radiusCircular),
  );

  static BoxDecoration get progressForeground => BoxDecoration(
    gradient: const LinearGradient(
      colors: [AppColors.primary, AppColors.accent],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ),
    borderRadius: BorderRadius.circular(AppTheme.radiusCircular),
    boxShadow: [
      BoxShadow(
        color: AppColors.primary.withValues(alpha: 0.3),
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ],
  );

  // Celebration decorations
  static BoxDecoration get celebrationCard => BoxDecoration(
    gradient: const LinearGradient(
      colors: [
        AppColors.sunnyYellow,
        AppColors.energyOrange,
        AppColors.secondary,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(AppTheme.radiusXL),
    boxShadow: [
      BoxShadow(
        color: AppColors.sunnyYellow.withValues(alpha: 0.4),
        blurRadius: 16,
        offset: const Offset(0, 8),
      ),
    ],
  );

  // Input field decorations
  static InputDecoration inputDecoration({
    required String labelText,
    String? hintText,
    IconData? prefixIcon,
    Widget? suffixIcon,
    bool hasError = false,
  }) => InputDecoration(
    labelText: labelText,
    hintText: hintText,
    prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
    suffixIcon: suffixIcon,
    filled: true,
    fillColor: AppColors.surface,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppTheme.radiusM),
      borderSide: BorderSide(
        color: hasError ? AppColors.error : AppColors.grey300,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppTheme.radiusM),
      borderSide: const BorderSide(color: AppColors.grey300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppTheme.radiusM),
      borderSide: const BorderSide(color: AppColors.primary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppTheme.radiusM),
      borderSide: const BorderSide(color: AppColors.error, width: 2),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppTheme.radiusM),
      borderSide: const BorderSide(color: AppColors.error, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppTheme.spacingM,
      vertical: AppTheme.spacingM,
    ),
  );

  // Container decorations
  static BoxDecoration get glassMorphism => BoxDecoration(
    color: AppColors.white.withValues(alpha: 0.2),
    borderRadius: BorderRadius.circular(AppTheme.radiusL),
    border: Border.all(color: AppColors.white.withValues(alpha: 0.3)),
    boxShadow: [
      BoxShadow(
        color: AppColors.shadowLight,
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static BoxDecoration get neuMorphism => BoxDecoration(
    color: AppColors.background,
    borderRadius: BorderRadius.circular(AppTheme.radiusL),
    boxShadow: [
      BoxShadow(
        color: AppColors.white,
        blurRadius: 10,
        offset: const Offset(-5, -5),
      ),
      BoxShadow(
        color: AppColors.shadowLight,
        blurRadius: 10,
        offset: const Offset(5, 5),
      ),
    ],
  );

  // Animation decorations
  static BoxDecoration get pulsingDecoration => BoxDecoration(
    gradient: const LinearGradient(
      colors: [AppColors.primary, AppColors.accent],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(AppTheme.radiusCircular),
    boxShadow: [
      BoxShadow(
        color: AppColors.primary.withValues(alpha: 0.6),
        blurRadius: 20,
        spreadRadius: 5,
      ),
    ],
  );

  // Status decorations
  static BoxDecoration successDecoration = BoxDecoration(
    color: AppColors.success,
    borderRadius: BorderRadius.circular(AppTheme.radiusS),
    boxShadow: [
      BoxShadow(
        color: AppColors.success.withValues(alpha: 0.3),
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ],
  );

  static BoxDecoration warningDecoration = BoxDecoration(
    color: AppColors.warning,
    borderRadius: BorderRadius.circular(AppTheme.radiusS),
    boxShadow: [
      BoxShadow(
        color: AppColors.warning.withValues(alpha: 0.3),
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ],
  );

  static BoxDecoration errorDecoration = BoxDecoration(
    color: AppColors.error,
    borderRadius: BorderRadius.circular(AppTheme.radiusS),
    boxShadow: [
      BoxShadow(
        color: AppColors.error.withValues(alpha: 0.3),
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ],
  );

  // Utility methods
  static BoxDecoration customGradientCard({
    required List<Color> colors,
    double borderRadius = 16,
    double shadowBlur = 8,
    Offset shadowOffset = const Offset(0, 4),
    double shadowOpacity = 0.3,
  }) => BoxDecoration(
    gradient: LinearGradient(
      colors: colors,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(borderRadius),
    boxShadow: [
      BoxShadow(
        color: colors.first.withValues(alpha: shadowOpacity),
        blurRadius: shadowBlur,
        offset: shadowOffset,
      ),
    ],
  );

  static BoxDecoration customBorderCard({
    Color borderColor = AppColors.primary,
    double borderWidth = 2,
    double borderRadius = 16,
    Color backgroundColor = AppColors.surface,
  }) => BoxDecoration(
    color: backgroundColor,
    border: Border.all(color: borderColor, width: borderWidth),
    borderRadius: BorderRadius.circular(borderRadius),
    boxShadow: [
      BoxShadow(
        color: AppColors.shadowLight,
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ],
  );
}
