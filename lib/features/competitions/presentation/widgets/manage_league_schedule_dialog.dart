import 'package:flutter/material.dart';

import '../../../../core/utils/app_datetime_format.dart';

/// Returns new kickoff time only (match week is unchanged in Firestore).
Future<DateTime?> showManageLeagueKickoffDialog(
  BuildContext context, {
  required DateTime initialKickoffAt,
}) async {
  var selected = initialKickoffAt;

  return showDialog<DateTime>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setLocalState) {
        return AlertDialog(
          title: const Text('Change kickoff time'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Only the date and time are updated. Match week stays the same.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              Text(
                'Current: ${AppDateTimeFormat.kickoffFull(selected)}',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: selected,
                    firstDate: DateTime.now().subtract(const Duration(days: 365)),
                    lastDate: DateTime.now().add(const Duration(days: 3650)),
                  );
                  if (date == null || !context.mounted) return;
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(selected),
                  );
                  if (time == null) return;
                  setLocalState(() {
                    selected = DateTime(date.year, date.month, date.day, time.hour, time.minute);
                  });
                },
                icon: const Icon(Icons.schedule),
                label: const Text('Pick date & time'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(selected),
              child: const Text('Save'),
            ),
          ],
        );
      },
    ),
  );
}
