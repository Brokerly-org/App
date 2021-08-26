import 'package:brokerly/const.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../utils.dart';
import '../style.dart';
import '../models/bot.dart';
import '../providers/bots_provider.dart';
import '../services/client.dart';
import '../screens/chat.dart';

class BotTile extends StatelessWidget {
  const BotTile({
    Key key,
    @required this.client,
    @required this.bot,
  }) : super(key: key);

  final Client client;
  final Bot bot;

  String formatDate(DateTime date) {
    String format = "hh:mm";
    final DateFormat formatter = DateFormat(format);
    final String formatted = formatter.format(date);
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {
          context.read<BotsProvider>().readBotMessages(bot.botname);
          if (!isDesktop(context)) {
            Navigator.pushNamed(context, '/chat',
                arguments: ChatScreenArguments(bot.botname, client));
          } else {
            context.read<BotsProvider>().selectBotName(bot.botname);
          }
        },
        tileColor: Theme.of(context).primaryColor,
        title: Text(bot.title),
        subtitle: Text(bot.server.url),
        leading: onlineIndicator(),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(height: 9),
            lastMessageDate(),
            SizedBox(height: 8),
            bot.unreadMessages > 0
                ? unreadMessagesCounter(context)
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  Text lastMessageDate() {
    return bot.messages.isNotEmpty
        ? Text(
            formatDate(bot.messages.last.sentAt),
            style: TextStyle(
                fontSize: 12,
                color: bot.unreadMessages > 0 ? Colors.amber : Colors.white,
                fontWeight: FontWeight.w300),
          )
        : SizedBox();
  }

  Widget unreadMessagesCounter(BuildContext context) {
    return CircleAvatar(
      radius: 8,
      backgroundColor: Colors.amber,
      child: FittedBox(
        child: Padding(
          padding: EdgeInsets.all(2.0),
          child: Text("${bot.unreadMessages}",
              style: TextStyle(color: Colors.black)),
        ),
      ),
    );
  }

  Container onlineIndicator() {
    return Container(
      width: 6.5,
      decoration: BoxDecoration(
        color: bot.durationFromLastOnline < kMaxDurationFromLastOnline
            ? onlineColor
            : offlineColor,
        borderRadius: BorderRadius.circular(25),
      ),
    );
  }
}
