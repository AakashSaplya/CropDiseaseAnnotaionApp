import 'package:flutter/material.dart';
import 'package:smartagro/admin/adm_dashb.dart';

// ignore: must_be_immutable
class HomePageAdm extends StatelessWidget {
  Future<List<dynamic>> farmersList;
  Future<List<dynamic>> annList;
  Future<List<dynamic>> admList;
  HomePageAdm(
      {Key? key,
      required this.farmersList,
      required this.annList,
      required this.admList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(192, 255, 210, 1),
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: const Text(
          'Home',
          style: TextStyle(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Welcome To Smart Agro',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text('(Admin Page)',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            const SizedBox(
              height: 5,
            ),
            const Divider(
              thickness: 1,
            ),
            Container(
              height: 150,
              width: 300,
              color: Colors.grey[100],
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FutureBuilder<List<dynamic>>(
                      future: farmersList,
                      builder: (context, snapshot) {
                        final users = snapshot.data!;
                        int totaluploads = gettotalUploads(users);
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('Total uploads: $totaluploads'),
                            const SizedBox(
                              height: 15,
                            ),
                            Text('Farmers: ${users.length}'),
                          ],
                        );
                      },
                    ),
                    FutureBuilder<List<dynamic>>(
                      future: admList,
                      builder: (context, snapshot) {
                        final users = snapshot.data!;
                        return Text('Admins: ${users.length}');
                      },
                    ),
                    FutureBuilder<List<dynamic>>(
                      future: annList,
                      builder: (context, snapshot) {
                        final users = snapshot.data!;
                        return Text('Annotators: ${users.length}');
                      },
                    ),
                  ]),
            ),
            const Divider(
              thickness: 1,
            ),
            const Text('User Activity',
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

int gettotalUploads(List users) {
  int totaluploads = 0;
  for (Farmer user in users) {
    totaluploads += user.uploads;
  }
  return totaluploads;
}
