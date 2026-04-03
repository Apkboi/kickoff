import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';
import '../controllers/create_league_state.dart';
import 'create_league_form_body.dart';
import 'create_league_header.dart';
import 'create_league_preview_card.dart';

class CreateLeagueMobileLayout extends StatelessWidget {
  const CreateLeagueMobileLayout({required this.state, super.key});

  final CreateLeagueState state;

  void _openPreview(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: DashboardColors.bgPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.md,
            right: AppSpacing.md,
            top: AppSpacing.md,
            bottom: MediaQuery.paddingOf(ctx).bottom + AppSpacing.md,
          ),
          child: SingleChildScrollView(
            child: CreateLeaguePreviewCard(state: state),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CreateLeagueHeader(
          compact: true,
          onPreviewTap: () => _openPreview(context),
        ),
        const SizedBox(height: AppSpacing.md),
        Expanded(
          child: SingleChildScrollView(
            child: CreateLeagueFormBody(
              state: state,
              formatHorizontal: true,
              showAutomationToggle: false,
            ),
          ),
        ),
      ],
    );
  }
}
