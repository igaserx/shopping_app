import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/core/DI/di.dart';
import 'package:shopping_app/core/auth_wrapper.dart';
import 'package:shopping_app/core/utils/utils.dart';
import 'package:shopping_app/core/views/welcome_view.dart';
import 'package:shopping_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:shopping_app/features/cart/cubits/cart_cubit.dart';
import 'package:shopping_app/features/favorite/cubits/favorite_cubit.dart';
import 'package:shopping_app/firebase_options.dart';
import 'package:shopping_app/routes/app_routes.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await init();
  runApp(
    EasyLocalization(
      path: "lang",
      supportedLocales: const [Locale('en'), Locale('ar')],
      fallbackLocale: const Locale('en'),
      child: MultiBlocProvider(
         providers: [
        BlocProvider(create: (_) => AuthCubit(signInUseCase: di(), signUpUseCase: di(), signOutUseCase: di(),)),
        BlocProvider(create: (_) => CartCubit()),
         BlocProvider<FavoritesCubit>(
      create: (context) => FavoritesCubit(),
    ),
      ],
        child: const MyApp()
        ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping App',
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      theme: Utils.appTheme(context),
      debugShowCheckedModeBanner: false,
      home: AuthWrapper(),
      routes: AppRoutes.routes
    );
  }
}
