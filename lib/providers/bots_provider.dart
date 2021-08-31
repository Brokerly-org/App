import 'package:flutter/material.dart';

import '../models/server.dart';
import '../models/message.dart';
import '../models/bot.dart';

class BotsProvider extends ChangeNotifier {
  Map<String, Bot> bots = {};
  Map<String, int> serverBotsCount = {};
  Map<String, Server> servers = {};
  String selectedBotID;

  void selectBotID(String botId) {
    this.selectedBotID = botId;
    notifyListeners();
  }

  void addBot(Bot bot) {
    bots[bot.id] = bot;
    if (!servers.containsKey(bot.server.url)) {
      servers[bot.server.url] = bot.server;
      serverBotsCount[bot.server.url] = 1;
    } else {
      serverBotsCount[bot.server.url] += 1;
    }
    notifyListeners();
  }

  void removeBot(Bot bot) {
    this.bots.remove(bot.id);
    this.serverBotsCount[bot.server.url] -= 1;
    if (this.serverBotsCount[bot.server.url] <= 0) {
      this.servers.remove(bot.server.url);
    }
    notifyListeners();
  }

  void addMessagesToBot(String botId, List<Message> messages) {
    Bot bot = this.bots[botId];
    if (bot.blocked) {
      return;
    }
    bot.messages.addAll(messages);
    bot.addNewMessages(messages.length);
    notifyListeners();
  }

  void blockBot(String botId) {
    Bot bot = this.bots[botId];
    bot.block();
    notifyListeners();
  }

  void unblockBot(String botId) {
    Bot bot = this.bots[botId];
    bot.unblock();
    notifyListeners();
  }

  void readBotMessages(String botId) {
    if (this.bots[botId].unreadMessages == 0) {
      return;
    }
    this.bots[botId].readMessages();
    notifyListeners();
  }

  void clearChat(String botId) {
    this.bots[botId].clear();
    notifyListeners();
  }

  void updateBotOnlineStatus(String botId, bool status) {
    Bot bot = this.bots[botId];
    if (bot == null) {
      return;
    }
    bot.updateOnlineStatus(status);
    notifyListeners();
  }
}
