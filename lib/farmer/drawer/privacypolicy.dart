import 'package:flutter/material.dart';

class PrivacyPolPage extends StatelessWidget {
  const PrivacyPolPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: const Text(
          'Privacy Policy',
          style: TextStyle(),
        ),
      ),
      backgroundColor: const Color.fromRGBO(192, 255, 210, 1),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(25.0),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 15,
              ),
              Text(
                'Privacy Policy',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                  style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w400),
                  'Last Updated: dd/mm/yyyy \n[Your Company/App Name] our operates the Smart Agro mobile application (the "App").\nThis page informs you of our policies regarding the collection, use, and disclosure of personal information \nwe receive from users of the App.'),
              SizedBox(
                height: 20,
              ),
              Text(
                'Information Collection and Use',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                  style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w400),
                  'The App collects images(variuous plant disease) uploaded by the users. The purpose of collecting the images is to investigate and analyze images for plant disease prediction and others.'),
              SizedBox(
                height: 20,
              ),
              Text(
                'Log Data ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                  style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w400),
                  'We may collect information that your device sends whenever you use the App ("Log Data"). This Log Data may include information such as your device\'s location, the time and date of your use, and other statistics.'),
              SizedBox(
                height: 20,
              ),
              Text(
                'Security',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                  style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w400),
                  'The security of your personal information is important to us. We take reasonable measures to protect and secure the information collected through the App. However, please be aware that no method of transmission over the internet or electronic storage is completely secure and we cannot guarantee the absolute security of your information.'),
              SizedBox(
                height: 20,
              ),
              Text(
                'Third-Party Services',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                  style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w400),
                  'We may employ third-party companies and individuals to facilitate the App, provide services on our behalf, or assist us in analyzing how the App is used. These third parties have access to your personal information only to perform these tasks on our behalf and are obligated not to disclose or use it for any other purpose.'),
              SizedBox(
                height: 20,
              ),
              Text(
                'Chinldren\'s Privacy ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                  style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w400),
                  'The App is not intended for use by children under the age of 13. We do not knowingly collect personal information from children under 13. If we discover that a child under 13 has provided us with personal information, we will promptly delete such information from our servers.'),
              SizedBox(
                height: 20,
              ),
              Text(
                'Changes to this Privacy Policy ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                  style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w400),
                  'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.'),
              SizedBox(
                height: 20,
              ),
              Text(
                'Terms and Conditions',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                  style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w400),
                  'The misuse of the app could be against the law. Uploading the irrelevant images i.e. images not related to plants ............................'),
              SizedBox(
                height: 20,
              ),
              Text(
                'Contact Us',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                  style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w400),
                  'If you have any questions about this Privacy Policy, please contact us.'),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
