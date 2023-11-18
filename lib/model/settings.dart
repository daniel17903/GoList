import 'dart:core';
import 'dart:ui';

import 'package:go_list/service/golist_languages.dart';
import 'package:uuid/uuid.dart';

class Settings {
  late String selectedShoppingListId;
  late List<String> shoppingListOrder;
  late String language;
  late String deviceId;

  Settings(
      {required this.selectedShoppingListId,
      required this.shoppingListOrder,
      String? language,
      String? deviceId})
      : deviceId = deviceId ?? const Uuid().v4(),
        language = language ?? GoListLanguages.platformLanguageOrDefault();

  Settings.fromJson(dynamic json)
      : selectedShoppingListId = json["selectedShoppingListId"],
        shoppingListOrder = List<String>.from(json["shoppingListOrder"]),
        language = json["language"],
        deviceId = json["deviceId"];

  Map<String, dynamic> toJson() => {
        'selectedShoppingListId': selectedShoppingListId,
        'shoppingListOrder': shoppingListOrder,
        'language': language,
        'deviceId': deviceId
      };

  Locale get locale => Locale(language);
}
