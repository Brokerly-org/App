import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Widget PopupMenuOption(
    BuildContext context, String value, String text, IconData icon) {
  return PopupMenuItem<String>(
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(text),
      SizedBox(width: 5.0),
      Icon(
        icon,
        color: Theme.of(context).backgroundColor,
      )
    ]),
    textStyle: TextStyle(
        color: Theme.of(context).backgroundColor, fontWeight: FontWeight.w600),
    value: value,
  );
}
