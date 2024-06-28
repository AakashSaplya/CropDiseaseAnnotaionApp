# Smartagro
# Crop Diasease Annotation App
A Flutter project.

## Description 
This is an android application to collect crop images from users/farmers and annotate these images for further use (deep learning and computer vision). The App is developed using software development kit flutter.
The app contains three different User Interfaces for three different categories of users; farmers, annotators and administrators.
The data is uploaded and retrieved using Firebase as the backend service.

## Snapshots of App 
<img src="Image1.jpg" alt="First page" width="300" height="450" /> <img src="Image2.jpg" alt="LogIn" width="300" height="450" />
<img src="Image3.jpg" alt="Image3" width="300" height="450" />
<img src="Image4.jpg" alt="Image4" width="300" height="450" />
<img src="Image5.jpg" alt="Image5" width="300" height="450" />
<img src="Image6.jpg" alt="Image6" width="300" height="450" />
<img src="Image7.jpg" alt="Image7" width="300" height="450" />
<img src="Image8.jpg" alt="Image8" width="300" height="450" />


## Installation
Requirements: 
  1. Flutter sdk 
  2. Android Studio
  3. VS code

To install flutter sdk: : https://docs.flutter.dev/get-started/install 
Install android studio and vs code from official websites. 

Download code and run: 
1. Download the zip file of the code (available above) 
2. Extract the zip file  to a new directory in C: drive.
example:  C:\newfolder\flutter Apps\CropDataAnnotationApp
3. Open the folder in the vs code
5. From Explorer in vs code open the main.dart file (CropDataAnnotationApp\lib\main.dart)
6. Connect the emulator. Press the No device and select the mobile emulator(if emulator is not available create android emulator). It will take little time to connect the emulator
7. In vs code terminal change directory to the app folder and run command: flutter pub get
8. Run the main.dart file in vs code by run button or using terminal: flutter run. It will take a little bit longer to run the app on emulator. 
10. Open other files from the CropDataAnnotationApp\lib\ to edit or create new dart files accordingly.

## Before running the code
To connect firebase and to avoid errors, upload google-services.json (from your firebase project) to android/app directory and ensure to make necessary changes in the android/build.gradle and android/app/build.gradle files. 
For more information go to: https://firebase.google.com/docs/android/setup
