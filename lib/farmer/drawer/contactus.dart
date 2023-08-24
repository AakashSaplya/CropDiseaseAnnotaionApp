import 'package:flutter/material.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: const Text(
          'Contact',
          style: TextStyle(),
        ),
      ),
      backgroundColor: const Color.fromRGBO(192, 255, 210, 1),
      body: Center(
          child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: screenheight * 0.1,
          ),
          const Text(
            'Contact Us',
            style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.w700, color: Colors.green),
          ),
          SizedBox(
            height: screenheight * 0.060,
          ),
          Text(
            'Office ',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.grey[900],
                fontSize: 17,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            child: Text('abcdefg hijklmn opqrs tuvw xyz',
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 17,
                  fontWeight: FontWeight.normal,
                )),
          ),
          SizedBox(
            height: screenheight * 0.025,
          ),
          Text(
            'Email ',
            style: TextStyle(
                color: Colors.grey[900],
                fontSize: 17,
                fontWeight: FontWeight.bold),
          ),
          const Text('abcxyz@gmail.com',
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 17,
                fontWeight: FontWeight.normal,
              )),
          SizedBox(
            height: screenheight * 0.025,
          ),
          Text(
            'Contact Number ',
            style: TextStyle(
                color: Colors.grey[900],
                fontSize: 17,
                fontWeight: FontWeight.bold),
          ),
          const Text('1234567890',
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 17,
                fontWeight: FontWeight.normal,
              )),
        ],
      )),
    );
  }
}
