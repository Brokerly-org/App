import 'dart:convert';

import 'package:brokerly/screens/qr_scanning.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../const.dart';
import '../models/bot.dart';
import '../providers/bots_provider.dart';
import '../services/client.dart';
import '../services/deep_links.dart';
import '../utils.dart';
import '../widgets/action_button.dart';
import '../widgets/bot_tile.dart';
import '../widgets/expandable_fab.dart';
import '../widgets/explain_new_bot_illustration.dart';
import '../widgets/new_bot_input.dart';

class ChatsListScreen extends StatefulWidget {
  ChatsListScreen(this.client);
  final Client client;

  @override
  _ChatsListScreenState createState() => _ChatsListScreenState();
}

class _ChatsListScreenState extends State<ChatsListScreen> {
  bool showFab = true;
  bool showNewBotInput = false;

  FocusNode focusNode = FocusNode();
  QRViewController controller;

  void addBot(BuildContext context, String botLinkBase64) {
    String botDeepLink = String.fromCharCodes(base64.decode(botLinkBase64));
    String botLink = extractBotLink(Uri.parse(botDeepLink));
    addBotFromUrl(context, botLink, widget.client);
    closeNewBotInput();
  }

  void closeNewBotInput() {
    setState(() {
      showNewBotInput = false;
      showFab = true;
    });
  }

  void openNewBotInput(BuildContext context) {
    setState(() {
      showNewBotInput = true;
      showFab = false;
      focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: title),
      //drawer: Drawer(),
      backgroundColor: Theme.of(context).backgroundColor,
      floatingActionButton: showFab ? newFab(context) : null,
      body: body(context),
    );
  }

  Widget newFab(BuildContext context) {
    return ExpandableFab(
      distance: 150,
      children: [
        ActionButton(
          onPressed: () => openNewBotInput(context),
          icon: const Icon(Icons.vpn_key),
        ),
        ActionButton(
          onPressed: onScanClick, //() => _onQRViewCreated(controller),
          icon: const Icon(Icons.qr_code),
        ),
      ],
    );
  }

  Widget body(BuildContext context) {
    BotsProvider botsProvider = context.watch<BotsProvider>();
    List<Bot> bots = botsProvider.bots.values.toList();
    return Stack(
      children: [
        bots.length == 0 && !isDesktop(context)
            ? ExplainIilustration()
            : botsListView(bots),
        newBotInputBox(),
        //qrScanner(),
      ],
    );
  }

  Widget newBotInputBox() {
    return this.showNewBotInput
        ? NewBotInput(
            focusNode: focusNode,
            onAdd: (String botLink) => addBot(context, botLink),
            onClose: () => closeNewBotInput(),
          )
        : Container();
  }

  Container botsListView(List<Bot> bots) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: bots.length,
        itemExtent: 80,
        itemBuilder: (BuildContext context, int index) {
          Bot bot = bots[index];
          return BotTile(client: widget.client, bot: bot);
        },
      ),
    );
  }

  @override
  void dispose() {
    if (controller != null) {
      controller.dispose();
    }
    super.dispose();
  }

  void onScanClick() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (BuildContext context) => QRScanningPage(
                  client: widget.client,
                )),
        (Route<dynamic> route) => true);
  }
}
