import 'dart:collection';
import 'package:acne_detector/settings/settingsPage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'dart:ui';
import 'dart:io';
import 'dart:math';
import 'dart:convert';
import '../color/color.dart';
import 'package:acne_detector/camera/camera.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:acne_detector/com/request.dart';
import 'package:acne_detector/search/searchPage.dart';
import 'package:acne_detector/search/statsPage.dart';
import 'package:acne_detector/search/blackheadinfo.dart';
import 'package:acne_detector/search/resultPage.dart';
import 'package:acne_detector/pages/login.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

List<CameraDescription> cameras = [];
File? imagePicked;
bool? uploaded = false;
final GlobalKey<State> _keyLoader = new GlobalKey<State>();

class AcneData {
  String classify;
  double percent;

  AcneData(this.classify, this.percent);

}

// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   State<MyApp> createState() => _MyApp();
// }
//class _MyApp extends State<MyApp> {
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
        defaultThemeId: "default_theme",
        themes: [ // This is standard dark theme (id is default_dark_theme)
          AppTheme(
            id: "default_theme", // Id(or name) of the theme(Has to be unique)
            description: "", // Description of theme
            data: ThemeData(
              brightness: Brightness.light,
              primarySwatch: myColor,
              primaryColor: myColor,
              primaryColorDark: myColor[900],
              primaryColorLight: myColor[50],
              hoverColor: myColor[700],
              fontFamily: 'Ariel',
            ),
          ),
          AppTheme.light(), // This is standard light theme (id is default_light_theme)
          AppTheme.dark(),
        ],
        child: ThemeConsumer(
      child: Builder(
        builder: (themeContext) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: '',
          theme: ThemeProvider.themeOf(themeContext).data,
          //home: const MyHomePage(title: 'Acne Types'),
          initialRoute: '/loginPage',
          routes: {
            "/homePage": (_) => MyHomePage(),
            "/loginPage": (_) => LoginPage(),
          },
        ),
      ),
    ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? search = "";
  bool activeTab = true; // True for Search Page, false for Stats Page
  int activeIndex = 0;
  final TextEditingController _search = TextEditingController();
  Map historyMap = {};

  Future<void> _initCamera() async {
    // Fetch the available cameras before initializing the app.
    try {
      WidgetsFlutterBinding.ensureInitialized();
      cameras = await availableCameras();
    } on CameraException catch (e) {
      print('Error in fetching the cameras: $e');
    }
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      activeTab = true;
      activeIndex = 0;
      setState(() {});
    } else if (index == 1) {
      _initCamera().then((i) {
        _awaitCamera();
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => CameraScreen()),);
      });
    } else if (index == 2) {
      request().then((i) async {
        _loadStats(i).then((i){
          activeTab = false;
          activeIndex = 1;
          setState(() {});
        });
      });
    }
    // setState(() {
    //   _selectedIndex = index;
    // });
  }

  _awaitCamera() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CameraScreen()),
    );

    // Upload
    if (imagePicked != null) {
      Dialogs.showLoadingDialog(context, _keyLoader);

      // final FirebaseStorage storage = FirebaseStorage.instance;
      // String fileName = path.basename(imagePicked?.path as String);
      // try {
      //   await storage.ref('test/$fileName').putFile(imagePicked as File);
      // } on FirebaseException catch (e) {
      //   print(e);
      // }
      try {
        final result = await InternetAddress.lookup('example.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          print('connected');
          String value = await onUploadImage(imagePicked as File);
          print(value);

          if (value != 'False') {

            var classNamesArr = new List<String>.filled(3, '', growable: false);
            var scoresArr = new List<double>.filled(3, 0, growable: false);

            Map<String, dynamic> map =
            jsonDecode(value); // import 'dart:convert';
            // map.forEach((k,v) => {
            //   classNamesArr.add(k),
            //   scoresArr.add(v)
            // });

            // var sortedEntries = map.entries.toList()
            //   ..sort((e1, e2) {
            //     var diff = e2.value.compareTo(e1.value);
            //     if (diff == 0) diff = e2.key.compareTo(e1.key);
            //     return diff;
            //   });

            // var sortedEntries = map.keys.toList(growable:false)
            //   ..sort((k1, k2) => map[k1].compareTo(map[k2]));
            // LinkedHashMap sortedMap = new LinkedHashMap.fromIterable(sortedEntries, key: (k) => k, value: (k) => map[k]);

            //var newMap = Map<String, dynamic>.fromEntries(sortedEntries);
            List<AcneData> acne = new List<AcneData>.filled(
                3, AcneData("", 0), growable: false);

            int i = 0;
            String time = "";

            map.forEach((key, value) {
              //classNamesArr[i] = key;
              //scoresArr[i] = double.parse(double.parse(value).toStringAsFixed(2));
              if(key != 'time') {
                acne[i] = AcneData(
                    key, double.parse(double.parse(value).toStringAsFixed(2)));
                i++;
              }else{
                time = value;
                print(time);
              }
            });

            acne.sort((a, b) => b.percent.compareTo(a.percent));

            //await updatePredictions(time);

            // for(AcneData a in acne){
            //  print(a.classify);
            //  print(a.percent);
            // }

            // int i = 0;
            // for (final k in sortedEntries) {
            //   classNamesArr[i] = k;
            //   //print(classNamesArr[i]);
            //   i++;
            // }
            // i = 0;
            // for (final v in newMap.values) {
            //   scoresArr[i] = double.parse(double.parse(v).toStringAsFixed(2));
            //   //print(scoresArr[i]);
            //   i++;
            // }

            Navigator.of(_keyLoader.currentContext as BuildContext,
                rootNavigator: true)
                .pop();
            Dialogs.showOkDialog(context, "Upload Status",
                "Upload has been successfully completed.");

            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    ResultPage(
                      title: 'Result',
                      firstClassName: acne[0].classify,
                      secondClassName: acne[1].classify,
                      thirdClassName: acne[2].classify,
                      firstScore: acne[0].percent,
                      secondScore: acne[1].percent,
                      thirdScore: acne[2].percent,
                    )));
          }else{
            Navigator.of(context, rootNavigator: true).pop();
            Dialogs.showOkDialog(
                context, "Invalid Picture", "Please take a picture of acne.");
          }
        }
      } on SocketException catch (_) {
        print('not connected');
        await _initCamera();
        Navigator.of(context, rootNavigator: true).pop();
        Dialogs.showOkDialog(
            context, "No Connection", "Could not connect to internet.");
      }
      imagePicked = null;
    }
  }

  Map<String, String> convert(Map<String, dynamic> data) {
    return Map<String, String>.fromEntries(data.entries
        .map<MapEntry<String, String>>((me) => MapEntry(me.key, me.value)));
  }

  _loadStats(String data) async {
    print(data);
    Map<String, dynamic> oldMap = jsonDecode(data);
    historyMap = oldMap;
    // var map = Map.fromEntries(
    //     oldMap.entries.map((me) => MapEntry(me.key, convert(me.value))));
    //
    // //var dates = new List<String>.empty(growable: true);
    // Map<String, String> acneTypes = new Map();

    // for (final k in map.keys) {
    //   dates.add(k);
    // }
    // for (final k in map.values) {
    //
    // }

    // map.forEach((date, v) {
    //   acneTypes.addAll(v);
    //   print(date); // DateTime
    //   acneTypes.forEach((classification, url) {
    //     print(classification); // Classification
    //     print(url);
    //     Image a = Image.network(url,);
    //     //urlToFile(url);// URL
    //   });
    // });

    //
    // for (final k in dates) {
    //   print(k);
    // }
  }

  @override
  Widget build(BuildContext context) {
    var controller = ThemeProvider.controllerOf(context);
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: activeTab ? getSearchAppBar(controller) : getStatsAppBar(controller),
          body: IndexedStack(
            index: activeIndex,
            children: [
              SearchPage(search: search, controller: controller,),
              StatsPage(historyMap: historyMap, title: 'Statistics',),
            ],
          ),

          //activeTab ? getSearchBody(controller) : getStatsBody(),

          bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Search',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.camera_alt),
                  label: 'Camera',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.query_stats),
                  label: 'Stats',
                ),
              ],
              onTap: _onItemTapped,
              currentIndex: activeTab ? 0 : 2,
              selectedItemColor: controller.theme.data.primaryColor,
              unselectedItemColor: black),

          // This trailing comma makes auto-formatting nicer for build methods.
        ),
      ),
    );
  }

  // ______________________AppBar for Search Page_____________________________

  PreferredSizeWidget getSearchAppBar(ThemeController controller) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(120.0), // here the desired height
      child: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        automaticallyImplyLeading: false,
        title: Text('Acne Types'),
        bottom: AppBar(
          automaticallyImplyLeading: false,
          title: Container(
            decoration: new BoxDecoration(
                borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
                color: Colors.white),
            width: double.infinity,
            height: 40,
            child: Center(
              child: TextField(
                controller: _search,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search for an acne type',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  // change searchValue
                  search = value;
                  setState(() {});
                },
              ),
            ),
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings,
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SettingsPage(title: 'Settings', controller: controller,)));
            },
          )
        ],
      ),
    );
  }

