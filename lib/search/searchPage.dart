import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:acne_detector/search/blackheadinfo.dart';
import 'package:acne_detector/search/whiteheadinfo.dart';
import 'package:acne_detector/color/color.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key, required this.search, required this.controller}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String? search;
  final ThemeController controller;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
      heightFactor: 1,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            if (('blackhead').contains((search as String).toLowerCase()))
              SizedBox(height: 15),
            if (('blackhead').contains((search as String).toLowerCase()))
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                        const BlackheadInfo(title: 'Blackhead')),
                  );
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Blackhead",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    primary: alphaBlend(controller.theme.data.primaryColor, Colors.grey[200] as Color, 118),
                    fixedSize: const Size(320, 80),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
            if (('whitehead').contains((search as String).toLowerCase()))
              SizedBox(height: 15),
            if (('whitehead').contains((search as String).toLowerCase()))
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                        const WhiteheadInfo(title: 'Whitehead')),
                  );
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Whitehead",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    primary: alphaBlend(controller.theme.data.primaryColor, Colors.grey[200] as Color, 118),
                    fixedSize: const Size(320, 80),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
            if (('cyst').contains((search as String).toLowerCase()))
              SizedBox(height: 15),
            if (('cyst').contains((search as String).toLowerCase()))
              ElevatedButton(
                onPressed: () {},
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Cyst",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    primary: alphaBlend(controller.theme.data.primaryColor, Colors.grey[200] as Color, 118),
                    fixedSize: const Size(320, 80),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
            if (('papule').contains((search as String).toLowerCase()))
              SizedBox(height: 15),
            if (('papule').contains((search as String).toLowerCase()))
              ElevatedButton(
                onPressed: () {},
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Papule",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    primary: alphaBlend(controller.theme.data.primaryColor, Colors.grey[200] as Color, 118),
                    fixedSize: const Size(320, 80),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
            if (('nodule').contains((search as String).toLowerCase()))
              SizedBox(height: 15),
            if (('nodule').contains((search as String).toLowerCase()))
              ElevatedButton(
                onPressed: () {},
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Nodule",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    primary: alphaBlend(controller.theme.data.primaryColor, Colors.grey[200] as Color, 118),
                    fixedSize: const Size(320, 80),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
            if (('pustule').contains((search as String).toLowerCase()))
              SizedBox(height: 15),
            if (('pustule').contains((search as String).toLowerCase()))
              ElevatedButton(
                onPressed: () {},
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Pustule",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    primary: alphaBlend(controller.theme.data.primaryColor, Colors.grey[200] as Color, 118),
                    fixedSize: const Size(320, 80),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
          ],
        ),
      ),
    );

  }

}

