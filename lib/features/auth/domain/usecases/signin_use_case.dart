import 'package:easy_localization/easy_localization.dart';
import 'package:shopping_app/features/auth/domain/entities/user_entity.dart';
import 'package:shopping_app/features/auth/domain/repositories/auth_repo.dart';

class SignInUseCase {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  Future<UserEntity> execute({
    required String email,
    required String password,
  }) {
    if (email.isEmpty || password.isEmpty) {
      throw ("all_fields_are_required".tr());
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)){
      throw ("invalid_email_format".tr());
    }
    if (password.length < 6) {
      throw ("password_must_be_at_least_6_characters".tr());
    }
    return repository.signIn(email: email, password: password);
  }
}
