import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smartagro/annotator/annotation.dart';
import 'package:image/image.dart' as img;

class PickImage extends StatefulWidget {
  const PickImage({super.key});

  @override
  State<PickImage> createState() => _PickImageState();
}

class _PickImageState extends State<PickImage> {
  File? _image;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);

    if (pickedImage != null) {
      // Read the image file
      final imageFile = File(pickedImage.path);
      final rawImage = img.decodeImage(imageFile.readAsBytesSync());

      // Resize the image to 512x512
      final resizedImage = img.copyResize(rawImage!, width: 256, height: 256);

      // Save the resized image to a new File
      final resizedImageFile = File(pickedImage.path)
        ..writeAsBytesSync(img.encodeJpg(resizedImage));

      setState(() {
        _image = resizedImageFile;
      });
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Picker Demo'),
        backgroundColor: Colors.green,
      ),
      body: GestureDetector(
        onDoubleTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeScreen(
                        image: _image,
                      )));
        },
        child: Center(
          child: _image == null
              ? const Text('No image selected.')
              : Image.file(_image!),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.green,
            child: const Icon(Icons.photo_library),
            onPressed: () => _pickImage(ImageSource.gallery),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            backgroundColor: Colors.green,
            child: const Icon(Icons.camera_alt),
            onPressed: () => _pickImage(ImageSource.camera),
          ),
        ],
      ),
    );
  }
}
