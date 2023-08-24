import 'package:flutter/material.dart';
import 'package:smartagro/admin/admin_login.dart';
import 'package:smartagro/annotator/ann_login.dart';
import 'package:smartagro/farmer/login_page_phone_num.dart';
import 'package:smartagro/xyz.dart';
import 'annotator/abcd.dart';

class CommonAuthPage extends StatelessWidget {
  const CommonAuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    //double screen_height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(192, 255, 210, 1),
      body: Center(
        child: Container(
          width: 280,
          height: 450,
          decoration: const BoxDecoration(
            color: Colors.white,
            //borderRadius: BorderRadius.circular(15),
          ),
          child: Column(children: [
            const SizedBox(
              height: 25,
            ),
            const Text(
              'Welcome To Smart Agro',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 25,
            ),
            const CircleAvatar(
              backgroundColor: Color.fromRGBO(192, 255, 210, 1),
              radius: 50,
              child: Icon(
                Icons.person,
                size: 50,
                color: Colors.green,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              'Select to Login as',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 35,
            ),
            GestureDetector(
              onTap: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => const VerifyPhoneNum(
                //             verificationId: 'kdkdjaiiddji',
                //             phonenum: '+917610192933')));
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginWithphoneNum()));
              },
              child: Container(
                width: screenWidth * 0.45,
                height: 35,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromRGBO(192, 255, 210, 1),
                    border: Border.all()),
                child: const Center(
                  child: Text(
                    'Farmer',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AdminLoginPage()));
              },
              child: Container(
                width: screenWidth * 0.45,
                height: 35,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromRGBO(192, 255, 210, 1),
                    border: Border.all()),
                child: const Center(
                  child: Text(
                    'Admin',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AnnLoginPage()));
              },
              child: Container(
                width: screenWidth * 0.45,
                height: 35,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromRGBO(192, 255, 210, 1),
                    border: Border.all()),
                child: const Center(
                  child: Text(
                    'Annotator',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
          ]),
        ),
      ),
    );
  }
}
