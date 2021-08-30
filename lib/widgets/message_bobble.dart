import 'package:brokerly/models/bot.dart';
import 'package:brokerly/widgets/message_actions/floating_checkbox.dart';
import 'package:brokerly/widgets/message_actions/floating_slider.dart';
import 'package:brokerly/widgets/message_actions/floating_switch.dart';
import 'package:brokerly/widgets/message_actions/floating_time_picker.dart';
import 'package:flutter/material.dart';

import '../models/message.dart';
import 'message_actions/floating_button.dart';
import 'message_actions/floating_date_picker.dart';

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
    // List<Widget> messageWidgets = [
    //   SizedBox(height: 4.0),
    //   FloatingButton(args: {"text": "Open"}),
    //   FloatingSlider(
    //       args: {"initial": 0.0, "min": 0.0, "max": 100.0, "divisions": 5}),
    //   FloatingCheckbox(args: {"initial": false}),
    //   FloatingSwitch(args: {"initial": false}),
    //   FloatingDatePicker(args: {
    //     "initial": DateTime.now(),
    //     "first": DateTime(2021, 1, 1, 1),
    //     "last": DateTime(2022, 1, 1, 1)
    //   }),
    //   FloatingTimePicker(args: {"initial": TimeOfDay.now()})
    // ];
    List<Widget> messageWidgets = [
      SizedBox(height: 4.0),
    ];
    switch (message.messageWidget.type) {
      case "button":
        {
          messageWidgets
              .add(FloatingButton(args: message.messageWidget.args, bot: bot));
        }
        break;
      case "slider":
        {
          messageWidgets
              .add(FloatingSlider(args: message.messageWidget.args, bot: bot));
        }
        break;
      case "checkbox":
        {
          messageWidgets.add(
              FloatingCheckbox(args: message.messageWidget.args, bot: bot));
        }
        break;
      case "date_picker":
        {
          messageWidgets.add(
              FloatingDatePicker(args: message.messageWidget.args, bot: bot));
        }
        break;
      case "switch":
        {
          messageWidgets
              .add(FloatingSwitch(args: message.messageWidget.args, bot: bot));
        }
        break;
      case "time_picker":
        {
          messageWidgets.add(
              FloatingTimePicker(args: message.messageWidget.args, bot: bot));
        }
        break;
    }
    if (messageWidgets.length <= 1) {
      return [];
    } else {
      messageWidgets.add(SizedBox(height: 5.0));
    }
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
              : Theme.of(context).primaryColor),
      child: content(context),
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
