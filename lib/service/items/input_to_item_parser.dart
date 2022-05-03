import 'package:go_list/service/items/icon_mapping.dart';
import 'package:go_list/service/items/icon_mappings.dart';

import '../../model/item.dart';

class InputToItemParser {
  static Item parseInput(String input) {
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

  static String? parseAmount(String input) {
    input = input.replaceAll(RegExp("typ +[0-9]+", caseSensitive: false), "");
    Iterable<String?> amount = RegExp(
            "(^| +)([0-9]+((.|,)[0-9])? ?(liter|ml|l|g|kg|kilo|gramm|kilogramm|becher|glas|bund|scheiben|packung(en)?|gläser|glaeser|stueck(e)?|stück(e)?|dose(n)?|flasche(n)?|kiste(n)?|beutel(n)?|tuete(n)?|tüte(n)?|becher)?)( +|\$)",
            caseSensitive: false)
        .allMatches(input)
        .map((m) => m.group(2));
    if (amount.isNotEmpty) {
      return amount.first;
    }
  }

  static IconMapping findMappingForName(String name) {
    name = name.toLowerCase();
    IconMapping? mappingForName;
    int matchingWordLength = 0;

    for (IconMapping iconMapping in iconMappings) {
      String? matchingWordForIconName = iconMapping.longestMatchForName(name);
      if (matchingWordForIconName != null &&
          matchingWordForIconName.length > matchingWordLength) {
        matchingWordLength = matchingWordForIconName.length;
        mappingForName = iconMapping;
      }
    }

    return mappingForName ??
        IconMapping(
            assetFileName: defaultIconAsset,
            matchingNames: [],
            category: defaultCategory);
  }
}
