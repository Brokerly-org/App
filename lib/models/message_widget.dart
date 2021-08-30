class MessageWidget {
  String type;
  Map<String, dynamic> args;

  MessageWidget.fromDict(Map<String, dynamic> dict) {
    this.type = dict["type"];
    this.args = dict["args"];
  }

  Map<String, dynamic> toDict() {
    Map<String, dynamic> dict = {};
    dict["type"] = this.type;
    dict["args"] = this.args;
    return dict;
  }
}
