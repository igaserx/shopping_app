import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_app/features/auth/presentation/views/sign_in_view.dart';
import 'package:shopping_app/features/auth/presentation/views/sign_up_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping App',
      theme: ThemeData(
        textTheme: GoogleFonts.robotoTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: SignInView.routeName,
      routes: {
        SignInView.routeName: (context) => const SignInView(),
        SignUpView.routeName: (context) => const SignUpView(),
      },
    );
  }
}
