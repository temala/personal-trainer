import 'package:flutter/material.dart';

/// Extended color palette for the cartoon fitness app
class AppColors {
  // Primary brand colors
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryLight = Color(0xFF9C88FF);
  static const Color primaryDark = Color(0xFF5A52E8);

  static const Color secondary = Color(0xFFFF6B9D);
  static const Color secondaryLight = Color(0xFFFF8FA3);
  static const Color secondaryDark = Color(0xFFE85A8A);

  static const Color accent = Color(0xFF4ECDC4);
  static const Color accentLight = Color(0xFF7EDDD6);
  static const Color accentDark = Color(0xFF3BB5AD);

  // Cartoon character colors
  static const Color sunnyYellow = Color(0xFFFFD93D);
  static const Color energyOrange = Color(0xFFFF8C42);
  static const Color freshGreen = Color(0xFF6BCF7F);
  static const Color skyBlue = Color(0xFF4FC3F7);
  static const Color lavenderPurple = Color(0xFFBA68C8);
  static const Color coralPink = Color(0xFFFF7A85);
  static const Color mintGreen = Color(0xFF98E4D6);
  static const Color peachOrange = Color(0xFFFFB347);

  // Exercise category colors
  static const Color cardioColor = Color(0xFFFF6B6B);
  static const Color strengthColor = Color(0xFF4ECDC4);
  static const Color flexibilityColor = Color(0xFFFFE66D);
  static const Color balanceColor = Color(0xFFBA68C8);
  static const Color enduranceColor = Color(0xFF4FC3F7);

  // Status and feedback colors
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFF81C784);
  static const Color successDark = Color(0xFF388E3C);

  static const Color warning = Color(0xFFFF9800);
  static const Color warningLight = Color(0xFFFFB74D);
  static const Color warningDark = Color(0xFFF57C00);

  static const Color error = Color(0xFFFF5252);
  static const Color errorLight = Color(0xFFFF8A80);
  static const Color errorDark = Color(0xFFD32F2F);

  static const Color info = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFF64B5F6);
  static const Color infoDark = Color(0xFF1976D2);

  // Neutral colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // Background colors
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFFFFBFE);
  static const Color surfaceTint = Color(0xFFF0F2F5);

  // Text colors
  static const Color textPrimary = Color(0xFF2D3748);
  static const Color textSecondary = Color(0xFF718096);
  static const Color textTertiary = Color(0xFFA0AEC0);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnSecondary = Color(0xFFFFFFFF);
  static const Color textOnSurface = Color(0xFF2D3748);

  // Shadow colors
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowMedium = Color(0x33000000);
  static const Color shadowDark = Color(0x4D000000);

  // Celebration colors for animations
  static const List<Color> celebrationColors = [
    sunnyYellow,
    energyOrange,
    secondary,
    accent,
    lavenderPurple,
    coralPink,
  ];

  // Progress colors
  static const List<Color> progressColors = [
    Color(0xFFFF6B6B), // Beginner - Red
    Color(0xFFFFE66D), // Intermediate - Yellow
    Color(0xFF4ECDC4), // Advanced - Teal
    Color(0xFF6C63FF), // Expert - Purple
  ];

  // Workout intensity colors
  static const Color lowIntensity = Color(0xFF81C784);
  static const Color mediumIntensity = Color(0xFFFFB74D);
  static const Color highIntensity = Color(0xFFFF8A65);
  static const Color maxIntensity = Color(0xFFE57373);

  /// Get color by exercise category
  static Color getExerciseCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'cardio':
        return cardioColor;
      case 'strength':
        return strengthColor;
      case 'flexibility':
        return flexibilityColor;
      case 'balance':
        return balanceColor;
      case 'endurance':
        return enduranceColor;
      default:
        return primary;
    }
  }

  /// Get color by workout intensity
  static Color getIntensityColor(String intensity) {
    switch (intensity.toLowerCase()) {
      case 'low':
        return lowIntensity;
      case 'medium':
        return mediumIntensity;
      case 'high':
        return highIntensity;
      case 'max':
        return maxIntensity;
      default:
        return mediumIntensity;
    }
  }

  /// Get progress color by level
  static Color getProgressColor(int level) {
    if (level < 0 || level >= progressColors.length) {
      return progressColors.first;
    }
    return progressColors[level];
  }

  /// Get random celebration color
  static Color getRandomCelebrationColor() {
    return celebrationColors[DateTime.now().millisecondsSinceEpoch %
        celebrationColors.length];
  }
}
