import 'package:flutter/material.dart';


class HomeView extends StatelessWidget {
static final String routeName = "HomeView";
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Shopping'),
      ),
    );
  }
}