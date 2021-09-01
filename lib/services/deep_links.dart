import 'dart:async';
import 'package:brokerly/main.dart';
import 'package:uni_links/uni_links.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter/foundation.dart' show kIsWeb;

String extractBotLink(Uri uri) {
  bool secure =
      uri.pathSegments.elementAt(uri.pathSegments.length - 2) == "secure";
  String schema = secure ? "https" : "http";
  String url = uri.queryParameters["url"];
  Uri newUri = Uri.parse('$schema://$url');

  // List<String> port = url.split(':');
  // print('port: $port');
  String botname = uri.pathSegments.last;
  String botLink = schema +
      "://" +
      newUri.host +
      ':' +
      newUri.port.toString() +
      "?botname=" +
      botname;
  return botLink;
}

bool isValidUri(Uri link) {
  return link.queryParameters.containsKey("url");
}

void handleUri(
    Uri uri, Function(String) onNewBot, Function(String) onInvalidLink) {
  if (isValidUri(uri)) {
    print('valid uri $uri');
    String botLink = extractBotLink(uri);
    onNewBot(botLink);
  } else {
    onInvalidLink(uri.queryParameters.toString());
  }
}

Future<void> initUniLinks(
    Function(String) onNewBot, Function(String) onInvalidLink) async {
  if (kIsWeb) {
    String url = webUri.queryParameters["url"];
    String botname = webUri.queryParameters["botname"];
    bool secure = !(webUri.queryParameters['secure'] == "false");
    print(url + " " + botname + " " + secure.toString());
    Uri botUri = Uri.parse(
        "https://brokerly.tk/bot/${secure ? 'secure' : 'unsecure'}/$botname?url=$url");
    handleUri(botUri, onNewBot, onInvalidLink);
    return;
  }
  linkStream.listen((String link) {
    Uri uri = Uri.parse(link);
    handleUri(uri, onNewBot, onInvalidLink);
  }, onError: (err) {
    // Handle exception by warning the user their action did not succeed
  });

  try {
    String initialLink = await getInitialLink();
    if (initialLink == null) {
      return;
    }
    final initialUri = Uri.parse(initialLink);

    if (initialUri == null) {
      return;
    }
    handleUri(initialUri, onNewBot, onInvalidLink);
  } on PlatformException {
    // Handle exception by warning the user their action did not succeed
    // return?
  }
}
