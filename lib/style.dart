import 'package:flutter/material.dart';

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

MaterialColor primery = MaterialColor(0xFF155cc2, color);
Color backgroundColor = Color.fromRGBO(255, 255, 255, 1);

Color onlineColor = Color.fromRGBO(36, 193, 33, 1);
Color offlineColor = Color.fromRGBO(223, 204, 204, 1);
