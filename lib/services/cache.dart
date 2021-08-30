import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/bot.dart';

class Cache {
  static void clear() async {
    SharedPreferences disk = await SharedPreferences.getInstance();
    disk.clear();
  }

  static Future<bool> addBotNameToList(String botKey) async {
    SharedPreferences disk = await SharedPreferences.getInstance();
    List<String> botNames = disk.getStringList("botlist") ?? [];
    if (!botNames.contains(botKey)) {
      botNames.add(botKey);
      return await disk.setStringList("botlist", botNames);
    }
    return true;
  }

  static Future<List<String>> getBotNameList() async {
    SharedPreferences disk = await SharedPreferences.getInstance();
    return disk.getStringList("botlist");
  }

  static Future<bool> saveBot(Bot bot) async {
    SharedPreferences disk = await SharedPreferences.getInstance();
    String botJson = json.encode(bot.toDict());
    String botKey = bot.server.url + ':' + bot.botname;
    bool saved = await disk.setString(botKey, botJson);
    if (saved) {
      return await addBotNameToList(botKey);
    }
    return saved;
  }

  static Future<Bot> loadBot(String serverUrlAndBotName) async {
    SharedPreferences disk = await SharedPreferences.getInstance();
    String botJson = disk.getString(serverUrlAndBotName);
    if (botJson == null) {
      return null;
    }
    Map<String, dynamic> botDict = json.decode(botJson);
    return Bot.fromDict(botDict);
  }

  static Future<bool> removeBot(Bot bot) async {
    SharedPreferences disk = await SharedPreferences.getInstance();
    List<String> botNames = disk.getStringList("botlist") ?? [];
    String botKey = bot.server.url + ':' + bot.botname;
    if (botNames.contains(botKey)) {
      botNames.remove(botKey);
      return await disk.setStringList("botlist", botNames);
    }
    return false;
  }

  static Future<bool> saveRootSecret(String secret) async {
    SharedPreferences disk = await SharedPreferences.getInstance();
    return await disk.setString("rootSecret", secret);
  }

  static Future<String> loadRootSecret() async {
    SharedPreferences disk = await SharedPreferences.getInstance();
    return disk.getString("rootSecret");
  }
}
