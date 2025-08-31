import 'package:shopping_app/features/auth/domain/entities/user_entity.dart';
import 'package:shopping_app/features/auth/domain/repositories/auth_repo.dart';

class SignInUseCase {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  Future<UserEntity> execute({
    required String email,
    required String password,
  }) {
    return repository.signIn(email: email, password: password);
  }
}
