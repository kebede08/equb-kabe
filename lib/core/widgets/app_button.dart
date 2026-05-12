import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum ButtonVariant { primary, secondary, outline, text }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final bool isLoading;
  final bool isDisabled;
  final IconData? icon;
  final double? width;
  final double height;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.width,
    this.height = 52,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = !isLoading && !isDisabled && onPressed != null;

    Widget child = isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18),
                const SizedBox(width: 8),
              ],
              Text(label),
            ],
          );

    switch (variant) {
      case ButtonVariant.primary:
        return SizedBox(
          width: width ?? double.infinity,
          height: height,
          child: ElevatedButton(
            onPressed: isEnabled ? onPressed : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: isEnabled ? AppColors.primary : AppColors.border,
              foregroundColor: AppColors.textWhite,
            ),
            child: child,
          ),
        );
      case ButtonVariant.secondary:
        return SizedBox(
          width: width ?? double.infinity,
          height: height,
          child: ElevatedButton(
            onPressed: isEnabled ? onPressed : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              foregroundColor: AppColors.textWhite,
            ),
            child: child,
          ),
        );
      case ButtonVariant.outline:
        return SizedBox(
          width: width ?? double.infinity,
          height: height,
          child: OutlinedButton(
            onPressed: isEnabled ? onPressed : null,
            child: child,
          ),
        );
      case ButtonVariant.text:
        return TextButton(
          onPressed: isEnabled ? onPressed : null,
          child: child,
        );
    }
  }
}
