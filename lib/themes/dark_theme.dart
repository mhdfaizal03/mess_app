import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[900]!,
      titleTextStyle: const TextStyle(color: Colors.white),
    ),
    colorScheme: ColorScheme.dark(
        background: Color.fromARGB(255, 6, 1, 27)!,
        primary: Colors.white,
        secondary: Color.fromARGB(255, 3, 28, 70)!,
        onPrimary: Colors.white,
        onSecondary: Colors.grey[300]!));
