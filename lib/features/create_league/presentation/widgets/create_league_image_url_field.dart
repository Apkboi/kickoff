import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';
import 'create_league_field_decoration.dart';

class CreateLeagueImageUrlField extends StatelessWidget {
  const CreateLeagueImageUrlField({
    required this.label,
    required this.controller,
    required this.uploading,
    required this.errorText,
    required this.onUploadTap,
    super.key,
  });

  final String label;
  final TextEditingController controller;
  final bool uploading;
  final String? errorText;
  final VoidCallback onUploadTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: DashboardColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.url,
                style: const TextStyle(color: DashboardColors.textPrimary),
                decoration: createLeagueFilledInputDecoration(hint: 'https://… or upload'),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            SizedBox(
              height: 52,
              child: OutlinedButton.icon(
                onPressed: uploading ? null : onUploadTap,
                style: OutlinedButton.styleFrom(
                  foregroundColor: DashboardColors.accentGreen,
                  side: const BorderSide(color: DashboardColors.accentGreen),
                ),
                icon: uploading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: DashboardColors.accentGreen),
                      )
                    : const Icon(Icons.cloud_upload_outlined, size: 20),
                label: Text(uploading ? '…' : 'Upload'),
              ),
            ),
          ],
        ),
        if (errorText != null && errorText!.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            errorText!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: DashboardColors.liveBadge,
                ),
          ),
        ],
      ],
    );
  }
}
