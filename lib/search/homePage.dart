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
import 'package:acne_detector/search/blackheadinfo.dart';
import 'package:acne_detector/search/resultPage.dart';
import 'package:acne_detector/pages/login.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:theme_provider/theme_provider.dart';

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
              // This is the theme of your application.
              //
              // Try running your application with "flutter run". You'll see the
              // application has a blue toolbar. Then, without quitting the app, try
              // changing the prch below to Colors.green and then invoke
              // "hot reload" (press "r"imarySwat in the console where you ran "flutter run",
              // or simply save your changes to "hot reload" in a Flutter IDE).
              // Notice that the counter didn't reset back to zero; the application
              // is not restarted.
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
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? search = "";
  bool activeTab = true; // True for Search Page, false for Stats Page

  final TextEditingController _search = TextEditingController();

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
      setState(() {});
    } else if (index == 1) {
      _initCamera().then((i) {
        _awaitCamera();
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => CameraScreen()),);
      });
    } else if (index == 2) {
      activeTab = false;
      request().then((i) {
        _loadStats(i);
      });
      setState(() {});
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
          List<AcneData> acne = new List<AcneData>.filled(3, AcneData("", 0), growable: false);
          int i = 0;
          map.forEach((key, value) {
            //classNamesArr[i] = key;
            //scoresArr[i] = double.parse(double.parse(value).toStringAsFixed(2));
            acne[i] = AcneData(key, double.parse(double.parse(value).toStringAsFixed(2)));
            i++;
          });

          acne.sort((a, b) => b.percent.compareTo(a.percent));

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
              builder: (context) => ResultPage(
                    title: 'Result',
                    firstClassName: acne[0].classify,
                    secondClassName: acne[1].classify,
                    thirdClassName: acne[2].classify,
                    firstScore: acne[0].percent,
                    secondScore: acne[1].percent,
                    thirdScore: acne[2].percent,
                  )));
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
    var map = Map.fromEntries(
        oldMap.entries.map((me) => MapEntry(me.key, convert(me.value))));

    //var dates = new List<String>.empty(growable: true);
    Map<String, String> acneTypes = new Map();

    // for (final k in map.keys) {
    //   dates.add(k);
    // }
    // for (final k in map.values) {
    //
    // }

    map.forEach((date, v) {
      acneTypes.addAll(v);
      print(date); // DateTime
      acneTypes.forEach((classification, percent) {
        print(classification); // Classification
        print(percent); // Percentages
      });
    });

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
          body: activeTab ? getSearchBody(controller) : getStatsBody(),

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

          // Center(
          //   child: SvgPicture.asset(
          //     'assets/Ellipse 117.svg'
          //   ),
          //
          // ),

          //   floatingActionButton: FloatingActionButton(
          //   onPressed: () {
          //     _incrementCounter();
          //   },
          //   tooltip: 'Increment',
          //   child: SvgPicture.network(
          //     dogUrl,
          //     semanticsLabel: 'Feed button',
          //     placeholderBuilder: (context) => Icon(Icons.error),
          //   ),
          // ),

          // This trailing comma makes auto-formatting nicer for build methods.
        ),
      ),
    );
  }

  // ______________________Widgets for Search Page_____________________________

  PreferredSizeWidget getSearchAppBar(ThemeController controller) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(120.0), // here the desired height
      child: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        automaticallyImplyLeading: false,
        title: const Center(child: Text('Acne Types')),
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

  Widget getSearchBody(ThemeController controller) {
    return Center(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
      heightFactor: 1,
      child: new SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            if (('blackhead').contains((search as String).toLowerCase()))
              SizedBox(height: 15),
            if (('blackhead').contains((search as String).toLowerCase()))
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const BlackheadInfo(title: 'Blackhead')),
                  );
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Blackhead",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    primary: alphaBlend(controller.theme.data.primaryColor, Colors.grey[200] as Color, 118),
                    fixedSize: const Size(320, 80),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
            if (('whitehead').contains((search as String).toLowerCase()))
              SizedBox(height: 15),
            if (('whitehead').contains((search as String).toLowerCase()))
              ElevatedButton(
                onPressed: () {},
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Whitehead",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    primary: alphaBlend(controller.theme.data.primaryColor, Colors.grey[200] as Color, 118),
                    fixedSize: const Size(320, 80),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
            if (('cyst').contains((search as String).toLowerCase()))
              SizedBox(height: 15),
            if (('cyst').contains((search as String).toLowerCase()))
              ElevatedButton(
                onPressed: () {},
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Cyst",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    primary: alphaBlend(controller.theme.data.primaryColor, Colors.grey[200] as Color, 118),
                    fixedSize: const Size(320, 80),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
            if (('papule').contains((search as String).toLowerCase()))
              SizedBox(height: 15),
            if (('papule').contains((search as String).toLowerCase()))
              ElevatedButton(
                onPressed: () {},
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Papule",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    primary: alphaBlend(controller.theme.data.primaryColor, Colors.grey[200] as Color, 118),
                    fixedSize: const Size(320, 80),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
            if (('nodule').contains((search as String).toLowerCase()))
              SizedBox(height: 15),
            if (('nodule').contains((search as String).toLowerCase()))
              ElevatedButton(
                onPressed: () {},
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Nodule",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    primary: alphaBlend(controller.theme.data.primaryColor, Colors.grey[200] as Color, 118),
                    fixedSize: const Size(320, 80),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
            if (('pustule').contains((search as String).toLowerCase()))
              SizedBox(height: 15),
            if (('pustule').contains((search as String).toLowerCase()))
              ElevatedButton(
                onPressed: () {},
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Pustule",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    primary: alphaBlend(controller.theme.data.primaryColor, Colors.grey[200] as Color, 118),
                    fixedSize: const Size(320, 80),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
          ],
        ),
      ),
    );
  }

  Color alphaBlend(Color foreground, Color background, int alpha) {
    if (alpha == 0x00) { // Foreground completely transparent.
      return background;
    }
    final int invAlpha = 0xff - alpha;
    int backAlpha = background.alpha;
    if (backAlpha == 0xff) { // Opaque background case
      return Color.fromARGB(
        0xff,
        (alpha * foreground.red + invAlpha * background.red) ~/ 0xff,
        (alpha * foreground.green + invAlpha * background.green) ~/ 0xff,
        (alpha * foreground.blue + invAlpha * background.blue) ~/ 0xff,
      );
    } else { // General case
      backAlpha = (backAlpha * invAlpha) ~/ 0xff;
      final int outAlpha = alpha + backAlpha;
      assert(outAlpha != 0x00);
      return Color.fromARGB(
        outAlpha,
        (foreground.red * alpha + background.red * backAlpha) ~/ outAlpha,
        (foreground.green * alpha + background.green * backAlpha) ~/ outAlpha,
        (foreground.blue * alpha + background.blue * backAlpha) ~/ outAlpha,
      );
    }
  }

// ______________________Widgets for Stats Page_____________________________

  PreferredSizeWidget getStatsAppBar(ThemeController controller) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(100.0), // here the desired height
      child: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Center(child: Text('Statistics')),
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

  Widget getStatsBody() {
    return Center();
  }

// _________________________________________________________________________

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
