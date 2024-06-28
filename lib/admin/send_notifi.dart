import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class SendNotifPage extends StatefulWidget {
  String email;
  SendNotifPage({Key? key, required this.email}) : super(key: key);

  @override
  State<SendNotifPage> createState() => _SendNotifPageState();
}

class _SendNotifPageState extends State<SendNotifPage> {
  TextEditingController username = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController body = TextEditingController();

  void sendPushMessage(String token, String body, String title) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key= go-to-the-firebase-cloud-messaging-for-the key'
        },
        body: jsonEncode(
          <String, dynamic>{
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done',
              'body': body,
              'title': title,
            },
            'notification': <String, dynamic>{
              'title': title,
              'body': body,
              'android_channel_id': 'smartagro'
            },
            'to': token,
          },
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print('error in sending the notification');
      }
    }
  }

  @override
  void dispose() {
    username.dispose();
    title.dispose();
    body.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    //double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(192, 255, 210, 1),
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: const Text(
          'Outbox',
          style: TextStyle(),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Container(
              width: screenWidth * 0.8,
              height: 45,
              //color: Colors.white,
              child: TextFormField(
                  //textAlignVertical: TextAlignVertical.bottom,
                  controller: username,
                  decoration: const InputDecoration(
                    hintText: "write or paste user\'s email",
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: screenWidth * 0.8,
              height: 45,
              //color: Colors.white,
              child: TextFormField(
                  //textAlignVertical: TextAlignVertical.bottom,
                  controller: title,
                  decoration: const InputDecoration(
                    hintText: "write title",
                  )),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              width: screenWidth * 0.8,
              height: 45,
              //color: Colors.white,
              child: TextFormField(
                  //textAlignVertical: TextAlignVertical.bottom,
                  controller: body,
                  decoration: const InputDecoration(
                    hintText: "write message",
                  )),
            ),
            const SizedBox(
              height: 40,
            ),
            GestureDetector(
              onTap: () async {
                String name = username.text.trim();
                String titleText = title.text;
                String bodyText = body.text;

                if (name != '') {
                  DocumentSnapshot<Map<String, dynamic>> snapshot =
                      await FirebaseFirestore.instance
                          .collection('userstoken')
                          .doc(name)
                          .get();

                  String token = snapshot['token'];
                  print(token);

                  //send notification to above name user on pushing the button
                  sendPushMessage(token, bodyText, titleText);

                  //save messages to firebase
                  await FirebaseFirestore.instance
                      .collection('notifications')
                      .doc(name)
                      .collection(name)
                      .doc()
                      .set({
                    'title': titleText,
                    'body': bodyText,
                  });
                }

                username.clear();
                title.clear();
                body.clear();
              },
              child: Container(
                margin: const EdgeInsets.all(20),
                height: 40,
                width: 200,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: Colors.greenAccent.withOpacity(0.5)),
                    ]),
                child: const Center(
                  child: Text('Send Notification'),
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}
