import 'package:shopping_app/features/auth/domain/entities/user_entity.dart';
import 'package:shopping_app/features/auth/domain/repositories/auth_repo.dart';

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<UserEntity> execute({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (password != confirmPassword) {
      throw Exception("Passwords do not match");
    }
    return repository.signUp(
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );
  }
}
