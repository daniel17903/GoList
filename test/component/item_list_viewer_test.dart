import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_list/model/item.dart';
import 'package:go_list/model/recently_used_item_collection.dart';
import 'package:go_list/service/items/category.dart';
import 'package:go_list/view/shopping_list/add_item_dialog/add_item_list_viewer.dart';
import 'package:go_list/view/shopping_list/item_list_viewer.dart';

import '../builders/item_builder.dart';

Widget buildTestableWidget(Widget widget) {
  return MediaQuery(
      data: const MediaQueryData(),
      child: MaterialApp(
          home: Material(
        child: widget,
      )));
}

void main() {
  testWidgets('MyWidget has a title and message', (tester) async {
    RecentlyUsedItemCollection items = RecentlyUsedItemCollection([
      ItemBuilder()
          .withName("apple")
          .withCategory(Category.fruitsVegetables)
          .withIconName("apple")
          .build(),
      ItemBuilder()
          .withName("banana")
          .withCategory(Category.fruitsVegetables)
          .withIconName("banana")
          .build(),
      ItemBuilder()
          .withName("beeren")
          .withCategory(Category.fruitsVegetables)
          .withIconName("berries")
          .build(),
      ItemBuilder()
          .withName("water")
          .withCategory(Category.beverages)
          .withIconName("bottle")
          .build()
    ]);

    Function(Item) onItemTapped = (item) => {};

    await tester.pumpWidget(buildTestableWidget(AddItemListViewer(
      recentlyUsedItemsSorted: items,
      onItemTapped: onItemTapped,
      parentWidth: 500,
    )));
    await tester.pump();
    await tester.pumpAndSettle(const Duration(seconds: 1));
    await expectLater(
        find.byType(ItemListViewer), matchesGoldenFile('item_list_viewer.png'));
  });
}
