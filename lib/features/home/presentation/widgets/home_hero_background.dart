import 'package:flutter/material.dart';

import '../../../../core/theme/dashboard_colors.dart';

class HomeHeroBackground extends StatelessWidget {
  const HomeHeroBackground({super.key, this.bannerUrl});

  final String? bannerUrl;

  @override
  Widget build(BuildContext context) {
    final u = bannerUrl?.trim();
    if (u != null && u.isNotEmpty) {
      return Image.network(
        u,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _assetFallback(),
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(color: DashboardColors.bgSurface);
        },
      );
    }
    return _assetFallback();
  }

  Widget _assetFallback() {
    return Image.asset(
      'assets/images/hero_stadium.png',
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        color: DashboardColors.bgSurface,
        child: const Icon(Icons.stadium, size: 64, color: DashboardColors.textSecondary),
      ),
    );
  }
}
