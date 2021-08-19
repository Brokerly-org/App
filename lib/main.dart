import 'package:brokerly/screens/chat.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_loader.dart';
import 'providers/bots_provider.dart';
import 'style.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => BotsProvider()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Brokerly',
      theme: ThemeData(
        primarySwatch: primery,
        backgroundColor: backgroundColor,
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: textColor,
              displayColor: textColor,
            ),
        buttonColor: buttonColor,
      ),
      onGenerateRoute: (settings) {
        print(settings.name);
        if (settings.name == "/chat") {
          return PageRouteBuilder(
              settings: settings,
              pageBuilder: (_, __, ___) => ChatScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.easeIn;
                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));

                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
              transitionDuration: Duration(milliseconds: 100));
        }
        // Unknown route
        return null;
      },
      routes: {
        '/': (_) => AppLoader(),
      },
      initialRoute: "/",
    );
  }
}
