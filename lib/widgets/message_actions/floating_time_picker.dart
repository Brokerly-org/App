import 'package:brokerly/models/bot.dart';
import 'package:flutter/material.dart';

import '../../ui_manager.dart';
import 'floating_action.dart';

class FloatingTimePicker extends StatefulWidget {
  const FloatingTimePicker({this.args, this.bot});
  final Map<String, dynamic> args;
  final Bot bot;

  @override
  _FloatingTimePickerState createState() => _FloatingTimePickerState();
}

class _FloatingTimePickerState extends State<FloatingTimePicker> {
  TimeOfDay selectedTime;

  void selectDate() async {
    print(widget.args);
    TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: widget.args["initial_hour"],
        minute: widget.args["initial_minute"],
      ),
    );
    setState(() {
      selectedTime = newTime;
    });
    sendCallback(newTime);
  }

  void sendCallback(dynamic data) {
    UIManager.sendCallback(widget.bot, data);
  }

  String formatTime(TimeOfDay time) {
    return "${time.hour < 10 ? 0 : ''}${time.hour}:${time.minute < 10 ? 0 : ''}${time.minute}";
  }

  @override
  Widget build(BuildContext context) {
    return FloatingAction(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(selectedTime != null ? formatTime(selectedTime) : "Select Time"),
          SizedBox(width: 5.0),
          Icon(Icons.access_time, color: Colors.white),
        ],
      ),
      onPressed: selectDate,
    );
  }
}
