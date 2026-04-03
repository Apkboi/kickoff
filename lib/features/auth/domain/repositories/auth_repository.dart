import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/auth_user_entity.dart';

abstract class AuthRepository {
  Stream<AuthUserEntity> authStateChanges();

  Future<Either<Failure, AuthUserEntity>> getCurrentUser();

  Future<Either<Failure, void>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  });

  Future<Either<Failure, void>> signOut();

  Future<Either<Failure, void>> sendPasswordResetEmail(String email);
}
