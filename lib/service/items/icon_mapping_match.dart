import 'package:go_list/service/items/icon_mapping.dart';

class IconMappingMatch implements Comparable<IconMappingMatch> {
  final IconMapping iconMapping;
  final int matchLength;
  final bool endsWithMatchingName;

  IconMappingMatch(
      {required this.iconMapping,
      required this.matchLength,
      required this.endsWithMatchingName});

  @override
  int compareTo(IconMappingMatch other) {
    if (endsWithMatchingName && !other.endsWithMatchingName) {
      return -1;
    }
    if (!endsWithMatchingName && other.endsWithMatchingName) {
      return 1;
    }
    return other.matchLength.compareTo(matchLength);
  }
}
