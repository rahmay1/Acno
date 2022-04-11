import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WhiteheadInfo extends StatelessWidget {
  const WhiteheadInfo({Key? key, required this.title}) : super(key: key);

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
          preferredSize: const Size.fromHeight(100.0), // here the desired height
          child: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.


            title: Center(
                child: Text(title)
            ),

          ),),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 30),
              Row(
                  children: <Widget>[
                    SizedBox(width: 20,),
                    Expanded(child:
                    Container(



                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: RichText(
                            text: TextSpan(

                              text: 'Info\n - Acne that shows up as white spots due to oil and dirt filling up pores\n\nSkincare routine\n - Wash face with cleanser that contains salicylic acid\n - Gently exfoliate with AHA’s or BHA’s\n - Moisturize your skin\n\nProducts Recommendations\n - AHA exfoliater (normal or oily skin)\n - BHA exfoliater (flacky or dull skin)\n - Moisturizer (Dry skin)\n - Moisturizer (Oily skin)\n\nSuggestions\n - Try to avoid scrubs exfoliaters\n - When using AHA’s exfoliate’s make sure to avoid sunlight\n\n\n\n',

                              style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: "Open Sans", fontWeight: FontWeight.bold),
                              children: <TextSpan>[
                                TextSpan(text: 'For more information about whitehead, visit ', style: TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(
                                  text: 'the source.',
                                  style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontSize: 18),
                                  recognizer: TapGestureRecognizer()..onTap = () => _whiteheadURL(),
                                )
                                ,
                              ],
                            ),
                          ),
                        )
                    ),
                    ),
                    SizedBox(width: 20,),
                  ]
              )
            ])
    );
  }
}

_whiteheadURL() async {
  const url = 'https://www.healthline.com/health/whitehead';

  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}