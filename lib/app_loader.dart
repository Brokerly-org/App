import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'utils.dart';
import 'providers/bots_provider.dart';
import 'screens/chat.dart';
import 'screens/chats.dart';
import 'models/bot.dart';
import 'services/push_notifications.dart';
import 'services/client.dart';
import 'services/cache.dart';
import 'services/deep_links.dart';

class AppLoader extends StatefulWidget {
  AppLoader({Key key}) : super(key: key);

  @override
  _AppLoaderState createState() => _AppLoaderState();
}

class _AppLoaderState extends State<AppLoader> {
  Client client = Client();

  void pullingLoop() async {
    while (true) {
      await Future.delayed(Duration(seconds: 1));
      client.pullMessagesFromServers(context);
    }
  }

  void checkBotsStatus() async {
    while (true) {
      print("update status");
      client.updateBotsStatus(context);
      await Future.delayed(Duration(seconds: 55));
    }
  }

  Future<void> loadBotsFromCache() async {
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

  @override
  Widget build(BuildContext context) {
    BotsProvider botsProvider = context.watch<BotsProvider>();
    String selectedBotName = botsProvider.selectedBotName ?? "";

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constrains) {
        if (constrains.maxWidth < 600) {
          return ChatsListScreen(client);
        } else {
          return Scaffold(
            body: Row(
              children: [
                SizedBox(width: 300, child: ChatsListScreen(client)),
                VerticalDivider(
                    color: Theme.of(context).primaryColor,
                    thickness: 1,
                    width: 1),
                Expanded(
                  flex: 13,
                  child: ChatScreen(botname: selectedBotName, client: client),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  void onNewBotLink(String botLink) {
    addBotFromUrl(context, botLink, client);
    print(botLink);
  }

  void onInvalidBotLink(String botLink) {
    showError(context, "Invalid bot link");
    print("Invalid $botLink");
  }

  void setup() async {
    await loadBotsFromCache();
    pullingLoop();
    checkBotsStatus();
    initUniLinks(onNewBotLink, onInvalidBotLink);
  }

  void setupBackroundTasks() {
    setupPushNotificationService();
  }

  @override
  void initState() {
    //Cache.clear();
    super.initState();
    setup();
    setupBackroundTasks();
  }
}
