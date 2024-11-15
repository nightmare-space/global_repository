import 'dart:math';

import 'package:flutter/material.dart';

class CandyColors {
  CandyColors._();
  static const Color candyPink = Color(0xffef92a5);
  static const Color candyBlue = Color(0xff73b3fa);
  static const Color candyGreen = Color(0xffb4d761);
  static const Color candyPurpleAccent = Color(0xffcc99fe);
  static const Color candyCyan = Color(0xff6d998e);
  static const Color deepPurple = Colors.deepPurple;
  static const Color indigo = Colors.indigo;
  static const Color blue = Color(0xff36aefa);
  static const Color orange = Color(0xfffd7b65);
  static const Color yellow = Color(0xffffc540);
  static const Color green = Color(0xff58df9a);
  static const Color purple = Color(0xff7f7dfc);
  static List<Color> colors = [
    candyPink,
    candyBlue,
    candyCyan,
    candyGreen,
    candyPurpleAccent,
    deepPurple,
    indigo,
  ];
  static Color getRandomColor() {
    return colors[Random().nextInt(6)];
  }
}
