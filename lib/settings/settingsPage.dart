import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:acne_detector/search/homePage.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../color/color.dart';
import 'package:theme_provider/theme_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key, required this.title, required this.controller}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final ThemeController controller;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0), // here the desired height
        child: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.

            centerTitle: true,
            title: Text(widget.title)),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text('Common'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: Icon(Icons.language),
                title: Text('Language'),
                value: Text('English'),
              ),
              SettingsTile.navigation(
                onPressed: (value) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Pick a color!'),
                          content: SingleChildScrollView(
                            child: BlockPicker(
                              pickerColor: Color(blackPrimaryValue), //default color
                              onColorChanged: (Color color) {
                                //on color picked

                                blackPrimaryValue = color.value;
                                String selectedColor = blackPrimaryValue.toString().toLowerCase();
                                if (!widget.controller.hasTheme(selectedColor)){

                                  myColor = MaterialColor(
                                    blackPrimaryValue,
                                    const <int, Color>{
                                      50:Color.fromRGBO(243, 238, 236, 1.0),
                                      100:Color.fromRGBO(238, 215, 200, 1.0),
                                      200:Color.fromRGBO(226, 198, 180, 1.0),
                                      300:Color.fromRGBO(226, 183, 159, 1.0),
                                      400:Color.fromRGBO(227, 180, 152, 1.0),
                                      500:Color.fromRGBO(222, 164, 130, 1.0),
                                      600:Color.fromRGBO(154, 111, 89, 1.0),
                                      700:Color.fromRGBO(135, 96, 77, 1.0),
                                      800:Color.fromRGBO(102, 72, 57, 1.0),
                                      900:Color.fromRGBO(59, 41, 32, 1.0),
                                    },
                                  );
                                  var newAppTheme = AppTheme(
                                    id: selectedColor,
                                    description: "Custom Color Scheme",
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
                                  );

                                  widget.controller.addTheme(newAppTheme);
                                  setState(() {widget.controller.setTheme(selectedColor);});
                                  //widget.controller.setTheme(blackPrimaryValue.toString());
                                }else {
                                  if (widget.controller.theme.id != selectedColor){
                                    //setState(() {widget.controller.setTheme(selectedColor);});
                                    widget.controller.removeTheme(selectedColor);
                                    myColor = MaterialColor(
                                      blackPrimaryValue,
                                      const <int, Color>{
                                        50:Color.fromRGBO(243, 238, 236, 1.0),
                                        100:Color.fromRGBO(238, 215, 200, 1.0),
                                        200:Color.fromRGBO(226, 198, 180, 1.0),
                                        300:Color.fromRGBO(226, 183, 159, 1.0),
                                        400:Color.fromRGBO(227, 180, 152, 1.0),
                                        500:Color.fromRGBO(222, 164, 130, 1.0),
                                        600:Color.fromRGBO(154, 111, 89, 1.0),
                                        700:Color.fromRGBO(135, 96, 77, 1.0),
                                        800:Color.fromRGBO(102, 72, 57, 1.0),
                                        900:Color.fromRGBO(59, 41, 32, 1.0),
                                      },
                                    );
                                    var newAppTheme = AppTheme(
                                      id: selectedColor,
                                      description: "Custom Color Scheme",
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
                                    );

                                    widget.controller.addTheme(newAppTheme);
                                    setState(() {widget.controller.setTheme(selectedColor);});
                                  }
                                  //widget.controller.setTheme(blackPrimaryValue.toString());
                                }

                                print(blackPrimaryValue);
                                for (var i in widget.controller.allThemes) {
                                  print(i.id);
                                }
                              },

                            ),
                          ),
                          actions: <Widget>[
                            ElevatedButton(
                              child: const Text('DONE'),
                              onPressed: () {
                                Navigator.of(context)
                                    .pop(); //dismiss the color picker
                              },
                            ),
                          ],
                        );
                      });
                },
                leading: Icon(Icons.format_paint),
                title: Text('Choose custom theme'),
              ),
              SettingsTile.navigation(
                onPressed: (value) {
                  //   Navigator.of(context)
                  //     .pushAndRemoveUntil(
                  //   CupertinoPageRoute(
                  //       builder: (context) => LoginPage()
                  //   ),
                  //       (_) => false,
                  // // );
                  //   Navigator.pushAndRemoveUntil(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) => LoginPage()
                  //       ),
                  //       ModalRoute.withName("/")
                  //   );
                  //   NavigatorState navigatorState = Navigator.of(this.context);
                  //   while (navigatorState.canPop()) {
                  //     navigatorState.pop();
                  //   }
                  //
                  //   Navigator.pushReplacement(
                  //     context,
                  //     MaterialPageRoute(builder: (BuildContext context) {
                  //       return LoginPage();
                  //     }),
                  //   );
                  //Navigator.pushNamedAndRemoveUntil(context, '/loginPage', (_) => false);
                  //Navigator.popUntil(context, (route) => route.isFirst);
                  if (widget.controller.hasTheme('default_theme')){
                    if (widget.controller.theme.id != 'default_theme') {
                      //setState(() {widget.controller.setTheme(selectedColor);});
                      widget.controller.removeTheme('default_theme');
                      blackPrimaryValue = 0xFFDEA482;
                      myColor = MaterialColor(
                        blackPrimaryValue,
                        const <int, Color>{
                          50:Color.fromRGBO(243, 238, 236, 1.0),
                          100:Color.fromRGBO(238, 215, 200, 1.0),
                          200:Color.fromRGBO(226, 198, 180, 1.0),
                          300:Color.fromRGBO(226, 183, 159, 1.0),
                          400:Color.fromRGBO(227, 180, 152, 1.0),
                          500:Color.fromRGBO(222, 164, 130, 1.0),
                          600:Color.fromRGBO(154, 111, 89, 1.0),
                          700:Color.fromRGBO(135, 96, 77, 1.0),
                          800:Color.fromRGBO(102, 72, 57, 1.0),
                          900:Color.fromRGBO(59, 41, 32, 1.0),
                        },
                      );
                      var newAppTheme = AppTheme(
                        id: 'default_theme',
                        description: "Custom Color Scheme",
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
                      );

                      widget.controller.addTheme(newAppTheme);
                      setState(() {widget.controller.setTheme('default_theme');});
                      print("I did this!");
                    }
                  }

                  Navigator.pushReplacementNamed(context, '/loginPage');
                },
                leading: Icon(Icons.logout),
                title: Text('Logout'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
