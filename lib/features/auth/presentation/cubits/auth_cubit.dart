import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/features/auth/domain/usecases/signin_use_case.dart';
import 'package:shopping_app/features/auth/domain/usecases/signout_use_case.dart';
import 'package:shopping_app/features/auth/domain/usecases/signup_use_case.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final SignOutUseCase signOutUseCase;

  AuthCubit({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.signOutUseCase,
  }) : super(AuthInitial());

  Future<void> signIn(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await signInUseCase.execute(email: email, password: password);
      emit(Authenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signUp(String fullName, String email, String password, String confirmPassword) async {
    emit(AuthLoading());
    try {
      final user = await signUpUseCase.execute(
        fullName: fullName,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      );
      emit(Authenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signOut() async {
    emit(AuthLoading());
    try {
      await signOutUseCase.execute();
      emit(AuthSignedOut());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
