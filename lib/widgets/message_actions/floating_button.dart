import 'package:flutter/material.dart';

import 'floating_action.dart';

class FloatingButton extends StatelessWidget {
  const FloatingButton({this.args});
  final Map<String, dynamic> args;

  @override
  Widget build(BuildContext context) {
    return FloatingAction(
      child: Text(this.args["text"]),
      onPressed: () {},
    );
  }
}
