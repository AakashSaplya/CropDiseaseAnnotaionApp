import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Mylocation extends StatefulWidget {
  const Mylocation({super.key});

  @override
  State<Mylocation> createState() => _MylocationState();
}

class _MylocationState extends State<Mylocation> {
  String textToshow = '';
  late String lat;
  late String long;
  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }
    //return null;
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission are denied');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  void _liveLocation() {
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.low,
      distanceFilter: 100,
    );

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      lat = position.latitude.toString();
      long = position.longitude.toString();

      setState(() {
        textToshow = 'Latitude: $lat , Longitude: $long';
      });
    });
  }

  Future<void> _openMap(String lat, String long) async {
    String googleURL =
        'https://www.google.com/maps/search/?api=1&query=$lat,$long';
    await canLaunchUrlString(googleURL)
        ? await launchUrlString(googleURL)
        : throw 'Could not launch Google URL';
  }

  @override
  Widget build(BuildContext context) {
    //double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(192, 255, 210, 1),
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: const Text(
          'Location',
          style: TextStyle(),
        ),
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          const SizedBox(
            height: 50,
          ),
          Text(
            textToshow,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                _getCurrentLocation().then((value) {
                  lat = '${value.latitude}';
                  long = '${value.longitude}';
                  setState(() {
                    textToshow = 'Latitude: $lat , Longitude: $long';
                  });
                  _liveLocation();
                });
              },
              child: const Text('Get Current Location')),
          const Text('Click here to get your current location'),
          SizedBox(
            height: screenheight * 0.15,
          ),
          SizedBox(
            height: 200,
            width: 200,
            child: Lottie.asset(
              'assets/map-pin-location.json',
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          ElevatedButton(
              onPressed: () {
                _openMap(lat, long);
                //_openMap('26.4710', '73.1134');
              },
              child: const Text('Google Map')),
          const Text('Click here to get location on google maps')
        ],
      )),
    );
  }
}
