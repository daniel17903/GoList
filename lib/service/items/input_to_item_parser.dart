import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:go_list/model/item.dart';
import 'package:go_list/service/items/icon_mapping.dart';
import 'package:go_list/style/golist_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'category.dart';
import 'icon_mapping_match.dart';

class InputToItemParser {
  late final List<IconMapping> iconMappings;

  static const String defaultLocale = "de";

  static final InputToItemParser _instance = InputToItemParser._internal();

  factory InputToItemParser() => _instance;

  InputToItemParser._internal();

  String getLocale() {
    String platformLocale = Platform.localeName.split("_")[0];
    List<String> supportedLocales = AppLocalizations.supportedLocales
        .map<String>((e) => e.languageCode)
        .toList();
    if (supportedLocales.contains(platformLocale)) {
      return platformLocale;
    }
    return defaultLocale;
  }

  @visibleForTesting
  Future<List<IconMapping>> iconMappingFromJsonFile(String filename) {
    return rootBundle.loadString(filename).then((value) {
      final jsonArray = json.decode(value);
      return jsonArray
          .map<IconMapping>((x) => IconMapping.fromJson(x))
          .toList();
    });
  }

  Future<void> init([String? locale]) async {
    iconMappings = await iconMappingFromJsonFile(
        "assets/mappings_" + (locale ?? getLocale()) + ".json");
  }

  Item parseInput(String input) {
    input = input.trim();
    String? amount = parseAmount(input);
    String name = input;
    if (amount != null) {
      name = input.replaceFirst(amount, "");
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
            assetFileName: GoListIcons.defaultAsset,
            matchingNames: [],
            category: defaultCategory);
  }
}
