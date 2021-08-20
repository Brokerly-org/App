import 'package:brokerly/const.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {
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
        trailing:
            bot.unreadMessages > 0 ? unreadMessagesCounter(context) : null,
      ),
    );
  }

  ClipRRect unreadMessagesCounter(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Container(
        height: 22,
        width: 10.0 + bot.unreadMessages.toString().length * 12.0,
        alignment: Alignment.center,
        padding: EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: Theme.of(context).buttonColor,
        ),
        child: Text(bot.unreadMessages.toString(),
            textAlign: TextAlign.center, style: TextStyle(fontSize: 15)),
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
