import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'floating_action.dart';

class FloatingDatePicker extends StatefulWidget {
  const FloatingDatePicker({this.args});
  final Map<String, dynamic> args;

  @override
  _FloatingDatePickerState createState() => _FloatingDatePickerState();
}

class _FloatingDatePickerState extends State<FloatingDatePicker> {
  DateTime selectedDate;

  void selectDate() async {
    DateTime newDate = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(widget.args["initial"]),
      firstDate: DateTime.parse(widget.args["first"]),
      lastDate: DateTime.parse(widget.args["last"]),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: Colors.amber),
          ),
          child: child,
        );
      },
    );
    setState(() {
      selectedDate = newDate;
    });
  }

  String formatDate(DateTime date) {
    String format = widget.args["format"] ?? "yy-MM-dd";
    final DateFormat formatter = DateFormat(format);
    final String formatted = formatter.format(date);
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    return FloatingAction(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(selectedDate != null ? formatDate(selectedDate) : "Select Date"),
          SizedBox(width: 5.0),
          Icon(Icons.date_range, color: Colors.white),
        ],
      ),
      onPressed: selectDate,
    );
  }
}
