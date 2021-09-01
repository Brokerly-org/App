import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart' as intl;

import '../notifications_settings/notifications_settings.dart';
import '../../services/common_functions.dart';
import '../../widgets/circle_button.dart';
import 'components/settings_item.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Divider _divider = Divider(
    color: Colors.white.withOpacity(0.5),
    thickness: 1,
  );
  SizedBox _sectionSpacer = SizedBox(height: 30);

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    super.initState();
  }

  void onCloseClick() {
    Navigator.pop(context);
  }

  void changeLanguage() {}

  void goToNotificationsSettings() {
    print("Goto notifications");
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NotificationsSettings();
    }));
  }

  void goToTermsAndConditions() {
    // Navigator.push(context, MaterialPageRoute(builder: (context) {
    //   return TermsAndConditions();
    // }));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Theme.of(context).backgroundColor,
        child: Column(
          children: [
            exitButton(context),
            SingleChildScrollView(
              child: Column(
                children: [
                  title(context),
                  preferences(context),
                  contactUs(context),
                  support(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column support(BuildContext context) {
    return Column(
      children: [
        _sectionSpacer,
        getTitleWidget(AppLocalizations.of(context).support),
        _divider,
        SettingsItem(
            text: AppLocalizations.of(context).about, onClick: () => {}),
        _divider,
        SettingsItem(
            text: AppLocalizations.of(context).help, onClick: () => {}),
        _divider,
        SettingsItem(
            text: AppLocalizations.of(context).termsAndConditions,
            onClick: () => {}),
        _divider,
        SettingsItem(
            text: AppLocalizations.of(context).attributions, onClick: () => {}),
        _divider,
      ],
    );
  }

  Column contactUs(BuildContext context) {
    return Column(
      children: [
        _sectionSpacer,
        getTitleWidget(AppLocalizations.of(context).contactUs),
        _divider,
        SettingsItem(
            text: AppLocalizations.of(context).rateUs,
            onClick: () {},
            leading: Icon(
              Icons.star,
              color: Color(0xFFEEC544),
            )),
        _divider,
      ],
    );
  }

  Column preferences(BuildContext context) {
    return Column(
      children: [
        getTitleWidget(AppLocalizations.of(context).preferences),
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
      ],
    );
  }

  Column title(BuildContext context) {
    return Column(
      children: [
        screenTitle(context),
        _sectionSpacer,
      ],
    );
  }

  Text screenTitle(BuildContext context) {
    return Text(
      AppLocalizations.of(context).settingsTitle,
      style: TextStyle(
        fontSize: 25,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Align exitButton(BuildContext context) {
    return Align(
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
            bgColor: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
      ),
    );
  }

  Alignment getTitlesAlignment() {
    if (intl.Bidi.isRtlLanguage(Localizations.localeOf(context).languageCode)) {
      return Alignment.centerRight;
    }
    return Alignment.centerLeft;
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
}
