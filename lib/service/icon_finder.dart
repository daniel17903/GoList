

class IconFinder {
  static final _namesMatchingForIcon = {
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
      "limonade"
    ],
    'box': ["box", "salz", "mehl"],
    'bread': ["brot", "brötchen", "laugenstange"],
    'can': ["bohnen", "dose"],
    'carrot': ["karotte"],
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
    "chocolate": ["schokolade"]
  };

  static String findMatchingIconForName(String name) {
    // TODO: calculate only once in initialize
    // sort, so that longest values are compared first
    _namesMatchingForIcon.map((iconName, matchingProductNames) => MapEntry(
        iconName, matchingProductNames.sort((a, b) => b.length - a.length)));

    name = name.toLowerCase();
    var matchingIconName = "box"; // TODO default icon
    var matchingWordLength = 0;
    for (var iconName in _namesMatchingForIcon.keys) {
      String? matchingWordForIconName = _namesMatchingForIcon[iconName]!
          .where((matchingWord) => name.contains(matchingWord))
          .fold(
              null,
              (longestMatch, element) => longestMatch == null ||
                      element.length > (longestMatch as String).length
                  ? element
                  : longestMatch)?[0];

      if (matchingWordForIconName != null &&
          matchingWordForIconName.length > matchingWordLength) {
        matchingWordLength = matchingWordForIconName.length;
        matchingIconName = iconName;
      }
    }
    return matchingIconName;

    /**
        var closestIconName = "box";
        var smallestDistance = 100;

        for (var iconName in _namesMatchingForIcon.keys) {
        int distanceForIcon = await Future.wait(_namesMatchingForIcon[iconName]!
        .map((matchingName) => levenshteinDistance(name, matchingName)))
        .then((levenshteinDistances) => levenshteinDistances.reduce(min));
        if (distanceForIcon < smallestDistance) {
        smallestDistance = distanceForIcon;
        closestIconName = iconName;
        }
        }

        return closestIconName;*/
  }

  static Map<String, String> sampleNamesWithIcon() {
    return _namesMatchingForIcon.map((key, value) => MapEntry(key, value[0]));
  }
}
