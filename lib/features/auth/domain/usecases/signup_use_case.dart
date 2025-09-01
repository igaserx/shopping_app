import 'package:easy_localization/easy_localization.dart';
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
      throw ("all_fields_are_required".tr());
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      throw ("invalid_email_format".tr());
    }
    if (password.length < 6) {
      throw ("password_must_be_at_least_6_characters".tr());
    }
    if (password != confirmPassword) {
      throw ("passwords_do_not_match".tr());
    }
    return repository.signUp(
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );
  }
}
