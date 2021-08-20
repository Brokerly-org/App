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
      AndroidNotificationDetails('BrokerlyNotificationsChannel1',
          'BrokerlyNotifications', 'Notifications for brokerly',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'New notification from brokerly');
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(0, 'New Messages',
      'you have $messagesCount new messages...', platformChannelSpecifics,
      payload: 'item x');
}

void checkForUpdates() async {
  Client client = Client();
  List<String> botKeys = await Cache.getBotNameList();
  int messagesCount = 0;
  for (String botKey in botKeys) {
    Bot bot = await Cache.loadBot(botKey);
    messagesCount += await client
        .hasUpdates(bot.server)
        .timeout(Duration(seconds: 1), onTimeout: () => 0);
  }
  if (true) {
    //messagesCount > 0) {
    showNotification(messagesCount);
  }
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case checkUpdatesTask:
        print("Some simple task");
        checkForUpdates();
        break;
      case Workmanager.iOSBackgroundTask:
        print("The iOS background fetch was triggered");
        print(
            "You can access other plugins in the background, for example Directory.getTemporaryDirectory()");
        break;
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
  Workmanager().registerPeriodicTask(
    "5",
    checkUpdatesTask,
    frequency: Duration(minutes: 15),
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
