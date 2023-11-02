import 'package:flutter/material.dart';
import 'package:go_list/service/golist_languages.dart';
import 'package:go_list/service/items/input_to_item_parser.dart';
import 'package:go_list/service/storage/local_settings_storage.dart';

class LocaleState extends ChangeNotifier {
  late Locale locale;

  LocaleState() {
    locale = Locale(LocalSettingsStorage().loadSelectedLanguage() ??
        GoListLanguages.getLanguageCode());
  }

  setLocale(Locale locale) {
    this.locale = locale;
    LocalSettingsStorage().saveSelectedLanguage(locale.languageCode);
    InputToItemParser().init();
    notifyListeners();
  }
}
