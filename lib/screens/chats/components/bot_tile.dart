import 'package:brokerly/ui_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../style.dart';
import '../../../models/bot.dart';
import '../../../providers/bots_provider.dart';
import '../../../services/client.dart';
import '../../chat/chat.dart';

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
    return SizedBox(
      height: 120,
      child: GestureDetector(
        onTap: () {
          context.read<BotsProvider>().readBotMessages(bot.id);
          if (!UIManager.isDesktop(context)) {
            Navigator.pushNamed(context, '/chat',
                arguments: ChatScreenArguments(bot.id, client));
          } else {
            context.read<BotsProvider>().selectBotID(bot.id);
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            botCard(context),
            SizedBox(height: 5),
            botTitle(),
          ],
        ),
      ),
    );
  }

  Text botTitle() {
    return Text(
      bot.title,
      style: TextStyle(
        fontSize: 16.5,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget botCard(BuildContext context) {
    return SizedBox(
      height: 85,
      width: 85,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).backgroundColor,
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.25),
                spreadRadius: 0,
                blurRadius: 4,
              ),
            ]),
        child: SvgPicture.asset(
          'assets/home_illustrate.svg',
          height: 48,
          width: 48,
        ),
      ),
    );
  }

  Container onlineIndicator() {
    return Container(
      width: 6.5,
      decoration: BoxDecoration(
        color: bot.onlineStatus ? onlineColor : offlineColor,
        borderRadius: BorderRadius.circular(25),
      ),
    );
  }
}
