import 'package:flutter/material.dart';

import '../../core/theme/dashboard_colors.dart';

/// Small avatar; tap opens profile (parent supplies [onTap]).
class ProfileAvatarChip extends StatelessWidget {
  const ProfileAvatarChip({
    super.key,
    this.photoUrl,
    this.radius = 18,
    this.onTap,
  });

  final String? photoUrl;
  final double radius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final hasPhoto = photoUrl != null && photoUrl!.isNotEmpty;
    final child = CircleAvatar(
      radius: radius,
      backgroundColor: DashboardColors.bgSurface,
      foregroundImage: hasPhoto ? NetworkImage(photoUrl!) : null,
      onForegroundImageError: hasPhoto ? (_, __) {} : null,
      child: Icon(Icons.person, color: DashboardColors.textSecondary, size: radius + 2),
    );
    if (onTap == null) return child;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius + 4),
        child: child,
      ),
    );
  }
}
