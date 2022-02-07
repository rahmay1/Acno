import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/cupertino.dart';

const Color primary = Color(0xFF25A0B0);
const Color primaryLight = Color(0xFFE1F6F4);
const Color white = Color(0xFFFFFFFF);
const Color black = Color(0xFF000000);
const Color grey = Color(0xFF3a3a3a);
const Color green = Color(0xFF4CAF50);

class AppColours {
  const AppColours();

  static const Color colorStart = const Color(0xFF0d47a1);
  static const Color colorEnd = const Color(0xFF1565c0);

  static const buttonGradient = const LinearGradient(
    colors: const [colorStart, colorEnd],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
