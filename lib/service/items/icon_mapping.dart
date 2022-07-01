import 'dart:ui';

import 'package:go_list/service/items/category.dart';
import 'package:go_list/service/items/icon_mapping_match.dart';

class IconMapping {
  final String assetFileName;
  final Map<Locale, List<String>> matchingNames;
  final Category category;

  IconMapping(
      {required this.assetFileName,
      required this.matchingNames,
      required this.category});

  List<IconMappingMatch> findMatches(String name) {
    List<IconMappingMatch> matches = [];

    matchingNames.values
        .expand((i) => i) // flatten list
        .where((matchingWord) => name.toLowerCase().contains(matchingWord))
        .forEach((matchingWord) {
      matches.add(IconMappingMatch(
          matchLength: matchingWord.length,
          endsWithMatchingName: name.toLowerCase().endsWith(matchingWord),
          iconMapping: this));
    });

    return matches;
  }
}
