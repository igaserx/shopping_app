import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_app/features/auth/presentation/views/sign_up_view.dart';
import 'package:shopping_app/features/auth/presentation/widgets/cutom_buttom.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});
  static final String routeName = "SignInView";

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  bool _obscureText = true;
  bool _login = false;
  final _emailController = TextEditingController(),
      _passwordController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  _fakeLogin() async {
    setState(() {
      _login = true;
    });
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      _login = false;
    });
  }

  _openSignUpView() {
    Navigator.of(context).pushReplacementNamed(SignUpView.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Icon(Icons.shopping_bag, size: 100, color: Colors.amber[900]),
                // Title.
                Text(
                  "login".tr(),
                  style: GoogleFonts.robotoCondensed(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Subtitle.
                Text(
                  "hello_login".tr(),
                  style: GoogleFonts.robotoCondensed(fontSize: 18),
                ),
                SizedBox(height: 50),

                // Email Textfield.
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextField(
                        keyboardType:
                            TextInputType
                                .emailAddress, //!  Shows "@" on keyboard
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: "email".tr(),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),

                // Password Textfield
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            icon:
                                _obscureText
                                    ? Icon(Icons.visibility_off)
                                    : Icon(Icons.visibility),
                          ),
                          hintText: "password".tr(),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),

                // sign in buttom
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: CustomButton(
                    color:
                        _login
                            ? Colors.amber[400]!.withValues(alpha: 1.5)
                            : Colors.amber[900]!,
                    text: _login ? "loading".tr() : "Sign_in".tr(),
                    onTap: // TODO: Implement sign in functionality
                        _fakeLogin,
                  ),
                ),
                SizedBox(height: 25),

                // Go to sign up page.
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "dont_have_account".tr(),
                      style: GoogleFonts.robotoCondensed(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: _openSignUpView,
                      child: Text(
                        "create_account".tr(),
                        style: GoogleFonts.robotoCondensed(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
