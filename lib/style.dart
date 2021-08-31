import 'package:flutter/material.dart';

int r = 77;
int g = 77;
int b = 77;

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

MaterialColor primery = MaterialColor(0xFF4D4D4D, color);

Color backgroundColor = Color.fromRGBO(30, 30, 30, 1);
Color textColor = Color.fromRGBO(253, 253, 253, 1);
Color buttonColor = Color.fromRGBO(52, 120, 219, 1);

Color onlineColor = Color.fromRGBO(36, 193, 33, 1);
Color offlineColor = Color.fromRGBO(223, 204, 204, 1);
