import '../model/item.dart';

Map<String, List<String>> _namesMatchingForIcon = {
  'apple': ["apfel", "äpfel", "aepfel"],
  'banana': ["banane"],
  'bottle': [
    "flasche",
    "wasser",
    "bier",
    "wein",
    "cola",
    "fanta",
    "eistee",
    "limo",
    "limonade",
    "sprite",
    "apfelschorle"
  ],
  'box': ["box", "salz", "mehl"],
  'bread': ["brot", "brötchen", "laugenstange"],
  'can': ["bohnen", "dose"],
  'carrot': ["karotte", "pastinake", "rübe", "ruebe"],
  'corn': ["samen", "körner"],
  'cup': ["becher", "yoghurt"],
  'glas': ["glas", "marmelade", "gläser"],
  'leek': ["lauch", "porree"],
  'peanut': ["nuss", "nüsse"],
  'round_fruit': ["tomate", "orange", "mandarine", "mango"],
  "dead_cow": ["fleisch", "hackfleisch", "wurst", "steak", "würste"],
  "cookie": ["keks", "kekse", "süssigkeiten"],
  "small_glas": ["salz", "pfeffer", "gewürz", "pulver"],
  "pepper": ["paprika"],
  "onion": ["zwiebel", "zwiebeln"],
  "pear": ["birne", "birnen"],
  "cabbage": ["kohl", "wirsing"],
  "eggplant": ["aubergine"],
  "salad": ["salat"],
  "chocolate": ["schokolade"],
  "ice": ["eis", "magnum"],
  "berries": [
    "beeren",
    "himbeeren",
    "johannisbeeren",
    "heidelbeeren",
    "blaubeeren"
  ],
  "block": ["tofu", "butter", "margarine", "fett"],
  "burger": ["burger"],
  "herbs": ["kräuter", "petersilie", "basilikum", "koriander", "dill"],
  "pizza_cake": ["pizza", "kuchen", "torte", "flammkuchen"],
  "yeast": ["hefe"],
  "package": [
    "backpulver",
    "natron",
    "vanillezucker",
    "trockenhefe",
    "agar-agar",
    "agar agar"
  ],
  "pasta": ["nudeln", "spaghetti", "pasta"],
  "lemon": ["zitrone"],
  "potatos": ["kartoffel"]
}.map((iconName, matchingProductNames) {
  matchingProductNames.sort((a, b) => b.length - a.length);
  return MapEntry(iconName, matchingProductNames);
});

class InputToItemParser {
  static Item parseInput(String input) {
    String? amount = parseAmount(input);
    String name = input;
    if (amount != null) {
      name = input.replaceFirst(amount, "");
    }

    return Item(
        iconName: findMatchingIconForName(input), name: name, amount: amount);
  }

  static String? parseAmount(String input) {
    Iterable<String?> amount = RegExp(
            "(^| +)([0-9]+((.|,)[0-9])? ?(liter|ml|l|g|kg|kilo|gramm|kilogramm|becher|glas|bund|scheiben|packung(en)?|gläser|glaeser|stueck(e)?|stück(e)?|dose(n)?|flasche(n)?|kiste(n)?|beutel(n)?|tuete(n)?|tüte(n)?|becher)?)( +|\$)",
            caseSensitive: false)
        .allMatches(input)
        .map((m) => m.group(2));
    if (amount.isNotEmpty) {
      return amount.first;
    }
  }

  static String findMatchingIconForName(String name) {
    name = name.toLowerCase();
    var matchingIconName = "box"; // TODO default icon
    var matchingWordLength = 0;
    for (var iconName in _namesMatchingForIcon.keys) {
      String? matchingWordForIconName = _namesMatchingForIcon[iconName]!
          .where((matchingWord) => name.contains(matchingWord))
          .fold(
              null,
              (longestMatch, element) =>
                  longestMatch == null || element.length > longestMatch.length
                      ? element
                      : longestMatch);

      if (matchingWordForIconName != null &&
          matchingWordForIconName.length > matchingWordLength) {
        matchingWordLength = matchingWordForIconName.length;
        matchingIconName = iconName;
      }
    }
    return matchingIconName;
  }

  static Map<String, String> sampleNamesWithIcon() {
    return _namesMatchingForIcon.map((key, value) => MapEntry(key, value[0]));
  }
}
