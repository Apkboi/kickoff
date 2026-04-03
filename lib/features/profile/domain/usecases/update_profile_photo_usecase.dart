import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/profile_repository.dart';

class UpdateProfilePhotoParams extends Equatable {
  const UpdateProfilePhotoParams({required this.imageBytes});

  final Uint8List imageBytes;

  @override
  List<Object?> get props => [imageBytes];
}

class UpdateProfilePhotoUseCase {
  const UpdateProfilePhotoUseCase(this._repository);

  final ProfileRepository _repository;

  Future<Either<Failure, Unit>> call(UpdateProfilePhotoParams params) {
    return _repository.updateProfilePhoto(params.imageBytes);
  }
}
