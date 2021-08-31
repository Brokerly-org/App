import 'package:brokerly/ui_manager.dart';

import 'message.dart';
import 'server.dart';

class Bot {
  String botname;
  String title;
  String description;
  bool onlineStatus = false;
  Server server;
  List<Message> messages = [];
  int unreadMessages = 0;
  bool blocked = false;

  Bot(this.botname, this.title, this.description, this.server);

  String shareLink() {
    return "https://brokerly.tk/bot/${server.urlSchema == 'https' ? 'secure' : 'notsecure'}/${this.botname}?url=${this.server.url}";
  }

  String get id {
    return this.server.url + "!" + this.botname;
  }

  void updateOnlineStatus(bool status) {
    this.onlineStatus = status;
  }

  void addNewMessages(int newUnreadMessages) {
    this.unreadMessages += newUnreadMessages;
    UIManager.saveBot(this);
  }

  void readMessages() {
    this.unreadMessages = 0;
    UIManager.saveBot(this);
  }

  void clear() {
    this.messages.clear();
    this.unreadMessages = 0;
    UIManager.saveBot(this);
  }

  void block() {
    this.blocked = true;
  }

  void unblock() {
    this.blocked = false;
  }

  Bot.fromDict(Map<String, dynamic> dict) {
    this.botname = dict["botname"];
    this.title = dict["title"];
    this.description = dict["description"];
    this.onlineStatus = dict["online_status"] ?? false;
    this.server = Server.fromDict(dict["server"]);
    this.messages = (dict["messages"] as List)
        .map((message) => Message.fromDict(message))
        .toList();
    this.unreadMessages = dict["unreadMessages"];
    this.blocked = dict["blocked"] ?? false;
  }

  Map<String, dynamic> toDict() {
    Map<String, dynamic> dict = {};
    dict["botname"] = this.botname;
    dict["title"] = this.title;
    dict["description"] = this.description;
    dict["server"] = this.server.toDict();
    dict["messages"] =
        this.messages.map((message) => message.toDict()).toList();
    dict["unreadMessages"] = this.unreadMessages;
    dict["blocked"] = this.blocked;
    return dict;
  }
}
