import 'package:brokerly/models/bot.dart';
import 'package:brokerly/services/client.dart';
import 'package:flutter/material.dart';

import 'floating_action.dart';

class FloatingButton extends StatelessWidget {
  const FloatingButton({this.args, this.bot});
  final Map<String, dynamic> args;
  final Bot bot;

  void sendCallback(dynamic data) {
    Client().pushCallbackDataToBot(bot, data);
  }

  @override
  Widget build(BuildContext context) {
    return FloatingAction(
      child: Text(this.args["text"]),
      onPressed: () => sendCallback(args["data"]),
    );
  }
}
