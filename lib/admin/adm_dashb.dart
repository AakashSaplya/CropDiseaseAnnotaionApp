import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:smartagro/admin/adm_home.dart';
import 'package:smartagro/admin/adm_profile.dart';
import 'package:smartagro/admin/send_notifi.dart';
import 'package:smartagro/admin/users.dart';

import '../notifications.dart';

// ignore: must_be_immutable
class DashboardAdm extends StatefulWidget {
  String email;
  DashboardAdm({Key? key, required this.email}) : super(key: key);

  @override
  State<DashboardAdm> createState() => _DashboardAdmState();
}

class _DashboardAdmState extends State<DashboardAdm> {
  int currentIndex = 0;
  String? mtoken = '';

  final List<BottomNavigationBarItem> _navigationItems = [
    const BottomNavigationBarItem(
      backgroundColor: Colors.green,
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    const BottomNavigationBarItem(
      backgroundColor: Colors.green,
      icon: Icon(Icons.people),
      label: 'Users',
    ),
    const BottomNavigationBarItem(
      backgroundColor: Colors.green,
      icon: Icon(Icons.outbox),
      label: 'Outbox',
    ),
    const BottomNavigationBarItem(
      backgroundColor: Colors.green,
      icon: Icon(Icons.person),
      label: 'Profile',
    ),
  ];

//fetch users from firebase
  Future<ListData> fetchUsers() async {
    final usersSnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    List<Farmer> farmers = [];
    List<Admin> admins = [];
    List<Annotator> annotators = [];
    //List<String> nullList = [];

    for (final doc in usersSnapshot.docs) {
      //print(farmers);
      final data = doc.data();
      final email = data['email'] as String;
      final category = data['category'] as String;
      final submissions = data['submissions'] as int; 
      final uploads = data['uploads'] as int;
      if (category == 'farmer') {
        farmers.add(Farmer(
            email: email,
            category: category,
            submissions: submissions,
            uploads: uploads));
      } else if (category == 'admin') {
        admins.add(Admin(email: email, category: category));
      } else if (category == 'annotator') {
        annotators.add(Annotator(email: email, category: category, annotated: submissions));
      }
    }
    return ListData(farmers, admins, annotators);
  }

  @override
  void initState() {
    super.initState();
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
    //call all data
    Future<ListData> allData = fetchUsers();

    final List<Widget> pages = [
      HomePageAdm(
        annList: allData.then((value) => value.annotators),
        farmersList: allData.then((value) => value.farmers),
        admList: allData.then((value) => value.admins),
      ),
      UsersPage(
        annList: allData.then((value) => value.annotators),
        farmersList: allData.then((value) => value.farmers),
        admList: allData.then((value) => value.admins),
      ),
      SendNotifPage(email: widget.email),
      AdmProfilePage(email: widget.email),
    ];
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color.fromRGBO(192, 255, 210, 1),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color.fromRGBO(192, 255, 210, 1),
        unselectedItemColor: Colors.white,
        currentIndex: currentIndex,
        items: _navigationItems,
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
        backgroundColor: Colors.green,
      ),
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
    );
  }
}

//create Farmer class
class Farmer {
  final String email;
  final String category;
  final int submissions;
  late final int uploads;

  Farmer({
    required this.email,
    required this.category,
    required this.submissions,
    required this.uploads,
  });
}

//create Admin class
class Admin {
  final String email;
  final String category;

  Admin({
    required this.email,
    required this.category,
  });
}

//create Annotator class
class Annotator {
  final String email;
  final String category;
  final int annotated;

  Annotator({
    required this.email,
    required this.category,
    required this.annotated,
  });
}

//create data of all lists
class ListData {
  final List<dynamic> farmers;
  final List<dynamic> admins;
  final List<dynamic> annotators;

  ListData(this.farmers, this.admins, this.annotators);
}
