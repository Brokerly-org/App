import 'package:flutter/material.dart';

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
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          height: 40,
          constraints: BoxConstraints(maxWidth: 400, minWidth: 150),
          alignment: Alignment.center,
          padding: EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.blueGrey.withOpacity(0.25),
          ),
          child: Slider.adaptive(
            value: sliderValue ?? widget.args["initial"],
            onChanged: updateSlider,
            activeColor: Colors.amber,
            min: widget.args["min"],
            max: widget.args["max"],
            divisions: widget.args["divisions"] ?? null,
            label: sliderValue.toString(),
          ),
        ),
      ),
    );
  }
}
