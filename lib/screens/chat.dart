import 'dart:typed_data';

import 'package:brokerly/services/cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:audioplayers/audioplayers.dart';

import '../utils.dart';
import '../widgets/explain_new_bot_illustration.dart';
import '../widgets/message_bar.dart';
import '../widgets/message_bobble.dart';
import '../widgets/popup_menu_option.dart';
import '../services/client.dart';
import '../models/message.dart';
import '../models/bot.dart';
import '../providers/bots_provider.dart';

class ChatScreenArguments {
  String botname;
  Client client;
  ChatScreenArguments(this.botname, this.client);
}

// ignore: must_be_immutable
class ChatScreen extends StatelessWidget {
  final ScrollController scrollController =
      ScrollController(keepScrollOffset: false);
  final MessageBarController messageBarController = MessageBarController();

  String botname;
  Client client;
  ChatScreen({this.botname, this.client});

  void scrollDown() {
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  void playSendSound() async {
    // TODO load data once and forever for that widget
    AudioPlayer audioPlayer = AudioPlayer();
    final ByteData data = await rootBundle.load('assets/sent.wav');
    final Uint8List dataBytes = data.buffer.asUint8List();
    int result = await audioPlayer.playBytes(dataBytes);
    print('sendMessageSound result is $result');
  }

  void sendMessage(
      BuildContext context, String message, Client client, Bot bot) async {
    if (message.isEmpty || message == null) {
      return;
    }
    client.pushMessageToBot(bot, message).then((value) => playSendSound());
    Message newMessage = Message(message, "user", DateTime.now());
    context.read<BotsProvider>().addMessagesToBot(bot.botname, [newMessage]);
  }

  void loadRouteArguments(BuildContext context) {
    if (this.botname == null) {
      ChatScreenArguments args =
          ModalRoute.of(context).settings.arguments as ChatScreenArguments;
      this.botname = args.botname;
      this.client = args.client;
    }
  }

  void jumpDown() {
    if (scrollController.hasClients) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => jumpDown());
    loadRouteArguments(context);
    BotsProvider botsProvider = context.watch<BotsProvider>();
    Bot bot = botsProvider.bots[botname];

    if (!botsProvider.bots.containsKey(botname)) {
      return emptyChat(context);
    }
    bot.readMessages();
    return Scaffold(
      appBar:
          AppBar(title: Text(bot.title), actions: [chatActions(context, bot)]),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          // Spacer(flex: 1),
          Expanded(flex: 80, child: messagesListView(bot)),
          // Spacer(flex: 1),
          MessageBar(
            sendMessage: (String message) =>
                sendMessage(context, message, client, bot),
            controller: messageBarController,
          ),
        ],
      ),
    );
  }

  Container emptyChat(BuildContext context) {
    bool haveChats = context.read<BotsProvider>().bots.length > 0;
    return Container(
      color: Theme.of(context).backgroundColor,
      child: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: haveChats ? selectBotMessage(context) : ExplainIilustration(),
      ),
    );
  }

  Center selectBotMessage(BuildContext context) {
    return Center(
      child: Text(
        "Select a bot to start messaging...",
        style: Theme.of(context).textTheme.headline4,
      ),
    );
  }

  PopupMenuButton<String> chatActions(BuildContext context, Bot bot) {
    return PopupMenuButton(
      onSelected: (String selected) async {
        if (selected == "share") {
          Share.share(bot.shareLink());
        } else if (selected == "delete") {
          Navigator.pop(context);
          print("delete bot: ${await Cache.removeBot(bot)}");
          showMessage(context, "Bot ${bot.botname} chat deleted");
          context.read<BotsProvider>().removeBot(bot);
        } else {
          showMessage(context, "<$selected> Not support yet.");
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuOption(context, "share", "Share bot", Icons.share_outlined),
          PopupMenuOption(context, "mute", "Disable Notifications",
              Icons.volume_off_outlined),
          PopupMenuOption(
              context, "clear", "Clear history", Icons.layers_clear_outlined),
          PopupMenuOption(context, "block", "Block bot", Icons.block_outlined),
          PopupMenuOption(
              context, "report", "Report bot", Icons.report_outlined),
          PopupMenuOption(
              context, "delete", "Delete chat", Icons.delete_outlined),
        ];
      },
    );
  }

  Widget messagesListView(Bot bot) {
    int itemCount = bot.messages.length + 2;
    return GestureDetector(
      onTap: () {
        if (messageBarController.unfocus != null) {
          messageBarController.unfocus();
        }
      },
      child: ListView.separated(
        controller: scrollController,
        itemCount: itemCount,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0 || index == itemCount - 1) {
            return SizedBox(height: 5);
          }
          Message message = bot.messages[index - 1];
          return MessageBobble(message: message);
        },
        separatorBuilder: (BuildContext context, _) => SizedBox(height: 5.0),
      ),
    );
  }
}
