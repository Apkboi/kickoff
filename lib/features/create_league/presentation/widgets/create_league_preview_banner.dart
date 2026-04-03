import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/dashboard_colors.dart';

class CreateLeaguePreviewBanner extends StatelessWidget {
  const CreateLeaguePreviewBanner({required this.bannerUrl, super.key});

  final String? bannerUrl;

  @override
  Widget build(BuildContext context) {
    final u = bannerUrl?.trim();
    if (u != null && u.isNotEmpty) {
      return Image.network(
        u,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            color: DashboardColors.bgSurface,
            alignment: Alignment.center,
            child: const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(strokeWidth: 2, color: DashboardColors.accentGreen),
            ),
          );
        },
        errorBuilder: (_, __, ___) => _assetFallback(),
      );
    }
    return _assetFallback();
  }

  Widget _assetFallback() {
    return Image.asset(
      AppAssets.gamingHeroPlaceholder,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        color: DashboardColors.bgSurface,
        alignment: Alignment.center,
        child: const Icon(Icons.sports_esports, color: DashboardColors.textSecondary),
      ),
    );
  }
}
