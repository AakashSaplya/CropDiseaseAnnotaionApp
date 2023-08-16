import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:smartagro/auth_controller.dart';
import 'package:get/get.dart';
import 'package:smartagro/splash_screen.dart';
//import 'package:firebase_app_check/firebase_app_check.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) => Get.put(AuthController()));
  // await FirebaseAppCheck.instance.activate(
  //     webRecaptchaSiteKey: '6LeN3e4mAAAAAOzxxxpixSqhlXISamGpIcMGeHR-');
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Smart Agro',
      theme: ThemeData(
        primaryColor: Colors.green,
      ),
      home: const SplashScreen(),
    );
  }
}
