import 'package:brokerly/models/bot.dart';
import 'package:brokerly/models/message.dart';
import 'package:flutter/material.dart';

import 'message_actions/floating_button.dart';
import 'message_actions/floating_checkbox.dart';
import 'message_actions/floating_date_picker.dart';
import 'message_actions/floating_slider.dart';
import 'message_actions/floating_switch.dart';
import 'message_actions/floating_time_picker.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget({Key key, this.message, this.bot}) : super(key: key);

  final Message message;
  final Bot bot;

  @override
  Widget build(BuildContext context) {
    switch (this.message.messageWidget.type) {
      case "button":
        {
          return FloatingButton(args: message.messageWidget.args, bot: bot);
        }
        break;
      case "slider":
        {
          return FloatingSlider(args: message.messageWidget.args, bot: bot);
        }
        break;
      case "checkbox":
        {
          return FloatingCheckbox(args: message.messageWidget.args, bot: bot);
        }
        break;
      case "date_picker":
        {
          return FloatingDatePicker(args: message.messageWidget.args, bot: bot);
        }
        break;
      case "switch":
        {
          return FloatingSwitch(args: message.messageWidget.args, bot: bot);
        }
        break;
      case "time_picker":
        {
          return FloatingTimePicker(args: message.messageWidget.args, bot: bot);
        }
        break;
    }
    return Container();
  }
}
