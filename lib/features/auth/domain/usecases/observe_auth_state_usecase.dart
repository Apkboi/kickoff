import '../../../../core/domain/no_params.dart';
import '../entities/auth_user_entity.dart';
import '../repositories/auth_repository.dart';

class ObserveAuthStateUseCase {
  const ObserveAuthStateUseCase(this._repository);

  final AuthRepository _repository;

  Stream<AuthUserEntity> call(NoParams params) {
    return _repository.authStateChanges();
  }
}
