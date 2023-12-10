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
      background: const Color.fromARGB(255, 244, 240, 240),
      primary: Colors.black,
      secondary: const Color.fromARGB(204, 190, 191, 198),
      onSecondary: Colors.grey[600]!),
);
