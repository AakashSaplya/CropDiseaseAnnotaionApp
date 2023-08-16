import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartagro/farmer/login_page.dart';
import 'package:smartagro/farmer/verify_phone.dart';

class PhoneLogIn extends StatefulWidget {
  const PhoneLogIn({super.key});

  @override
  State<PhoneLogIn> createState() => _PhoneLogInState();
}

class _PhoneLogInState extends State<PhoneLogIn> {
  var numberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(192, 255, 210, 1),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              const Text(
                'Mobile Number Login',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              const CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage("assets/wheat_login.jpg"),
              ),
              const SizedBox(
                height: 25,
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  textAlignVertical: TextAlignVertical.bottom,
                  controller: numberController,
                  decoration: const InputDecoration(
                    hintText: "Enter phone number",
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                  width: 150,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const VerifyPhoneNum()));
                      },
                      child: const Text('Send OTP'))),
              const SizedBox(
                height: 50,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Divider(
                      color: Colors.grey,
                      height: 1,
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Other Methods',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.grey,
                      height: 1,
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              RichText(
                  text: TextSpan(
                      text: 'Signin/Register using email ',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 15,
                      ),
                      children: [
                    TextSpan(
                      text: 'Click here',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 15,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Get.to(() => const LoginPage()),
                    ),
                  ])),
              const SizedBox(
                height: 25,
              ),
              const Text(
                'Or',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                width: 150,
                decoration: BoxDecoration(
                  border: Border.all(),
                ),
                child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 17,
                        backgroundImage: AssetImage("assets/google_logo.jpg"),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Google Sign-In')
                    ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
