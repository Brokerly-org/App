import "dart:ui" as ui;

import 'package:brokerly/screens/notifications_settings.dart';
import 'package:brokerly/services/common_functions.dart';
import 'package:brokerly/style.dart';
import 'package:brokerly/widgets/circle_button.dart';
import 'package:brokerly/widgets/settings_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart' as intl;

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Divider _divider = Divider(
    color: Colors.white.withOpacity(0.5),
    thickness: 1,
  );

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: backgroundColor,
        child: Column(
          children: [
            Align(
              alignment: getExistButtonAlingment(context),
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: GestureDetector(
                  onTap: onCloseClick,
                  child: CircleButton(
                    size: 36.0,
                    iconData: Icons.close_sharp,
                    onTap: onCloseClick,
                    iconSize: 23,
                    bgColor: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      AppLocalizations.of(context).settingsTitle,
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    getTitleWidget(AppLocalizations.of(context).preferences),
                    // _divider,
                    // SettingsItem(text: AppLocalizations.of(context).lo, onClick: () => {}),
                    _divider,
                    SettingsItem(
                        text: AppLocalizations.of(context).notifications,
                        onClick: goToNotificationsSettings),
                    _divider,
                    SettingsItem(
                      text: AppLocalizations.of(context).language,
                      onClick: changeLanguage,
                    ),
                    _divider,
                    SizedBox(
                      height: 30,
                    ),
                    getTitleWidget(AppLocalizations.of(context).contactUs),
                    _divider,
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: <InlineSpan>[
                                WidgetSpan(
                                  alignment: ui.PlaceholderAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 5.0, left: 5),
                                    child: Icon(Icons.star,
                                        color: Color(0xFFEEC544), size: 26),
                                  ),
                                ),
                                TextSpan(
                                  text: AppLocalizations.of(context).rateUs,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                    _divider,
                    SizedBox(
                      height: 30,
                    ),
                    getTitleWidget(AppLocalizations.of(context).support),
                    _divider,
                    SettingsItem(
                        text: AppLocalizations.of(context).about,
                        onClick: () => {}),
                    _divider,
                    SettingsItem(
                        text: AppLocalizations.of(context).help,
                        onClick: () => {}),
                    _divider,
                    SettingsItem(
                        text: AppLocalizations.of(context).termsAndConditions,
                        onClick: () => {}),
                    _divider,
                    SettingsItem(
                        text: AppLocalizations.of(context).attributions,
                        onClick: () => {}),
                    _divider,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void goToNotificationsSettings() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NotificationsSettings();
    }));
  }

  void goToTermsAndConditions() {
    // Navigator.push(context, MaterialPageRoute(builder: (context) {
    //   return TermsAndConditions();
    // }));
  }

  Alignment getTitlesAlignment() {
    if (intl.Bidi.isRtlLanguage(Localizations.localeOf(context).languageCode)) {
      return Alignment.centerRight;
    }
    return Alignment.centerLeft;
  }

  void onCloseClick() {
    Navigator.pop(context);
  }

  Widget getTitleWidget(String title) {
    return Align(
      alignment: getTitlesAlignment(),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 3, left: 10, right: 10),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void changeLanguage() {}
}
