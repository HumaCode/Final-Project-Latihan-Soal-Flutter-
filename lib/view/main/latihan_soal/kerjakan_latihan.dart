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

class _KerjakanLatihanState extends State<KerjakanLatihan>
    with SingleTickerProviderStateMixin {
  KerjakanSoalList? soalList;

  getQuestionList() async {
    final result = await LatihanSoalApi().postQuestionList(widget.id);
    if (result.status == Status.success) {
      soalList = KerjakanSoalList.fromJson(result.data!);
      // tab controller
      _controller = TabController(length: soalList!.data!.length, vsync: this);
      setState(() {});
    }
  }

  // tabBar
  TabController? _controller;

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
      bottomNavigationBar: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {},
              child: Text("Selanjutnya"),
            ),
          ],
        ),
      ),
      body: soalList == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                // tabBar no soal
                Container(
                  child: TabBar(
                    controller: _controller,
                    tabs: List.generate(
                      soalList!.data!.length,
                      (index) => Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                // tabBar view soal dan jawaban
                Expanded(
                  child: Container(
                    child: TabBarView(
                      controller: _controller,
                      children: List.generate(
                        soalList!.data!.length,
                        (index) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Soal No ${index + 1}"),
                            if (soalList!.data![index].questionTitle != null)
                              Text(soalList!.data![index].questionTitle!),
                            if (soalList!.data![index].questionTitleImg != null)
                              Image.network(
                                  soalList!.data![index].questionTitleImg!),
                          ],
                        ),
                      ).toList(),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
