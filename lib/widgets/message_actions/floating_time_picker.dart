import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'floating_action.dart';

class FloatingTimePicker extends StatefulWidget {
  const FloatingTimePicker({this.args});
  final Map<String, dynamic> args;

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
