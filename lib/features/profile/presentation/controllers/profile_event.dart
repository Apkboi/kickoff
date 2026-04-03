import 'dart:typed_data';

import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileRequested extends ProfileEvent {
  const ProfileRequested({this.forUserId});

  /// When set, loads that user's public profile (must be signed in).
  final String? forUserId;

  @override
  List<Object?> get props => [forUserId];
}

class ProfileDisplayNameSubmitted extends ProfileEvent {
  const ProfileDisplayNameSubmitted(this.displayName);

  final String displayName;

  @override
  List<Object?> get props => [displayName];
}

class ProfilePhotoUploadRequested extends ProfileEvent {
  const ProfilePhotoUploadRequested(this.imageBytes);

  final Uint8List imageBytes;

  @override
  List<Object?> get props => [imageBytes];
}
