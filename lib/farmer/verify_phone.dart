import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:smartagro/farmer/phone_login.dart';

class VerifyPhoneNum extends StatelessWidget {
  const VerifyPhoneNum({super.key});

  @override
  Widget build(BuildContext context) {
    var smscodeController = TextEditingController();
    String mobnum = '1234567890';
    return Scaffold(
      backgroundColor: const Color.fromRGBO(192, 255, 210, 1),
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          const Text(
            'Verify Mobile Number',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('OTP has been sent on: '),
              Text(
                '+91 $mobnum',
                style: TextStyle(color: Colors.blue),
              ),
            ],
          ),
          const SizedBox(
            height: 50,
          ),
          TextField(
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            textAlignVertical: TextAlignVertical.bottom,
            controller: smscodeController,
            decoration: const InputDecoration(
              hintText: "Enter 6 digits code",
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          const SizedBox(
            height: 50,
          ),
          RichText(
              text: TextSpan(
                  text: 'Didn\'t receive OTP? ',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                  children: [
                TextSpan(
                  text: 'Retry',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 15,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => Get.to(() => const PhoneLogIn()),
                ),
              ])),
          ElevatedButton(onPressed: () {}, child: const Text('Verify')),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}
