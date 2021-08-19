class Message {
  String chatId;
  String data;
  String sender; // "bot" or "user"
  DateTime sentAt;
  bool readStatus;
  int index;

  Message(this.data, this.sender, this.sentAt);

  Message.fromDict(Map<String, dynamic> dict) {
    this.chatId = dict["chat_id"];
    this.readStatus = dict["read_status"];
    this.data = dict["content"];
    this.sender = dict["sender"];
    this.index = dict["index"];
    this.sentAt = DateTime.fromMillisecondsSinceEpoch(dict["created_at"]);
  }

  Map<String, dynamic> toDict() {
    Map<String, dynamic> dict = {};
    dict["chat_id"] = this.chatId;
    dict["read_status"] = this.readStatus;
    dict["content"] = this.data;
    dict["sender"] = this.sender;
    dict["index"] = this.index;
    dict["created_at"] = this.sentAt.millisecondsSinceEpoch;
    return dict;
  }
}
