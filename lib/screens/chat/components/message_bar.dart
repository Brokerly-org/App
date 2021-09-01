import 'package:brokerly/const.dart';
import 'package:emoji_picker/emoji_picker.dart' as emoji;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MessageBarController {
  VoidCallback unfocus;

  void dispose() {
    unfocus = null;
  }
}

class MessageBar extends StatefulWidget {
  const MessageBar({Key key, @required this.sendMessage, this.controller})
      : super(key: key);
  final Function(String) sendMessage;
  final MessageBarController controller;

  @override
  _MessageBarState createState() => _MessageBarState();
}

class _MessageBarState extends State<MessageBar> {
  final FocusNode focusNode = FocusNode();
  final TextEditingController textEditingController = TextEditingController();
  final hintColor = Color.fromRGBO(148, 148, 148, 1);
  bool emojiKeyboardOpen = false;

  void sendMessage() {
    String message = this.textEditingController.value.text;
    this.textEditingController.clear();
    widget.sendMessage(message);
  }

  void unfocus() {
    this.focusNode.unfocus();
    this.emojiKeyboardOpen = false;
  }

  void openEmojiKeyboard() {
    this.focusNode.unfocus();
    setState(() {
      emojiKeyboardOpen = true;
    });
  }

  void closeEmojiKeyboard() {
    setState(() {
      emojiKeyboardOpen = false;
      focusNode.requestFocus();
    });
  }

  @override
  void initState() {
    super.initState();
    MessageBarController controller = widget.controller;
    if (controller != null) {
      controller.unfocus = unfocus;
    }
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(maxHeight: 300),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          boxShadow: [
            BoxShadow(offset: Offset(0, 4), spreadRadius: 1, blurRadius: 5)
          ],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                emojiKeyboardOpen
                    ? openTextKeyboardButton()
                    : openEmojiKeyboardButton(),
                textField(),
                sendButton()
              ],
            ),
            emojiKeyboardOpen ? emojiKeyboard(context) : SizedBox(),
          ],
        ),
      ),
    );
  }

  IconButton openTextKeyboardButton() {
    return IconButton(
        icon: Icon(Icons.keyboard, color: hintColor),
        onPressed: closeEmojiKeyboard);
  }

  IconButton openEmojiKeyboardButton() {
    return IconButton(
      icon: Icon(Icons.face_outlined, color: hintColor),
      onPressed: openEmojiKeyboard,
    );
  }

  emoji.EmojiPicker emojiKeyboard(BuildContext context) {
    return emoji.EmojiPicker(
      bgColor: Theme.of(context).backgroundColor,
      rows: 3,
      columns: 8,
      numRecommended: 10,
      buttonMode: emoji.ButtonMode.CUPERTINO,
      onEmojiSelected: (emoji.Emoji e, emoji.Category c) {
        textEditingController.text += e.emoji;
      },
    );
  }

  Expanded textField() {
    return Expanded(
      child: TextFormField(
        onFieldSubmitted: (String message) => sendMessage(),
        controller: textEditingController,
        focusNode: focusNode,
        autofocus: MediaQuery.of(context).size.width > kDesktopMinSize,
        cursorColor: Theme.of(context).colorScheme.onSecondary,
        style: TextStyle(fontSize: 20),
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: AppLocalizations.of(context).messageHint,
            hintStyle: TextStyle(
              fontSize: 17.9,
              color: hintColor,
            )),
      ),
    );
  }

  IconButton sendButton() {
    return IconButton(
      icon: Icon(
        Icons.send,
        color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.7),
        size: 32,
      ),
      onPressed: sendMessage,
    );
  }
}
