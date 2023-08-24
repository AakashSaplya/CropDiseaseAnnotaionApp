import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartagro/farmer/login_page.dart';
import 'package:smartagro/farmer/verify_phone_num.dart';
import '../auth_controller.dart';

class LoginWithphoneNum extends StatefulWidget {
  const LoginWithphoneNum({super.key});

  @override
  State<LoginWithphoneNum> createState() => _LoginWithphoneNumState();
}

class _LoginWithphoneNumState extends State<LoginWithphoneNum> {
  bool isLoading = false;
  final phoneNumController = TextEditingController();
  final auth = FirebaseAuth.instance;

  void sendOTP() {
    setState(() {
      isLoading = true; // Set isLoading to true to show the progress indicator
    });

    // Perform the verification process
    auth.verifyPhoneNumber(
      phoneNumber: '+91${phoneNumController.text}',
      verificationCompleted: (_) {},
      verificationFailed: (e) {
        setState(() {
          isLoading =
              false; // Set isLoading to false to hide the progress indicator
        });

        Get.snackbar(
          "Unable To send OTP",
          'Check your number',
          backgroundColor: Colors.redAccent,
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
        );
      },
      codeSent: (String verificationId, int? token) {
        setState(() {
          isLoading =
              false; // Set isLoading to false to hide the progress indicator
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyPhoneNum(
              verificationId: verificationId,
              phonenum: '+91${phoneNumController.text}',
            ),
          ),
        );
      },
      codeAutoRetrievalTimeout: (e) {
        setState(() {
          isLoading =
              false; // Set isLoading to false to hide the progress indicator
        });

        Get.snackbar(
          " ",
          'Verification code auto-retrieval timeout',
          backgroundColor: Colors.blueAccent,
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //double screenWidth = MediaQuery.of(context).size.width;
    //double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(192, 255, 210, 1),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(children: [
            const SizedBox(
              height: 30,
            ),
            const Text(
              'Mobile Number Login',
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
            TextFormField(
              textAlign: TextAlign.center,
              controller: phoneNumController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Enter phone number'),
            ),
            const SizedBox(
              height: 120,
            ),
            SizedBox(
              height: 50,
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  sendOTP();
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (!isLoading)
                      const Text(
                        'Send OTP',
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.w500),
                      ), // Show the text if not loading
                    if (isLoading)
                      const CircularProgressIndicator(
                        color: Colors.white,
                      ), // Show the progress indicator if loading
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 45,
            ),
            const SizedBox(
              height: 30,
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
            ),
            const SizedBox(
              height: 15,
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
                        fontWeight: FontWeight.bold),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => Get.to(() => const LoginPage()),
                  ),
                ])),
            const SizedBox(
              height: 15,
            ),
            const Text(
              'Or',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 15,
            ),
            GestureDetector(
              onTap: () {
                String category = 'farmer';
                AuthController.instance.signinWithGoogle(category);
              },
              child: Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                  border: Border.all(),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 15,
                    ),
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage('assets/google_logo.jpg'),
                    ),
                    Text('Google Sign-In'),
                    SizedBox(
                      width: 15,
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}


// () {
//                     auth.verifyPhoneNumber(
//                         phoneNumber: '+91${phoneNumController.text}',
//                         verificationCompleted: (_) {},
//                         verificationFailed: (e) {
//                           Get.snackbar(
//                             "Unable To send OTP",
//                             'Check your number',
//                             backgroundColor: Colors.redAccent,
//                             snackPosition: SnackPosition.BOTTOM,
//                             colorText: Colors.white,
//                           );
//                         },
//                         codeSent: (String verificationId, int? token) {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => VerifyPhoneNum(
//                                         verificationId: verificationId,
//                                         phonenum:
//                                             '+91${phoneNumController.text}',
//                                       )));
//                         },
//                         codeAutoRetrievalTimeout: (e) {
//                           Get.snackbar(
//                             "Unable to Send OTP",
//                             'Try again',
//                             backgroundColor: Colors.redAccent,
//                             snackPosition: SnackPosition.BOTTOM,
//                             colorText: Colors.white,
//                           );
//                         });
//                   },