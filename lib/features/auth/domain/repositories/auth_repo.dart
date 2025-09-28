import 'package:shopping_app/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> signIn({required String email, required String password});

  Future<UserEntity> signUp({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
  });
    Future<void> signOut();
}
