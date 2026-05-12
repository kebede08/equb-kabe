import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  final double fontSize;

  const StatusBadge({
    super.key,
    required this.status,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getConfig(status.toLowerCase());
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        config.label,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: config.textColor,
        ),
      ),
    );
  }

  _BadgeConfig _getConfig(String status) {
    switch (status) {
      case 'paid':
      case 'approved':
      case 'active':
      case 'completed':
        return _BadgeConfig(
          label: status.toUpperCase(),
          backgroundColor: AppColors.successLight,
          textColor: AppColors.secondary,
        );
      case 'pending':
        return _BadgeConfig(
          label: 'PENDING',
          backgroundColor: AppColors.warningLight,
          textColor: AppColors.warning,
        );
      case 'late':
      case 'rejected':
      case 'overdue':
        return _BadgeConfig(
          label: status.toUpperCase(),
          backgroundColor: AppColors.errorLight,
          textColor: AppColors.error,
        );
      default:
        return _BadgeConfig(
          label: status.toUpperCase(),
          backgroundColor: AppColors.infoLight,
          textColor: AppColors.info,
        );
    }
  }
}

class _BadgeConfig {
  final String label;
  final Color backgroundColor;
  final Color textColor;

  _BadgeConfig({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });
}
