import 'dart:convert';
import 'dart:core';
import 'dart:ui';

import 'package:uuid/uuid.dart';

class Settings {
  late String selectedShoppingListId;
  late List<String> shoppingListOrder;
  late String language;
  late String deviceId;

  Settings(
      {required this.selectedShoppingListId,
      required this.shoppingListOrder,
      this.language = "en",
      String? deviceId})
      : deviceId = deviceId ?? const Uuid().v4();

  Settings.fromJson(dynamic json)
      : selectedShoppingListId = json["selectedShoppingListId"],
        shoppingListOrder =
            List<String>.from(jsonDecode(json["shoppingListOrder"])),
        language = json["language"],
        deviceId = json["deviceId"];

  Map<String, dynamic> toJson() => {
        'selectedShoppingListId': selectedShoppingListId,
        'shoppingListOrder': jsonEncode(shoppingListOrder),
        'language': language,
        'deviceId': deviceId
      };

  Locale get locale => Locale(language);
}
