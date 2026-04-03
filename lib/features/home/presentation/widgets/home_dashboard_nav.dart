import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';

abstract final class HomeDashboardNav {
  static void openMatch(BuildContext context, String leagueId, String matchId) {
    context.push(AppRoutes.matchDetailPath(leagueId, matchId));
  }

  static void openLeague(BuildContext context, String leagueId) {
    context.push(AppRoutes.competitionDetailPath(leagueId));
  }

  static void openExplore(BuildContext context) {
    context.push(AppRoutes.explore);
  }

  static void openEditProfile(BuildContext context) {
    context.go(AppRoutes.profile);
  }
}
