import 'dart:async';
import 'package:final_project/constant/r.dart';
import 'package:final_project/view/login_page.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static String route = "splash_screen";

  @override
  Widget build(BuildContext context) {
    // timer
    Timer(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacementNamed(LoginPage.route);
    });

    return Scaffold(
      backgroundColor: R.colors.primary,
      body: Center(
        child: Image.asset(
          R.assets.icSplash,
          width: MediaQuery.of(context).size.width * 0.5,
        ),
      ),
    );
  }
}
