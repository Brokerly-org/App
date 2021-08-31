import 'package:flutter/material.dart';

class NotificationItem extends StatefulWidget {
  const NotificationItem({Key key, @required this.notification})
      : super(key: key);
  final String notification;

  @override
  _NotificationItemState createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  bool isSwitchedRecommend = true;
  bool isSwitchedNew = true;
  bool isSwitchedUpdate = true;

  void updateStatus(bool val) {
    setState(() {
      isSwitchedRecommend = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => updateStatus(!isSwitchedRecommend),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            text(),
            settingSwitch(context),
          ],
        ),
      ),
    );
  }

  Switch settingSwitch(BuildContext context) {
    return Switch.adaptive(
      value: isSwitchedRecommend,
      activeColor: Theme.of(context).buttonColor,
      inactiveThumbColor: Color.fromRGBO(225, 225, 225, 1),
      onChanged: updateStatus,
    );
  }

  Text text() {
    return Text(
      widget.notification,
      style: TextStyle(
        fontSize: 16.0,
        color: Colors.white,
      ),
    );
  }
}
