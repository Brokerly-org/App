import 'package:flutter/material.dart';

class FloatingButton extends StatelessWidget {
  const FloatingButton({this.args});
  final Map<String, dynamic> args;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: RawMaterialButton(
          onPressed: () {},
          child: Container(
            height: 40,
            alignment: Alignment.center,
            padding: EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.blueGrey.withOpacity(0.25),
            ),
            child: Text(this.args["text"]),
          ),
        ),
      ),
    );
  }
}
