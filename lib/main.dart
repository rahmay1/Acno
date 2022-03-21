import 'package:acne_detector/pages/login.dart';
import 'package:acne_detector/pages/root_app.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'color/color.dart';
import 'package:acne_detector/search/searchPage.dart';
import 'package:acne_detector/pages/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
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
    debugShowCheckedModeBanner: false,
    home: MyApp()
  ));
}

// import 'package:flutter/material.dart';
// import 'package:acne_detector/login/dashboard.dart';
// import 'package:acne_detector/login/login.dart';
// import 'package:acne_detector/login/register.dart';
// import 'package:acne_detector/login/welcome.dart';
// import 'package:acne_detector/login/auth.dart';
// import 'package:acne_detector/login/user_provider.dart';
// import 'package:acne_detector/login/shared_preference.dart';
// import 'package:provider/provider.dart';
//
// import 'package:acne_detector/login/user.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     Future<User> getUserData() => UserPreferences().getUser();
//
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AuthProvider()),
//         ChangeNotifierProvider(create: (_) => UserProvider()),
//       ],
//       child: MaterialApp(
//           title: 'Flutter Demo',
//           theme: ThemeData(
//             primarySwatch: Colors.blue,
//             visualDensity: VisualDensity.adaptivePlatformDensity,
//           ),
//           home: FutureBuilder(
//               future: getUserData(),
//               builder: (context, snapshot) {
//                 switch (snapshot.connectionState) {
//                   case ConnectionState.none:
//                   case ConnectionState.waiting:
//                     return CircularProgressIndicator();
//                   default:
//                     if (snapshot.hasError)
//                       return Text('Error: ${snapshot.error}');
//                     else if (snapshot.data.token == null)
//                       return Login();
//                     else
//                       UserPreferences().removeUser();
//                     return Welcome(user: snapshot.data);
//                 }
//               }),
//           routes: {
//             '/dashboard': (context) => DashBoard(),
//             '/login': (context) => Login(),
//             '/register': (context) => Register(),
//           }),
//     );
//   }
// }