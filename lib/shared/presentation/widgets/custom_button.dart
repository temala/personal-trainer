import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';
import '../themes/app_theme.dart';

/// Button variants for different visual styles
enum ButtonVariant { filled, outlined, text, gradient }

/// Custom button widget with cartoon-style design and consistent styling
class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.variant = ButtonVariant.filled,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height = 56,
    this.fontSize = 16,
    this.borderRadius,
    this.color,
    this.textColor,
    this.borderColor,
    this.loadingColor,
    this.gradient,
  });

  final VoidCallback? onPressed;
  final String text;
  final ButtonVariant variant;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final double height;
  final double fontSize;
  final double? borderRadius;
  final Color? color;
  final Color? textColor;
  final Color? borderColor;
  final Color? loadingColor;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = borderRadius ?? AppTheme.radiusM;
    final primaryColor = color ?? AppColors.primary;
    final isDisabled = onPressed == null || isLoading;

    final Widget child = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                loadingColor ?? _getTextColor(context),
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacingM),
        ] else if (icon != null) ...[
          Icon(icon, size: 20, color: _getTextColor(context)),
          const SizedBox(width: AppTheme.spacingS),
        ],
        Flexible(
          child: Text(
            text,
            style: AppTextStyles.buttonText.copyWith(
              fontSize: fontSize,
              color: _getTextColor(context),
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );

    Widget button;

    switch (variant) {
      case ButtonVariant.filled:
        button = ElevatedButton(
          onPressed: isDisabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: textColor ?? AppColors.textOnPrimary,
            disabledBackgroundColor: AppColors.grey300,
            disabledForegroundColor: AppColors.grey500,
            elevation: isDisabled ? 0 : AppTheme.elevationMedium,
            shadowColor: primaryColor.withValues(alpha: 0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(effectiveBorderRadius),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingL,
              vertical: AppTheme.spacingM,
            ),
            minimumSize: Size(width ?? 0, height),
          ),
          child: child,
        );

      case ButtonVariant.outlined:
        button = OutlinedButton(
          onPressed: isDisabled ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: textColor ?? primaryColor,
            disabledForegroundColor: AppColors.grey500,
            side: BorderSide(
              color:
                  isDisabled
                      ? AppColors.grey300
                      : (borderColor ?? primaryColor),
              width: 2,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(effectiveBorderRadius),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingL,
              vertical: AppTheme.spacingM,
            ),
            minimumSize: Size(width ?? 0, height),
          ),
          child: child,
        );

      case ButtonVariant.text:
        button = TextButton(
          onPressed: isDisabled ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: textColor ?? primaryColor,
            disabledForegroundColor: AppColors.grey500,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(effectiveBorderRadius),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingL,
              vertical: AppTheme.spacingM,
            ),
            minimumSize: Size(width ?? 0, height),
          ),
          child: child,
        );

      case ButtonVariant.gradient:
        button = Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            gradient:
                gradient ??
                const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
            borderRadius: BorderRadius.circular(effectiveBorderRadius),
            boxShadow:
                isDisabled
                    ? null
                    : [
                      BoxShadow(
                        color: primaryColor.withValues(alpha: 0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isDisabled ? null : onPressed,
              borderRadius: BorderRadius.circular(effectiveBorderRadius),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingL,
                  vertical: AppTheme.spacingM,
                ),
                child: child,
              ),
            ),
          ),
        );
    }

    return SizedBox(width: width, height: height, child: button);
  }

  Color _getTextColor(BuildContext context) {
    if (isLoading && loadingColor != null) {
      return loadingColor!;
    }

    if (textColor != null) {
      return textColor!;
    }

    switch (variant) {
      case ButtonVariant.filled:
      case ButtonVariant.gradient:
        return AppColors.textOnPrimary;
      case ButtonVariant.outlined:
      case ButtonVariant.text:
        return color ?? AppColors.primary;
    }
  }
}
