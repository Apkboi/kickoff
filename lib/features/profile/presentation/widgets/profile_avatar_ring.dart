import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../controllers/profile_bloc.dart';
import '../controllers/profile_event.dart';

/// Large avatar with gradient ring; tap to pick a new photo (uploads via [ProfileBloc]).
class ProfileAvatarRing extends StatelessWidget {
  const ProfileAvatarRing({required this.profile, super.key});

  final UserProfileEntity profile;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () async {
              final file = await ImagePicker().pickImage(source: ImageSource.gallery);
              if (file == null || !context.mounted) return;
              final bytes = await file.readAsBytes();
              if (!context.mounted) return;
              context.read<ProfileBloc>().add(ProfilePhotoUploadRequested(bytes));
            },
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [DashboardColors.accentGreen, DashboardColors.accentMuted],
                ),
              ),
              child: CircleAvatar(
                radius: 56,
                backgroundColor: DashboardColors.bgSurface,
                backgroundImage: profile.photoUrl != null && profile.photoUrl!.isNotEmpty
                    ? NetworkImage(profile.photoUrl!)
                    : null,
                child: profile.photoUrl == null || profile.photoUrl!.isEmpty
                    ? const Icon(Icons.person, size: 56, color: DashboardColors.textSecondary)
                    : null,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 4,
          right: 24,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
            decoration: BoxDecoration(
              color: DashboardColors.accentGreen,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Text(
              'EDIT',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: DashboardColors.textOnAccent,
                    fontWeight: FontWeight.w900,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
