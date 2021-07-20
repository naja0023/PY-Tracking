import 'dart:ui';

import 'package:flutter/material.dart';

class MyConstant {
  //appName
  static String appName = 'Driver App';

  // color
  static Color primary = Color(0xff24a7aa);
  static Color dark = Color(0xff00777b);
  static Color light = Color(0xff64d9dc);

  //style
  TextStyle h1_Stlye() => TextStyle(
        fontSize: 24,
        color: dark,
        fontWeight: FontWeight.bold,
      );
  TextStyle h2_Stlye() => TextStyle(
        fontSize: 18,
        color: dark,
        fontWeight: FontWeight.w700,
      );
  TextStyle h3_Stlye() => TextStyle(
        fontSize: 14,
        color: dark,
        fontWeight: FontWeight.normal,
      );

  //button style
  ButtonStyle MyButtonStlye() => ElevatedButton.styleFrom(
        primary: MyConstant.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      );
}
