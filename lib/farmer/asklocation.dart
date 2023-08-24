import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smartagro/farmer/home.dart';

// ignore: must_be_immutable
class AskLocation extends StatelessWidget {
  String email;
  AskLocation({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenheight = MediaQuery.of(context).size.height;
    double screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(192, 255, 210, 1),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: screenheight * 0.20,
            child: Lottie.asset(
              'assets/89437-location-loading.json',
              fit: BoxFit.cover,
            ),
          ),
          const Text(
            'Give Location permission',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Text('Share location for better experiences'),
          SizedBox(
            height: screenheight * 0.35,
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                //direct navigate to homepage if location has already enabled
                //// ignore: unrelated_type_equality_checks
                if (Geolocator.isLocationServiceEnabled() == true) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomePage(email: email)));
                }
                enableLocation(context, email);
              },
              child: Container(
                width: screenwidth * 0.9,
                height: 45,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.blueGrey),
                child: const Center(
                  child: Text(
                    'Allow Permission',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> enableLocation(BuildContext context, String email) async {
  bool locatioinEnabled = await Geolocator.isLocationServiceEnabled();
  if (!locatioinEnabled) {
    // ignore: use_build_context_synchronously
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Enable Location'),
            content: const Text('Please enable location services to continue.'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel')),
              TextButton(
                onPressed: () {
                  Geolocator.openLocationSettings();
                  Navigator.of(context).pop();
                },
                child: const Text('Open Settings'),
              )
            ],
          );
        });
  } else {
    //location service enabled
    //navigate to home page
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => HomePage(email: email)));
  }
}
