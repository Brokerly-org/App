import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/bot.dart';
import 'models/server.dart';
import 'providers/bots_provider.dart';
import 'services/cache.dart';
import 'services/client.dart';

void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message, style: TextStyle(fontSize: 18)),
      duration: Duration(seconds: 2)));
}

void showError(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message, style: TextStyle(fontSize: 18, color: Colors.red)),
      duration: Duration(milliseconds: 800)));
}

Future<String> registerToServer(Client client, Uri uri) async {
  String userToken = await client
      .registerToServer(uri.scheme, uri.authority)
      .catchError((var error) {
    return null;
  });
  return userToken;
}

Future<Server> serverFromUrl(
    BuildContext context, Client client, Uri uri) async {
  BotsProvider botsProvider = context.read<BotsProvider>();
  if (botsProvider.servers.containsKey(uri.authority)) {
    return botsProvider.servers[uri.authority];
  } else {
    String userToken = await registerToServer(client, uri);
    if (userToken == null) {
      showError(context, "Registration error...");
    }
    return Server(uri.authority, uri.scheme, userToken);
  }
}

void addBotFromUrl(BuildContext context, String url, Client client) async {
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

  showMessage(context, "Registering to bot...");
  Server server = await serverFromUrl(context, client, uri);
  print("registered to server ${uri.authority}");

  String botname = uri.queryParameters["botname"];
  Bot newBot = await client.fetchBot(botname, server);
  if (newBot == null) {
    showError(context, "Bot $botname does not exists on this server");
    return;
  }
  Cache.saveBot(newBot);
  botsProvider.addBot(newBot);
}
