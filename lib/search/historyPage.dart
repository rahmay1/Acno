import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:acne_detector/search/statsPage.dart';

class HistoryPage extends StatelessWidget {
  HistoryPage(
      {Key? key,
      required this.title,
      required this.result,
      required this.seconds,
      required this.day,
      required this.month,
      required this.year})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final AssessmentResult result;
  final String seconds;
  final String day;
  final String month;
  final String year;

  late String acneType;
  late String acneImageUrl;

  // @override
  // void initState(){
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    acneType = result.acneType;
    acneImageUrl = result.acneImageUrl;
    print(result);
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70.0), // here the desired height
          child: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            centerTitle: true,
            title: Text(title),
          ),
        ),
        body: Column(mainAxisAlignment: MainAxisAlignment.start, children: <
            Widget>[
          // SizedBox(width: 20),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
            // SizedBox(width: 10),

            Expanded(
                child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 0.0),
                    child: Column(children: <Widget>[
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          text: TextSpan(
                            text: "  $month $day $year",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontFamily: "Open Sans",
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Align(
                        alignment: Alignment.center,
                        child: RichText(
                          text: TextSpan(
                            text: "Your acne prediction was $acneType.",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontFamily: "Open Sans",
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),

                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(width: 2),
                            bottom: BorderSide(width: 2),
                          ),
                        ),
                        child: Image.network(acneImageUrl),
                      ),
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: RichText(
                          text: TextSpan(
                            text: "Uploaded at $seconds ",
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 15,
                                fontFamily: "Open Sans",
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ])))
          ])
        ]));
  }
}
