import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          if (MediaQuery.of(context).size.width < 600) {
            Navigator.pushNamed(context, '/chat',
                arguments: ChatScreenArguments(bot.botname, client));
          } else {
            context.read<BotsProvider>().selectBotName(bot.botname);
          }
        },
        tileColor: Theme.of(context).primaryColor,
        title: Text(bot.title),
        subtitle: Text(bot.description),
        leading: DateTime.now().difference(bot.lastOnline).inMinutes < 1
            ? Container(
                width: 6.5,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(36, 193, 33, 1),
                  borderRadius: BorderRadius.circular(25),
                ),
              )
            : null,
        trailing: bot.unreadMessages > 0
            ? ClipRRect(
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
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15)),
                ),
              )
            : null,
      ),
    );
  }
}
