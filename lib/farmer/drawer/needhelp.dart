import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartagro/farmer/drawer/contactus.dart';

class NeedHelpPage extends StatefulWidget {
  const NeedHelpPage({super.key});

  @override
  State<NeedHelpPage> createState() => _NeedHelpPageState();
}

class _NeedHelpPageState extends State<NeedHelpPage> {
  List<Item> faquestions = [];

  @override
  void initState() {
    super.initState();
    fetchFAQItems().then((items) {
      setState(() {
        faquestions = items;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenheight = MediaQuery.of(context).size.height;
    double screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: const Text(
          'Need Help',
          style: TextStyle(),
        ),
      ),
      backgroundColor: const Color.fromRGBO(192, 255, 210, 1),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: screenheight * 0.050,
            ),
            const Text(
              ' FAQ ',
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  color: Colors.green),
            ),
            SizedBox(
              height: screenheight * 0.025,
            ),
            SizedBox(
              height: screenheight * 0.5,
              width: screenwidth * 0.9,
              child: ListView(
                children: faquestions.map<Widget>((Item item) {
                  return ExpansionPanelList(
                    elevation: 1,
                    expandedHeaderPadding: EdgeInsets.zero,
                    expansionCallback: (int index, bool isExpanded) {
                      setState(() {
                        item.isExpanded = !isExpanded;
                      });
                    },
                    children: [
                      ExpansionPanel(
                        backgroundColor: const Color.fromRGBO(192, 255, 210, 1),
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return ListTile(
                            title: Text(item.question),
                          );
                        },
                        body: Container(
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 0.75, color: Colors.grey))),
                          child: ListTile(
                            title: Text(item.answer),
                          ),
                        ),
                        isExpanded: item.isExpanded,
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
            SizedBox(
              height: screenheight * 0.025,
            ),
            RichText(
                text: TextSpan(
                    text: 'For more query  ',
                    style: TextStyle(
                        color: Colors.grey[900],
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                    children: [
                  TextSpan(
                    text: 'Contact Us',
                    style: const TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => Get.to(() => const ContactUsPage()),
                  ),
                ])),
          ],
        ),
      ),
    );
  }
}

//class Itme
class Item {
  String question;
  String answer;
  bool isExpanded;

  Item({
    required this.question,
    required this.answer,
    this.isExpanded = false,
  });
}

//collecting data from firebase
Future<List<Item>> fetchFAQItems() async {
  final faquestionsSnapshot =
      await FirebaseFirestore.instance.collection('faquestions').get();

  List<Item> faquestions = [];

  for (final doc in faquestionsSnapshot.docs) {
    final data = doc.data();
    final question = data['question'] as String;
    final answer = data['answer'] as String;

    faquestions.add(Item(question: question, answer: answer));
  }

  return faquestions;
}
