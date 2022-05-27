import 'package:final_project/constant/constant.dart';
import 'package:final_project/constant/r.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Akun Saya"),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {},
            child: Text("Edit", style: profile),
          )
        ],
      ),
      body: Column(
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
                        "Nama User",
                        style: user,
                      ),
                      Text(
                        "Nama Sekolah User",
                        style: user.copyWith(
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
                  "Nama Lengkap User",
                  style: profile4,
                ),
                const SizedBox(height: 15),
                Text(
                  "Nama Lengkap",
                  style: profile3,
                ),
                Text(
                  "Nama Lengkap User",
                  style: profile4,
                ),
                const SizedBox(height: 15),
                Text(
                  "Nama Lengkap",
                  style: profile3,
                ),
                Text(
                  "Nama Lengkap User",
                  style: profile4,
                ),
                const SizedBox(height: 15),
                Text(
                  "Nama Lengkap",
                  style: profile3,
                ),
                Text(
                  "Nama Lengkap User",
                  style: profile4,
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 13.0,
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                  "Title",
                  style: user.copyWith(
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
