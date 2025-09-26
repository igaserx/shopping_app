import 'package:flutter/material.dart';
import 'package:shopping_app/features/auth/presentation/views/sign_in_view.dart';
import 'package:shopping_app/features/auth/presentation/views/sign_up_view.dart';
import 'package:shopping_app/features/products/presentation/views/home_view.dart';
import 'package:shopping_app/features/products/presentation/views/products_view.dart';

class AppRoutes {
  static final Map<String, WidgetBuilder> routes = {
    SignInView.routeName: (context) => const SignInView(),
    SignUpView.routeName: (context) => const SignUpView(),
    HomeView.routeName: (context) => const HomeView(),
    ProductView.routeName: (context) => const ProductView(),
  };
}
