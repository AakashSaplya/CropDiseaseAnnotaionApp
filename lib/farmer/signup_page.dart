import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartagro/auth_controller.dart';
import 'package:smartagro/farmer/login_page.dart';

import 'login_page_phone_num.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  List images = [
    'google_logo.jpg',
    // 'twitter.png',
    // 'facebook.png',
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    //double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(192, 255, 210, 1),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Email Register',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 15,
              ),
              const CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage('assets/tea image1.jpeg'),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 240,
                child: Column(children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: screenWidth * 0.9,
                    height: 45,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                              blurRadius: 5,
                              offset: Offset(1, 1),
                              color: Colors.grey)
                        ]),
                    child: TextField(
                      textAlignVertical: TextAlignVertical.bottom,
                      controller: nameController,
                      decoration: InputDecoration(
                          hintText: "Enter Name",
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.grey[500],
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 1.0)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 1)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5))),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: screenWidth * 0.9,
                    height: 45,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                              blurRadius: 5,
                              offset: Offset(1, 1),
                              color: Colors.grey)
                        ]),
                    child: TextField(
                      textAlignVertical: TextAlignVertical.bottom,
                      controller: emailController,
                      decoration: InputDecoration(
                          hintText: "Enter email",
                          prefixIcon: Icon(
                            Icons.mail,
                            color: Colors.grey[500],
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 1.0)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 1)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5))),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: screenWidth * 0.9,
                    height: 45,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                              blurRadius: 5,
                              offset: Offset(1, 1),
                              color: Colors.grey)
                        ]),
                    child: TextField(
                      textAlignVertical: TextAlignVertical.bottom,
                      controller: passwordController,
                      decoration: InputDecoration(
                          hintText: "Enter password",
                          prefixIcon: Icon(
                            Icons.remove_red_eye_sharp,
                            color: Colors.grey[500],
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 1.0)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 1)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5))),
                    ),
                  ),
                ]),
              ),
              const SizedBox(
                height: 5,
              ),
              GestureDetector(
                onTap: () {
                  String category = 'farmer';
                  AuthController.instance.register(emailController.text.trim(),
                      passwordController.text.trim(), category);
                },
                child: Container(
                  width: screenWidth * 0.9,
                  height: 50,
                  decoration: const BoxDecoration(color: Colors.blue),
                  child: const Center(
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              RichText(
                  text: TextSpan(
                      text: 'Already have an account? ',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 15,
                      ),
                      children: [
                    TextSpan(
                      text: 'Log In',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 15,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Get.to(() => const LoginPage()),
                    ),
                  ])),
              const SizedBox(
                height: 5,
              ),
              const SizedBox(
                height: 20,
                child: Row(
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
                        'Or',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
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
              ),
              const SizedBox(
                height: 15,
              ),
              RichText(
                  text: TextSpan(
                      text: 'Mobile Signin ',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                      children: [
                    TextSpan(
                      text: 'Click here',
                      style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Get.to(() => const LoginWithphoneNum()),
                    ),
                  ])),
            ],
          ),
        ),
      ),
    );
  }
}
