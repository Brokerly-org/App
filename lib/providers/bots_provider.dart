import 'package:flutter/material.dart';

import '../models/server.dart';
import '../models/message.dart';
import '../models/bot.dart';

class BotsProvider extends ChangeNotifier {
  Map<String, Bot> bots = {};
  Map<String, Server> servers = {};
  String selectedBotName;

  void selectBotName(String botname) {
    this.selectedBotName = botname;
    notifyListeners();
  }

  void addBot(Bot bot) {
    // todo: bot name is uniqu
    bots[bot.botname] = bot;
    if (!servers.containsKey(bot.server.url)) {
      servers[bot.server.url] = bot.server;
    }
    notifyListeners();
  }

  void addMessagesToBot(String botname, List<Message> messages) {
    Bot bot = this.bots[botname];
    bot.messages.addAll(messages);
    bot.addNewMessages(messages.length);
    notifyListeners();
  }

  void readBotMessages(String botname) {
    this.bots[botname].readMessages();
    notifyListeners();
  }

  void updateBotLastOnline(String botname, int timestamp) {
    this.bots[botname].updateLastOnline(timestamp);
    notifyListeners();
  }
}
