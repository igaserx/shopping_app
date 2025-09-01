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
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      throw Exception("All fields are required");
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      throw Exception("Invalid email format");
    }
    if (password.length < 6) {
      throw Exception("Password must be at least 6 characters");
    }
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
