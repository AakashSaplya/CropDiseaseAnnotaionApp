import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'annotator/annotation.dart';

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
  //uploadImgurls(email_, photosurl, imagesnames);
  //call function to upload user wise
  uploadImgurlsUserwise(email_, photosurl, imagesnames, subfolderpath);
}

//upload all the images together
Future<void> uploadImgurls(
    String email_, List<String> imagesurl, List<String> imagesnames) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  for (int i = 0; i < imagesurl.length; i++) {
    // Create a new document reference in the 'Images' collection
    DocumentReference documentRef =
        firestore.collection('Images').doc(imagesnames[i]);

    // Prepare the data to be saved
    Map<String, dynamic> data = {
      'email': email_,
      'image': imagesurl[i],
      'img name': imagesnames[i],
    };

    // Save the data to Firestore
    documentRef.set(data).then((value) {
      print('Data saved successfully!');
    }).catchError((error) {
      print('Failed to save data: $error');
    });
  }
}

//upload images user wise/ in users collection/doc
Future<void> uploadImgurlsUserwise(String email_, List<String> imagesurl,
    List<String> imagesnames, String subfolder) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Create a new document reference in the 'Images' collection
  DocumentReference documentRef = firestore
      .collection('Uploaded Images2')
      .doc(email_)
      .collection(email_)
      .doc(subfolder);
  // Prepare the data to save subfolder field
  Map<String, dynamic> data1 = {
    'subfolder': subfolder,
  };
  documentRef.set(data1);

  //add the images urls in the subfolder
  for (int i = 0; i < imagesurl.length; i++) {
    // Create a new document reference in the 'Images' collection
    DocumentReference documentRef2 =
        documentRef.collection(subfolder).doc(imagesnames[i]);

    // Prepare the data to be saved
    Map<String, dynamic> data = {
      'email': email_,
      'image': imagesurl[i],
      'img name': imagesnames[i],
    };

    // Save the data to Firestore
    documentRef2.set(data).then((value) {
      print('Data saved successfully!');
    }).catchError((error) {
      print('Failed to save data: $error');
    });
  }
}

//to increase the uploads in firebase
void increaseUploads(String email, int numUploads) {
  FirebaseFirestore.instance
      .collection('users')
      .doc(email)
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      Users user = Users.fromSnapshot(documentSnapshot);
      // Increment the number of uploads
      int uploads = user.uploads + numUploads;
      //increment the number of submissions
      int submissions = user.submissions + 1;

      // Update the corresponding document in Firestore
      FirebaseFirestore.instance.collection('users').doc(email).update(
          {'submissions': submissions, 'uploads': uploads}).then((value) {
        print('Number of uploads increased for user: $email');
      }).catchError((error) {
        print('Failed to update uploads count: $error');
      });
    } else {
      print('user not found');
    }
  }).catchError((error) {
    print('Failed to retrieve user: $error');
  });
}

Future<void> uploadAnnotatedImg(
    String email, File image, List<RectangleLabel> rectangleLabels) async {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final Reference storageRef = storage.ref();

  String imageUrl = '';
  DateTime now = DateTime.now();
  String imagename = DateFormat('yyyyMMdd_HHmmss').format(now);
  final Reference imageRef = storageRef.child('Annotated Images/$imagename');

  // Upload the photo file to Firebase Storage
  final TaskSnapshot uploadTask = await imageRef.putFile(image);

  // Get the download URL of the uploaded photo
  final String downloadUrl = await uploadTask.ref.getDownloadURL();

  //add url of the uploaded photo to list
  imageUrl = downloadUrl;

  //check photo uploaded or not
  print('Annotated Image uploaded');

  //upload url in firebase cloudstore
  uploadAnnotatedImgurl(email, imagename, imageUrl, rectangleLabels);
}

Future<void> uploadAnnotatedImgurl(String email_, String imagename,
    String imageUrl, List<RectangleLabel> rectangleLabels) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Create a new document reference in the 'Images' collection
  DocumentReference documentRef =
      firestore.collection('AnnotatedImages').doc(imagename);

  //get data from the rectangleLabels
  // Create an empty map to store the Rect objects as keys and nested maps as values
  Map<String, Map<String, dynamic>> rectValueMap = {};

  int i = 0;
  // Iterate through the rectangleLabels list and add them to the map
  for (var rectangleLabel in rectangleLabels) {
    i += 1;
    rectValueMap['rectangle $i'] = {
      'label': rectangleLabel.label,
      'top': rectangleLabel.rect.top,
      'bottom': rectangleLabel.rect.bottom,
      'left': rectangleLabel.rect.left,
      'right': rectangleLabel.rect.right,
      'height': rectangleLabel.rect.height,
      'width': rectangleLabel.rect.width,
    };
  }

  // Prepare the data to be saved
  Map<String, dynamic> data = {
    'annot. by': email_,
    'annot. data': rectValueMap,
    'img link': imageUrl,
    'img name': imagename,
    'img size w': '256',
    'img size h': '256',
  };
  // Save the data to Firestore
  documentRef.set(data).then((value) {
    print('Data saved successfully!');
  }).catchError((error) {
    print('Failed to save data: $error');
  });
}

//to increase the annotation uploads in firebase
void increaseAnnUploads(String email) {
  FirebaseFirestore.instance
      .collection('users')
      .doc(email)
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      Users user = Users.fromSnapshot(documentSnapshot);
      // Increment the number of uploads
      //int uploads = user.uploads + numUploads;
      //increment the number of submissions
      int submissions = user.submissions + 1;

      // Update the corresponding document in Firestore
      FirebaseFirestore.instance
          .collection('users')
          .doc(email)
          .update({'submissions': submissions}).then((value) {
        print('Number of uploads increased for user: $email');
      }).catchError((error) {
        print('Failed to update uploads count: $error');
      });
    } else {
      print('user not found');
    }
  }).catchError((error) {
    print('Failed to retrieve user: $error');
  });
}

class Users {
  final String email;
  final String category;
  int submissions;
  int uploads;

  Users({
    required this.email,
    required this.category,
    required this.submissions,
    required this.uploads,
  });

  factory Users.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Users(
      email: data['email'],
      category: data['category'],
      submissions: data['submissions'],
      uploads: data['uploads'],
    );
  }
}
