import 'package:brokerly/models/bot.dart';
import 'package:brokerly/models/message.dart';
import 'package:flutter/material.dart';

import 'message_widget.dart';

class MessageBobble extends StatelessWidget {
  const MessageBobble({Key key, @required this.message, @required this.bot})
      : super(key: key);

  final Bot bot;
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
    return messageAndWidget(myMessage, bubbleMaxWidth, context);
  }

  Widget messageAndWidget(
      bool myMessage, double bubbleMaxWidth, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisAlignment:
            myMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          IntrinsicWidth(
            stepWidth: 10.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                contentBubble(bubbleMaxWidth, myMessage, context),
                if (!myMessage) ...messageWidgets(context)
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> messageWidgets(BuildContext context) {
    List<Widget> messageWidgets = [
      SizedBox(height: 4.0),
    ];
    if (message.messageWidget == null) {
      return [];
    }
    var messageWidget = MessageWidget(message: message, bot: bot);
    if (messageWidget.runtimeType == Container) {
      return [];
    }
    messageWidgets.add(messageWidget);
    messageWidgets.add(SizedBox(height: 5.0));
    return messageWidgets;
  }

  Container contentBubble(
      double bubbleMaxWidth, bool myMessage, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      constraints: BoxConstraints(maxWidth: bubbleMaxWidth),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          color: myMessage
              ? Theme.of(context).buttonColor
              : Theme.of(context).accentColor),
      child: content(context, myMessage),
    );
  }

  Column content(BuildContext context, bool myMessage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        text(context, myMessage),
        SizedBox(height: 2),
        date(),
      ],
    );
  }

  Container text(BuildContext context, bool myMessage) {
    return Container(
      child: Text(message.data,
          style: TextStyle(
              fontSize: 18,
              color: myMessage
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSecondary)),
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
          "${message.sentAt.hour}:${message.sentAt.minute}",
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
