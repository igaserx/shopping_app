import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:shopping_app/features/auth/data/repositories/auth_reop_impl.dart';
import 'package:shopping_app/features/auth/domain/repositories/auth_repo.dart';
import 'package:shopping_app/features/auth/domain/usecases/signin_use_case.dart';
import 'package:shopping_app/features/auth/domain/usecases/signout_use_case.dart';
import 'package:shopping_app/features/auth/domain/usecases/signup_use_case.dart';
import 'package:shopping_app/features/auth/presentation/cubits/auth_cubit.dart';

final di = GetIt.instance;

Future<void> init() async {
  // Firebase
  di.registerLazySingleton(() => FirebaseAuth.instance);

  // Repositories
  di.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(firebaseAuth: di()),
  );

  // Use Cases
  di.registerLazySingleton(() => SignInUseCase( di()));
  di.registerLazySingleton(() => SignUpUseCase( di()));
  di.registerLazySingleton(() => SignOutUseCase(di()));
  
  // Cubits
  di.registerFactory(
    () => AuthCubit(
      signInUseCase: di(),
      signUpUseCase: di(),
      signOutUseCase: di(),
    ),
  );
}
