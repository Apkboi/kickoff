import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color accentGreen = Color(0xFF25C26E);
  /// Plan: accent green `#00E676`
  static const Color authPrimary = Color(0xFF00E676);
  static const Color authPrimaryForeground = Color(0xFF072216);
  static const Color authGradientStart = Color(0xFF1D9E75);
  static const Color authGradientEnd = Color(0xFF00E676);
  /// Plan: background primary `#0D1B0F`
  static const Color authBackgroundStart = Color(0xFF0D1B0F);
  static const Color authBackgroundEnd = Color(0xFF0A2818);
  /// Plan: surface `#1A2E1C`
  static const Color authInputBackground = Color(0xFF1A2E1C);
  static const Color authInputHint = Color(0xFF74857E);
  static const Color authForeground = Color(0xFFFFFFFF);
  /// Plan: text secondary `#A0B8A2`
  static const Color authSubtleForeground = Color(0xFFA0B8A2);
  static const Color authGlassFill = Color(0x1AFFFFFF);
  static const Color authGlassBorder = Color(0x402A4A2C);
  static const Color authRatingStar = Color(0xFFFFC107);

  static Color backgroundCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? const Color(0xFF1D1D1F) : const Color(0xFFFFFFFF);
  }

  static Color scaffoldBackground(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? const Color(0xFF121212) : const Color(0xFFF5F6F8);
  }

  static Color error(BuildContext context) {
    return Theme.of(context).colorScheme.error;
  }
}
