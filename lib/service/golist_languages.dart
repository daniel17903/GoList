import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:go_list/main.dart';
import 'package:go_list/model/locale_state.dart';
import 'package:go_list/service/storage/local_settings_storage.dart';
import 'package:provider/provider.dart';

class GoListLanguages {
  static const defaultLanguage = "en";
  static const supportedLanguages = {
    "de": "Deutsch",
    "en": "English",
    "es": "Español"
  };
  static List<String> supportedLanguageCodes = supportedLanguages.keys.toList();

  static String getLanguageCode() {
    String? previouslySetLanguage =
        LocalSettingsStorage().loadSelectedLanguage();
    String platformLanguage = Platform.localeName.split("_")[0];
    if (supportedLanguageCodes.contains(platformLanguage)) {
      return previouslySetLanguage ?? platformLanguage;
    } else {
      return previouslySetLanguage ?? defaultLanguage;
    }
  }

  static void setLanguage(BuildContext context, String language) {
    Provider.of<LocaleState>(context, listen: false)
        .setLocale(Locale(language));
  }

  static String getLanguageName(String language) {
    return supportedLanguages[language]!;
  }
}
