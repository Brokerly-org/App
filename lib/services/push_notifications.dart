import 'package:brokerly/models/bot.dart';
import 'package:brokerly/services/cache.dart';
import 'package:brokerly/services/client.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const checkUpdatesTask = "check_updates_task";
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
final MacOSInitializationSettings initializationSettingsMacOS =
    MacOSInitializationSettings();
final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
    macOS: initializationSettingsMacOS);

Future<void> showNotification(int messagesCount) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'BrokerlyNotificationsChannel1',
    'BrokerlyNotifications',
    'Notifications for brokerly',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'New notification from brokerly',
    enableLights: true,
    enableVibration: true,
    visibility: NotificationVisibility.public,
    channelShowBadge: true,
  );
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  return await flutterLocalNotificationsPlugin.show(125, 'New Messages',
      'you have $messagesCount new messages...', platformChannelSpecifics,
      payload: '$messagesCount');
}

Future<void> checkForUpdates() async {
  print("Run backround");
  Client client = Client();
  List<String> botKeys = await Cache.getBotNameList();
  List<String> servers = [];

  List<Future<int>> tasks = [];
  for (String botKey in botKeys) {
    Bot bot = await Cache.loadBot(botKey);
    if (servers.contains(bot.server.url)) {
      continue;
    }
    tasks.add(client
        .hasUpdates(bot.server)
        .timeout(Duration(seconds: 5), onTimeout: () => 0));
    servers.add(bot.server.url);
  }
  List<int> serverUpdates = await Future.wait<int>(tasks)
      .timeout(Duration(seconds: 9), onTimeout: () => [0]);
  int messagesCount = serverUpdates.reduce((value, element) => value + element);
  if (messagesCount > 0) {
    await showNotification(messagesCount);
  }
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      switch (task) {
        case checkUpdatesTask:
          Workmanager().registerOneOffTask(
            "task ${DateTime.now().millisecondsSinceEpoch}",
            checkUpdatesTask,
            initialDelay: Duration(minutes: 1),
            constraints: Constraints(networkType: NetworkType.connected),
          );
          await checkForUpdates().timeout(Duration(seconds: 10));
          break;
        case Workmanager.iOSBackgroundTask:
          print("The iOS background fetch was triggered");
          print(
              "You can access other plugins in the background, for example Directory.getTemporaryDirectory()");
          break;
      }
    } catch (ex) {
      print(ex);
    }
    return Future.value(true);
  });
}

void initWorkManager() {
  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );
}

void registerPullUpdatesTask() {
  //Workmanager().cancelAll();
  Workmanager().registerPeriodicTask(
    "5",
    checkUpdatesTask,
    frequency: Duration(minutes: 15),
    initialDelay: Duration(seconds: 10),
    constraints: Constraints(networkType: NetworkType.connected),
    existingWorkPolicy: ExistingWorkPolicy.replace,
  );
}

Future<bool> onDidReceiveLocalNotification(
    int one, String tow, String three, String fore) async {
  print(one);
  print(tow);
  print(three);
  print(fore);
  return true;
}

void setupFlutterNotificationPlugin() async {
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String value) {
    print("selected notification value: $value");
    return;
  });
}

void setupPushNotificationService() async {
  initWorkManager();
  registerPullUpdatesTask();
  setupFlutterNotificationPlugin();
}
