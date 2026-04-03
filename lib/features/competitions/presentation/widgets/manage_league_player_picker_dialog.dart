import 'package:flutter/material.dart';

Future<String?> showManageLeaguePlayerPickerDialog(
  BuildContext context, {
  required String title,
  required List<String> options,
}) {
  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final name in options)
            ListTile(
              title: Text(name),
              onTap: () => Navigator.of(context).pop(name),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    ),
  );
}

