import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_app/core/widgets/custom_snack_bar.dart';
import 'package:shopping_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:shopping_app/features/auth/presentation/cubits/auth_state.dart';
import 'package:shopping_app/features/auth/presentation/views/sign_up_view.dart';
import 'package:shopping_app/features/auth/presentation/widgets/cutom_buttom.dart';
import 'package:shopping_app/features/home_view.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});
  static final String routeName = "SignInView";

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  bool _obscureText = true;
  // bool _login = false;
  // Controllers.
  final _emailController = TextEditingController(),
      _passwordController = TextEditingController();
  // Focus Nodes.
  final FocusNode _emailFocusNode = FocusNode(),
      _passwordFocusNode = FocusNode();
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  // _fakeLogin() async {
  //   setState(() {
  //     _login = true;
  //   });
  //   await Future.delayed(Duration(seconds: 3));
  //   setState(() {
  //     _login = false;
  //   });
  // }

  _openSignUpView() {
    Navigator.of(context).pushReplacementNamed(SignUpView.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
             CustomSnackBar.show(context,state.message,type: SnackBarType.error);
            }
            if (state is Authenticated) {
              Navigator.of(context).pushReplacementNamed(HomeView.routeName);
              CustomSnackBar.show(context,"successfully_sign_in".tr(),type: SnackBarType.success);
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    Icon(
                      Icons.shopping_bag,
                      size: 100,
                      color: Colors.amber[900],
                    ),
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
                            focusNode: _emailFocusNode,
                            onSubmitted: (_) {
                              FocusScope.of(
                                context,
                              ).requestFocus(_passwordFocusNode);
                            },
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
                            focusNode: _passwordFocusNode,
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
                            isLoading
                                ? Colors.amber[400]!.withValues(alpha: 1.5)
                                : Colors.amber[900]!,
                        text: isLoading ? "loading".tr() : "Sign_in".tr(),
                        onTap: () {
                       context.read<AuthCubit>().signIn(
                        _emailController.text.trim()
                        ,
                         _passwordController.text.trim()
                         );
                        },
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
            );
          },
        ),
      ),

      //? Temp switch button to change language.
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (context.locale.languageCode == 'en') {
            context.setLocale(Locale('ar'));
          } else {
            context.setLocale(Locale('en'));
          }
        },
        child: Icon(Icons.language),
      ),
    );
  }
}
