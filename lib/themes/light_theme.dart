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
      background: Colors.white,
      primary: Colors.black,
      secondary: const Color.fromRGBO(161, 173, 245, 0.8),
      onSecondary: Colors.grey[600]!),
);
