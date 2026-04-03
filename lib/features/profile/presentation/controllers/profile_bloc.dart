import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/get_user_profile_usecase.dart';
import '../../domain/usecases/update_profile_display_name_usecase.dart';
import '../../domain/usecases/update_profile_photo_usecase.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required GetCurrentUserUseCase getCurrentUser,
    required GetUserProfileUseCase getUserProfile,
    required UpdateProfilePhotoUseCase updateProfilePhoto,
    required UpdateProfileDisplayNameUseCase updateDisplayName,
  })  : _getCurrentUser = getCurrentUser,
        _getUserProfile = getUserProfile,
        _updateProfilePhoto = updateProfilePhoto,
        _updateDisplayName = updateDisplayName,
        super(const ProfileInitial()) {
    on<ProfileRequested>(_onRequested);
    on<ProfilePhotoUploadRequested>(_onPhotoUpload);
    on<ProfileDisplayNameSubmitted>(_onDisplayName);
  }

  final GetCurrentUserUseCase _getCurrentUser;
  final GetUserProfileUseCase _getUserProfile;
  final UpdateProfilePhotoUseCase _updateProfilePhoto;
  final UpdateProfileDisplayNameUseCase _updateDisplayName;

  Future<void> _onRequested(
    ProfileRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());
    final authResult = await _getCurrentUser(const GetCurrentUserParams());
    await authResult.fold(
      (failure) async => emit(ProfileError(failure.message)),
      (user) async {
        if (!user.isAuthenticated || user.id.isEmpty) {
          emit(const ProfileError('You need to sign in to view your profile.'));
          return;
        }
        final targetId = (event.forUserId != null && event.forUserId!.isNotEmpty)
            ? event.forUserId!
            : user.id;
        final result = await _getUserProfile(
          GetUserProfileParams(uid: targetId),
        );
        result.fold(
          (failure) => emit(ProfileError(failure.message)),
          (profile) => emit(
            ProfileLoaded(
              profile: profile,
              isOwnProfile: targetId == user.id,
            ),
          ),
        );
      },
    );
  }

  Future<void> _onPhotoUpload(
    ProfilePhotoUploadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());
    final result = await _updateProfilePhoto(UpdateProfilePhotoParams(imageBytes: event.imageBytes));
    await result.fold(
      (failure) async => emit(ProfileError(failure.message)),
      (_) async => add(const ProfileRequested()),
    );
  }

  Future<void> _onDisplayName(
    ProfileDisplayNameSubmitted event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());
    final result = await _updateDisplayName(
      UpdateProfileDisplayNameParams(displayName: event.displayName),
    );
    await result.fold(
      (failure) async => emit(ProfileError(failure.message)),
      (_) async => add(const ProfileRequested()),
    );
  }
}
