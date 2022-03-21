import 'package:acne_detector/stats/statsPage.dart';
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


List<CameraDescription> cameras = [];
File? imagePicked;
bool? uploaded = false;
final GlobalKey<State> _keyLoader = new GlobalKey<State>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '',
      theme: ThemeData(
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
        primarySwatch: CompanyColors.myColor,
        primaryColor: CompanyColors.myColor,
        primaryColorDark: CompanyColors.myColor[900],
        primaryColorLight: CompanyColors.myColor[50],
        hoverColor: CompanyColors.myColor[700],
        fontFamily: 'Ariel',
      ),
      //home: const MyHomePage(title: 'Acne Types'),
      initialRoute: '/loginPage',
      routes: {
        "/searchPage": (_) => const MyHomePage(title: 'Acne Types'),
        "/loginPage": (_) => LoginPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? search = "";

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
    if (index == 1) {
      _initCamera().then((i) {
        _awaitCamera();
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => CameraScreen()),);
      });
    }
    if (index == 2) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const StatsPage(title: 'Statistics')));
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

          Map<String, dynamic> map = jsonDecode(value); // import 'dart:convert';
          // map.forEach((k,v) => {
          //   classNamesArr.add(k),
          //   scoresArr.add(v)
          // });

          var sortedEntries = map.entries.toList()..sort((e1, e2) {
            var diff = e2.value.compareTo(e1.value);
            if (diff == 0) diff = e2.key.compareTo(e1.key);
            return diff;
          });

          var newMap = Map<String, dynamic>.fromEntries(sortedEntries);

          int i = 0;
          for (final k in newMap.keys){
            classNamesArr[i] = k;
            i++;
          }
          i = 0;
          for (final v in newMap.values){
            scoresArr[i] = double.parse(double.parse(v).toStringAsFixed(2));
            i++;
          }

          Navigator.of(_keyLoader.currentContext as BuildContext,
              rootNavigator: true)
              .pop();
          Dialogs.showOkDialog(context, _keyLoader, "Upload Status",  "Upload has been successfully completed.");
          imagePicked = null;

          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ResultPage(title: 'Result', firstClassName: classNamesArr[0],
            secondClassName: classNamesArr[1], thirdClassName: classNamesArr[2], firstScore: scoresArr[0], secondScore: scoresArr[1], thirdScore: scoresArr[2],)));

        }
      } on SocketException catch (_) {
        print('not connected');
        Navigator.of(_keyLoader.currentContext as BuildContext,
            rootNavigator: true)
            .pop();
        Dialogs.showOkDialog(context, _keyLoader, "No Connection", "Could not connect to internet.");
        imagePicked = null;
      }
      imagePicked = null;

    }
  }

  @override
  Widget build(BuildContext context) {
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
        appBar: PreferredSize(
          preferredSize:
              const Size.fromHeight(100.0), // here the desired height
          child: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.

            title: Center(child: Text(widget.title)),
            bottom: AppBar(
              title: Container(
                width: double.infinity,
                height: 40,
                color: Colors.white,
                child: Center(
                  child: TextField(
                    controller: _search,
                    decoration: InputDecoration(
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
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          const SettingsPage(title: 'Settings')));
                },
              )
            ],
          ),
        ),
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          heightFactor: 1,
          child: new SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                if (('blackhead').contains((search as String).toLowerCase())) SizedBox(height: 15),
                if (('blackhead').contains((search as String).toLowerCase())) ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const BlackheadInfo(title: 'Blackhead')),
                    );
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Blackhead",
                      style: TextStyle(
                        color: black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: tabsBeige,
                      fixedSize: const Size(320, 80),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                if (('whitehead').contains((search as String).toLowerCase())) SizedBox(height: 15),
                if (('whitehead').contains((search as String).toLowerCase())) ElevatedButton(
                  onPressed: () {},
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Whitehead",
                      style: TextStyle(
                        color: black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: tabsBeige,
                      fixedSize: const Size(320, 80),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                if (('cyst').contains((search as String).toLowerCase())) SizedBox(height: 15),
                if (('cyst').contains((search as String).toLowerCase())) ElevatedButton(
                  onPressed: () {},
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Cyst",
                      style: TextStyle(
                        color: black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: tabsBeige,
                      fixedSize: const Size(320, 80),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                if (('papule').contains((search as String).toLowerCase())) SizedBox(height: 15),
                if (('papule').contains((search as String).toLowerCase())) ElevatedButton(
                  onPressed: () {},
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Papule",
                      style: TextStyle(
                        color: black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: tabsBeige,
                      fixedSize: const Size(320, 80),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                if (('nodule').contains((search as String).toLowerCase())) SizedBox(height: 15),
                if (('nodule').contains((search as String).toLowerCase())) ElevatedButton(
                  onPressed: () {},
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Nodule",
                      style: TextStyle(
                        color: black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: tabsBeige,
                      fixedSize: const Size(320, 80),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                if (('pustule').contains((search as String).toLowerCase())) SizedBox(height: 15),
                if (('pustule').contains((search as String).toLowerCase())) ElevatedButton(
                  onPressed: () {},
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Pustule",
                      style: TextStyle(
                        color: black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: tabsBeige,
                      fixedSize: const Size(320, 80),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
              ],
            ),
          ),
        ),

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
        ),

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
                  backgroundColor: Colors.black54,
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Uploading to Server...",
                          style: TextStyle(color: Colors.blueAccent),
                        )
                      ]),
                    )
                  ]));
        });
  }

  static Future<void> showOkDialog(BuildContext context, GlobalKey key, String Title, String Content) async {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title:
            Text(Title, style: TextStyle(color: Colors.blueAccent)),
        content: Text(
          Content,
          style: TextStyle(color: Colors.blueAccent),
        ),
        backgroundColor: Colors.black87,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text("Ok", style: TextStyle(color: Colors.blueAccent)),
          ),
        ],
      ),
    );
  }
}
