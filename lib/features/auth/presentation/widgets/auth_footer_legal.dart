import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';

class AuthFooterLegal extends StatelessWidget {
  const AuthFooterLegal({super.key});

  void _stub(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label coming soon.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelSmall?.copyWith(
          letterSpacing: 1.0,
          color: AppColors.authSubtleForeground,
        );
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.xs,
      children: [
        TextButton(
          onPressed: () => _stub(context, 'Terms of Service'),
          child: Text('TERMS OF SERVICE', style: style),
        ),
        TextButton(
          onPressed: () => _stub(context, 'Privacy Policy'),
          child: Text('PRIVACY POLICY', style: style),
        ),
        TextButton(
          onPressed: () => _stub(context, 'Help Center'),
          child: Text('HELP CENTER', style: style),
        ),
      ],
    );
  }
}
