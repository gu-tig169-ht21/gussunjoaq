import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData get standardTheme {
    return ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.purple,
          titleTextStyle: TextStyle(color: Colors.white),
          centerTitle: true,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.purple,
        ));
  }
}
