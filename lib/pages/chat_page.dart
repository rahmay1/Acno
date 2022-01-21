import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:acne_detector/theme/colors.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar:
      PreferredSize(child: getAppBar(), preferredSize: Size.fromHeight(0)),
      body: getBody(),
    );
  }

  Widget getAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: white,
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
            Text(
              "Acne Types",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        color: grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 15,
                        offset: Offset(0, 1))
                  ]),
              child: Row(
                children: [
                  SizedBox(
                    width: 5,
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Feather.search,
                        color: black,
                      )),
                  SizedBox(
                    width: 5,
                  ),
                  Flexible(
                    child: TextField(
                      cursorColor: black,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search for acne types"),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Column(
            )
          ],
        ),
      ),
    );
  }
}
