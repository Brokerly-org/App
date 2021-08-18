class Message {
  String data;
  String sender;
  DateTime sentAt;
  // "bot" or "user"

  Message(this.data, this.sender, this.sentAt);

  Message.fromDict(Map<String, dynamic> dict) {
    this.data = dict["data"];
    this.sender = dict["sender"];
    this.sentAt = DateTime.parse(dict["sentAt"]);
  }

  Map<String, dynamic> toDict() {
    Map<String, dynamic> dict = {};
    dict["data"] = this.data;
    dict["sender"] = this.sender;
    dict["sentAt"] = this.sentAt.toIso8601String();
    return dict;
  }
}
