import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:brokerly/services/cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../models/bot.dart';
import '../models/message.dart';
import '../providers/bots_provider.dart';
import '../services/client.dart';
import '../utils.dart';
import '../widgets/explain_new_bot_illustration.dart';
import '../widgets/message_bar.dart';
import '../widgets/message_bobble.dart';
import '../widgets/popup_menu_option.dart';

class ChatScreenArguments {
  String botname;
  Client client;
  ChatScreenArguments(this.botname, this.client);
}

class ChatScreen extends StatefulWidget {
  String botname;
  Client client;
  ChatScreen({this.botname, this.client});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController scrollController =
      ScrollController(keepScrollOffset: false);
  final MessageBarController messageBarController = MessageBarController();

  bool showScrollToBottomButton = false;

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
    if (this.widget.botname == null) {
      ChatScreenArguments args =
          ModalRoute.of(context).settings.arguments as ChatScreenArguments;
      widget.botname = args.botname;
      widget.client = args.client;
    }
  }

  void scrollDown() {
    scrollController.animateTo(0.0,
        duration: Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  @override
  void initState() {
    super.initState();
    this.scrollController.addListener(() {
      setState(() {
        showScrollToBottomButton = scrollController.offset > 300;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    loadRouteArguments(context);
    BotsProvider botsProvider = context.watch<BotsProvider>();
    Bot bot = botsProvider.bots[widget.botname];

    if (!botsProvider.bots.containsKey(widget.botname)) {
      return emptyChat(context);
    }
    bot.readMessages();
    return Scaffold(
      appBar: AppBar(
          title: Row(
            children: [
              Text(bot.title),
              if (bot.blocked) Text(" (Blocked)"),
            ],
          ),
          actions: [chatActions(context, bot)]),
      backgroundColor: Theme.of(context).backgroundColor,
      body: body(bot, context),
      floatingActionButton: fab(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }

  Widget fab(BuildContext context) {
    return showScrollToBottomButton
        ? Container(
            margin: EdgeInsets.only(bottom: 40),
            child: FloatingActionButton(
              onPressed: this.scrollDown,
              child: Icon(Icons.keyboard_arrow_down),
              mini: true,
              elevation: 20.0,
            ),
          )
        : null;
  }

  Column body(Bot bot, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(flex: 80, child: messagesListView(bot)),
        MessageBar(
          sendMessage: (String message) =>
              sendMessage(context, message, widget.client, bot),
          controller: messageBarController,
        ),
      ],
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
        } else if (selected == "clear") {
          context.read<BotsProvider>().clearChat(bot.botname);
        } else if (selected == "block") {
          context.read<BotsProvider>().blockBot(bot.botname);
          showMessage(context, "Bot blocked!");
          widget.client.blockBot(bot);
        } else if (selected == "unblock") {
          context.read<BotsProvider>().unblockBot(bot.botname);
          widget.client.unblockBot(bot);
          showMessage(context, "Bot unblocked!");
        } else {
          showMessage(context, "<$selected> Not support yet.");
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuOption(context, "share",
              AppLocalizations.of(context).shareBot, Icons.share_outlined),
          PopupMenuOption(
              context,
              "mute",
              AppLocalizations.of(context).disNotifications,
              Icons.volume_off_outlined),
          PopupMenuOption(
              context,
              "clear",
              AppLocalizations.of(context).clearHistory,
              Icons.layers_clear_outlined),
          bot.blocked == false
              ? PopupMenuOption(context, "block",
                  AppLocalizations.of(context).blockBot, Icons.block_outlined)
              : PopupMenuOption(context, "unblock",
                  AppLocalizations.of(context).unblockBot, Icons.lock_open),
          PopupMenuOption(context, "report",
              AppLocalizations.of(context).reportBot, Icons.report_outlined),
          PopupMenuOption(context, "delete",
              AppLocalizations.of(context).deleteChat, Icons.delete_outlined),
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
        reverse: true,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0 || index == itemCount - 1) {
            return SizedBox(height: 5);
          }
          Message message = bot.messages.reversed.elementAt(index - 1);
          return MessageBobble(message: message, bot: bot);
        },
        separatorBuilder: (BuildContext context, _) => SizedBox(height: 5.0),
      ),
    );
  }
}
