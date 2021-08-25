import 'package:flutter/material.dart';

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
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: RawMaterialButton(
          onPressed: () => updateSwitch(!(switchValue ?? false)),
          child: Container(
            height: 40,
            constraints: BoxConstraints(maxWidth: 400, minWidth: 150),
            alignment: Alignment.center,
            padding: EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.blueGrey.withOpacity(0.25),
            ),
            child: Switch.adaptive(
              value: this.switchValue ?? widget.args["initial"],
              onChanged: updateSwitch,
              activeColor: Colors.amber,
            ),
          ),
        ),
      ),
    );
  }
}
