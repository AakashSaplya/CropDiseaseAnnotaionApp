import 'package:flutter/material.dart';
import '../auth_controller.dart';
import '../farmer/drawer/contactus.dart';
import '../farmer/drawer/needhelp.dart';
import '../farmer/drawer/privacypolicy.dart';
import '../notifications.dart';

// ignore: must_be_immutable
class AdmProfilePage extends StatelessWidget {
  String email;
  AdmProfilePage({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    //double screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(),
        ),
      ),
      body: Container(
        width: screenwidth * 1,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: const Border(
            bottom: BorderSide(color: Colors.grey, width: 1.0),
            top: BorderSide(color: Colors.grey, width: 1.0),
            left: BorderSide(color: Colors.grey, width: 1.0),
            right: BorderSide(color: Colors.grey, width: 1.0),
          ),
        ),
        child: Column(children: [
          const SizedBox(
            height: 22,
          ),
          const CircleAvatar(
            radius: 37,
            backgroundColor: Colors.green,
            child: CircleAvatar(
              radius: 35,
              backgroundColor: Color.fromRGBO(192, 255, 210, 1),
              child: Icon(
                Icons.person,
                size: 50,
                color: Colors.green,
              ),
            ),
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
          const SizedBox(
            height: 20,
          ),
          Column(
            children: [
              const Divider(
                thickness: 1,
              ),
              ListTile(
                textColor: Colors.grey[800],
                title:
                    const Text('Notifications', style: TextStyle(fontSize: 17)),
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
                title: const Text('Contact Us', style: TextStyle(fontSize: 17)),
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
              const Divider(
                thickness: 1,
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
                  }),
            ],
          ),
        ]),
      ),
    );
  }
}
