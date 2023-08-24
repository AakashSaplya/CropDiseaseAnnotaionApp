import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smartagro/annotator/image_crop.dart';
import 'package:uuid/uuid.dart';
import '../admin/adm_dashb.dart';
import 'package:http/http.dart' as http;

class FarmersList extends StatefulWidget {
  final String email;
  const FarmersList({super.key, required this.email});

  @override
  State<FarmersList> createState() => _FarmersListState();
}

class _FarmersListState extends State<FarmersList> {
  late Future<List<dynamic>> farmersList;
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
        annotators.add(
            Annotator(email: email, category: category, annotated: uploads));
      }
    }
    return ListData(farmers, admins, annotators);
  }

  @override
  Widget build(BuildContext context) {
    double screenheight = MediaQuery.of(context).size.height;
    double screenwidth = MediaQuery.of(context).size.width;
    //call all data
    Future<ListData> allData = fetchUsers();
    farmersList = allData.then((value) => value.farmers);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: const Text('Farmer\'s List'),
      ),
      backgroundColor: const Color.fromRGBO(192, 255, 210, 1),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container(
                height: screenheight * 0.85,
                width: screenwidth * 0.95,
                decoration: const BoxDecoration(
                    border: Border(
                        left: BorderSide(color: Colors.green),
                        right: BorderSide(color: Colors.green),
                        bottom: BorderSide(color: Colors.green))),
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
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 300),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 4, 15, 2),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: ListTile(
                                      title: Text(user.email),
                                      subtitle: Row(
                                        children: [
                                          Text(
                                              'submissions: ${user.submissions}'),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text('uploads: ${user.uploads}'),
                                        ],
                                      ),
                                      trailing: IconButton(
                                        icon:
                                            const Icon(Icons.arrow_forward_ios),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      FarmersSubmissions(
                                                        farmerEmail: user.email,
                                                        email: widget.email,
                                                      )));
                                        },
                                      ),
                                    ),
                                  ),
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
        ),
      ),
    );
  }
}

//class to fetch the submissions of a farmer
class FarmersSubmissions extends StatefulWidget {
  final String farmerEmail;
  final String email;
  const FarmersSubmissions(
      {Key? key, required this.farmerEmail, required this.email})
      : super(key: key);

  @override
  State<FarmersSubmissions> createState() => _FarmersSubmissionsState();
}

class _FarmersSubmissionsState extends State<FarmersSubmissions> {
  //list to store the number of uploaded images in a folder
  List<int> uploadsCount = [];

  //fetch user's submission from firebase
  Future<List<String>> fetchUsersSubmissions() async {
    final usersSnapshot = FirebaseFirestore.instance
        .collection('Uploaded Images')
        .doc(widget.farmerEmail)
        .collection(widget.farmerEmail);

    final usersSnapshot2 = await usersSnapshot.get();

    //list to store the submissionId/ folder name
    List<String> submissionsList = [];

    for (final doc in usersSnapshot2.docs) {
      final data = doc.data();
      final submissionId = data['subfolder'];
      submissionsList.add(submissionId);

      //to find the number of uploaded images in a particular submission
      final usersSnapshot3 =
          await usersSnapshot.doc(submissionId).collection(submissionId).get();
      //get number of images/docs
      final imagesNum = usersSnapshot3.size;
      //add to the list uploadCount
      uploadsCount.add(imagesNum);
    }
    return submissionsList;
  }

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
          'Submissions',
          style: TextStyle(),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            height: screenheight * 0.85,
            width: screenwidth * 0.95,
            decoration: const BoxDecoration(
                border: Border(
                    left: BorderSide(color: Colors.green),
                    right: BorderSide(color: Colors.green),
                    bottom: BorderSide(color: Colors.green))),
            child: FutureBuilder<List<String>>(
              future: fetchUsersSubmissions(),
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
                  final data = snapshot.data!;

                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final subfolder = data[index];
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(15, 4, 15, 2),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(15)),
                          child: ListTile(
                            title: Text('${index + 1}. $subfolder'),
                            subtitle:
                                Text('Uploaded Images: ${uploadsCount[index]}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.arrow_forward_ios),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UploadedImages(
                                              submissionId: subfolder,
                                              farmerEmail: widget.farmerEmail,
                                              email: widget.email,
                                            )));
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
      ),
    );
  }
}

//class to fetch the uploaded images of a submission of a farmer
class UploadedImages extends StatelessWidget {
  final String submissionId;
  final String farmerEmail;
  final String email;
  const UploadedImages(
      {super.key,
      required this.submissionId,
      required this.farmerEmail,
      required this.email});

  //fetch user's submission from firebase
  Future<List<File>> fetchUploadedImages() async {
    final usersSnapshot = await FirebaseFirestore.instance
        .collection('Uploaded Images')
        .doc(farmerEmail)
        .collection(farmerEmail)
        .doc(submissionId)
        .collection(submissionId)
        .get();

    //create a list to store the images
    List<File> imageFiles = [];

    for (final doc in usersSnapshot.docs) {
      //get data of a doc
      final data = doc.data();
      //assign image field data to imageUrl
      final imageUrl = data['image'];

      // Fetch the image bytes using the http package
      final response = await http.get(Uri.parse(imageUrl));

      // Create a temporary file to store the image bytes
      final tempDir = await getTemporaryDirectory();

      // Generate a unique filename for each image
      String filename = '${const Uuid().v4()}.jpg';
      final tempFile = File('${tempDir.path}/$filename');

      // Write the image bytes to the temporary file
      await tempFile.writeAsBytes(response.bodyBytes);

      // Add the temporary file to the list
      imageFiles.add(tempFile);
    }
    return imageFiles;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(192, 255, 210, 1),
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: const Text(
          'Uploaded Images',
          style: TextStyle(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            Text(
              'Farmers Id: $farmerEmail',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const Text(
              'Uploaded Images for Submission',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            Text(
              '\'$submissionId\'',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: SizedBox(
                height: screenHeight * 0.80,
                width: screenWidth * 0.90,
                child: FutureBuilder<List<File>>(
                  future: fetchUploadedImages(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<File>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // While waiting for the future to complete, show a loading indicator
                      return const Center(
                          child: SizedBox(child: CircularProgressIndicator()));
                    } else if (snapshot.hasError) {
                      //error occurs during the future execution, display an error message
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      //future completes successfully and returns data, build the GridView
                      List<File> imageFiles = snapshot.data!;
                      return AnimationLimiter(
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 8.0,
                            crossAxisSpacing: 8.0,
                            childAspectRatio: 1.0,
                          ),
                          itemCount: imageFiles.length,
                          itemBuilder: (BuildContext context, int index) {
                            return AnimationConfiguration.staggeredGrid(
                              position: index,
                              columnCount: 3,
                              duration: const Duration(milliseconds: 500),
                              child: ScaleAnimation(
                                child: FadeInAnimation(
                                  child: GestureDetector(
                                    onDoubleTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ImageCrop(
                                                    email: 'email',
                                                    imageFile:
                                                        imageFiles[index],
                                                  )));
                                    },
                                    child: Image.file(
                                      imageFiles[index],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      // Handle the case when the future completes with no data
                      return const Text('No images found');
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
