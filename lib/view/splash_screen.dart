import 'dart:async';
import 'package:final_project/view/login_page.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static String route = "splash_screen";

  @override
  Widget build(BuildContext context) {
    // timer
    Timer(const Duration(seconds: 5), () {
      Navigator.of(context).pushNamed(LoginPage.route);
    });

    return Scaffold(
      backgroundColor: Color(0xff34dbeb),
      body: Center(child: Image.asset("assets/auth/ic_splash.png")),
    );
  }
}
