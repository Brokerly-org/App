import 'dart:math' as math;
import 'package:brokerly/ui_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/bots_provider.dart';
import 'screens/chat/chat.dart';
import 'screens/chats/chats.dart';
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

  void connectToServers(BuildContext context) {
    Client().connectToServers(context);
  }

  void checkBotsStatus() async {
    while (true) {
      print("update status");
      client.updateBotsStatus(context);
      await Future.delayed(Duration(seconds: 20));
    }
  }

  @override
  Widget build(BuildContext context) {
    BotsProvider botsProvider = context.watch<BotsProvider>();
    String selectedBotID = botsProvider.selectedBotID ?? "";

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
                  child: ChatScreen(botId: selectedBotID, client: client),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  void onNewBotLink(String botLink) {
    UIManager.addBotFromUrl(context, botLink);
    print(botLink);
  }

  void onInvalidBotLink(String botLink) {
    UIManager.showError(context, "Invalid bot link");
    print("Invalid $botLink");
  }

  Future<void> loadOrCreateRootSecret() async {
    if (await Cache.loadRootSecret() != null) {
      return;
    }
    int length = 10;
    String rootSecret = "";
    for (var i = 0; i < length; i++) {
      rootSecret += math.Random.secure().nextInt(9999999).toString();
    }
    print("created root secret <$rootSecret>");
    await Cache.saveRootSecret(rootSecret);
    return;
  }

  void setup() async {
    await loadOrCreateRootSecret();
    await UIManager.loadBots(context);
    connectToServers(context);
    checkBotsStatus();
    initUniLinks(onNewBotLink, onInvalidBotLink);
    setupPushNotificationService();
  }

  @override
  void initState() {
    //Cache.clear();
    super.initState();
    setup();
  }
}
