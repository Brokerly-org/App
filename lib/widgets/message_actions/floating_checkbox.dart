import 'package:brokerly/models/bot.dart';
import 'package:flutter/material.dart';

import '../../ui_manager.dart';
import 'floating_action.dart';

class FloatingCheckbox extends StatefulWidget {
  const FloatingCheckbox({this.args, this.bot});
  final Map<String, dynamic> args;
  final Bot bot;

  @override
  _FloatingCheckboxState createState() => _FloatingCheckboxState();
}

class _FloatingCheckboxState extends State<FloatingCheckbox> {
  bool checkboxValue;

  void updateCheckbox(bool newValue) {
    setState(() {
      checkboxValue = newValue;
    });
    sendCallback(newValue);
  }

  void sendCallback(dynamic data) {
    UIManager.sendCallback(widget.bot, data);
  }

  @override
  Widget build(BuildContext context) {
    return FloatingAction(
      child: Checkbox(
        value: this.checkboxValue ?? widget.args["initial"],
        onChanged: updateCheckbox,
        activeColor: Colors.amber,
      ),
      onPressed: () => updateCheckbox(!(checkboxValue ?? false)),
    );
  }
}
