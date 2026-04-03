import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';
import '../../../../core/utils/app_datetime_format.dart';
import '../../domain/entities/match_prediction_view_entity.dart';

/// Score inputs + save / change / success (used from [MatchPredictionPanel]).
class MatchPredictionInputsSection extends StatelessWidget {
  const MatchPredictionInputsSection({
    required this.data,
    required this.actionError,
    required this.homeCtrl,
    required this.awayCtrl,
    required this.fieldsReadOnly,
    required this.submitting,
    required this.showSuccess,
    required this.showChangeButton,
    required this.onSubmit,
    required this.onChangePressed,
    super.key,
  });

  final MatchPredictionViewEntity data;
  final String? actionError;
  final TextEditingController homeCtrl;
  final TextEditingController awayCtrl;
  final bool fieldsReadOnly;
  final bool submitting;
  final bool showSuccess;
  /// Existing server prediction: show Change instead of Save until user edits.
  final bool showChangeButton;
  final VoidCallback onSubmit;
  final VoidCallback onChangePressed;

  @override
  Widget build(BuildContext context) {
    final d = data;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (d.predictionClosesAt != null)
          Text(
            'Closes: ${AppDateTimeFormat.kickoffFull(d.predictionClosesAt!)}',
            style: const TextStyle(color: DashboardColors.accentNeon, fontWeight: FontWeight.w600),
          ),
        if (showSuccess) ...[
          const SizedBox(height: AppSpacing.sm),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: DashboardColors.accentGreen.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppRadius.button),
              border: Border.all(color: DashboardColors.accentGreen.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: DashboardColors.accentGreen, size: 20),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Prediction saved',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: DashboardColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(child: _scoreField(context, 'Home', homeCtrl, readOnly: fieldsReadOnly)),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: _scoreField(context, 'Away', awayCtrl, readOnly: fieldsReadOnly)),
          ],
        ),
        if (actionError != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            actionError!,
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
              fontSize: 12,
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.md),
        if (showChangeButton)
          OutlinedButton(
            onPressed: onChangePressed,
            child: const Text('Change prediction'),
          )
        else
          FilledButton(
            onPressed: (!submitting && !fieldsReadOnly) ? onSubmit : null,
            child: submitting
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save prediction'),
          ),
      ],
    );
  }

  Widget _scoreField(
    BuildContext context,
    String label,
    TextEditingController c, {
    required bool readOnly,
  }) {
    return TextField(
      controller: c,
      readOnly: readOnly,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(2)],
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: readOnly ? DashboardColors.bgCard : DashboardColors.bgSurface,
      ),
    );
  }
}
