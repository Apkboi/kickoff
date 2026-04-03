import 'package:flutter/material.dart';

Future<String?> showManageLeagueStreamLinkDialog(BuildContext context) async {
  final controller = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final value = await showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Add streaming link'),
      content: Form(
        key: formKey,
        child: TextFormField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.url,
          decoration: const InputDecoration(
            labelText: 'Stream URL',
            hintText: 'https://...',
          ),
          validator: (value) {
            final text = (value ?? '').trim();
            if (text.isEmpty) return 'Streaming link is required';
            final uri = Uri.tryParse(text);
            final isHttp = uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
            return isHttp ? null : 'Enter a valid http/https URL';
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (formKey.currentState?.validate() != true) return;
            Navigator.of(context).pop(controller.text.trim());
          },
          child: const Text('Start match'),
        ),
      ],
    ),
  );
  // controller.dispose();
  return value;
}

