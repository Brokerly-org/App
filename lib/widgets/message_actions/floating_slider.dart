import 'package:flutter/material.dart';

import 'floating_action.dart';

class FloatingSlider extends StatefulWidget {
  const FloatingSlider({this.args});
  final Map<String, dynamic> args;

  @override
  _FloatingSliderState createState() => _FloatingSliderState();
}

class _FloatingSliderState extends State<FloatingSlider> {
  double sliderValue;

  void updateSlider(double newValue) {
    setState(() {
      sliderValue = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FloatingAction(
      child: Slider.adaptive(
        value: sliderValue ?? widget.args["initial"],
        onChanged: updateSlider,
        activeColor: Colors.amber,
        min: widget.args["min"],
        max: widget.args["max"],
        divisions: widget.args["divisions"] ?? null,
        label: (sliderValue ?? widget.args["initial"]).toString(),
      ),
      onPressed: () {},
    );
  }
}
