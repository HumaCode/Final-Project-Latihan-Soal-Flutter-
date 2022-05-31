import 'package:final_project/constant/r.dart';
import 'package:final_project/models/banner_list.dart';
import 'package:final_project/models/mapel_list.dart';
import 'package:final_project/models/network_response.dart';
import 'package:final_project/repository/latihan_soal_api.dart';
import 'package:final_project/view/main/latihan_soal/mapel_page.dart';
import 'package:final_project/view/main/latihan_soal/paket_soal_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
// mapel
  MapelList? mapelList;
  getMapel() async {
    final mapelResult = await LatihanSoalApi().getMapel();

    if (mapelResult.status == Status.success) {
      mapelList = MapelList.fromJson(mapelResult.data!);
      setState(() {});
    }
  }

// banner
  BannerList? bannerList;
  getBanner() async {
    final banner = await LatihanSoalApi().getBanner();

    if (banner.status == Status.success) {
      bannerList = BannerList.fromJson(banner.data!);
      setState(() {});
    }
  }

  // notifikasi
  setupFcm() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    final tokenFcm = await FirebaseMessaging.instance.getToken();
    print("tokenFcm: $tokenFcm");

    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    // if (initialMessage != null) {
    //   _handleMessage(initialMessage);
    // }

    // FirebaseMessaging.onMessageOpenedApp.listen((event) {});
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMapel();
    getBanner();
    setupFcm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: R.colors.grey,
      body: SafeArea(
        child: ListView(
          children: [
            _buildUserHomeProfile(),
            _builtTopBanner(context),
            _builtHomeListMapel(mapelList),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "Terbaru",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  bannerList == null
                      ? Container(
                          height: 70,
                          width: double.infinity,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Container(
                          height: 150,
                          child: ListView.builder(
                            itemCount: bannerList!.data!.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final currentBanner = bannerList!.data![index];

                              return Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    currentBanner.eventImage!,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                  const SizedBox(height: 35),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Container _builtHomeListMapel(MapelList? list) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 21.0,
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                "Pilih Pelajaran",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return MapelPage(mapel: mapelList!);
                      },
                    ),
                  );
                },
                child: Text(
                  "Lihat Semua",
                  style: TextStyle(
                    fontSize: 12,
                    color: R.colors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          list == null
              ? Container(
                  height: 70,
                  width: double.infinity,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: list.data!.length > 3 ? 3 : list.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    final currentMapel = list.data![index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PaketSoalPage(
                              id: currentMapel.courseId!,
                            ),
                          ),
                        );
                      },
                      child: MapelWidget(
                        title: currentMapel.courseName!,
                        totalPacket: currentMapel.jumlahMateri!,
                        totalDone: currentMapel.jumlahDone!,
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  Container _builtTopBanner(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20.0,
      ),
      height: 147,
      width: double.infinity,
      decoration: BoxDecoration(
        color: R.colors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.45,
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 15.0,
            ),
            child: const Text(
              "Mau kerjain latihan soal apa hari ini?",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Image.asset(R.assets.imgHome,
                width: MediaQuery.of(context).size.width * 0.5),
          ),
        ],
      ),
    );
  }

  Padding _buildUserHomeProfile() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 15.0,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hi, Nama User",
                  style: GoogleFonts.poppins().copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  "Selamat Datang",
                  style: GoogleFonts.poppins().copyWith(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Image.asset(
            R.assets.icAvatar,
            width: 35,
            height: 35,
          ),
        ],
      ),
    );
  }
}

class MapelWidget extends StatelessWidget {
  const MapelWidget({
    Key? key,
    required this.title,
    required this.totalDone,
    required this.totalPacket,
  }) : super(key: key);

  // data mapel
  final String title;
  final int? totalDone;
  final int? totalPacket;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.only(
        bottom: 10.0,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 18.0,
        vertical: 21.0,
      ),
      child: Row(
        children: [
          Container(
            height: 53,
            width: 53,
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: R.colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(R.assets.icAtom),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  "$totalDone/$totalPacket Paket latihan soal",
                  style: TextStyle(
                    fontSize: 12,
                    color: R.colors.greySubtitleHome,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Stack(
                  children: [
                    Container(
                      height: 10,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: R.colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Container(
                      height: 10,
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                        color: R.colors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
