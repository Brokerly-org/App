import 'dart:convert';
import 'dart:math' as math;

import 'package:brokerly/providers/bots_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../models/message.dart';
import '../models/server.dart';
import '../models/bot.dart';

class Client {
  void pushMessageToBot(Bot bot, String message) async {
    Server server = bot.server;

    Map<String, String> params = {
      "token": server.userToken,
      "message": message,
      "botname": bot.botname,
    };
    String path = '/user/push';

    Uri uri;
    if (server.urlSchema == "http") {
      uri = Uri.http(server.url, path, params);
    } else {
      uri = Uri.https(server.url, path, params);
    }

    await http.post(uri);
  }

  Future<List<dynamic>> _pullFromServer(Server server) async {
    Map<String, String> params = {"token": server.userToken};
    String path = '/user/pull';

    Uri uri;
    if (server.urlSchema == "http") {
      uri = Uri.http(server.url, path, params);
    } else {
      uri = Uri.https(server.url, path, params);
    }
    var response = await http.get(uri);
    String responseBodyDecoded = utf8.decode(response.body.codeUnits);
    Map<String, dynamic> messages;
    try {
      messages = json.decode(responseBodyDecoded);
    } catch (exception) {
      print(response.body);
      throw exception;
    }
    List<dynamic> messageList = messages["messages"];
    return messageList;
  }

  void pullMessagesFromServers(BuildContext context) {
    BotsProvider botsProvider = context.read<BotsProvider>();
    botsProvider.servers.values.forEach((server) {
      this._pullFromServer(server).then((serverMessages) => {
            if (serverMessages == null) {serverMessages = []},
            serverMessages.forEach((botMessages) {
              var messages = botMessages["messages"];
              Bot bot = botsProvider.bots[botMessages["chat"]];
              messages.forEach((messageData) {
                messageData["created_at"] =
                    (messageData["created_at"] * 1000.0).round();
                print(messageData);
                Message message = Message.fromDict(messageData);
                botsProvider.addMessagesToBot(bot.botname, [message]);
              });
            })
          });
    });
  }

  Future<String> registerToServer(String scema, String serverUrl) async {
    int userId = math.Random().nextInt(999999);
    Map<String, String> queryParams = {
      "email": "somemail$userId@gmail.com",
      "password": "secret",
      "name": "normal_name_$userId",
    };
    String path = "/user/register";
    Uri uri;
    if (scema == "http") {
      uri = Uri.http(serverUrl, path, queryParams);
    } else {
      uri = Uri.https(serverUrl, path, queryParams);
    }
    var response = await http.post(uri);
    return json.decode(response.body)["token"];
  }

  void updateServerBotsStatus(BuildContext context, Server server) async {
    BotsProvider botsProvider = context.read<BotsProvider>();

    Uri uri;
    String path = "/user/bots_status";
    Map<String, String> params = {"token": server.userToken};
    if (server.urlSchema == "http") {
      uri = Uri.http(server.url, path, params);
    } else {
      uri = Uri.https(server.url, path, params);
    }

    var response = await http.get(uri);
    print(response.body);
    List<dynamic> statusUpdate = json.decode(response.body);
    print(statusUpdate);
    statusUpdate.forEach((botStatus) {
      String botname = botStatus["botname"];
      double value = botStatus["last_online"];
      double lastOnline = value * 1.0;
      botsProvider.updateBotLastOnline(botname, lastOnline.round());
    });
  }

  void updateBotsStatus(BuildContext context) async {
    BotsProvider botsProvider = context.read<BotsProvider>();
    botsProvider.servers.values
        .forEach((server) => updateServerBotsStatus(context, server));
  }

  Future<Bot> fetchBot(String botname, Server server) async {
    Map<String, String> params = {"botname": botname};
    String path = "/user/bot_info";
    Uri uri;
    if (server.urlSchema == "http") {
      uri = Uri.http(server.url, path, params);
    } else {
      uri = Uri.https(server.url, path, params);
    }
    var response = await http.get(uri);
    if (response.statusCode != 200) {
      return null;
    }
    String responseBody = utf8.decode(response.body.codeUnits);
    Map<String, dynamic> botInfo = json.decode(responseBody);
    Bot newBot = Bot(botname, botInfo["title"], botInfo["description"], server);
    double lastOnline;
    try {
      lastOnline = botInfo["last_online"] * 1.0;
    } catch (exception) {
      lastOnline = 0.0;
    }
    newBot.updateLastOnline(lastOnline.round());
    return newBot;
  }
}
