import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:crypto/crypto.dart';
//import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'cache.dart';
import '../providers/bots_provider.dart';
import '../models/server.dart';
import '../models/bot.dart';
import '../ui_manager.dart';

class Client {
  static Map<String, WebSocketChannel> connections = {};

  void connectToServers(BuildContext context) {
    context
        .read<BotsProvider>()
        .servers
        .values
        .forEach((server) => this.connectToServer(context, server));
  }

  void reconnect(BuildContext context, Server server) {
    Future.delayed(Duration(seconds: 30)).then(
      (value) => connectToServer(context, server),
    );
  }

  Uri uriFromServer(Server server, String path, Map<String, String> params) {
    Uri uri;
    if (server.urlSchema == "http") {
      uri = Uri.http(server.url, path, params);
    } else {
      uri = Uri.https(server.url, path, params);
    }
    return uri;
  }

  void connectToServer(BuildContext context, Server server) {
    String serverUrl =
        (server.urlSchema == "https" ? "wss://" : "ws://") + server.url;
    String path = "/user_connect";

    if (connections.containsKey(serverUrl)) {
      return;
    }
    String wsUrl = serverUrl + path + "?" + "token=${server.userToken}";
    print("Connect to $wsUrl");
    final WebSocketChannel webSocket = WebSocketChannel.connect(
      Uri.parse(wsUrl),
    );
    connections[serverUrl] = webSocket;
    webSocket.stream.listen(
      (message) {
        List<dynamic> messages = json.decode(utf8.decode(message.codeUnits));
        messages.forEach((botMessages) {
          this.onNewUpdate(context, botMessages, server);
        });
      },
      onDone: () => reconnect(context, server),
      cancelOnError: false,
    );
  }

  void onNewUpdate(
      BuildContext context, Map<String, dynamic> botMessages, Server server) {
    playRecvSound();
    var messages = botMessages["messages"];
    String botname = botMessages["chat"];
    messages.forEach((messageData) {
      UIManager.newMessage(context, server.url + "!" + botname, messageData);
    });
  }

  Future<void> pushMessageToBot(Bot bot, String message) async {
    Server server = bot.server;
    Map<String, String> params = {
      "token": server.userToken,
      "message": message,
      "botname": bot.botname,
    };
    String path = '/user/push';
    Uri uri = this.uriFromServer(server, path, params);
    await http.post(uri);
  }

  Future<void> pushCallbackDataToBot(Bot bot, dynamic callback) async {
    Server server = bot.server;
    Map<String, String> params = {
      "token": server.userToken,
      "callback_data": callback.toString(),
      "botname": bot.botname,
    };
    String path = '/user/callback';
    Uri uri = this.uriFromServer(server, path, params);

    var response = await http.post(uri).timeout(Duration(seconds: 20));
    if (response.statusCode != 200) {
      throw "callback faild"; //TODO: change to real exception
    }
  }

  Future<void> blockBot(Bot bot) async {
    Server server = bot.server;
    Map<String, String> params = {
      "token": server.userToken,
      "botname": bot.botname,
    };
    String path = '/user/block_bot';
    Uri uri = this.uriFromServer(server, path, params);

    await http.post(uri);
  }

  Future<void> reportBot(Bot bot, String explain) async {
    Server server = bot.server;
    Map<String, String> params = {
      "token": server.userToken,
      "botname": bot.botname,
    };
    String path = '/user/report_bot';
    Uri uri = this.uriFromServer(server, path, params);

    await http.post(uri);
  }

  Future<void> unblockBot(Bot bot) async {
    Server server = bot.server;
    Map<String, String> params = {
      "token": server.userToken,
      "botname": bot.botname,
    };
    String path = '/user/unblock_bot';
    Uri uri = this.uriFromServer(server, path, params);

    await http.post(uri);
  }

  void playRecvSound() async {
    // TODO load data once and forever for that widget
    if (kIsWeb) {
      return;
    }
    // AudioPlayer audioPlayer = AudioPlayer();
    // final ByteData data = await rootBundle.load('assets/received.wav');
    // final Uint8List dataBytes = data.buffer.asUint8List();
    // int result = await audioPlayer.playBytes(dataBytes);
    // print('sendMessageSound result is $result');
  }

  Future<int> hasUpdates(Server server) async {
    Map<String, String> params = {"token": server.userToken};
    String path = '/user/has_updates';
    Uri uri = this.uriFromServer(server, path, params);

    var response = await http.get(uri);
    return int.parse(response.body);
  }

  Future<String> registerToServer(String scema, String serverUrl) async {
    String secret = await Cache.loadRootSecret();
    int userId = math.Random().nextInt(999999);
    String serverPassword =
        sha256.convert(utf8.encode(secret + ":" + serverUrl)).toString();
    Map<String, String> queryParams = {
      "email": "somemail$userId",
      "password": serverPassword,
      "name": "username",
    };
    String path = "/auth/register";
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
    String path = "/user/bots_status";
    Map<String, String> params = {"token": server.userToken};
    Uri uri = this.uriFromServer(server, path, params);

    var response = await http.get(uri);
    List<dynamic> statusUpdate = json.decode(response.body);
    statusUpdate.forEach((botStatus) {
      String botname = botStatus["botname"];
      bool status = botStatus["online_status"];
      UIManager.updateStatus(context, server.url + "!" + botname, status);
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
    Uri uri = this.uriFromServer(server, path, params);
    var response = await http.get(uri);
    if (response.statusCode != 200) {
      return null;
    }
    String responseBody = utf8.decode(response.body.codeUnits);
    Map<String, dynamic> botInfo = json.decode(responseBody);
    Bot newBot = Bot(botname, botInfo["title"], botInfo["description"], server);
    bool status = botInfo["online_status"];
    newBot.updateOnlineStatus(status);
    return newBot;
  }
}
