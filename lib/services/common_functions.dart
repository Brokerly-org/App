import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

FractionalOffset getExistButtonAlingment(BuildContext context) {
  if (intl.Bidi.isRtlLanguage(Localizations.localeOf(context).languageCode)) {
    return FractionalOffset(0.05, 0.0);
  }
  return FractionalOffset(0.95, 0.0);
}
