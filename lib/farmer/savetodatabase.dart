import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

Future<void> uploadImages(
    List<File> images, List<String> imagesnames, String email_) async {
  //initiate firebase storage and storageref
  final FirebaseStorage storage = FirebaseStorage.instance;
  final Reference storageRef = storage.ref();

  List<String> photosurl = [];
  String folderpath = email_;
  DateTime now = DateTime.now();
  String subfolderpath = DateFormat('yyyyMMdd_HHmmss').format(now);

  for (int i = 0; i < images.length; i++) {
    //print image name
    print(imagesnames[i]);

    // Get a reference to the photo file in Firebase Storage
    final Reference imageRef =
        storageRef.child('$folderpath/$subfolderpath/${imagesnames[i]}');

    // Upload the photo file to Firebase Storage
    final TaskSnapshot uploadTask = await imageRef.putFile(images[i]);

    // Get the download URL of the uploaded photo
    final String downloadUrl = await uploadTask.ref.getDownloadURL();

    //add url of the uploaded photo to list
    photosurl.add(downloadUrl);

    //check photo uploaded or not
    print('photo${i + 1} uploaded');
  }

  //call function to upload urls
  //uploadImgurls(email_, photosurl);
}

Future<void> uploadImgurls(String email_, List<String> imagesurl) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  for (int i = 0; i < imagesurl.length; i++) {
    // Create a new document reference in the 'Images' collection
    DocumentReference documentRef = firestore.collection('Images').doc();

    // Prepare the data to be saved
    Map<String, dynamic> data = {
      'email': email_,
      'image$i': imagesurl[i],
    };
    i += 1;
    // Save the data to Firestore
    documentRef.set(data).then((value) {
      print('Data saved successfully!');
    }).catchError((error) {
      print('Failed to save data: $error');
    });
  }
  // for (var imgurl in imagesurl) {
  //   //content above
  // }
}

//to increase the uploads in firebase
void increaseUploads(String email, int numUploads) {
  FirebaseFirestore.instance
      .collection('users')
      .doc(email)
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      Farmer2 farmer = Farmer2.fromSnapshot(documentSnapshot);
      // Increment the number of equipments used
      int uploads = farmer.uploads + numUploads;

      // Update the corresponding document in Firestore
      FirebaseFirestore.instance
          .collection('users')
          .doc(email)
          .update({'uploads': uploads}).then((value) {
        print('Number of uploads increased for farmer: $email');
      }).catchError((error) {
        print('Failed to update uploads count: $error');
      });
    } else {
      print('farmer not found');
    }
  }).catchError((error) {
    print('Failed to retrieve farmer: $error');
  });
}

class Farmer2 {
  final String email;
  final String category;
  int uploads;

  Farmer2({
    required this.email,
    required this.category,
    required this.uploads,
  });

  factory Farmer2.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Farmer2(
      email: data['email'],
      category: data['category'],
      uploads: data['uploads'],
    );
  }
}
