import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:shopping_app/core/database/apis/api_consumer.dart';
import 'package:shopping_app/core/database/apis/dio_consumer.dart';
import 'package:shopping_app/features/auth/data/repositories/auth_reop_impl.dart';
import 'package:shopping_app/features/auth/domain/repositories/auth_repo.dart';
import 'package:shopping_app/features/auth/domain/usecases/signin_use_case.dart';
import 'package:shopping_app/features/auth/domain/usecases/signout_use_case.dart';
import 'package:shopping_app/features/auth/domain/usecases/signup_use_case.dart';
import 'package:shopping_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:shopping_app/features/products/data/data_sources/data_source.dart';
import 'package:shopping_app/features/products/data/repositories/product_repository_impl.dart';
import 'package:shopping_app/features/products/domain/repositories/products_repo.dart';
import 'package:shopping_app/features/products/domain/usecases/get_all_products_usecase.dart';
import 'package:shopping_app/features/products/domain/usecases/get_product_by_category_usecase.dart';
import 'package:shopping_app/features/products/presentation/cubits/cubit/search_cubit.dart';
import 'package:shopping_app/features/products/presentation/cubits/prduct_cubit.dart';


final di = GetIt.instance;

Future<void> init() async {
  //! Core Layer 
  di.registerLazySingleton<Dio>(() => Dio());
  di.registerLazySingleton<ApiConsumer>(() => DioConsumer(dio: di()));
  di.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  //! Features
  // Auth Feature
  // Data layer
  di.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(firebaseAuth: di<FirebaseAuth>()),
  );

  // Domain layer
  di.registerLazySingleton(() => SignInUseCase(di<AuthRepository>()));
  di.registerLazySingleton(() => SignUpUseCase(di<AuthRepository>()));
  di.registerLazySingleton(() => SignOutUseCase(di<AuthRepository>()));
  
  // Presentation layer
  di.registerFactory(
    () => AuthCubit(
      signInUseCase: di(),
      signUpUseCase: di(),
      signOutUseCase: di(),
    ),
  );
  
  // Products Feature
  // Data layer
  di.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDatasourcesImpl(api: di<ApiConsumer>()),
  );
  di.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(remoteDataSource: di()),
  );
  // Domain layer
  di.registerLazySingleton(() => GetAllProductsUseCase(repository: di()));
  di.registerLazySingleton(() => GetProductByCategoryUsecase(repo: di()));

  // Presentation layer
  di.registerFactory(
    () => ProductCubit(
      getAllProductsUseCase: di(),
      getProductByCategoryUsecase: di(),
    ),
  );
  di.registerFactory(
    () => ProductSearchCubit(
      productRepository: di(),
    ),
  );

}