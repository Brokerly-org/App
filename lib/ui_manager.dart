import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'const.dart';
import 'models/message.dart';
import 'providers/bots_provider.dart';
import 'models/bot.dart';
import 'models/server.dart';
import 'services/client.dart';
import 'services/cache.dart';

class UIManager {
  static void addBotFromUrl(BuildContext context, String url) async {
    BotsProvider botsProvider = context.read<BotsProvider>();
    if (url == "") {
      return;
    }
    Uri uri = Uri.parse(url);
    if (uri.authority == "" || !uri.queryParameters.containsKey("botname")) {
      showError(context, "Invalid Link");
      return;
    }
    if (botsProvider.bots.containsKey(uri.queryParameters["botname"])) {
      return;
    }

    Server server;
    showMessage(context, "Registering to bot...");
    if (botsProvider.servers.containsKey(uri.authority)) {
      server = botsProvider.servers[uri.authority];
    } else {
      String userToken = await Client()
          .registerToServer(uri.scheme, uri.authority)
          .catchError((var error) {
        return null;
      });
      if (userToken == null) {
        showError(context, "Registration error...");
        return;
      }
      server = Server(uri.authority, uri.scheme, userToken);
      print("registered to server ${uri.authority}");

      String botname = uri.queryParameters["botname"];
      Bot newBot = await Client().fetchBot(botname, server);
      if (newBot == null) {
        showError(context, "Bot $botname does not exists on this server");
        return;
      }
      Cache.saveBot(newBot);
      botsProvider.addBot(newBot);
      Client().connectToServer(context, server);
    }
  }

  static void removeBot(BuildContext context, Bot bot) {
    context.read<BotsProvider>().removeBot(bot);
    showMessage(context, "Bot ${bot.botname} chat deleted");
  }

  static void sendMessage(BuildContext context, Bot bot, String message) {
    if (message.isEmpty || message == null) {
      return;
    }
    Client().pushMessageToBot(bot, message).then((value) async {
      // TODO load data once and forever for that widget
      AudioPlayer audioPlayer = AudioPlayer();
      final ByteData data = await rootBundle.load('assets/sent.wav');
      final Uint8List dataBytes = data.buffer.asUint8List();
      int result = await audioPlayer.playBytes(dataBytes);
      print('sendMessageSound result is $result');
    });
    Message newMessage = Message(message, "user", DateTime.now());
    context.read<BotsProvider>().addMessagesToBot(bot.botname, [newMessage]);
  }

  static Future<void> sendCallback(Bot bot, dynamic data) async {
    await Client().pushCallbackDataToBot(bot, data);
  }

  static void blockBot(BuildContext context, Bot bot,
      {bool showSnakBar = true}) {
    context.read<BotsProvider>().blockBot(bot.botname);
    if (showSnakBar) {
      showMessage(context, "Bot blocked!");
    }
    Client().blockBot(bot);
  }

  static void reportBot(BuildContext context, Bot bot, String reportMessage,
      {bool showSnakBar = true}) {
    Client().reportBot(bot, reportMessage);
    if (showSnakBar) {
      UIManager.showMessage(context, "Reporting...");
    }
  }

  static void updateStatus(BuildContext context, String botname, bool status) {
    BotsProvider botsProvider = context.read<BotsProvider>();
    botsProvider.updateBotOnlineStatus(botname, status);
  }

  static Future<void> loadBots(BuildContext context) async {
    BotsProvider botsProvider = context.read<BotsProvider>();
    List<String> botNames = await Cache.getBotNameList();
    if (botNames == null) {
      return;
    }
    print(botNames);
    for (String botname in botNames) {
      Bot bot = await Cache.loadBot(botname);
      if (bot != null) {
        botsProvider.addBot(bot);
      }
    }
  }

  static Future<bool> saveBot(Bot bot) {
    return Cache.saveBot(bot);
  }

  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text(message, style: TextStyle(fontSize: 18, color: Colors.red)),
        duration: Duration(milliseconds: 800)));
  }

  static void showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message, style: TextStyle(fontSize: 18)),
        duration: Duration(milliseconds: 1400)));
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width > kDesktopMinSize;
  }
}
