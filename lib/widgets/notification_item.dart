import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.notification,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
            ),
          ),
          FlutterSwitch(
            width: 57.6,
            height: 32.0,
            toggleSize: 30.0,
            value: isSwitchedRecommend,
            borderRadius: 30.0,
            padding: 2.0,
            toggleColor: Color.fromRGBO(225, 225, 225, 1),
            activeColor: Colors.black,
            inactiveColor: Colors.blue,
            onToggle: (val) {
              setState(() {
                isSwitchedRecommend = val;
              });
            },
          ),
        ],
      ),
    );
  }
}
