import 'package:flutter/material.dart';

class FloatingAction extends StatelessWidget {
  const FloatingAction({@required this.child, @required this.onPressed});

  final Widget child;
  final GestureTapCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: RawMaterialButton(
          onPressed: onPressed,
          child: Container(
            height: 42.0,
            constraints: BoxConstraints(maxWidth: 400, minWidth: 150),
            alignment: Alignment.center,
            padding: EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.blueGrey.withOpacity(0.25),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
