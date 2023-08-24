import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image/image.dart' as img;
import 'package:smartagro/annotator/annotation.dart';

enum AppState {
  picked,
  cropped,
}

class ImageCrop extends StatefulWidget {
  final String email;
  final File? imageFile;
  const ImageCrop({Key? key, required this.email, required this.imageFile})
      : super(key: key);

  @override
  State<ImageCrop> createState() => _ImageCropState();
}

class _ImageCropState extends State<ImageCrop> {
  late AppState state;
  File? imageFile;

  @override
  void initState() {
    super.initState();
    //_cropImage();
    state = AppState.picked;
  }

  Future<void> _cropImage() async {
    final CroppedFile? croppedFile = await ImageCropper()
        .cropImage(sourcePath: widget.imageFile!.path, aspectRatioPresets: [
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.ratio4x3,
    ], uiSettings: [
      AndroidUiSettings(
          backgroundColor: const Color.fromRGBO(192, 255, 210, 1),
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.green,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
    ]);
    if (croppedFile != null) {
      //change size of the cropped image
      // Read the image file
      final crpImage = File(croppedFile.path);
      final rawImage = img.decodeImage(crpImage.readAsBytesSync());

      // Resize the image to 512x512
      final resizedImage = img.copyResize(rawImage!, width: 512, height: 512);

      // Save the resized image to a new File
      final resizedImageFile = File(croppedFile.path)
        ..writeAsBytesSync(img.encodeJpg(resizedImage));
      imageFile = File(resizedImageFile.path);
      setState(() {
        state = AppState.cropped;
      });
    }
  }

  void cancelSubmit() {
    imageFile = null;
    setState(() {
      state = AppState.picked;
    });
  }

  Widget appBarText() {
    if (state == AppState.picked) {
      return const Text('Crop Image');
    } else if (state == AppState.cropped) {
      return const Text('Annotate Image');
    } else {
      return const SizedBox();
    }
  }

  Widget floatingButton() {
    return FloatingActionButton(
      onPressed: () {
        if (state == AppState.picked) {
          _cropImage();
        }
      },
      backgroundColor: Colors.green,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(37.5),
      ),
      child: _buildButtonIcon(),
    );
  }

  Widget _buildButtonIcon() {
    if (state == AppState.picked) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Icon(Icons.crop), Text('Crop')],
      );
    } else {
      return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: appBarText(),
      ),
      body: (state == AppState.picked)
          ? Center(
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                const SizedBox(height: 25),
                SizedBox(
                  height: screenHeight * 0.45,
                  width: screenWidth * 0.75,
                  child: Image(
                    image: FileImage(File(widget.imageFile!.path)),
                  ),
                ),
                const SizedBox(height: 35),
                SizedBox(
                  width: 75,
                  height: 75,
                  child: floatingButton(),
                ),
                const SizedBox(
                  height: 15,
                ),
              ]),
            )
          : (state == AppState.cropped)
              ? Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                  const SizedBox(height: 50),
                  Container(
                    height: 256,
                    width: 256,
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.grey)),
                    child: Image(
                      image: FileImage(File(imageFile!.path)),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 25,
                      ),
                      //floating action button for cancel
                      SizedBox(
                        height: 66,
                        width: 66,
                        child: FloatingActionButton(
                          onPressed: () {
                            cancelSubmit();
                          },
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(33),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.clear,
                                color: Colors.amber,
                              ),
                              Text(
                                'Cancel',
                                style: TextStyle(color: Colors.amber),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: screenWidth * 0.25,
                      ),
                      //floating action button for annotate
                      SizedBox(
                        height: 66,
                        width: 66,
                        child: FloatingActionButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AnnotateImage(
                                          image: imageFile,
                                          email: widget.email,
                                        )));
                          },
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(33),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Icon(Icons.check), Text('Next')],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                    ],
                  ),
                ])
              : const SizedBox(),
    );
  }
}
