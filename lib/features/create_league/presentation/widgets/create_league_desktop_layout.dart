import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../controllers/create_league_state.dart';
import 'create_league_form_body.dart';
import 'create_league_header.dart';
import 'create_league_preview_card.dart';

class CreateLeagueDesktopLayout extends StatelessWidget {
  const CreateLeagueDesktopLayout({required this.state, super.key});

  final CreateLeagueState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CreateLeagueHeader(compact: false),
        const SizedBox(height: AppSpacing.lg),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  child: CreateLeagueFormBody(
                    state: state,
                    formatHorizontal: false,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: SingleChildScrollView(
                  child: CreateLeaguePreviewCard(state: state),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
