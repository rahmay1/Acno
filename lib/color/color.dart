import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/cupertino.dart';

// const Color beige =
// const Color lightBeige =
// const Color darkBeige =
// const Color tabsBeige =
const Color white = Color(0xFFFFFFFF);
const Color black = Color(0xFF000000);
const Color tabsBeige = Color(0XFFFAF0D3);
// const Color green = Color(0xFF4CAF50);
// MaterialColor themeBeige = MaterialColor(0xFFE8D3B9, color);
// MaterialColor themeBeige = MaterialColor(0xFFE8D3B9, color);

// FAF0D3
// const
// const Color beige = HexColor("b74093");

// class HexColor extends Color {
//   static int _getColorFromHex(String hexColor) {
//     hexColor = hexColor.toUpperCase().replaceAll("#", "");
//     if (hexColor.length == 6) {
//       hexColor = "FF" + hexColor;
//     }
//     return int.parse(hexColor, radix: 16);
//   }
//
//   HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
// }
// class AppColours {
//   const AppColours();
//
//   static const Color colorStart = const Color(0xFF0d47a1);
//   static const Color colorEnd = const Color(0xFF1565c0);
//
//   static const buttonGradient = const LinearGradient(
//     colors: const [colorStart, colorEnd],
//     stops: const [0.0, 1.0],
//     begin: Alignment.topCenter,
//     end: Alignment.bottomCenter,
//   );
// }
class CompanyColors {
  CompanyColors._(); // this basically makes it so you can instantiate this class

  static const _blackPrimaryValue = 0xFFDEA482;

  static const MaterialColor myColor = const MaterialColor(
    _blackPrimaryValue,
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
}