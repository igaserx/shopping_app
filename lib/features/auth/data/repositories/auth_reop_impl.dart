import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopping_app/features/auth/domain/repositories/auth_repo.dart';
import '../../domain/entities/user_entity.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth firebaseAuth;

  AuthRepositoryImpl({required this.firebaseAuth});

  @override
  Future<UserEntity> signIn({
    required String email,
    required String password,
  }) async {
    final userCredential = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = userCredential.user;
    if (user == null) throw Exception('User not found');

    return UserModel.fromFirebase(user);
  }

  @override
  Future<UserEntity> signUp({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await userCredential.user!.updateDisplayName(fullName);
    final user = userCredential.user;
    if (user == null) throw Exception('User not created');

    return UserModel.fromFirebase(user);
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
}
