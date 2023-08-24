import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:smartagro/farmer/drawer/drawer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smartagro/notifications.dart';
import 'package:smartagro/savetodatabase.dart';

class HomePage extends StatefulWidget {
  final String email;
  const HomePage({Key? key, required this.email}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? mtoken = '';
  List<File> photos = [];
  List<String> photosnames = [];
  bool _flag = false;
  bool _flag2 = false;
  bool _flag3 = false;
  bool _imgselect = false;

  //to show current location
  String _messageOflocation = 'not detected';

  Future<void> _clickPhoto() async {
    //check for location
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    //String uniqueFileName = DateTime.now().toString();
    DateTime now = DateTime.now();
    String uniqueFileName = DateFormat('yyyyMMdd_HHmmss_S').format(now);

    if (pickedFile != null) {
      setState(() {
        photos.add(File(pickedFile.path));
        photosnames.add(uniqueFileName);
      });
    }
  }

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    String uniqueFileName = DateTime.now().toString();

    if (pickedFile != null) {
      setState(() {
        photos.add(File(pickedFile.path));
        photosnames.add(uniqueFileName);
      });
    }
  }

  void removeItem(int index) {
    setState(() {
      photos.removeAt(index);
      photosnames.removeAt(index);
    });
  }

  void nonSelected() {
    setState(() {
      _imgselect = true;
      Future.delayed(const Duration(milliseconds: 800), () {
        setState(() {
          _imgselect = false;
        });
      });
    });
  }

  void submitImages() {
    setState(() async {
      _flag = true;
      //upload the images of the list photos
      await uploadImages(photos, photosnames, widget.email);
      // Future.delayed(const Duration(seconds: 10), () {
      //   setState(() {
      //     _flag = false;
      //     resetPage();
      //   });
      // });
      _flag = false;
      resetPage();
    });
  }

  void resetPage() {
    setState(() {
      _flag2 = true;
      photos.clear();
      photosnames.clear();
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          _flag2 = false;
        });
      });
      _flag3 = false;
    });
  }

  Future<void> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.medium,
    );
    setState(() {
      _messageOflocation =
          'Latitude: ${position.latitude}, Longitude: ${position.longitude}';
    });
  }

  //for current location
  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    requestPermission();
    getToken();
    initInfo();
  }

  initInfo() {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    var androidInitialize =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: androidInitialize);
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      //action after pressing the notification
      onDidReceiveNotificationResponse: (payload) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NotifyPage(
                      email: widget.email,
                    )));
      },
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('..................onMessage...............................');
      print(
          'onMessage: ${message.notification?.title}/${message.notification?.body}');

      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(),
        htmlFormatContentTitle: true,
      );

      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'smartagro',
        'smartagro',
        importance: Importance.high,
        styleInformation: bigTextStyleInformation,
        priority: Priority.high,
        playSound: false,
      );
      NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(0, message.notification?.title,
          message.notification?.body, platformChannelSpecifics,
          payload: message.data['title']);
    });
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then(
      (token) {
        setState(() {
          mtoken = token;
          print('My token is $mtoken');
        });
        saveToken(token!);
      },
    );
  }

  void saveToken(String token) async {
    await FirebaseFirestore.instance
        .collection('userstoken')
        .doc(widget.email)
        .set({
      'token': token,
    });
    print('Token saved.');
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(192, 255, 210, 1),
      drawer: MyDrawer(email: widget.email),
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: const Text(
          'Smart Agro',
          style: TextStyle(),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotifyPage(
                              email: widget.email,
                            )));
              },
              icon: const Icon(Icons.notifications))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            const Column(
              children: [
                Text(
                  'Welcome To Smart Agro',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Capture photos and upload',
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
            Container(
                height: screenheight * 0.40,
                width: screenwidth * 0.98,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: const Border(
                    bottom: BorderSide(color: Colors.grey, width: 1.0),
                    top: BorderSide(color: Colors.grey, width: 1.0),
                    left: BorderSide(color: Colors.grey, width: 1.0),
                    right: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                ),
                child: (photos.isNotEmpty)
                    ? ListView.builder(
                        itemCount: photos.length,
                        itemBuilder: (context, index) {
                          return Container(
                            height: 75,
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.green, width: 1.0))),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              leading: SizedBox(
                                  height: 65,
                                  width: 65,
                                  child: Image.file(
                                    photos[index],
                                    fit: BoxFit.cover,
                                  )),
                              title: Text('Photo ${index + 1}'),
                              subtitle: Text(photosnames[index]),
                              trailing: IconButton(
                                icon: const Icon(Icons.remove_circle),
                                onPressed: () {
                                  setState(() {
                                    removeItem(index);
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      )
                    : _flag2
                        ? const Center(
                            child: Text(
                              'Submitted',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        : const Center(
                            child: Text(
                            'Select photos',
                            style: TextStyle(fontSize: 15),
                          ))),
            SizedBox(
              height: screenheight * 0.05,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(15)),
                      height: 60,
                      width: 60,
                      child: IconButton(
                        onPressed: _clickPhoto,
                        icon: const Icon(
                          Icons.camera_alt,
                          size: 40,
                        ),
                      ),
                    ),
                    const Text(
                      'Camera',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenheight * 0.11,
                  width: screenwidth * 0.11,
                  child: const Center(
                    child: Text(
                      'OR',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(15)),
                      height: 60,
                      width: 60,
                      child: IconButton(
                        onPressed: _pickPhoto,
                        icon: const Icon(
                          Icons.image,
                          size: 40,
                        ),
                      ),
                    ),
                    const Text(
                      'Gallery',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: screenheight * 0.05,
            ),
            Column(
              children: [
                _flag3
                    ? const Text(
                        'Submitting....',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.amber,
                            fontWeight: FontWeight.bold),
                      )
                    : Text(
                        'Total photos selected: ${photos.length}',
                        style: const TextStyle(fontSize: 12),
                      ),
                SizedBox(
                  height: screenheight * 0.03,
                ),
                (photos.isEmpty)
                    ? ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.green), // Set the desired background color
                        ),
                        onPressed: () {
                          setState(() {
                            //no photos selected
                            nonSelected();
                          });
                        },
                        child: const Text(
                          'Submit',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))
                    : _flag3
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors
                                      .green), // Set the desired background color
                            ),
                            onPressed: () {
                              setState(() {
                                _flag3 = true;
                                //call function increaseUploads
                                increaseUploads(widget.email, photos.length);
                                //submit the images of list photos
                                submitImages();
                              });
                            },
                            child: const Text(
                              'Submit',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                _imgselect
                    ? const Center(
                        child: Text('No images selected',
                            style: TextStyle(fontSize: 15, color: Colors.red)),
                      )
                    : const Center(
                        child: Text(' ', style: TextStyle(fontSize: 15))),
                SizedBox(
                  height: screenheight * 0.01,
                ),
                Text(
                  'Location ($_messageOflocation)',
                  style: TextStyle(fontSize: 11, color: Colors.grey[800]),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
