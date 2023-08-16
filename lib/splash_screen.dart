import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      color: const Color.fromRGBO(192, 255, 210, 1),
      child: const Center(
        child: SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              //backgroundColor: Colors.white,
              color: Colors.green,
            )),
      ),
    );
  }
}
