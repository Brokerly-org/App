import 'package:flutter/material.dart';

import '../ui_manager.dart';
import '../models/bot.dart';

void showReportDialog(BuildContext context, Bot bot) {
  final TextEditingController textEditingController = TextEditingController();
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Report",
            style: TextStyle(color: Theme.of(context).backgroundColor),
          ),
          content: TextField(
            style: TextStyle(color: Theme.of(context).backgroundColor),
            decoration: InputDecoration(
              hintText: "Report message...",
            ),
          ),
          actions: [
            report(context, bot, textEditingController),
            reportAndBlock(context, bot, textEditingController),
            cancle(context)
          ],
        );
      });
}

TextButton cancle(BuildContext context) => TextButton(
    onPressed: () {
      Navigator.pop(context);
    },
    child: Text("Cancle"));

TextButton report(BuildContext context, Bot bot,
        TextEditingController textEditingController) =>
    TextButton(
      onPressed: () {
        Navigator.pop(context);
        UIManager.reportBot(context, bot, textEditingController.value.text);
      },
      child: Text(
        "Report",
        style: TextStyle(color: Colors.red.shade400),
      ),
    );

TextButton reportAndBlock(BuildContext context, Bot bot,
        TextEditingController textEditingController) =>
    TextButton(
      onPressed: () {
        UIManager.blockBot(context, bot, showSnakBar: false);
        UIManager.reportBot(context, bot, textEditingController.value.text,
            showSnakBar: false);
        Navigator.pop(context);
        UIManager.showMessage(context, "Reporting And Blocking...");
      },
      child: Text(
        "Report And Block",
        style: TextStyle(color: Colors.red.shade400),
      ),
    );
