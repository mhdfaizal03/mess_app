import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[900]!,
      titleTextStyle: const TextStyle(color: Colors.white),
    ),
    colorScheme: ColorScheme.dark(
        background: Colors.black,
        primary: Colors.white,
        secondary: Colors.grey[800]!,
        onPrimary: Colors.white,
        onSecondary: Colors.grey[300]!));
