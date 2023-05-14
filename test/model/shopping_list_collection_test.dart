import 'package:flutter_test/flutter_test.dart';
import 'package:go_list/model/golist_collection.dart';
import 'package:go_list/model/item.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/model/shopping_list_collection.dart';

import '../builders/item_builder.dart';
import '../builders/shopping_list_builder.dart';

void main() {
  group("merge shopping list collections", () {
    test("Merges two collections of shopping lists", () async {
      Item item1 = ItemBuilder().build();
      Item item2 = ItemBuilder().build();

      ShoppingList list1 = ShoppingListBuilder().withItems([item1]).build();
      ShoppingList list2 = ShoppingListBuilder().withItems([item2]).build();

      ShoppingListCollection goListCollection1 =
          ShoppingListCollection(entries: [list1]);
      ShoppingListCollection goListCollection2 =
          ShoppingListCollection(entries: [list2]);

      GoListCollection<ShoppingList> mergedGoListCollection1 =
          goListCollection1.merge(goListCollection2);
      GoListCollection<ShoppingList> mergedGoListCollection2 =
          goListCollection2.merge(goListCollection1);

      expect(mergedGoListCollection1.entries, unorderedEquals([list1, list2]));
      expect(mergedGoListCollection2.entries, unorderedEquals([list1, list2]));
    });
  });
}
