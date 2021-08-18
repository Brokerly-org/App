import '../services/cache.dart';

import 'message.dart';
import 'server.dart';

class Bot {
  String botname;
  String title;
  String description;
  DateTime lastOnline;
  Server server;
  List<Message> messages = [];
  int unreadMessages = 0;

  Bot(this.botname, this.title, this.description, this.server);

  String shareLink() {
    return "https://brokerly.tk/bot/${server.urlSchema == 'https' ? 'secure' : 'notsecure'}/${this.botname}?url=${this.server.url}";
  }

  void updateLastOnline(int timestamp) {
    this.lastOnline = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  }

  void addNewMessages(int newUnreadMessages) {
    this.unreadMessages += newUnreadMessages;
    Cache.saveBot(this);
  }

  void readMessages() {
    this.unreadMessages = 0;
    Cache.saveBot(this);
  }

  Bot.fromDict(Map<String, dynamic> dict) {
    this.botname = dict["botname"];
    this.title = dict["title"];
    this.description = dict["description"];
    this.lastOnline = DateTime.parse(dict["lastOnline"]);
    this.server = Server.fromDict(dict["server"]);
    this.messages = (dict["messages"] as List)
        .map((message) => Message.fromDict(message))
        .toList();
    this.unreadMessages = dict["unreadMessages"];
  }

  Map<String, dynamic> toDict() {
    Map<String, dynamic> dict = {};
    dict["botname"] = this.botname;
    dict["title"] = this.title;
    dict["description"] = this.description;
    dict["lastOnline"] = this.lastOnline.toIso8601String();
    dict["server"] = this.server.toDict();
    dict["messages"] =
        this.messages.map((message) => message.toDict()).toList();
    dict["unreadMessages"] = this.unreadMessages;
    return dict;
  }
}
