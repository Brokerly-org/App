import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Widget PopupMenuOption(
    BuildContext context, String value, String text, IconData icon) {
  return PopupMenuItem<String>(
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Icon(
        icon,
        color: Theme.of(context).backgroundColor,
      ),
      SizedBox(width: 5.0),
      Text(text),
    ]),
    textStyle: TextStyle(
        color: Theme.of(context).backgroundColor, fontWeight: FontWeight.w600),
    value: value,
  );
}
