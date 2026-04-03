import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../widgets/league_fixtures_browser_view.dart';

class LeagueFixturesScreen extends StatelessWidget {
  const LeagueFixturesScreen({
    required this.competitionId,
    super.key,
  });

  final String competitionId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All fixtures'),
      ),
      body: LeagueFixturesBrowserView(
        competitionId: competitionId,
        onFixtureTap: (fixture) {
          context.push(AppRoutes.matchDetailPath(competitionId, fixture.matchId));
        },
      ),
    );
  }
}

class ManageLeagueFixturesScreen extends StatelessWidget {
  const ManageLeagueFixturesScreen({
    required this.competitionId,
    required this.selectedMatchId,
    super.key,
  });

  final String competitionId;
  final String selectedMatchId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage fixtures'),
      ),
      body: LeagueFixturesBrowserView(
        competitionId: competitionId,
        selectedMatchId: selectedMatchId,
        onFixtureTap: (fixture) => context.pop(fixture.matchId),
      ),
    );
  }
}

