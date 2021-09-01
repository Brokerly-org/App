import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewBotInput extends StatelessWidget {
  NewBotInput(
      {@required this.focusNode, @required this.onAdd, @required this.onClose});

  final FocusNode focusNode;
  final Function onAdd;
  final Function onClose;
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: GestureDetector(onTap: () => onClose())),
        Container(
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(offset: Offset(0, 4), spreadRadius: 1, blurRadius: 5)
          ]),
          child: Column(
            children: [
              textField(context),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [pasteButton(context), addButton(context)],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  TextButton addButton(BuildContext context) {
    return TextButton(
        onPressed: () {
          focusNode.unfocus();
          onAdd(this.textController.value.text);
        },
        child: Text(AppLocalizations.of(context).add,
            style: TextStyle(
                color: Theme.of(context).buttonColor,
                fontWeight: FontWeight.bold,
                fontSize: 20)));
  }

  TextButton pasteButton(BuildContext context) {
    return TextButton(
        onPressed: () async {
          String text = (await Clipboard.getData(Clipboard.kTextPlain)).text;
          textController.text = text;
        },
        child: Text(AppLocalizations.of(context).past,
            style: TextStyle(
                color: Theme.of(context).buttonColor,
                fontWeight: FontWeight.bold,
                fontSize: 20)));
  }

  Container textField(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12.0),
      child: TextField(
        onSubmitted: (String value) {
          focusNode.unfocus();
          onAdd(value);
        },
        focusNode: focusNode,
        controller: textController,
        style: TextStyle(fontSize: 20, color: Colors.black),
        decoration: InputDecoration.collapsed(
          hintText: AppLocalizations.of(context).botSearchBoxHint,
          hintStyle:
              TextStyle(fontSize: 20, color: Colors.black.withOpacity(0.5)),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
