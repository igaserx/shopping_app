import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_app/core/widgets/custom_snack_bar.dart';
import 'package:shopping_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:shopping_app/features/auth/presentation/cubits/auth_state.dart';
import 'package:shopping_app/features/auth/presentation/views/sign_in_view.dart';
import 'package:shopping_app/features/auth/presentation/widgets/cutom_buttom.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});
  static final String routeName = "SignUpView";

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  // bool _signup = false;
  // Controllers.
  final _emailController = TextEditingController(),
      _passwordController = TextEditingController(),
      _confirmPasswordController = TextEditingController();
  // Focus Nodes.
  final FocusNode _emailFocusNode = FocusNode(),
      _passwordFocusNode = FocusNode(),
      _confirmPasswordFocusNode = FocusNode();
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  _openSignInView() {
    Navigator.of(context).pushReplacementNamed(SignInView.routeName);
  }

  // _fakeSignup() async {
  //   setState(() {
  //     _signup = true;
  //   });
  //   await Future.delayed(Duration(seconds: 3));
  //   setState(() {
  //     _signup = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthLoading) {
            } else if (state is Authenticated) {
              Navigator.pushReplacementNamed(context, SignInView.routeName);
              CustomSnackBar.show(
                context,
                "account_created_successfully_please_sign_in".tr(),
                type: SnackBarType.success,
                duration: Duration(seconds: 3),
              );
            } else if (state is AuthError) {
              CustomSnackBar.show(
                context,
                state.message,
                type: SnackBarType.error,
              );
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
                    // Title
                    Text(
                      "sign_up".tr(),
                      style: GoogleFonts.robotoCondensed(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Subtitle
                    Text(
                      "create_a_new_account".tr(),
                      style: GoogleFonts.robotoCondensed(fontSize: 18),
                    ),
                    SizedBox(height: 50),

                    // Email Textfield
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
                            onSubmitted: (_) {
                              FocusScope.of(
                                context,
                              ).requestFocus(_confirmPasswordFocusNode);
                            },
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                                icon:
                                    _obscurePassword
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
                   
                    // confirm Password Textfield
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
                            controller: _confirmPasswordController,
                            focusNode: _confirmPasswordFocusNode,
                            obscureText: _obscureConfirmPassword,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword =
                                        !_obscureConfirmPassword;
                                  });
                                },
                                icon:
                                    _obscureConfirmPassword
                                        ? Icon(Icons.visibility_off)
                                        : Icon(Icons.visibility),
                              ),
                              hintText: "Confirm_Password".tr(),
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
                        text: isLoading ? "loading".tr() : "create".tr(),
                        onTap: () {
                          context.read<AuthCubit>().signUp(
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                            _confirmPasswordController.text.trim(),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 25),

                    // Back to sign in page.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "already_have_an_account".tr(),
                          style: GoogleFonts.robotoCondensed(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        GestureDetector(
                          onTap: _openSignInView,
                          child: Text(
                            "Sign_in".tr(),
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
    );
  }
}
