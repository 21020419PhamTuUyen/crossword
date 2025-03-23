import 'package:flutter/material.dart';

class AppColors {
  // define all your color
  static const Color white = Color(0xffffffff);
  static const Color base_color = Color(0xFF0085FF);
  static const Color base_color_border_textfield = Color(0xFFD6DCE2);
  static const Color gray = Color(0xFF75818F);
  static const Color border = Color(0xFFD4CFCF);
  static const Color ffBDBDBD = Color(0xFFBDBDBD);
  static const Color ff828282 = Color(0xFF828282);
  static const Color disable = Color(0xffF0F4F9);

  static const LinearGradient base_color_gradient = LinearGradient(colors: [
    Color(0xFF258EFF),
    Color(0xFF0D49FF),
  ], begin: FractionalOffset.topCenter, end: FractionalOffset.bottomCenter, tileMode: TileMode.mirror);
}
