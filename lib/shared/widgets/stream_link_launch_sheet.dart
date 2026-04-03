import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/models/stream_link.dart';
import '../../core/theme/dashboard_colors.dart';

/// Opens one URL or shows a bottom sheet when [links] has more than one entry.
Future<void> launchStreamLinksOrSheet(BuildContext context, List<StreamLink> links) async {
  if (links.isEmpty) return;
  if (links.length == 1) {
    final uri = Uri.tryParse(links.first.url);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
    return;
  }
  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Text(
                'Choose stream',
                style: Theme.of(ctx).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
            ),
            for (final l in links)
              ListTile(
                leading: const Icon(Icons.live_tv_outlined, color: DashboardColors.accentGreen),
                title: Text(l.label),
                subtitle: Text(
                  l.url,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(ctx).textTheme.bodySmall?.copyWith(color: DashboardColors.textSecondary),
                ),
                onTap: () async {
                  Navigator.of(ctx).pop();
                  final uri = Uri.tryParse(l.url);
                  if (uri == null) return;
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                },
              ),
          ],
        ),
      ),
    ),
  );
}
