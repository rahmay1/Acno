import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CystInfo extends StatelessWidget {
  const CystInfo({Key? key, required this.title}) : super(key: key);

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
                                      'Acne that swells containing a substance or fluid which is caused blockage in a duct. This is a severe type of acne and develops when bumps form deep underneath your skin.\n\n',
                                      style: TextStyle(fontWeight: FontWeight.normal)),
                                  TextSpan(
                                      text:
                                      'Treatment\n',
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text:
                                      'Best to visit a dermatologist for effective treatment, otherwise you can stick to the basics of cleanser and moisturizer. Also, you can try to apply a warm damp cloth for 20 min 3 to 4 times a day to speed healing.\n\n',
                                      style: TextStyle(fontWeight: FontWeight.normal)),
                                  TextSpan(
                                      text:
                                      'Suggestions\n',
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text:
                                      'Cysts are formed by agitation underneath the skin, so avoid instigating acne even more, that means don’t squeeze, scratch, drain, open (lance), or puncture the lump.\n\n',
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
      'https://www.healthline.com/health/cyst';
  if (await canLaunch(url)) {
    print('launch url');
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
