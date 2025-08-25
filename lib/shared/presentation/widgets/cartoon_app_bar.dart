import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';
import '../themes/app_theme.dart';

/// Cartoon-style app bar with gradient background and custom styling
class CartoonAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CartoonAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.backgroundColor,
    this.gradient,
    this.elevation = 0,
    this.centerTitle = true,
    this.titleStyle,
    this.iconColor,
    this.showBackButton = true,
  });

  final String? title;
  final Widget? leading;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Gradient? gradient;
  final double elevation;
  final bool centerTitle;
  final TextStyle? titleStyle;
  final Color? iconColor;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    final effectiveIconColor = iconColor ?? AppColors.textPrimary;
    final effectiveTitleStyle = titleStyle ?? AppTextStyles.appBarTitle;

    Widget appBar = AppBar(
      title: title != null ? Text(title!, style: effectiveTitleStyle) : null,
      leading:
          leading ??
          (showBackButton && Navigator.canPop(context)
              ? IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: effectiveIconColor,
                ),
                onPressed: () => Navigator.pop(context),
              )
              : null),
      actions: actions,
      backgroundColor: backgroundColor ?? Colors.transparent,
      elevation: elevation,
      centerTitle: centerTitle,
      iconTheme: IconThemeData(color: effectiveIconColor),
      actionsIconTheme: IconThemeData(color: effectiveIconColor),
    );

    if (gradient != null) {
      return Container(
        decoration: BoxDecoration(gradient: gradient),
        child: appBar,
      );
    }

    return appBar;
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Specialized app bar for workout screens
class WorkoutAppBar extends StatelessWidget implements PreferredSizeWidget {
  const WorkoutAppBar({
    super.key,
    required this.title,
    this.progress,
    this.onClose,
    this.actions,
  });

  final String title;
  final double? progress;
  final VoidCallback? onClose;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            AppBar(
              title: Text(
                title,
                style: AppTextStyles.appBarTitle.copyWith(
                  color: AppColors.white,
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.close_rounded, color: AppColors.white),
                onPressed: onClose ?? () => Navigator.pop(context),
              ),
              actions: actions,
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              iconTheme: const IconThemeData(color: AppColors.white),
            ),
            if (progress != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingM,
                ),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppColors.white.withValues(alpha: 0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.white,
                  ),
                  minHeight: 4,
                ),
              ),
              const SizedBox(height: AppTheme.spacingS),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(
    kToolbarHeight + 24 + 44, // Approximate safe area height
  );
}

/// Specialized app bar for celebration screens
class CelebrationAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CelebrationAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.onClose,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.sunnyYellow,
            AppColors.energyOrange,
            AppColors.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.celebrationText.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: AppTheme.spacingXS),
                      Text(
                        subtitle!,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (onClose != null)
                IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppColors.white,
                    size: 28,
                  ),
                  onPressed: onClose,
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(120);
}
