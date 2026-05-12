import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary - Phoenixopia Orange
  static const Color primary = Color(0xFFF97316);
  static const Color primaryLight = Color(0xFFFED7AA);
  static const Color primaryDark = Color(0xFFEA580C);

  // Secondary - Finance Green
  static const Color secondary = Color(0xFF16A34A);
  static const Color secondaryLight = Color(0xFFBBF7D0);
  static const Color secondaryDark = Color(0xFF15803D);

  // Background
  static const Color background = Color(0xFFF9FAFB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF3F4F6);

  // Text
  static const Color textDark = Color(0xFF111827);
  static const Color textGray = Color(0xFF6B7280);
  static const Color textLight = Color(0xFF9CA3AF);
  static const Color textWhite = Color(0xFFFFFFFF);

  // Status
  static const Color error = Color(0xFFDC2626);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color success = Color(0xFF22C55E);
  static const Color successLight = Color(0xFFDCFCE7);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFDBEAFE);

  // Status Badges
  static const Color paid = Color(0xFF22C55E);
  static const Color pending = Color(0xFFF59E0B);
  static const Color late = Color(0xFFDC2626);

  // Border
  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFF3F4F6);

  // Shadow
  static const Color shadow = Color(0x1A000000);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFF97316), Color(0xFFEA580C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFF97316), Color(0xFFDC2626)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
