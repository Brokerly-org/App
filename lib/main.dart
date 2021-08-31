import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'app_loader.dart';
import 'providers/bots_provider.dart';
import 'screens/chat/chat.dart';
import 'style.dart';

Uri webUri;

void main() {
  if (kIsWeb) {
    webUri = Uri.base;
  }
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
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        AppLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', ''), // English, no country code
        Locale('he', ''), // Hebrew, no country code
      ],
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
              transitionDuration: Duration(milliseconds: 300));
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
