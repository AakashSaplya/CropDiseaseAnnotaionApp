import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NotifyPage extends StatefulWidget {
  String email;
  NotifyPage({Key? key, required this.email}) : super(key: key);

  @override
  State<NotifyPage> createState() => _NotifyPageState();
}

class _NotifyPageState extends State<NotifyPage> {
  List<MessageData> messageDataList = [];

  @override
  void initState() {
    super.initState();
    fetchMessageData();
  }

  Future<void> fetchMessageData() async {
    try {
      CollectionReference notifiCollection = FirebaseFirestore.instance
          .collection('notifications')
          .doc(widget.email)
          .collection(widget.email);
      QuerySnapshot notifiSnapshot = await notifiCollection.get();

      List<MessageData> tempList = [];

      //loop to fetch the data
      for (DocumentSnapshot messages in notifiSnapshot.docs) {
        dynamic messageData = messages.data();
        String title = messageData?['title'] ?? '';
        String body = messageData?['title'] ?? '';

        tempList.add(MessageData(title: title, body: body));
      }

      setState(() {
        messageDataList = tempList;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    int listsize = messageDataList.length;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(192, 255, 210, 1),
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: const Text(
          'Notifications',
          style: TextStyle(),
        ),
      ),
      body: Center(
          child: (listsize != 0)
              ? ListView.builder(
                  itemCount: messageDataList.length,
                  itemBuilder: (context, index) {
                    MessageData quizData = messageDataList[index];
                    return ListTile(
                      title: Text(quizData.title),
                      subtitle: Text(quizData.body),
                    );
                  },
                )
              : const Text('No notifications yet')),
    );
  }
}

class MessageData {
  final String title;
  final String body;

  MessageData({required this.title, required this.body});
}
