import 'package:flutter/material.dart';

class SettingsItem extends StatelessWidget {
  const SettingsItem({
    Key key,
    this.leading,
    @required this.text,
    @required this.onClick,
  }) : super(key: key);
  final Icon leading;
  final String text;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        height: 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            settingName(),
            settingForwardIcon(),
          ],
        ),
      ),
    );
  }

  Icon settingForwardIcon() {
    return Icon(
      Icons.arrow_forward_ios,
      size: 15,
      color: Colors.white,
    );
  }

  Widget settingName() {
    return Row(
      children: [
        leading != null
            ? Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: leading,
              )
            : SizedBox.shrink(),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
