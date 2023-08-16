import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartagro/auth_controller.dart';
import 'package:smartagro/farmer/phone_login.dart';
import 'package:smartagro/farmer/signup_page.dart';
import 'package:smartagro/pass_forgt_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    //double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(192, 255, 210, 1),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            const Text(
              'Email Login',
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
              height: 200,
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
                    controller: emailController,
                    decoration: InputDecoration(
                        hintText: "Enter email",
                        prefixIcon: Icon(
                          Icons.email,
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
                  height: 18,
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
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const PasswordForgotPage();
                }));
              },
              child: const Text('Forgot Password',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 15,
                  )),
            ),
            const SizedBox(
              height: 12,
            ),
            GestureDetector(
              onTap: () {
                AuthController.instance.login(emailController.text.trim(),
                    passwordController.text.trim());
              },
              child: Container(
                width: screenWidth * 0.9,
                height: 50,
                decoration: const BoxDecoration(color: Colors.blue),
                child: const Center(
                  child: Text(
                    'Log In',
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
                    text: 'Don\'t have an account? ',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 15,
                    ),
                    children: [
                  TextSpan(
                    text: 'Sign up',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 15,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => Get.to(() => const SignupPage()),
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
            ),
            const SizedBox(
              height: 10,
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
                    text: 'click here',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 15,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => Get.to(() => const PhoneLogIn()),
                  ),
                ])),
          ],
        ),
      ),
    );
  }
}
