import 'dart:async';
import 'package:final_project/constant/r.dart';
import 'package:final_project/constant/repository/auth_api.dart';
import 'package:final_project/models/user_by_email.dart';
import 'package:final_project/view/login_page.dart';
import 'package:final_project/view/main_page.dart';
import 'package:final_project/view/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static String route = "splash_screen";

  @override
  Widget build(BuildContext context) {
    // timer
    Timer(const Duration(seconds: 5), () async {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // pemanggilan api
        final dataUser = await AuthApi().getUserByEmail(user.email);
        if (dataUser != null) {
          final data = UserByEmail.fromJson(dataUser);
          if (data.status == 1) {
            Navigator.of(context).pushNamed(MainPage.route);
          } else {
            Navigator.of(context).pushNamed(RegisterPage.route);
          }
        }
      } else {
        Navigator.of(context).pushReplacementNamed(LoginPage.route);
      }
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
