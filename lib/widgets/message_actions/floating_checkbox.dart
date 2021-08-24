import 'package:flutter/material.dart';

class FloatingCheckbox extends StatefulWidget {
  const FloatingCheckbox({this.args});
  final Map<String, dynamic> args;

  @override
  _FloatingCheckboxState createState() => _FloatingCheckboxState();
}

class _FloatingCheckboxState extends State<FloatingCheckbox> {
  bool checkboxValue;

  void updateCheckbox(bool newValue) {
    setState(() {
      checkboxValue = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: RawMaterialButton(
          onPressed: () => updateCheckbox(!(checkboxValue ?? false)),
          child: Container(
            height: 40,
            constraints: BoxConstraints(maxWidth: 400, minWidth: 150),
            alignment: Alignment.center,
            padding: EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.blueGrey.withOpacity(0.25),
            ),
            child: Checkbox(
              value: this.checkboxValue ?? widget.args["initial"],
              onChanged: updateCheckbox,
              activeColor: Colors.amber,
            ),
          ),
        ),
      ),
    );
  }
}
