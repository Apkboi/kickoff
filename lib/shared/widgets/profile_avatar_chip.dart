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
    final child = CircleAvatar(
      radius: radius,
      backgroundColor: DashboardColors.bgSurface,
      backgroundImage: photoUrl != null && photoUrl!.isNotEmpty ? NetworkImage(photoUrl!) : null,
      child: photoUrl == null || photoUrl!.isEmpty
          ? Icon(Icons.person, color: DashboardColors.textSecondary, size: radius + 2)
          : null,
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
