import 'package:brokerly/widgets/action_button.dart';
import 'package:brokerly/widgets/bot_tile.dart';
import 'package:brokerly/widgets/expandable_fab.dart';
import 'package:brokerly/widgets/explain_new_bot_illustration.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../utils.dart';
import '../widgets/new_bot_input.dart';
import '../providers/bots_provider.dart';
import '../services/client.dart';
import '../models/bot.dart';
import '../const.dart';

class ChatsListScreen extends StatefulWidget {
  ChatsListScreen(this.client);
  final Client client;

  @override
  _ChatsListScreenState createState() => _ChatsListScreenState();
}

class _ChatsListScreenState extends State<ChatsListScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool showFab = true;
  bool showNewBotInput = false;
  bool showQr = false;

  FocusNode focusNode = FocusNode();
  QRViewController controller;

  void addBot(BuildContext context, String botLink) {
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
      showQr = false;
      focusNode.requestFocus();
    });
  }

  void openQrScanner() {
    setState(() {
      showQr = true;
      showNewBotInput = false;
      showFab = false;
    });
  }

  void closeQrScanner() {
    controller.stopCamera();
    setState(() {
      showQr = false;
      showNewBotInput = false;
      showFab = true;
    });
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        String result = scanData.code;
        addBotFromUrl(context, result, widget.client);
        closeQrScanner();
      });
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
          onPressed: () => _onQRViewCreated(controller),
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
        bots.length == 0 && MediaQuery.of(context).size.width < 600
            ? ExplainIilustration()
            : botsListView(bots),
        newBotInputBox(),
        qrScanner(),
      ],
    );
  }

  Widget qrScanner() {
    return showQr
        ? QRView(key: qrKey, onQRViewCreated: _onQRViewCreated)
        : Container();
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
}
