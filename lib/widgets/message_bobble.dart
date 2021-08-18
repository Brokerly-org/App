import 'package:flutter/material.dart';

import '../models/message.dart';

class MessageBobble extends StatelessWidget {
  const MessageBobble({Key key, @required this.message}) : super(key: key);

  final Message message;

  @override
  Widget build(BuildContext context) {
    bool myMessage = this.message.sender == "user";
    bool isLargScreen = MediaQuery.of(context).size.width > 600;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenFraction = 0.6;
    double bubbleMaxWidth = isLargScreen
        ? (screenWidth - 300) * screenFraction
        : screenWidth * screenFraction;
    return Row(
      mainAxisAlignment:
          myMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        IntrinsicWidth(
          stepWidth: 10.0,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 12.0),
            padding: EdgeInsets.all(10.0),
            constraints: BoxConstraints(maxWidth: bubbleMaxWidth),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(14)),
                color: myMessage
                    ? Theme.of(context).buttonColor
                    : Theme.of(context).primaryColor),
            child: content(context),
          ),
        ),
      ],
    );
  }

  Column content(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        text(context),
        SizedBox(height: 2),
        date(),
      ],
    );
  }

  Container text(BuildContext context) {
    return Container(
      child: Text(message.data, style: TextStyle(fontSize: 18)),
    );
  }

  Row date() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(width: 20.0),
        Text(
          "13:00 AM",
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: Color.fromRGBO(148, 148, 148, 1),
          ),
        ),
      ],
    );
  }
}
