import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/constant/constant.dart';
import 'package:final_project/constant/r.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    CollectionReference chat = FirebaseFirestore.instance
        .collection("room")
        .doc("kimia")
        .collection("chat");

    return Scaffold(
        appBar: AppBar(
          title: const Text("Diskusi Soal"),
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Nama",
                          style: chating,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: R.colors.pink,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "Pesan",
                          ),
                        ),
                        Text(
                          "Waktu Kirim",
                          style: chating.copyWith(
                              color: R.colors.greySubtitleHome),
                        ),
                      ],
                    ),
                  );
                }),
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
                                padding: EdgeInsets.symmetric(vertical: 4),
                                height: 50,
                                child: TextField(
                                  controller: textController,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.camera_alt,
                                        color: R.colors.iconColor,
                                      ),
                                    ),
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 5),
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
                        print(textController.text);
                        final user = FirebaseAuth.instance.currentUser;

                        final chatContent = {
                          "nama": user!.displayName,
                          "uid": user.uid,
                          "content": textController.text,
                          "email": user.email,
                          "photo": user.photoURL,
                          "time": FieldValue.serverTimestamp(),
                        };
                        chat.add(chatContent);
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
