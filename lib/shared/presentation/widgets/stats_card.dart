import 'package:flutter/material.dart';

import 'package:fitness_training_app/shared/presentation/themes/app_colors.dart';
import 'package:fitness_training_app/shared/presentation/themes/app_text_styles.dart';
import 'package:fitness_training_app/shared/presentation/themes/app_theme.dart';
import 'package:fitness_training_app/shared/presentation/widgets/cartoon_card.dart';

/// A card widget for displaying user statistics
class StatsCard extends StatelessWidget {
  const StatsCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.subtitle,
    required this.color,
    super.key,
  });

  final String title;
  final String value;
  final IconData icon;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CartoonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: AppTheme.spacingS),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingM),
          Flexible(
            child: Text(
              value,
              style: AppTextStyles.headlineMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: AppTheme.spacingXS),
          Flexible(
            child: Text(
              subtitle,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
