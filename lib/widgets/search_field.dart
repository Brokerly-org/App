import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SearchField extends StatelessWidget {
  SearchField(
      {@required this.hint, @required this.iconData, @required this.onChanged});
  var _controller = TextEditingController();
  final String hint;
  final IconData iconData;
  final hintColor = Color.fromRGBO(148, 148, 148, 1);
  final ValueChanged<String> onChanged;
  String _fieldData = "";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        controller: _controller,
        onChanged: (text) {
          onChanged(text);
          _fieldData = text;
        },
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.white,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(
            iconData,
            size: 30.0,
            color: Color(0xFFB2B2B2),
          ),
          filled: true,
          fillColor: Theme.of(context).primaryColor,
          hintText: hint,
          hintStyle: TextStyle(
            color: Color(0xFFB2B2B2),
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

  String getFieldData() {
    _controller.clear();
    return _fieldData;
  }
}
