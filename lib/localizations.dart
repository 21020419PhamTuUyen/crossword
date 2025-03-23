import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';
import 'utils/shared_preference.dart';

Map<String, dynamic>? language;

class Language {
  final Locale _locale;

  Language(this._locale);

  static Language? of(BuildContext context) {
    return Localizations.of<Language>(context, Language);
  }

  /// func get value of json with nest string key
  String getText(String key) {
    try {
      List<String> listKey = key.split(".");
      if (listKey.length == 1) {
        return language?[key] ?? key;
      }
      dynamic valueNest;
      for (int i = 0; i < listKey.length - 1; i++) {
        valueNest = language?[listKey[i]];
      }
      String keyResult = listKey[listKey.length - 1];
      return valueNest[keyResult] ?? key;
    } catch (e) {
      return key;
    }
  }

  String get currentLanguage => _locale.languageCode;
}

class LanguageDelegate extends LocalizationsDelegate<Language> {
  const LanguageDelegate();

  @override
  bool isSupported(Locale locale) => [Constants.VI, Constants.EN].contains(locale.languageCode);

  @override
  Future<Language> load(Locale locale) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(SPrefCache.PREF_KEY_LANGUAGE, locale.languageCode);
    String string = await rootBundle.loadString("assets/strings/${locale.languageCode}.json");
    language = json.decode(string);
    return SynchronousFuture<Language>(Language(locale));
  }

  @override
  bool shouldReload(LanguageDelegate old) => false;
}
