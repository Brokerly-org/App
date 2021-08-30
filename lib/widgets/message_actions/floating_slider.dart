import 'package:brokerly/models/bot.dart';
import 'package:flutter/material.dart';

import '../../ui_manager.dart';
import 'floating_action.dart';

class FloatingSlider extends StatefulWidget {
  const FloatingSlider({this.args, this.bot});
  final Map<String, dynamic> args;
  final Bot bot;

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

  void sendCallback(dynamic data) {
    UIManager.sendCallback(widget.bot, data)
        .onError((error, stackTrace) => print(error));
  }

  @override
  Widget build(BuildContext context) {
    return FloatingAction(
      child: Slider.adaptive(
        value: sliderValue ?? widget.args["initial"],
        onChanged: updateSlider,
        onChangeEnd: sendCallback,
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
