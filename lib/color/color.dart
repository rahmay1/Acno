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
const Color grey = Color(0xFF3a3a3a);
const Color defaultTheme = Color(0xFFDEA482);

int blackPrimaryValue = 0xFFDEA482;
MaterialColor myColor = MaterialColor(
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