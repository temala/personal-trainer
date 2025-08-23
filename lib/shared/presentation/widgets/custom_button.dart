import 'package:flutter/material.dart';

/// Button variants
enum ButtonVariant { filled, outlined, text }

/// Custom button widget with consistent styling
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
    this.borderRadius = 12,
    this.color,
    this.textColor,
    this.borderColor,
    this.loadingColor,
  });

  final VoidCallback? onPressed;
  final String text;
  final ButtonVariant variant;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final double height;
  final double fontSize;
  final double borderRadius;
  final Color? color;
  final Color? textColor;
  final Color? borderColor;
  final Color? loadingColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = color ?? theme.primaryColor;
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
          const SizedBox(width: 12),
        ] else if (icon != null) ...[
          Icon(icon, size: 20, color: _getTextColor(context)),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
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
            foregroundColor: textColor ?? Colors.white,
            disabledBackgroundColor: Colors.grey[300],
            disabledForegroundColor: Colors.grey[500],
            elevation: isDisabled ? 0 : 2,
            shadowColor: primaryColor.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            minimumSize: Size(width ?? 0, height),
          ),
          child: child,
        );

      case ButtonVariant.outlined:
        button = OutlinedButton(
          onPressed: isDisabled ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: textColor ?? primaryColor,
            disabledForegroundColor: Colors.grey[500],
            side: BorderSide(
              color:
                  isDisabled
                      ? Colors.grey[300]!
                      : (borderColor ?? primaryColor),
              width: 1.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            minimumSize: Size(width ?? 0, height),
          ),
          child: child,
        );

      case ButtonVariant.text:
        button = TextButton(
          onPressed: isDisabled ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: textColor ?? primaryColor,
            disabledForegroundColor: Colors.grey[500],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            minimumSize: Size(width ?? 0, height),
          ),
          child: child,
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
        return Colors.white;
      case ButtonVariant.outlined:
      case ButtonVariant.text:
        return color ?? Theme.of(context).primaryColor;
    }
  }
}
