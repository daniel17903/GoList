import 'package:go_list/service/items/category.dart';

class IconMapping {
  final String assetFileName;
  late final List<String> matchingNames;
  final Category category;

  IconMapping(
      {required this.assetFileName,
      required List<String> matchingNames,
      required this.category}) {
    matchingNames.sort((a, b) => b.length - a.length);
    this.matchingNames = matchingNames;
  }

  String? longestMatchForName(String name) {
    return matchingNames
        .where((matchingWord) => name.toLowerCase().contains(matchingWord))
        .fold(
            null,
            (longestMatch, element) =>
                longestMatch == null || element.length > longestMatch.length
                    ? element
                    : longestMatch);
  }
}
