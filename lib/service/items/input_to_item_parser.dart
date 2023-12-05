import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:go_list/model/item.dart';
import 'package:go_list/service/items/icon_mapping.dart';
import 'package:go_list/style/golist_icons.dart';

import 'category.dart';
import 'icon_mapping_match.dart';

class InputToItemParser {
  late List<IconMapping> iconMappings;

  static final InputToItemParser _instance = InputToItemParser._internal();

  factory InputToItemParser() => _instance;

  InputToItemParser._internal();

  @visibleForTesting
  Future<List<IconMapping>> iconMappingFromJsonFile(String filename) {
    return rootBundle.loadString(filename).then((value) {
      final jsonArray = json.decode(value);
      return jsonArray
          .map<IconMapping>((x) => IconMapping.fromJson(x))
          .toList();
    });
  }

  Future<void> init(String languageCode) async {
    iconMappings =
        await iconMappingFromJsonFile("assets/mappings_$languageCode.json");
  }

  Item parseInput(String input) {
    input = input.trim();
    String? amount = parseAmount(input);
    String name = input;
    if (amount != null) {
      name = input.replaceFirst(amount, "").trim();
    }

    IconMapping mappingForInput = findMappingForName(input);

    return Item(
        iconName: mappingForInput.assetFileName,
        name: name,
        amount: amount,
        category: mappingForInput.category);
  }

  String? parseAmount(String input) {
    input = input.replaceAll(RegExp("typ +[0-9]+", caseSensitive: false), "");
    Iterable<String?> amount = RegExp(
            "(^| +)([0-9]+((.|,)[0-9])? ?(liter|ml|l|g|kg|kilo|gramm|kilogramm|becher|glas|bund|scheiben|packung(en)?|gläser|glaeser|stueck(e)?|stück(e)?|dose(n)?|flasche(n)?|kiste(n)?|beutel(n)?|tuete(n)?|tüte(n)?|becher)?)( +|\$)",
            caseSensitive: false)
        .allMatches(input)
        .map((m) => m.group(2));
    if (amount.isNotEmpty) {
      return amount.first;
    }
    return null;
  }

  IconMapping findMappingForName(String name) {
    List<IconMappingMatch> iconMappingMatches =
        iconMappings.map((e) => e.findMatches(name)).expand((e) => e).toList();

    iconMappingMatches.sort();

    return iconMappingMatches.firstOrNull?.iconMapping ??
        IconMapping(
            assetFileName: GoListIcons.defaultIconAssetName,
            matchingNames: [],
            category: defaultCategory);
  }
}
