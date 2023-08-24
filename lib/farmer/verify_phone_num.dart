import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smartagro/auth_controller.dart';

class VerifyPhoneNum extends StatefulWidget {
  final String verificationId;
  final String phonenum;
  const VerifyPhoneNum(
      {super.key, required this.verificationId, required this.phonenum});

  @override
  State<VerifyPhoneNum> createState() => _VerifyPhoneNumState();
}

class _VerifyPhoneNumState extends State<VerifyPhoneNum> {
  bool loading = false;
  final smsCodeController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    loading = false;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(192, 255, 210, 1),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(children: [
          const SizedBox(
            height: 40,
          ),
          const Text(
            'Verify Mobile Number',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 12,
          ),
          RichText(
              text: TextSpan(
                  text: 'OTP has been sent on: ',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                  children: [
                TextSpan(
                  text: widget.phonenum,
                  style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ])),
          const SizedBox(
            height: 40,
          ),
          TextFormField(
            textAlign: TextAlign.center,
            controller: smsCodeController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: 'Enter 6 digit code'),
          ),
          const SizedBox(
            height: 100,
          ),
          RichText(
              text: const TextSpan(
                  text: 'Didn\'t get OTP ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                  children: [
                TextSpan(
                  text: 'Resend',
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ])),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 45,
            width: 200,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  loading = true;
                });
                AuthController.instance.signinWithPhoneNumber(
                    widget.verificationId, smsCodeController.text.toString());
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (!loading)
                    const Text(
                      'Verify',
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
                    ), // Show the text if not loading
                  if (loading)
                    const CircularProgressIndicator(
                      color: Colors.white,
                    ), // Show the progress indicator if loading
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}
