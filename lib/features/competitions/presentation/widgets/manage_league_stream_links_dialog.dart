import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/models/stream_link.dart';

/// Returns chosen links (may be empty), or null if cancelled.
Future<List<StreamLink>?> showManageLeagueStreamLinksDialog(BuildContext context) {
  return showDialog<List<StreamLink>>(
    context: context,
    builder: (context) => const _StreamLinksDialogBody(),
  );
}

class _StreamLinksDialogBody extends StatefulWidget {
  const _StreamLinksDialogBody();

  @override
  State<_StreamLinksDialogBody> createState() => _StreamLinksDialogBodyState();
}

class _StreamLinksDialogBodyState extends State<_StreamLinksDialogBody> {
  final _rows = <_LinkRow>[
    _LinkRow(),
  ];

  @override
  void dispose() {
    for (final r in _rows) {
      r.dispose();
    }
    super.dispose();
  }

  void _addRow() {
    if (_rows.length >= 6) return;
    setState(() => _rows.add(_LinkRow()));
  }

  /// True if every non-empty URL is valid http(s). Empty rows are OK.
  bool _validateUrls() {
    for (final r in _rows) {
      final url = r.urlCtrl.text.trim();
      if (url.isEmpty) continue;
      final uri = Uri.tryParse(url);
      final isHttp = uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
      if (!isHttp) return false;
    }
    return true;
  }

  void _submit() {
    if (!_validateUrls()) return;
    final out = <StreamLink>[];
    for (final r in _rows) {
      final label = r.labelCtrl.text.trim();
      final url = r.urlCtrl.text.trim();
      if (url.isEmpty) continue;
      out.add(StreamLink(label: label.isEmpty ? 'Stream' : label, url: url));
    }
    Navigator.of(context).pop(out);
  }

  void _startWithoutLinks() {
    Navigator.of(context).pop(<StreamLink>[]);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Streaming links'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Streaming is optional. Add links or start the match without them.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.md),
            for (var i = 0; i < _rows.length; i++) ...[
              TextField(
                controller: _rows[i].labelCtrl,
                decoration: const InputDecoration(labelText: 'Platform / title'),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: _rows[i].urlCtrl,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  labelText: 'URL',
                  hintText: 'https://...',
                ),
              ),
              if (i < _rows.length - 1) const SizedBox(height: AppSpacing.md),
            ],
            TextButton.icon(
              onPressed: _addRow,
              icon: const Icon(Icons.add),
              label: const Text('Add another link'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _startWithoutLinks,
          child: const Text('Start without stream'),
        ),
        FilledButton(
          onPressed: _submit,
          child: const Text('Start match'),
        ),
      ],
    );
  }
}

class _LinkRow {
  _LinkRow() : labelCtrl = TextEditingController(), urlCtrl = TextEditingController();

  final TextEditingController labelCtrl;
  final TextEditingController urlCtrl;

  void dispose() {
    labelCtrl.dispose();
    urlCtrl.dispose();
  }
}
