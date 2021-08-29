import 'package:brokerly/style.dart';
import 'package:brokerly/widgets/circle_button.dart';
import 'package:brokerly/widgets/notification_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationsSettings extends StatefulWidget {
  @override
  _NotificationsSettingsState createState() => _NotificationsSettingsState();
}

class _NotificationsSettingsState extends State<NotificationsSettings> {
  Divider _divider = Divider(
    color: Colors.white.withOpacity(0.3),
    thickness: 1,
  );

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: backgroundColor,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 10.0, right: 12.0),
                          child: CircleButton(
                            size: 36.0,
                            iconData: Icons.arrow_back_ios_outlined,
                            onTap: onBackClick,
                            iconSize: 20,
                            bgColor: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        Text(
                          AppLocalizations.of(context).notifications,
                          style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    _divider,
                    NotificationItem(
                        notification:
                            AppLocalizations.of(context).botsNotifications),
                    _divider,
                    NotificationItem(
                        notification:
                            AppLocalizations.of(context).updatesNotifications),
                    _divider,
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onBackClick() {
    Navigator.pop(context);
  }
}
