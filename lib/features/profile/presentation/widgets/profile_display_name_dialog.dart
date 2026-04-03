import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/dashboard_colors.dart';
import '../controllers/profile_bloc.dart';
import '../controllers/profile_event.dart';

void showProfileDisplayNameDialog(BuildContext context, String current) {
  final controller = TextEditingController(text: current);
  showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: DashboardColors.bgCard,
      title: const Text('Display name', style: TextStyle(color: DashboardColors.textPrimary)),
      content: TextField(
        controller: controller,
        style: const TextStyle(color: DashboardColors.textPrimary),
        decoration: const InputDecoration(
          hintText: 'Your name',
          hintStyle: TextStyle(color: DashboardColors.textSecondary),
        ),
        autofocus: true,
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
        TextButton(
          onPressed: () {
            context.read<ProfileBloc>().add(ProfileDisplayNameSubmitted(controller.text));
            Navigator.pop(ctx);
          },
          child: const Text('Save'),
        ),
      ],
    ),
  );
}
