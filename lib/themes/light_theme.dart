import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    titleTextStyle: TextStyle(color: Colors.black),
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
  ),
  colorScheme: ColorScheme.light(
      background: Color.fromARGB(255, 244, 240, 240),
      primary: Colors.black,
      secondary: Color.fromARGB(204, 154, 165, 231),
      onSecondary: Colors.grey[600]!),
);
