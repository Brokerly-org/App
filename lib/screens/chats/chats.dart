import 'package:brokerly/screens/qr_scanner/qr_scanning.dart';
import 'package:brokerly/screens/search/search_page.dart';
import 'package:brokerly/screens/settings/settings_screen.dart';
import 'package:brokerly/ui_manager.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../const.dart';
import '../../models/bot.dart';
import '../../providers/bots_provider.dart';
import '../../services/client.dart';
import '../../services/deep_links.dart';
import 'components/action_button.dart';
import 'components/bot_tile.dart';
import '../../widgets/explain_new_bot_illustration.dart';
import 'components/expandable_fab.dart';
import 'components/new_bot_input.dart';

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

  void addBot(BuildContext context, String longBotLink) {
    String botLink = extractBotLink(Uri.parse(longBotLink));
    UIManager.addBotFromUrl(context, botLink);
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

  void onScanClick() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => QRScanningPage(
          client: widget.client,
        ),
      ),
    );
  }

  void onSearchClick() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => SearchPage()),
        (Route<dynamic> route) => true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(right: getAppBarTitlePadding()),
          child: title,
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      floatingActionButton: showFab ? getFab(context) : null,
      body: body(context),
    );
  }

  Widget newFab(BuildContext context) {
    return ExpandableFab(
      distance: 90,
      children: [
        ActionButton(
          onPressed: () => openNewBotInput(context),
          icon: const Icon(Icons.add_link),
        ),
        ActionButton(
          onPressed: onScanClick,
          icon: const Icon(Icons.qr_code),
        ),
        ActionButton(
          onPressed: () => onSearchClick(),
          icon: const Icon(Icons.search_sharp),
        ),
      ],
    );
  }

  Widget getFab(BuildContext context) {
    if (intl.Bidi.isRtlLanguage(Localizations.localeOf(context).languageCode)) {
      return Padding(
        padding: const EdgeInsets.only(right: 30.0),
        child: newFab(context),
      );
    }
    return newFab(context);
  }

  double getAppBarTitlePadding() {
    if (intl.Bidi.isRtlLanguage(Localizations.localeOf(context).languageCode)) {
      return MediaQuery.of(context).size.width - 154;
    }
    return 0.0;
  }

  Widget body(BuildContext context) {
    BotsProvider botsProvider = context.watch<BotsProvider>();
    List<Bot> bots = botsProvider.bots.values.toList();
    return Stack(
      children: [
        bots.length == 0 && !UIManager.isDesktop(context)
            ? ExplainIilustration()
            : botsListView(bots),
        newBotInputBox(),
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
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 120,
          crossAxisSpacing: 12,
          mainAxisSpacing: 20,
          mainAxisExtent: 120,
        ),
        itemCount: bots.length,
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
