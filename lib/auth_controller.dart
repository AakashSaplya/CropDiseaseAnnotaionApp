import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smartagro/admin/adm_dashb.dart';
import 'package:smartagro/annotator/home_ann.dart';
import 'package:smartagro/common_authpage.dart';
import 'package:smartagro/farmer/asklocation.dart';
//import 'home.dart';

class AuthController extends GetxController {
  //to access globally
  static AuthController instance = Get.find();
  //for email and passwords.....
  late Rx<User?> _user;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(auth.currentUser);
    //our user would be notified
    _user.bindStream(auth.userChanges());
    ever(_user, _initialScreen);
  }

  _initialScreen(User? user) async {
    //check log in or not
    if (user == null) {
      print('Common auth page');
      Get.offAll(() => const CommonAuthPage());

      // user logged in
    } else {
      print('email print ${user.email}');

      // Check user already  in the Firestore database
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.email)
          .get();
      if (userSnapshot.exists) {
        //get user data
        Map<String, dynamic>? userData =
            userSnapshot.data() as Map<String, dynamic>?;
        //get the category of the user
        if (userData != null) {
          String category = userData['category'];
          print('category is: $category');

          //according to category open UI
          if (category == 'farmer') {
            Get.offAll(() => AskLocation(email: user.email!));
          } else if (category == 'admin') {
            Get.offAll(() => DashboardAdm(email: user.email!));
          } else if (category == 'annotator') {
            Get.offAll(() => HomePageAnn(
                  email: user.email!,
                ));
          } else {
            // Handle unknown category or error
          }
        }
      }
    }
  }

  void register(String email, password, catg_) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await FirebaseFirestore.instance.collection('users').doc(email).set({
        'email': email,
        'category': catg_,
        'uploads': 0,
      });
    } catch (e) {
      //print(e);
      String errormsg = e.toString();
      errormsg = errormsg.replaceAll(RegExp(r'\[.*?\] '), '');
      Get.snackbar("About User", "User message",
          backgroundColor: Colors.redAccent,
          snackPosition: SnackPosition.BOTTOM,
          titleText: const Text(
            "Account creation failed",
            style: TextStyle(color: Colors.white),
          ),
          messageText: Text(
            errormsg,
            style: const TextStyle(color: Colors.white),
          ));
    }
  }

  void login(String email, password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      //print(e);
      String errormsg = e.toString();
      errormsg = errormsg.replaceAll(RegExp(r'\[.*?\] '), '');
      Get.snackbar("About Login", "User message",
          backgroundColor: Colors.redAccent,
          snackPosition: SnackPosition.BOTTOM,
          titleText: const Text(
            "Login failed",
            style: TextStyle(color: Colors.white),
          ),
          messageText: Text(
            //e.toString(),
            errormsg,
            style: const TextStyle(color: Colors.white),
          ));
    }
  }

  void signinWithGoogle(cat_) async {
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      //obtain auth details
      final GoogleSignInAuthentication gAuth = await gUser!.authentication;

      //creat a new credential for user
      final credential_ = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );
      //now sign in and get user credintial
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential_);
      User? user = userCredential.user;

      if (user != null) {
        // Access user properties
        String email = user.email.toString();
        //check user exist in firestore or not
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(email)
            .get();
        if (userSnapshot.exists) {
          //
        } else {
          // User doesn't exist, save the category information in the Firestore database
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'email': email,
            'category': cat_,
            'uploads': 0,
          });
        }
      }
    } catch (e) {
      Get.snackbar(
        "Google Sign-In failed",
        e.toString(),
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
      );
    }
  }

  void logout() async {
    await GoogleSignIn().signOut();
    await auth.signOut();
  }
}
