import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../../ui_manager.dart';
import '../../models/bot.dart';
import '../../models/message.dart';
import '../../providers/bots_provider.dart';
import '../../services/client.dart';
import '../../widgets/explain_new_bot_illustration.dart';
import 'components/popup_menu_option.dart';
import 'components/message_bar.dart';
import 'components/message_bobble.dart';
import 'components/report_dialog.dart';

class ChatScreenArguments {
  String botId;
  Client client;
  ChatScreenArguments(this.botId, this.client);
}

class ChatScreen extends StatefulWidget {
  String botId;
  Client client;
  ChatScreen({this.botId, this.client});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController scrollController =
      ScrollController(keepScrollOffset: false);
  final MessageBarController messageBarController = MessageBarController();

  bool showScrollToBottomButton = false;

  void loadRouteArguments(BuildContext context) {
    if (this.widget.botId == null) {
      ChatScreenArguments args =
          ModalRoute.of(context).settings.arguments as ChatScreenArguments;
      widget.botId = args.botId;
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
    Bot bot = botsProvider.bots[widget.botId];

    if (!botsProvider.bots.containsKey(widget.botId)) {
      return emptyChat(context);
    }
    bot.readMessages();
    return Scaffold(
      appBar: buildAppBar(bot, context),
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

  Widget body(Bot bot, BuildContext context) {
    return Stack(
      children: [
        messagesListView(bot),
        routesMenu(),
      ],
    );
  }

  DraggableScrollableSheet routesMenu() {
    return DraggableScrollableSheet(
      maxChildSize: 0.56,
      minChildSize: 0.0625,
      initialChildSize: 0.0625,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35),
                topRight: Radius.circular(35),
              ),
              boxShadow: [
                BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.25), blurRadius: 4)
              ]),
          child: GridView.count(
            shrinkWrap: true,
            controller: scrollController,
            crossAxisCount: 2,
            children: [
              Container(
                height: 83,
                width: 89,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(33),
                  color: Theme.of(context).primaryColor,
                ),
              )
            ],
          ),
        );
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
          Message message = bot.messages.elementAt(index - 1);
          return MessageBobble(message: message, bot: bot);
        },
        separatorBuilder: (BuildContext context, _) => SizedBox(height: 5.0),
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

  AppBar buildAppBar(Bot bot, BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Text(bot.title),
          if (bot.blocked) Text(" (Blocked)"),
        ],
      ),
      //actions: [chatActions(context, bot)],
    );
  }

  PopupMenuButton<String> chatActions(BuildContext context, Bot bot) {
    return PopupMenuButton(
      onSelected: (String selected) async {
        if (selected == "share") {
          Share.share(bot.shareLink());
        } else if (selected == "delete") {
          Navigator.pop(context);
          UIManager.removeBot(context, bot);
        } else if (selected == "clear") {
          context.read<BotsProvider>().clearChat(bot.id);
        } else if (selected == "block") {
          UIManager.blockBot(context, bot);
        } else if (selected == "unblock") {
          context.read<BotsProvider>().unblockBot(bot.id);
          widget.client.unblockBot(bot);
          UIManager.showMessage(context, "Bot unblocked!");
        } else if (selected == "report") {
          showReportDialog(context, bot);
        } else {
          UIManager.showMessage(context, "<$selected> Not support yet.");
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
}
