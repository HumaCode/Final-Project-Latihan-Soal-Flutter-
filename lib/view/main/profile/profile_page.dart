import 'package:final_project/constant/constant.dart';
import 'package:final_project/constant/r.dart';
import 'package:final_project/helpers/preference_helper.dart';
import 'package:final_project/models/user_by_email.dart';
import 'package:final_project/view/login_page.dart';
import 'package:final_project/view/main/profile/edit_profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserData? user;
  getUserData() async {
    final data = await PreferenceHelper().getUserData();
    user = data;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Akun Saya"),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditProfilePage(),
                ),
              );
            },
            child: Text("Edit", style: profile),
          )
        ],
      ),
      body: user == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    top: 28,
                    bottom: 60,
                    right: 15,
                    left: 15,
                  ),
                  decoration: BoxDecoration(
                    color: R.colors.primary,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(9),
                      bottomRight: Radius.circular(9),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user!.userName!,
                              style: userProfil,
                            ),
                            Text(
                              user!.userAsalSekolah!,
                              style: userProfil.copyWith(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Image.asset(
                        R.assets.icAvatar,
                        height: 50,
                        width: 50,
                      )
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 7,
                        color: Colors.black.withOpacity(0.25),
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.symmetric(
                    vertical: 18.0,
                    horizontal: 13.0,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 18.0,
                    horizontal: 13.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        R.strings.identitas,
                        style: profile2,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Nama Lengkap",
                        style: profile3,
                      ),
                      Text(
                        user!.userName!,
                        style: profile4,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Email",
                        style: profile3,
                      ),
                      Text(
                        user!.userEmail!,
                        style: profile4,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Jenis Kelamin",
                        style: profile3,
                      ),
                      Text(
                        user!.userGender!,
                        style: profile4,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Kelas",
                        style: profile3,
                      ),
                      Text(
                        user!.jenjang ?? "User Belum Memilih Kelas",
                        style: profile4,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Asal Sekolah",
                        style: profile3,
                      ),
                      Text(
                        user!.userAsalSekolah!,
                        style: profile4,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    if (kIsWeb) {
                      await GoogleSignIn(
                              clientId:
                                  "189971851302-m8lv2ir9q2d2gueolc6t7kcjclhk37e0.apps.googleusercontent.com")
                          .signOut();
                    } else {
                      await GoogleSignIn().signOut();
                    }

                    await FirebaseAuth.instance.signOut();

                    Navigator.of(context).pushNamedAndRemoveUntil(
                        LoginPage.route, (route) => false);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 13.0,
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 7,
                          color: Colors.black.withOpacity(0.25),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.exit_to_app,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "Keluar",
                          style: userProfil.copyWith(
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
