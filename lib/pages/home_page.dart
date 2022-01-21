import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:acne_detector/theme/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar:
      PreferredSize(child: getAppBar(), preferredSize: Size.fromHeight(60)),
      body: getBody(),
    );
  }

  Widget getAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: white,
      title: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Acne Vision Homepage",
              style: TextStyle(
                  fontSize: 18, color: black, fontWeight: FontWeight.bold),
            ),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  IconData(58751, fontFamily: 'MaterialIcons'),
                  color: black,
                  size: 25,
                ))
          ],
        ),
      ),
    );
  }

  Widget getBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 25, right: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Feed",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 30,
                ),
                // story profile
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(colors: [
                              Color(0xFFFFE0DF),
                              Color(0xFFE1F6F4)
                            ])),
                        child: Center(
                          child: Icon(
                            Icons.add,
                            color: black,
                            size: 28,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Row(

                      )
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Column(
            )
          ],
        ),
      ),
    );
  }
}
