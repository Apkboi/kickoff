import 'package:flutter/material.dart';

Future<String?> showManageLeagueEndLeagueDialog(BuildContext context) async {
  final controller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('End league'),
      content: Form(
        key: formKey,
        child: TextFormField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Winner name',
            hintText: 'Team or player declared champion',
          ),
          validator: (v) {
            if (v == null || v.trim().isEmpty) return 'Enter a winner';
            return null;
          },
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        FilledButton(
          onPressed: () {
            if (formKey.currentState?.validate() != true) return;
            Navigator.of(context).pop(controller.text.trim());
          },
          child: const Text('Confirm'),
        ),
      ],
    ),
  );
}
