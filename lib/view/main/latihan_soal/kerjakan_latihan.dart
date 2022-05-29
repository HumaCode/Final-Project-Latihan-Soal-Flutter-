import 'package:final_project/models/kerjakan_soal_list.dart';
import 'package:final_project/models/network_response.dart';
import 'package:final_project/repository/latihan_soal_api.dart';
import 'package:flutter/material.dart';

class KerjakanLatihan extends StatefulWidget {
  const KerjakanLatihan({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  State<KerjakanLatihan> createState() => _KerjakanLatihanState();
}

class _KerjakanLatihanState extends State<KerjakanLatihan> {
  KerjakanSoalList? soalList;

  getQuestionList() async {
    final result = await LatihanSoalApi().postQuestionList(widget.id);
    if (result.status == Status.success) {
      soalList = KerjakanSoalList.fromJson(result.data!);
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getQuestionList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Latihan Soal"),
      ),
      bottomNavigationBar: Container(),
      body: soalList == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                // tabBar no soal
                Container(),
                // tabBar view soal dan jawaban
                Expanded(child: Container())
              ],
            ),
    );
  }
}
