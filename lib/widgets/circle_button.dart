import 'package:brokerly/style.dart';
import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  CircleButton(
      {@required this.size,
      @required this.onTap,
      @required this.iconSize,
      @required this.iconData,
      @required this.bgColor});

  final double size;
  final double iconSize;
  final VoidCallback onTap;
  final IconData iconData;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onMyClick,
      child: Container(
        width: size,
        height: size,
        decoration: new BoxDecoration(
          color: bgColor, //kButtonBgColor,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            iconData,
            color: backgroundColor,
            size: iconSize,
          ),
        ),
      ),
    );
  }

  void onMyClick() {
    onTap();
  }
}
