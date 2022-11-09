import 'package:flutter/material.dart';

ThemeData themeData = ThemeData(
  accentColor: Colors.blue[300],
  primaryColor: Colors.deepOrange,
  splashColor: Colors.black38,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    actionsIconTheme: IconThemeData(color: Colors.black),
    iconTheme: IconThemeData(color: Colors.black),
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w500,
      fontSize: 18,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
    ),
  ),
);

//Colors
Color homeMenuButtonColor = Colors.white;
