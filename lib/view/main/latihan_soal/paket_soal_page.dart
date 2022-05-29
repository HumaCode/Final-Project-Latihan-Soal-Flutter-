import 'package:final_project/constant/r.dart';
import 'package:final_project/models/network_response.dart';
import 'package:final_project/models/paket_soal_list.dart';
import 'package:final_project/repository/latihan_soal_api.dart';
import 'package:final_project/view/main/latihan_soal/kerjakan_latihan.dart';
import 'package:flutter/material.dart';

class PaketSoalPage extends StatefulWidget {
  const PaketSoalPage({Key? key, required this.id}) : super(key: key);

  static String route = "paket_soal";

  final String id;

  @override
  State<PaketSoalPage> createState() => _PaketSoalPageState();
}

class _PaketSoalPageState extends State<PaketSoalPage> {
// parsing data paket soal
  PaketSoalList? paketSoalList;
  getPaketSoal() async {
    final mapelResult = await LatihanSoalApi().getPaketSoal(widget.id);

    if (mapelResult.status == Status.success) {
      paketSoalList = PaketSoalList.fromJson(mapelResult.data!);
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPaketSoal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: R.colors.grey,
      appBar: AppBar(
        title: const Text("Paket Soal"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pilih Paket Soal",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: paketSoalList == null
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  :
                  // : SingleChildScrollView(
                  //     child: Wrap(
                  //         children: List.generate(
                  //       paketSoalList!.data!.length,
                  //       (index) {
                  //         final currentPaketSoal = paketSoalList!.data![index];
                  //         return Container(
                  //           width: MediaQuery.of(context).size.width * 0.4,
                  //           padding: EdgeInsets.all(3),
                  //           child: PaketSoalWidget(
                  //             data: currentPaketSoal,
                  //           ),
                  //         );
                  //       },
                  //     ).toList()

                  //         // const [
                  //         //   PaketSoalWidget(),
                  //         //   PaketSoalWidget(),
                  //         //   PaketSoalWidget(),
                  //         //   PaketSoalWidget(),
                  //         // ],
                  //         ),
                  //   ),

                  GridView.count(
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      crossAxisCount: 2,
                      childAspectRatio: 5 / 4,
                      children: List.generate(
                        paketSoalList!.data!.length,
                        (index) {
                          final currentPaketSoal = paketSoalList!.data![index];
                          return PaketSoalWidget(
                            data: currentPaketSoal,
                          );
                        },
                      ).toList()

                      // const [
                      //   PaketSoalWidget(),
                      //   PaketSoalWidget(),
                      //   PaketSoalWidget(),
                      //   PaketSoalWidget(),
                      // ],
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaketSoalWidget extends StatelessWidget {
  const PaketSoalWidget({
    Key? key,
    required this.data,
  }) : super(key: key);

  final paketSoalData data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => KerjakanLatihan(
              id: data.exerciseId!,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(13.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blue.withOpacity(0.2),
              ),
              padding: const EdgeInsets.all(12),
              child: Image.asset(
                R.assets.icNote,
                width: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              data.exerciseTitle!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "${data.jumlahDone}/${data.jumlahSoal} Paket Soal",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  color: R.colors.greySubtitleHome),
            ),
          ],
        ),
      ),
    );
  }
}
