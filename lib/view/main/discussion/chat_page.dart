import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/constant/constant.dart';
import 'package:final_project/constant/r.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key, this.id}) : super(key: key);

  final String? id;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final textController = TextEditingController();

  late CollectionReference chat;
  late QuerySnapshot chatData;
  // List<QueryDocumentSnapshot>? listChat;

  // ambil data chat dari firebase
  // getDataFromFirebase() async {
  //   chatData = await FirebaseFirestore.instance
  //       .collection("room")
  //       .doc("kimia")
  //       .collection("chat")
  //       .get();

  //   // listChat = chatData.docs;
  //   setState(() {});
  //   // print(chatData.docs);
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getDataFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    chat = FirebaseFirestore.instance
        .collection("room")
        .doc("kimia")
        .collection("chat");

    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Diskusi Soal"),
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: StreamBuilder<QuerySnapshot>(
                  stream: chat.orderBy("time").snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
                    // jika tidak ada data tampilkan proggressbar
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.reversed.length,
                        reverse: true,
                        itemBuilder: (BuildContext context, int index) {
                          final currentChat =
                              snapshot.data!.docs.reversed.toList()[index];

                          final currentDate =
                              (currentChat["time"] as Timestamp?)?.toDate();
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Column(
                              crossAxisAlignment:
                                  user!.uid == currentChat["uid"]
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentChat["nama"],
                                  style: chating,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 4.0),
                                  decoration: BoxDecoration(
                                    color: user.uid == currentChat["uid"]
                                        ? Colors.blue[200]
                                        : R.colors.pink,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: const Radius.circular(10),
                                      bottomRight:
                                          user.uid == currentChat["uid"]
                                              ? const Radius.circular(0)
                                              : const Radius.circular(10),
                                      topRight: const Radius.circular(10),
                                      topLeft: user.uid != currentChat["uid"]
                                          ? const Radius.circular(0)
                                          : const Radius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    currentChat["content"],
                                    style: profile2,
                                  ),
                                ),
                                Text(
                                  currentDate == null
                                      ? ""
                                      : DateFormat("dd-MMM-yyy HH:mm")
                                          .format(currentDate),
                                  style: chating.copyWith(
                                      color: R.colors.greySubtitleHome),
                                ),
                              ],
                            ),
                          );
                        });
                  },
                ),
              ),
            ),
            SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, -1),
                      blurRadius: 10,
                      color: Colors.black.withOpacity(0.25),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.add,
                        color: R.colors.iconColor,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                height: 50,
                                child: TextField(
                                  controller: textController,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      onPressed: () async {
                                        final imgResult = await ImagePicker()
                                            .pickImage(
                                                source: ImageSource.camera);

                                        if (imgResult != null) {
                                          File file = File(imgResult.path);
                                          final name =
                                              imgResult.path.split("/");

                                          String room = widget.id ?? "kimia";
                                          String ref =
                                              "chat/$room/${user!.uid}/${imgResult.name}";

                                          final imgResUpload =
                                              await FirebaseStorage.instance
                                                  .ref()
                                                  .child(ref)
                                                  .putFile(file);

                                          final url = await imgResUpload.ref
                                              .getDownloadURL();

                                          final chatContent = {
                                            "nama": user.displayName,
                                            "uid": user.uid,
                                            "content": textController.text,
                                            "email": user.email,
                                            "photo": user.photoURL,
                                            "ref": ref,
                                            "type": "file",
                                            "file_url": url,
                                            "time":
                                                FieldValue.serverTimestamp(),
                                          };
                                          chat
                                              .add(chatContent)
                                              .whenComplete(() {
                                            textController.clear();
                                          });
                                        }
                                      },
                                      icon: Icon(
                                        Icons.camera_alt,
                                        color: R.colors.iconColor,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    hintText: R.strings.inputChat,
                                    hintStyle: const TextStyle(
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.send,
                        color: R.colors.iconColor,
                      ),
                      onPressed: () {
                        if (textController.text.isEmpty) {
                          return;
                        }
                        // print(textController.text);

                        final chatContent = {
                          "nama": user!.displayName,
                          "uid": user.uid,
                          "content": textController.text,
                          "email": user.email,
                          "photo": user.photoURL,
                          "ref": null,
                          "type": "text",
                          "file_url": null,
                          "file_url": "user.photoURL",
                          "time": FieldValue.serverTimestamp(),
                        };
                        chat.add(chatContent).whenComplete(() {
                          textController.clear();
                        });
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
