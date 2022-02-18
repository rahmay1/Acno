import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:acne_detector/pages/chat_page.dart';
import 'package:acne_detector/pages/home_page.dart';
import 'package:acne_detector/pages/profile_page.dart';
import 'package:acne_detector/pages/saved_page.dart';
import 'package:acne_detector/theme/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:math' as math;
import 'dart:io';
import 'package:acne_detector/camera/camera.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras = [];

class RootApp extends StatefulWidget {
  //const RootApp({Key? key}) : super(key: key);

  final File? image;

  const RootApp({this.image});

  @override
  _RootAppState createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  int activeTab = 2;
  File? _pickedImage;

  void _pickImage() async {
    final imageSource = await showDialog<ImageSource>(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: const Text("Select the image source"),
              actions: <Widget>[
                MaterialButton(
                    child: const Text("Camera"),
                    onPressed: (){
                      _initCamera().then((i) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CameraScreen()),);
                      });
                    }
                ),
                MaterialButton(
                  child: const Text("Gallery"),
                  onPressed: () => Navigator.pop(context, ImageSource.gallery),
                )
              ],
            )
    );

    if(imageSource != null) {
      final file = await ImagePicker.pickImage(source: imageSource, maxHeight: 500, maxWidth: 500);
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
        const HomePage(),
        const ChatPage(),
        Center(
          child: widget.image == null ?
          const Text("No Image") :
          Image(image: FileImage(widget.image as File)),
        ),
        const SavedPage(),
        const ProfilePage()
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
              offset: const Offset(0, 1)),
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
                const SizedBox(
                  width: 55,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      activeTab = 1;
                    });
                  },
                  child: Icon(
                    const IconData(58311, fontFamily: 'MaterialIcons'),
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
                    const IconData(57702, fontFamily: 'MaterialIcons'),
                    size: 28,
                    color: activeTab == 3 ? primary : black,
                  ),
                ),
                const SizedBox(
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
          _pickImage();
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
                offset: const Offset(0, 1)),
          ], color: _pickedImage == null ? black : green
              , borderRadius: BorderRadius.circular(23)),
          child: Transform.rotate(
            angle: math.pi / 4,
            child: Center(
                child: Icon(
                  _pickedImage == null ? Ionicons.md_add_circle : const IconData(61533, fontFamily: 'MaterialIcons'),
                  color: white,
                  size: _pickedImage == null ? 35:50,
                )),
          ),
        ),
      ),
    );
  }
}
