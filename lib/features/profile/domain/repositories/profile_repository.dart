import 'dart:typed_data';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/user_profile_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserProfileEntity>> getUserProfile(String uid);

  Future<Either<Failure, Unit>> updateProfilePhoto(Uint8List imageBytes);

  Future<Either<Failure, Unit>> updateDisplayName(String displayName);
}
