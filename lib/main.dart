import 'package:acne_detector/pages/login.dart';
import 'package:acne_detector/pages/root_app.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginPage(),
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