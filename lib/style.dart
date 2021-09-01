import 'package:flutter/material.dart';

// Light Theme
int r = 21;
int g = 92;
int b = 194;

Map<int, Color> color = {
  50: Color.fromRGBO(r, g, b, .1),
  100: Color.fromRGBO(r, g, b, .2),
  200: Color.fromRGBO(r, g, b, .3),
  300: Color.fromRGBO(r, g, b, .4),
  400: Color.fromRGBO(r, g, b, .5),
  500: Color.fromRGBO(r, g, b, .6),
  600: Color.fromRGBO(r, g, b, .7),
  700: Color.fromRGBO(r, g, b, .8),
  800: Color.fromRGBO(r, g, b, .9),
  900: Color.fromRGBO(r, g, b, 1),
};

MaterialColor primery = MaterialColor(0xFF155CC2, color);
Color onPrimery = Colors.white;
Color onSecondary = Colors.black;

Color accentColor = Colors.grey[300];

Color backgroundColor = Color.fromRGBO(255, 255, 255, 1);
Color textColor = Color.fromRGBO(68, 73, 80, 1);
Color buttonColor = Color.fromRGBO(52, 120, 219, 1);

Color onlineColor = Color.fromRGBO(36, 193, 33, 1);
Color offlineColor = Color.fromRGBO(223, 204, 204, 1);

// Dark Theme
int dr = 77;
int dg = 77;
int db = 77;

Map<int, Color> darkSwatch = {
  50: Color.fromRGBO(dr, dg, db, .1),
  100: Color.fromRGBO(dr, dg, db, .2),
  200: Color.fromRGBO(dr, dg, db, .3),
  300: Color.fromRGBO(dr, dg, db, .4),
  400: Color.fromRGBO(dr, dg, db, .5),
  500: Color.fromRGBO(dr, dg, db, .6),
  600: Color.fromRGBO(dr, dg, db, .7),
  700: Color.fromRGBO(dr, dg, db, .8),
  800: Color.fromRGBO(dr, dg, db, .9),
  900: Color.fromRGBO(dr, dg, db, 1),
};

MaterialColor darkPrimery = MaterialColor(0xFF4D4D4D, darkSwatch);
Color darkOnPrimery = Colors.white;
Color darkOnSecondary = Colors.white;
Color darkAccentColor = Color(0xFF4D4D4D);
Color darkBackgroundColor = Color.fromRGBO(30, 30, 30, 1);
Color darkTextColor = Color.fromRGBO(253, 253, 253, 1);
Color darkButtonColor = Color.fromRGBO(52, 120, 219, 1);

Color darkOnlineColor = Color.fromRGBO(36, 193, 33, 1);
Color darkOfflineColor = Color.fromRGBO(223, 204, 204, 1);
