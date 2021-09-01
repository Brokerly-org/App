import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Widget PopupMenuOption(
    BuildContext context, String value, String text, IconData icon) {
  return PopupMenuItem<String>(
    child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Icon(
        icon,
        color: Theme.of(context).colorScheme.onSecondary,
      ),
      SizedBox(width: 5.0),
      Text(text),
    ]),
    textStyle: TextStyle(
        color: Theme.of(context).colorScheme.onSecondary,
        fontWeight: FontWeight.w600),
    value: value,
  );
}
