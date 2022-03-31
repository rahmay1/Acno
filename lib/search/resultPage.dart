import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:acne_detector/search/homePage.dart';

class ResultPage extends StatelessWidget {
  ResultPage(
      {Key? key,
      required this.title,
      required this.firstClassName,
      required this.secondClassName,
      required this.thirdClassName,
      required this.firstScore,
      required this.secondScore,
      required this.thirdScore})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final String firstClassName;
  final String secondClassName;
  final String thirdClassName;
  final double firstScore;
  final double secondScore;
  final double thirdScore;

  late List<TopThreeData> _chartData;

  // @override
  // void initState(){
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _chartData = getTopThreeData();
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
        body: Column(mainAxisAlignment: MainAxisAlignment.start, children: <
            Widget>[
          // SizedBox(width: 20),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
            // SizedBox(width: 10),
            Expanded(
                child: Container(
                    child: Column(children: <Widget>[
              SizedBox(height: 30),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "We are $firstScore% sure your acne is $firstClassName",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: "Open Sans",
                      fontWeight: FontWeight.bold),
                ),
              ),
              SfCircularChart(
                series: <CircularSeries>[
                  PieSeries<TopThreeData, String>(
                      dataSource: _chartData,
                      xValueMapper: (TopThreeData data, _) => data.className,
                      yValueMapper: (TopThreeData data, _) => data.score,
                      dataLabelSettings: DataLabelSettings(isVisible: true))
                ],
              ),
              SizedBox(height: 10),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "But it could also be...\n\n",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: "Open Sans",
                      fontWeight: FontWeight.bold),
                  children: <TextSpan>[
                    TextSpan(
                        text: '$secondClassName with a $secondScore% chance\n',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: 'or\n',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: '$thirdClassName with a $thirdScore% chance\n',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              SizedBox(height: 25),
              RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "Not $firstClassName? Choose another type of acne.",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: "Open Sans",
                        fontWeight: FontWeight.bold),
                  )),
              SizedBox(height: 5),
              ElevatedButton(
                child: Text('Choose'),
                onPressed: () {
                  //Navigator.of(context).pop(); //dismiss the color picker
                  Dialogs.showListDialog(context, "Choose an acne type", firstClassName, secondClassName, thirdClassName);
                },
              ),
            ])))
          ])
        ]));
  }

  List<TopThreeData> getTopThreeData() {
    final List<TopThreeData> chartData = [
      TopThreeData(firstClassName, firstScore),
      TopThreeData(secondClassName, secondScore),
      TopThreeData(thirdClassName, thirdScore),
      TopThreeData(
          "Others",
          double.parse(
              (100 - firstScore - secondScore - thirdScore).toStringAsFixed(2)))
    ];
    return chartData;
  }

}

class TopThreeData {
  TopThreeData(this.className, this.score);
  final String className;
  final double score;
}