// ______________________AppBar for Stats Page_____________________________

  PreferredSizeWidget getStatsAppBar(ThemeController controller) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(100.0), // here the desired height
      child: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Statistics'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings,
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SettingsPage(title: 'Settings', controller: controller,)));
            },
          )
        ],
      ),
    );
  }

// ________________________Dialog Widgets____________________________________

}

class Dialogs {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  key: key,
                  backgroundColor: myColor,
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        CircularProgressIndicator(color: ThemeData.estimateBrightnessForColor(myColor) ==
                            Brightness.light
                            ? Colors.black
                            : Colors.white,),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Uploading to Server...",
                            style: TextStyle(color: ThemeData.estimateBrightnessForColor(myColor) ==
                                Brightness.light
                                ? Colors.black
                                : Colors.white),
                        )
                      ]),
                    )
                  ]));
        });
  }

  static Future<void> showOkDialog(
      BuildContext context, String Title, String Content) async {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(Title, style: TextStyle(color: ThemeData.estimateBrightnessForColor(myColor) ==
            Brightness.light
            ? Colors.black
            : Colors.white),),
        content: Text(
          Content,
            style: TextStyle(color: ThemeData.estimateBrightnessForColor(myColor) ==
            Brightness.light
            ? Colors.black
            : Colors.white),
        ),
        backgroundColor: myColor,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('Ok', style: TextStyle(color: ThemeData.estimateBrightnessForColor(myColor) ==
                Brightness.light
                ? Colors.black
                : Colors.white)),
          ),
        ],
      ),
    );
  }
}
