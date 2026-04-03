import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';

class AuthSplitShell extends StatelessWidget {
  const AuthSplitShell({
    required this.form,
    required this.showcase,
    super.key,
  });

  final Widget form;
  final Widget showcase;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: form,
          ),
        ),
        Expanded(child: showcase),
      ],
    );
  }
}
