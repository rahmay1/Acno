import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PustuleInfo extends StatelessWidget {
  const PustuleInfo({Key? key, required this.title}) : super(key: key);

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
                              'Acne that is full of a yellowish or white fluid called pus. Typically caused hormonal imbalances or hormonal changes in the body.\n\n',
                              style: TextStyle(fontWeight: FontWeight.normal)),
                          TextSpan(
                              text:
                              'Recommended Products\n',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                              text:
                              ' - CeraVe Salicylic Acid Cleanser\n - BHA exfoliator\n - Moisturizer\n\n',
                              style: TextStyle(fontWeight: FontWeight.normal)),
                          TextSpan(
                              text:
                              'Skin Routine\n',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                              text:
                              ' - Use a mild cleanser\n\n',
                              style: TextStyle(fontWeight: FontWeight.normal)),
                          TextSpan(
                              text:
                              'Suggestions\n',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                              text:
                              ' - Use warm water when washing your skin\n - Don\'t irritate skin, avoid rubbing area with towel and pat down when needed\n\n',
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
      'https://www.healthline.com/health/pustules';
  if (await canLaunch(url)) {
    print('launch url');
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
