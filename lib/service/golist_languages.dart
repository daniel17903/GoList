import 'dart:io';

class GoListLanguages {
  static const defaultLanguage = "en";
  static const supportedLanguages = {
    "de": "Deutsch",
    "en": "English",
    "es": "Español"
  };
  static List<String> supportedLanguageCodes = supportedLanguages.keys.toList();

  static String platformLanguageOrDefault() {
    String platformLanguage = Platform.localeName.split("_")[0];
    if (supportedLanguageCodes.contains(platformLanguage)) {
      return platformLanguage;
    } else {
      return defaultLanguage;
    }
  }

  static String getLanguageName(String language) {
    return supportedLanguages[language]!;
  }
}
