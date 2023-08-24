import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartagro/auth_controller.dart';
import 'package:smartagro/farmer/login_page_phone_num.dart';
import 'package:smartagro/pass_forgt_page.dart';
import 'package:smartagro/farmer/signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  List images = [
    'google_logo.jpg',
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
              // Container(
              //     width: screenWidth * 1,
              //     height: screenHeight * 0.35,
              //     decoration: const BoxDecoration(
              //         image: DecorationImage(
              //             image: AssetImage("assets/wheat_login.jpg"),
              //             fit: BoxFit.cover))),
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Email Login',
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
                height: 20,
              ),
              SizedBox(
                height: 200,
                child: Column(children: [
                  // Container(
                  //   width: screenWidth * 1,
                  //   height: 40,
                  //   decoration: const BoxDecoration(
                  //       color: Color.fromRGBO(157, 249, 183, 1),
                  //       borderRadius: BorderRadius.only(
                  //           bottomLeft: Radius.circular(32),
                  //           bottomRight: Radius.circular(32))),
                  //   child: const Text(
                  //     'Log In',
                  //     textAlign: TextAlign.center,
                  //     style:
                  //         TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  //   ),
                  // ),
                  const SizedBox(
                    height: 30,
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
                height: 15,
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
              // RichText(
              //     text: TextSpan(
              //   text: 'Sign in using google',
              //   style: TextStyle(color: Colors.grey[700], fontSize: 16),
              // )),
              // Wrap(
              //   children: List<Widget>.generate(
              //     1,
              //     ((index) {
              //       return Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: CircleAvatar(
              //           radius: 20,
              //           backgroundColor: Colors.white,
              //           child: GestureDetector(
              //             onTap: () {
              //               String category = 'farmer';
              //               AuthController.instance.signinWithGoogle(category);
              //             },
              //             child: CircleAvatar(
              //               radius: 17,
              //               backgroundImage:
              //                   AssetImage('assets/' + images[index]),
              //             ),
              //           ),
              //         ),
              //       );
              //     }),
              //   ),
              // ),
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
