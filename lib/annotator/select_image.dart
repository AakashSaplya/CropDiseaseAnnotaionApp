import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:smartagro/annotator/image_crop.dart';
import 'package:uuid/uuid.dart';

class SelectImage extends StatelessWidget {
  final String email;
  const SelectImage({Key? key, required this.email}) : super(key: key);

  //fetch images from firebase
  Future<List<File>> fetchImageUrlsFromFirebase() async {
    List<File> imageFiles = [];

    // Reference to the Firestore collection containing the images
    CollectionReference imagesCollection =
        FirebaseFirestore.instance.collection('Images');

    // Query the collection to fetch the documents
    QuerySnapshot<Object?> snapshot = await imagesCollection.get();

    // Iterate over the documents and extract the image URLs
    for (var document in snapshot.docs) {
      // Access the 'image' field from the document and add it to the list
      String imageUrl = document['image'];
      //imageUrls.add(imageUrl);

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
        centerTitle: true,
        backgroundColor: Colors.green,
        title: const Text('Annotate Image'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 30,
          ),
          const Text(
            'Select an image to annotate',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
              height: screenHeight * 0.80,
              width: screenWidth * 0.90,
              child: FutureBuilder<List<File>>(
                future: fetchImageUrlsFromFirebase(),
                builder:
                    (BuildContext context, AsyncSnapshot<List<File>> snapshot) {
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
                                                  email: email,
                                                  imageFile: imageFiles[index],
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
              )),
          const Divider(
            thickness: 2,
            height: 4,
          ),
        ],
      ),
    );
  }
}
