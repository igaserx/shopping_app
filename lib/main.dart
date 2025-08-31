import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_app/features/auth/presentation/views/sign_in_view.dart';
import 'package:shopping_app/features/auth/presentation/views/sign_up_view.dart';
import 'package:shopping_app/firebase_options.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    EasyLocalization(
      path: "lang",
      supportedLocales: const [Locale('en'), Locale('ar')],
      fallbackLocale: const Locale('en'),

      child: const MyApp(),
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
      theme: appTheme(context),
      debugShowCheckedModeBanner: false,
      initialRoute: SignInView.routeName,
      routes: {
        SignInView.routeName: (context) => const SignInView(),
        SignUpView.routeName: (context) => const SignUpView(),
      },
    );
  }
}

ThemeData appTheme(BuildContext context) {
  final currentLocale = context.locale.languageCode;

  return ThemeData(
    textTheme:
        currentLocale == 'ar'
            ? GoogleFonts.cairoTextTheme()
            : GoogleFonts.robotoTextTheme(),
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
  );
}
