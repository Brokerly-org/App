import 'package:flutter/material.dart';

import 'floating_action.dart';

class FloatingSwitch extends StatefulWidget {
  const FloatingSwitch({this.args});
  final Map<String, dynamic> args;

  @override
  _FloatingSwitchState createState() => _FloatingSwitchState();
}

class _FloatingSwitchState extends State<FloatingSwitch> {
  bool switchValue;

  void updateSwitch(bool newValue) {
    setState(() {
      switchValue = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FloatingAction(
      child: Switch.adaptive(
        value: this.switchValue ?? widget.args["initial"],
        onChanged: updateSwitch,
        activeColor: Colors.amber,
      ),
      onPressed: () => updateSwitch(!(switchValue ?? false)),
    );
  }
}
