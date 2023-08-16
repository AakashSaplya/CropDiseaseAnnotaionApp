import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../admin/adm_dashb.dart';

class FarmersList extends StatefulWidget {
  const FarmersList({super.key});

  @override
  State<FarmersList> createState() => _FarmersListState();
}

class _FarmersListState extends State<FarmersList> {
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
      final uploads = data['uploads'] as int;
      if (category == 'farmer') {
        farmers.add(Farmer(email: email, category: category, uploads: uploads));
      } else if (category == 'admin') {
        admins.add(Admin(email: email, category: category));
      } else if (category == 'annotator') {
        annotators.add(Annotator(email: email, category: category));
      }
    }
    return ListData(farmers, admins, annotators);
  }

  @override
  Widget build(BuildContext context) {
    //double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    //fetch data
    //call all data
    Future<ListData> allData = fetchUsers();
    Future<List<dynamic>> farmersList = allData.then((value) => value.farmers);
    return Scaffold(
      backgroundColor: const Color.fromRGBO(192, 255, 210, 1),
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: const Text(
          'Farmer\'s List',
          style: TextStyle(),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenHeight * 0.80,
          child: FutureBuilder<List<dynamic>>(
            future: farmersList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (snapshot.hasData) {
                final users = snapshot.data!;

                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(15, 4, 15, 2),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(15)),
                        child: ListTile(
                          title: Text(user.email),
                          subtitle: Text('uploads: ${user.uploads}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.arrow_forward_ios),
                            onPressed: () {},
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text('No users found.'),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
