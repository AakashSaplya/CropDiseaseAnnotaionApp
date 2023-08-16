import 'package:flutter/material.dart';
import 'package:smartagro/auth_controller.dart';
import 'package:smartagro/farmer/drawer/contactus.dart';
import 'package:smartagro/farmer/drawer/location.dart';
import 'package:smartagro/farmer/drawer/needhelp.dart';
import 'package:smartagro/notifications.dart';
import 'package:smartagro/farmer/drawer/privacypolicy.dart';

// ignore: must_be_immutable
class MyDrawer extends StatelessWidget {
  String email;
  MyDrawer({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromRGBO(239, 223, 182, 1),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
        children: [
          DrawerHeader(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: const Border(
                  bottom: BorderSide(color: Colors.grey, width: 1.0),
                  top: BorderSide(color: Colors.grey, width: 1.0),
                  left: BorderSide(color: Colors.grey, width: 1.0),
                  right: BorderSide(color: Colors.grey, width: 1.0),
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'Profile',
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.grey,
                    backgroundImage: AssetImage('assets/farmer01.jpg'),
                    //child: Icon(Icons.person),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  RichText(
                      text: TextSpan(
                          text: 'User: ',
                          style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                          children: [
                        TextSpan(
                          text: email,
                          style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ])),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              //color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: const Border(
                bottom: BorderSide(color: Colors.grey, width: 1.0),
                top: BorderSide(color: Colors.grey, width: 1.0),
                left: BorderSide(color: Colors.grey, width: 1.0),
                right: BorderSide(color: Colors.grey, width: 1.0),
              ),
            ),
            child: Column(
              children: [
                ListTile(
                  textColor: Colors.grey[800],
                  title: const Text('Notifications',
                      style: TextStyle(fontSize: 17)),
                  //trailing: const Icon(Icons.arrow_forward_ios),
                  leading: Icon(
                    Icons.notifications,
                    color: Colors.grey[800],
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NotifyPage(
                                  email: email,
                                )));
                  },
                ),
                ListTile(
                  textColor: Colors.grey[800],
                  title: const Text(
                    'Location',
                    style: TextStyle(fontSize: 17),
                  ),
                  leading: Icon(
                    Icons.location_on,
                    color: Colors.grey[800],
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Mylocation()));
                  },
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              //color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: const Border(
                bottom: BorderSide(color: Colors.grey, width: 1.0),
                top: BorderSide(color: Colors.grey, width: 0.0),
                left: BorderSide(color: Colors.grey, width: 1.0),
                right: BorderSide(color: Colors.grey, width: 1.0),
              ),
            ),
            child: Column(
              children: [
                ListTile(
                  textColor: Colors.grey[800],
                  title:
                      const Text('Contact Us', style: TextStyle(fontSize: 17)),
                  leading: Icon(
                    Icons.contact_page,
                    color: Colors.grey[800],
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ContactUsPage()));
                  },
                ),
                ListTile(
                  textColor: Colors.grey[800],
                  title: const Text(
                    'Need Help',
                    style: TextStyle(fontSize: 17),
                  ),
                  leading: Icon(
                    Icons.help,
                    color: Colors.grey[800],
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NeedHelpPage()));
                  },
                ),
                ListTile(
                  textColor: Colors.grey[800],
                  title: const Text(
                    'Privacy Policy',
                    style: TextStyle(fontSize: 17),
                  ),
                  leading: Icon(
                    Icons.privacy_tip,
                    color: Colors.grey[800],
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PrivacyPolPage()));
                  },
                ),
                ListTile(
                  title: const Text('Log Out', style: TextStyle(fontSize: 17)),
                  textColor: Colors.red,
                  leading: Icon(
                    Icons.logout,
                    color: Colors.grey[800],
                  ),
                  onTap: () {
                    AuthController.instance.logout();
                    // Handle drawer item 2 tap
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
