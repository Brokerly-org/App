import 'package:flutter/material.dart';

class SettingsItem extends StatelessWidget {
  const SettingsItem({
    Key key,
    @required this.text,
    @required this.onClick,
  }) : super(key: key);
  final String text;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Padding(
        padding:
            const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 15,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
