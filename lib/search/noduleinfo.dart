import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NoduleInfo extends StatelessWidget {
  const NoduleInfo({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: PreferredSize(
          preferredSize:
              const Size.fromHeight(100.0), // here the desired height
          child: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.

            centerTitle: true,
            title: Text(title),
          ),
        ),
        body: SingleChildScrollView(
    child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 30),
              Row(children: <Widget>[
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Container(
                      child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: "Open Sans",
                            fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          TextSpan(
                              text:
                              'Info\n',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                              text:
                              'When acne (whitehead or blackheads) become infected by bacteria causing pores to become red and swollen. Can be a more severe type of acne so visiting a dermatologist is advised.\n\n',
                              style: TextStyle(fontWeight: FontWeight.normal)),
                          TextSpan(
                              text:
                              'Recommended Products\n',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                              text:
                              ' - CeraVe Cleanser\n - Exfoliator (AHA for normal or oily skin and BHA for flaky or dull skin)\n - Moisturizer\n\n',
                              style: TextStyle(fontWeight: FontWeight.normal)),
                          TextSpan(
                              text:
                              'Skin Routine\n',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                              text:
                              ' - Wash face with cleanser that contains salicylic acid\n - Gently exfoliate with AHA’s or BHA’s\n - Moisturize your skin\n\n',
                              style: TextStyle(fontWeight: FontWeight.normal)),
                          TextSpan(
                              text:
                              'Suggestions\n',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                              text:
                              ' - Avoid picking or popping acne due to potential scaring\n - Try to avoid scrubs exfoliators\n - When using AHA’s exfoliate make sure to avoid sunlight\n\n',
                              style: TextStyle(fontWeight: FontWeight.normal)),
                          TextSpan(
                              text:
                                  'For more information about blackhead, visit ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                            text: 'the source.\n\n',
                            style: TextStyle(
                                color: Colors.blueAccent, fontSize: 18),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => _launchURL(),
                          ),
                        ],
                      ),
                    ),
                  )),
                ),
                SizedBox(
                  width: 20,
                ),
              ])
            ])));
  }
}

_launchURL() async {
  const url =
      'https://www.healthline.com/health/beauty-skin-care/nodular-acne';
  if (await canLaunch(url)) {
    print('launch url');
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
