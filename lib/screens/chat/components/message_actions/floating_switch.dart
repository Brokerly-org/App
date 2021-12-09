import 'package:brokerly/models/bot.dart';
import 'package:flutter/material.dart';

import 'package:brokerly/ui_manager.dart';
import 'floating_action.dart';

class FloatingSwitch extends StatefulWidget {
  const FloatingSwitch({this.args, this.bot});
  final Map<String, dynamic> args;
  final Bot bot;

  @override
  _FloatingSwitchState createState() => _FloatingSwitchState();
}

class _FloatingSwitchState extends State<FloatingSwitch> {
  bool switchValue;

  void updateSwitch(bool newValue) {
    setState(() {
      switchValue = newValue;
    });
    sendCallback(newValue);
  }

  void sendCallback(dynamic data) {
    UIManager.sendCallback(widget.bot, {"switch": data});
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
