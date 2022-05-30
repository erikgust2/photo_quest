import 'package:flutter/material.dart';

const VANILLA_ICE = Color.fromRGBO(255, 160, 190, 1);
const PANSY_PURPLE = Color.fromRGBO(134, 22, 87, 1 );
const OLD_LACE = Color.fromRGBO(247, 243, 227, 1);
const WINTERGREEN_DREAM = Color.fromRGBO(79, 132, 117, 1);
const CADET = Color.fromRGBO(79, 109, 122, 1);

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,

  appBarTheme: const AppBarTheme(
      color: Colors.white
  ),

  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
  ),

);

//Kan och bör nog ändras till ett custom theme
ThemeData darkTheme = ThemeData.dark();