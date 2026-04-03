import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';

class AuthInputField extends StatelessWidget {
  const AuthInputField({
    required this.hint,
    required this.icon,
    this.label,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.suffix,
    super.key,
  });

  final String hint;
  final IconData icon;
  final String? label;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    final field = TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: const TextStyle(color: AppColors.authForeground),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.authInputHint),
        prefixIcon: Icon(icon, color: AppColors.authSubtleForeground),
        suffixIcon: suffix,
        filled: true,
        fillColor: AppColors.authInputBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
      ),
    );
    if (label == null) return field;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label!,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                letterSpacing: 1.4,
                color: AppColors.authSubtleForeground,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: AppSpacing.sm),
        field,
      ],
    );
  }
}
