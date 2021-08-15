import 'dart:ui';

import 'package:flutter/material.dart';

const MaterialColor _grey = MaterialColor(
  _greyPrimaryValue,
  <int, Color>{
    // 对应UI的灰度4
    100: Color(0xFFf1f1f1),
    // 对应UI的灰度3
    200: Color(0xFFe1e1e1),
    // 对应UI的灰度2
    500: Color(_greyPrimaryValue),
    // 对应UI的灰度1
    900: Color(0x00000000),
  },
);
const int _greyPrimaryValue = 0xFF9999999;

class AppColors {
  AppColors._();
  static const MaterialColor grey = Colors.grey;
  static const Color accentColor = Color(0xffd3c1fe);
  static const Color fontColor = Color(0xff201b1a);
  static const Color borderColor = Color(0xffeeeeee);
  static const Color surface = Color(0xffede8f8);
  static const Color background = Color(0xfff8f8f8);
}
