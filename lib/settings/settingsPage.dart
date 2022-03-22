import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:acne_detector/pages/login.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../color/color.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

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
                              pickerColor: Colors.red, //default color
                              onColorChanged: (Color color) {
                                //on color picked
                                setState(() {
                                  //mycolor = color;
                                });
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
