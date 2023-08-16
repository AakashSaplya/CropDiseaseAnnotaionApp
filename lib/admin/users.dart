import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class UsersPage extends StatefulWidget {
  Future<List<dynamic>> farmersList;
  Future<List<dynamic>> annList;
  Future<List<dynamic>> admList;
  UsersPage(
      {Key? key,
      required this.farmersList,
      required this.annList,
      required this.admList})
      : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    double screenheight = MediaQuery.of(context).size.height;
    double screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(192, 255, 210, 1),
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: const Text(
          'Users',
          style: TextStyle(),
        ),
      ),
      body: (index == 0)
          ? Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          index = 0;
                        });
                      },
                      child: Container(
                        height: 40,
                        width: screenwidth * 0.33,
                        color: const Color.fromARGB(255, 222, 146, 118),
                        child: const Center(child: Text('Farmers')),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          index = 1;
                        });
                      },
                      child: Container(
                        height: 30,
                        width: screenwidth * 0.33,
                        color: const Color.fromARGB(255, 222, 146, 118),
                        child: const Center(child: Text('Annotators')),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          index = 2;
                        });
                      },
                      child: Container(
                        height: 30,
                        width: screenwidth * 0.33,
                        color: const Color.fromARGB(255, 222, 146, 118),
                        child: const Center(child: Text('Admins')),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  'Farmer\'s List',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                ),
                SingleChildScrollView(
                  child: SizedBox(
                    height: screenheight * 0.60,
                    child: FutureBuilder<List<dynamic>>(
                      future: widget.farmersList,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                                padding:
                                    const EdgeInsets.fromLTRB(15, 4, 15, 2),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(15)),
                                  child: ListTile(
                                    title: Text(user.email),
                                    subtitle: Text('uploads: ${user.uploads}'),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.copy),
                                      onPressed: () {
                                        String emailcopied = user.email;

                                        Clipboard.setData(
                                            ClipboardData(text: emailcopied));
                                        const snackBar = SnackBar(
                                          content:
                                              Text('email copied to clipboard'),
                                          backgroundColor: Colors.blueAccent,
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      },
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
              ],
            )
          : (index == 1)
              ? Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              index = 0;
                            });
                          },
                          child: Container(
                            height: 30,
                            width: screenwidth * 0.33,
                            color: const Color.fromARGB(255, 222, 146, 118),
                            child: const Center(child: Text('Farmers')),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              index = 1;
                            });
                          },
                          child: Container(
                            height: 40,
                            width: screenwidth * 0.33,
                            color: const Color.fromARGB(255, 222, 146, 118),
                            child: const Center(child: Text('Annotators')),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              index = 2;
                            });
                          },
                          child: Container(
                            height: 30,
                            width: screenwidth * 0.33,
                            color: const Color.fromARGB(255, 222, 146, 118),
                            child: const Center(child: Text('Admins')),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      'Annotator\'s List',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SingleChildScrollView(
                      child: SizedBox(
                        height: screenheight * 0.60,
                        child: FutureBuilder<List<dynamic>>(
                          future: widget.annList,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
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
                                    padding:
                                        const EdgeInsets.fromLTRB(15, 4, 15, 2),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: ListTile(
                                        title: Text(user.email),
                                        // subtitle:
                                        //     Text('uploads: ${user.uploads}'),
                                        trailing: IconButton(
                                          icon: const Icon(Icons.copy),
                                          onPressed: () {
                                            String emailcopied = user.email;

                                            Clipboard.setData(ClipboardData(
                                                text: emailcopied));
                                            const snackBar = SnackBar(
                                              content: Text(
                                                  'email copied to clipboard'),
                                              backgroundColor:
                                                  Colors.blueAccent,
                                            );
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                          },
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
                  ],
                )
              : Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              index = 0;
                            });
                          },
                          child: Container(
                            height: 30,
                            width: screenwidth * 0.33,
                            color: const Color.fromARGB(255, 222, 146, 118),
                            child: const Center(child: Text('Farmers')),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              index = 1;
                            });
                          },
                          child: Container(
                            height: 30,
                            width: screenwidth * 0.33,
                            color: const Color.fromARGB(255, 222, 146, 118),
                            child: const Center(child: Text('Annotators')),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              index = 2;
                            });
                          },
                          child: Container(
                            height: 40,
                            width: screenwidth * 0.33,
                            color: const Color.fromARGB(255, 222, 146, 118),
                            child: const Center(child: Text('Admins')),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      'Admin\'s List',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SingleChildScrollView(
                      child: SizedBox(
                        height: screenheight * 0.60,
                        child: FutureBuilder<List<dynamic>>(
                          future: widget.admList,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
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
                                    padding:
                                        const EdgeInsets.fromLTRB(15, 4, 15, 2),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: ListTile(
                                        title: Text(user.email),
                                        // subtitle:
                                        //     Text('uploads: ${user.uploads}'),
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
                  ],
                ),
    );
  }
}
