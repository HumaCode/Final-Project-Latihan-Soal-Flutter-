import 'package:final_project/constant/constant.dart';
import 'package:final_project/constant/r.dart';
import 'package:final_project/helpers/preference_helper.dart';
import 'package:final_project/models/network_response.dart';
import 'package:final_project/models/user_by_email.dart';
import 'package:final_project/repository/auth_api.dart';
import 'package:final_project/view/main_page.dart';
import 'package:final_project/view/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static String route = "login_screen";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<UserCredential> signInWithGoogle() async {
    if (kIsWeb) {
      // Create a new provider
      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      googleProvider
          .addScope('https://www.googleapis.com/auth/contacts.readonly');
      googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithPopup(googleProvider);

      // Or use signInWithRedirect
      // return await FirebaseAuth.instance.signInWithRedirect(googleProvider);
    } else {
// Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3f7f8),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text(
                  R.strings.login,
                  style: login,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Image.asset(R.assets.imgLogin),
            const SizedBox(height: 35),
            Text(
              R.strings.welcome,
              style: login.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              R.strings.loginDescription,
              textAlign: TextAlign.center,
              style: subTitle.copyWith(
                color: R.colors.greySubtitle,
              ),
            ),
            const Spacer(),
            ButtonLogin(
              onTap: () async {
                await signInWithGoogle();

                final user = FirebaseAuth.instance.currentUser;

                if (user != null) {
                  // pemanggilan api
                  final dataUser = await AuthApi().getUserByEmail();
                  if (dataUser.status == Status.success) {
                    final data = UserByEmail.fromJson(dataUser.data!);
                    if (data.status == 1) {
                      await PreferenceHelper().setUserData(data.data!);
                      Navigator.of(context).pushNamed(MainPage.route);
                    } else {
                      Navigator.of(context).pushNamed(RegisterPage.route);
                    }
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Gagal Masuk"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              backgroundColor: Colors.white,
              borderColor: R.colors.primary,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(R.assets.icGoogle),
                  const SizedBox(width: 15),
                  Text(
                    R.strings.loginWithGoogle,
                    style: buttonLogin.copyWith(
                      color: R.colors.blackLogin,
                    ),
                  ),
                ],
              ),
            ),
            ButtonLogin(
              onTap: () {},
              backgroundColor: R.colors.blackLogin,
              borderColor: R.colors.blackLogin,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(R.assets.icApple),
                  const SizedBox(width: 15),
                  Text(
                    R.strings.loginWithAppleId,
                    style: buttonLogin.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ButtonLogin extends StatelessWidget {
  const ButtonLogin({
    Key? key,
    required this.backgroundColor,
    required this.child,
    required this.borderColor,
    required this.onTap,
  }) : super(key: key);

  // properti berubah-ubah
  final Color backgroundColor;
  final Widget child;
  final Color borderColor;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 12.0,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: backgroundColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
            side: BorderSide(
              color: borderColor,
            ),
          ),
          fixedSize: Size(MediaQuery.of(context).size.width * 0.8, 50),
        ),
        onPressed: onTap,
        child: child,
      ),
    );
  }
}
