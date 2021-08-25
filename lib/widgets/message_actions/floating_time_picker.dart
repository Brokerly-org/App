import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FloatingTimePicker extends StatefulWidget {
  const FloatingTimePicker({this.args});
  final Map<String, dynamic> args;

  @override
  _FloatingTimePickerState createState() => _FloatingTimePickerState();
}

class _FloatingTimePickerState extends State<FloatingTimePicker> {
  TimeOfDay selectedTime;

  void selectDate() async {
    TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: widget.args["initial"],
    );
    setState(() {
      selectedTime = newTime;
    });
  }

  String formatTime(TimeOfDay time) {
    return "${time.hour}:${time.minute}";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: RawMaterialButton(
          onPressed: selectDate,
          child: Container(
            height: 40,
            alignment: Alignment.center,
            padding: EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.blueGrey.withOpacity(0.25),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(selectedTime != null
                    ? formatTime(selectedTime)
                    : "Select Time"),
                SizedBox(width: 5.0),
                Icon(Icons.access_time, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
