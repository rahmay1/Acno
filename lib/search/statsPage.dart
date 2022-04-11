import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:acne_detector/Search/searchPage.dart';
import 'package:acne_detector/Search/historyPage.dart';
import '../Color/color.dart';
import '../color/color.dart' as c;
import 'package:theme_provider/theme_provider.dart';
import 'package:acne_detector/Search/homePage.dart';

Map<String, Widget> globalHistoryData = {};
ValueNotifier<int> updater = ValueNotifier(1);

class StatsPage extends StatelessWidget {
  StatsPage({Key? key, required this.title, this.historyMap, required this.controller}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  Map? historyMap;
  final ThemeController controller;

  //late Map<String, Widget> globalHistoryData;
  //late ValueNotifier<Map<String, Widget>> globalHistoryData = ValueNotifier({});
  //late ValueNotifier<int> updater = ValueNotifier(1);

  @override
  Widget build(BuildContext context) {
    globalHistoryData = getAssessmentResults(context);
    return ValueListenableBuilder(
        //TODO 2nd: listen playerPointsToAdd
        valueListenable: updater,
        builder: (context, value, widget) {
          return Scaffold(
        body: Container(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: globalHistoryData.values.toList(),
              ),

            )));});
  }

  Map<String, Widget> getAssessmentResults(BuildContext context) {
    Map<String, Widget> historyData = {};
    Map monthMap = {
      "01": "Jan",
      "02": "Feb",
      "03": "Mar",
      "04": "Apr",
      "05": "May",
      "06": "Jun",
      "07": "Jul",
      "08": "Aug",
      "09": "Sep",
      "10": "Oct",
      "11": "Nov",
      "12": "Dec"
    };
    // final fixedLengthList = List<int>.filled(5, 0); // Creates fixed-length list.
    // final growableList = <String>['A', 'B'];
    // List<AssementResult> historyData = List<AssementResult>.filled(5,AssementResult());
    historyData["start"] = (SizedBox(height: 15));
    if (historyMap != null) {
      for (var time in historyMap!.keys) {
        Map resultObject = historyMap![time];
        print("The value of history map: $historyMap");
        // String date = resultObject['time'];
        final AssessmentResult result = AssessmentResult(
            DateTime.parse(resultObject['date']), resultObject['type'],
            resultObject['imageUrl']);
        final dateList = resultObject['date'].split(" ")[0].split("-");
        String seconds = resultObject['date'].split(" ")[1];
        String month = monthMap[dateList[1]];
        String day = dateList[2];
        String year = dateList[0];
        String fullDate = resultObject['date'];
        historyData["$fullDate 1"] =
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>
                      HistoryPage(title: 'Prediction History',
                          result: result,
                          seconds: seconds,
                          day: day,
                          month: month,
                          year: year)),
                );
              },
              child: Stack(
                  children: [
                    Container(
                      alignment: Alignment.centerRight,
                      child: Material(
                          type: MaterialType.transparency,
                          //Makes it usable on any background color, thanks @IanSmith
                          child: Ink(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: InkWell(
                              //This keeps the splash effect within the circle
                              borderRadius: BorderRadius.circular(1000.0),
                              //Something large to ensure a circle
                              onTap: () {
                                Dialogs.showYesDialog(context, "Delete result",
                                    "Are you sure you want to continue?",
                                    fullDate);
                                print(globalHistoryData);
                              },
                              child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Icon(
                                  Icons.delete,
                                  size: 25.0,
                                ),
                              ),
                            ),
                          )
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        " $month $day at $seconds",
                        // DateFormat("yyyy-MM-dd hh:mm:ss"). resultObject['data'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ]
              ),
              style: ElevatedButton.styleFrom(
                  primary: c.alphaBlend(controller.theme.data.primaryColor,
                      Colors.grey[200] as Color, 118),
                  fixedSize: const Size(320, 80),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
            );
        historyData["$fullDate 2"] = (SizedBox(height: 15));
        updater.value *= -1;
      }
      // return new Row(children: list);
    }
      return historyData;
  }

  // List<Widget> getAssessmentResults(BuildContext context) {
  //   List<Widget> historyData = [];
  //   Map monthMap = {
  //     "01" : "Jan",
  //     "02" : "Feb",
  //     "03" : "Mar",
  //     "04" : "Apr",
  //     "05" : "May",
  //     "06" : "Jun",
  //     "07" : "Jul",
  //     "08" : "Aug",
  //     "09" : "Sep",
  //     "10" : "Oct",
  //     "11" : "Nov",
  //     "12" : "Dec"
  //   };
  //   // final fixedLengthList = List<int>.filled(5, 0); // Creates fixed-length list.
  //   // final growableList = <String>['A', 'B'];
  //   // List<AssementResult> historyData = List<AssementResult>.filled(5,AssementResult());
  //   historyData.add(SizedBox(height: 15));
  //   for (var time in historyMap.keys) {
  //     Map resultObject = historyMap[time];
  //     print(historyMap);
  //     // String date = resultObject['time'];
  //     final AssessmentResult result = AssessmentResult(DateTime.parse(resultObject['date']), resultObject['type'], resultObject['imageUrl']);
  //     final dateList = resultObject['date'].split(" ")[0].split("-");
  //     String seconds = resultObject['date'].split(" ")[1];
  //     String month = monthMap[dateList[1]];
  //     String day = dateList[2];
  //     String year = dateList[0];
  //     historyData.add(
  //         ElevatedButton(
  //           onPressed: () {
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(builder: (context) =>  HistoryPage(title: 'Prediction History',
  //                   result: result, seconds: seconds, day: day, month: month, year: year)),
  //             );
  //           },
  //           child: Stack(
  //                 children: [
  //                   Container(
  //                     alignment: Alignment.centerRight,
  //                     child: Material(
  //                         type: MaterialType.transparency, //Makes it usable on any background color, thanks @IanSmith
  //                         child: Ink(
  //                           decoration: BoxDecoration(
  //                             shape: BoxShape.circle,
  //                           ),
  //                           child: InkWell(
  //                             //This keeps the splash effect within the circle
  //                             borderRadius: BorderRadius.circular(1000.0), //Something large to ensure a circle
  //                             onTap: (){
  //                               historyData.removeWhere((element) => element)
  //                             },
  //                             child: Padding(
  //                               padding:EdgeInsets.all(10.0),
  //                               child: Icon(
  //                                 Icons.delete,
  //                                 size: 25.0,
  //                               ),
  //                             ),
  //                           ),
  //                         )
  //                     ),
  //                   ),
  //                   Container(
  //                     alignment: Alignment.centerLeft,
  //
  //                     child:  Text(
  //                       " $month $day at $seconds",
  //                       // DateFormat("yyyy-MM-dd hh:mm:ss"). resultObject['data'],
  //                       style: TextStyle(
  //                         fontSize: 18,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                       textAlign: TextAlign.left,
  //                     ),
  //                   ),
  //                 ]
  //             ),
  //           style: ElevatedButton.styleFrom(
  //               primary: c.alphaBlend(controller.theme.data.primaryColor, Colors.grey[200] as Color, 118),
  //               fixedSize: const Size(320, 80),
  //               shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(20))),
  //         ));
  //     historyData.add(SizedBox(height: 15));
  //
  //   }
  //   return historyData;
  //   // return new Row(children: list);
  // }
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
