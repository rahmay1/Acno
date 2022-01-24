import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:acne_detector/pages/chat_page.dart';
import 'package:acne_detector/pages/home_page.dart';
import 'package:acne_detector/pages/profile_page.dart';
import 'package:acne_detector/pages/saved_page.dart';
import 'package:acne_detector/theme/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:acne_detector/com/request.dart';
import 'dart:math' as math;
import 'dart:io';
import 'package:acne_detector/camera/camera.dart';
import 'package:acne_detector/camera/capture.dart';
import 'package:acne_detector/camera/preview.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras = [];

class RootApp extends StatefulWidget {
  const RootApp({Key? key}) : super(key: key);

  @override
  _RootAppState createState() => _RootAppState();
}


class _RootAppState extends State<RootApp> {
  int activeTab = 0;
  File? _pickedImage;

  void _pickImage() async {
    final imageSource = await showDialog<ImageSource>(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text("Select the image source"),
              actions: <Widget>[
                MaterialButton(
                    child: Text("Camera"),
                    onPressed: () => Navigator.pop(context, ImageSource.camera)
                ),
                MaterialButton(
                  child: Text("Gallery"),
                  onPressed: () => Navigator.pop(context, ImageSource.gallery),
                )
              ],
            )
    );

    if(imageSource != null) {
      ImagePicker i = new ImagePicker();
      final file = await i.pickImage(source: imageSource);
      if(file != null) {
        setState(() => _pickedImage = File( file.path ));
      }
    }
  }

  Future<void> _initCamera() async {
    // Fetch the available cameras before initializing the app.
    try {
      WidgetsFlutterBinding.ensureInitialized();
      cameras = await availableCameras();
    } on CameraException catch (e) {
      print('Error in fetching the cameras: $e');
    }
  }

  void runCamera() {
    _initCamera().then((i) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CameraScreen()),);
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: getFooter(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: getFloatingButton(),
      body: getBody(),
    );
  }

  Widget getBody() {
    return IndexedStack(
      index: activeTab,
      children: [
        HomePage(),
        ChatPage(),
        Center(
          child: _pickedImage == null ?
          Text("No Image") :
          Image(image: FileImage(_pickedImage as File)),
        ),
        SavedPage(),
        ProfilePage()
      ],
    );
  }

  Widget getFooter() {
    return Container(
      width: double.infinity,
      height: 90,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 20,
              offset: Offset(0, 1)),
        ],
        borderRadius: BorderRadius.circular(20),
        color: white,
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      activeTab = 0;
                    });
                  },
                  child: Icon(
                    Feather.home,
                    size: 25,
                    color: activeTab == 0 ? primary : black,
                  ),
                ),
                SizedBox(
                  width: 55,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      activeTab = 1;
                    });
                  },
                  child: Icon(
                    IconData(58311, fontFamily: 'MaterialIcons'),
                    size: 30,
                    color: activeTab == 1 ? primary : black,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      activeTab = 3;
                    });
                  },
                  child: Icon(
                    IconData(57702, fontFamily: 'MaterialIcons'),
                    size: 28,
                    color: activeTab == 3 ? primary : black,
                  ),
                ),
                SizedBox(
                  width: 55,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      activeTab = 4;
                    });
                  },
                  child: Icon(
                    MaterialIcons.account_circle,
                    size: 28,
                    color: activeTab == 4 ? primary : black,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget getFloatingButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          //_pickedImage == null ? _pickImage() : main([""], _pickedImage as File);
          runCamera();
          //activeTab = 2;
        });
      },
      child: Transform.rotate(
        angle: -math.pi / 4,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 15,
                offset: Offset(0, 1)),
          ], color: _pickedImage == null ? black : green
              , borderRadius: BorderRadius.circular(23)),
          child: Transform.rotate(
            angle: math.pi / 4,
            child: Center(
                child: Icon(
                  _pickedImage == null ? Ionicons.md_add_circle : IconData(61533, fontFamily: 'MaterialIcons'),
                  color: white,
                  size: _pickedImage == null ? 35:50,
                )),
          ),
        ),
      ),
    );
  }
}
