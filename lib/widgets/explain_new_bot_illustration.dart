import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ExplainIilustration extends StatelessWidget {
  const ExplainIilustration({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String svg = 'assets/home_illustrate.svg';
    return Center(
      child: SvgPicture.asset(
        svg,
        semanticsLabel: 'Press on the floating button to add bot',
      ),
    );
  }
}
