import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:acne_detector/Search/searchPage.dart';
import 'package:acne_detector/Search/historyPage.dart';
import '../Color/color.dart';
import '../color/color.dart' as c;
import 'package:theme_provider/theme_provider.dart';

class StatsPage extends StatelessWidget {
  StatsPage({Key? key, required this.title, required this.historyMap, required this.controller}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final Map historyMap;
  final ThemeController controller;

  late List<Widget> _historyData;


  @override
  Widget build(BuildContext context) {
    _historyData = getAssessmentResults(context);

    return Scaffold(
        body: Container(
            alignment: Alignment.topCenter,
            child: new SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: getAssessmentResults(context),
              ),

            )));
  }
  List<Widget> getAssessmentResults(BuildContext context) {
    List<Widget> historyData = [];
    Map monthMap = {
      "01" : "Jan",
      "02" : "Feb",
      "03" : "Mar",
      "04" : "Apr",
      "05" : "May",
      "06" : "Jun",
      "07" : "Jul",
      "08" : "Aug",
      "09" : "Sep",
      "10" : "Oct",
      "11" : "Nov",
      "12" : "Dec"
    };
    // final fixedLengthList = List<int>.filled(5, 0); // Creates fixed-length list.
    // final growableList = <String>['A', 'B'];
    // List<AssementResult> historyData = List<AssementResult>.filled(5,AssementResult());
    for (var time in historyMap.keys) {
      Map resultObject = historyMap[time];
      print(historyMap);
      // String date = resultObject['time'];
      final AssessmentResult result = AssessmentResult(DateTime.parse(resultObject['date']), resultObject['type'], resultObject['imageUrl']);
      final dateList = resultObject['date'].split(" ")[0].split("-");
      String seconds = resultObject['date'].split(" ")[1];
      String month = monthMap[dateList[1]];
      String day = dateList[2];
      String year = dateList[0];
      historyData.add(SizedBox(height: 15));
      historyData.add(
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  HistoryPage(title: 'Prediction History',
                    result: result, seconds: seconds, day: day, month: month, year: year)),
              );
            },
            child: Container(
              alignment: Alignment.centerLeft,

              child:  Text(
                " $month $day at $seconds",
                // DateFormat("yyyy-MM-dd hh:mm:ss"). resultObject['data'],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            style: ElevatedButton.styleFrom(
                primary: c.alphaBlend(controller.theme.data.primaryColor, Colors.grey[200] as Color, 118),
                fixedSize: const Size(320, 80),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
          ));

    }
    return historyData;
    // return new Row(children: list);
  }
}



//
// final List<AssementResult> resultList = [
//   AssementResult(firstClassName, firstScore),
//   AssementResult(secondClassName, secondScore),
//   AssementResult(thirdClassName, thirdScore),
//   AssementResult("Others", 100 - firstScore - secondScore - thirdScore)
// ];
// return chartData;
//

// {"2022-03-22 04:07:45":{"Blackheads":"0.06539592","Cysts":"0.17751414","Nodules":"0.021176465","Papules":"0.18001154","Pustules":"0.30135766","Whiteheads":"0.2545443"},
// "2022-03-22 04:31:35":{"Blackheads":"0.06539592","Cysts":"0.17751414","Nodules":"0.021176465","Papules":"0.18001154","Pustules":"0.30135766","Whiteheads":"0.2545443"}}

// {"2022-03-22":{"data":"2022-03-22 04:07:45",
// "type":"Blackheads",
// "image":"uploaded_from_cam.jpeg"},
// "2022-03-23":
// {"data":"2022-03-22 04:31:35",
// "type":"Cysts",
// "image":"uploaded_from_lib.jpeg"}
// }

class AssessmentResult {
  AssessmentResult(this.date, this.acneType, this.acneImageUrl);
  final DateTime date;
  final String acneType;
  final String acneImageUrl;
}
