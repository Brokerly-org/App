import 'package:flutter/material.dart';
import 'package:emoji_picker/emoji_picker.dart';

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
        color: Theme.of(context).primaryColor,
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

  EmojiPicker emojiKeyboard(BuildContext context) {
    return EmojiPicker(
      bgColor: Theme.of(context).backgroundColor,
      rows: 3,
      columns: 8,
      numRecommended: 10,
      buttonMode: ButtonMode.CUPERTINO,
      onEmojiSelected: (Emoji e, Category c) {
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
        cursorColor: Colors.white,
        style: TextStyle(fontSize: 20),
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Message",
            hintStyle: TextStyle(
              fontSize: 20,
              color: hintColor,
            )),
      ),
    );
  }

  IconButton sendButton() {
    return IconButton(
      icon: Icon(
        Icons.send,
        color: Colors.white,
        size: 32,
      ),
      onPressed: sendMessage,
    );
  }
}
