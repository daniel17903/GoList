import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/view/shopping_list/shopping_list_item/shopping_list_item.dart';
import 'package:go_list/view/shopping_list_page.dart';

import '../../builders/item_builder.dart';
import '../../builders/shopping_list_builder.dart';
import '../../snapshot/fixtures.dart';

void main() {
  late ShoppingList shoppingList;

  setUp(() async {
    shoppingList = ShoppingListBuilder().withItems([
      ItemBuilder().withName("item a").withAmount("1").build(),
      ItemBuilder().withName("item b").withAmount("2").build(),
      ItemBuilder().withName("item c").withAmount("3").build(),
      ItemBuilder().withName("item d").withAmount("4").build(),
      ItemBuilder().withName("item e").withAmount("5").build(),
    ]).build();
  });

  testWidgets('Renders names and amounts of all items', (tester) async {
    await pumpWithSelectedShoppingList(
        tester, ShoppingListPage(), shoppingList);

    expect(find.byType(ShoppingListItem),
        findsNWidgets(shoppingList.items.length()));
    shoppingList.itemsAsList().forEach((item) {
      var widgetFinder = find.byKey(Key(item.id));
      expect(find.descendant(of: widgetFinder, matching: find.text(item.name)),
          findsOneWidget);
      expect(
          find.descendant(of: widgetFinder, matching: find.text(item.amount!)),
          findsOneWidget);
    });
  });

  testWidgets('Deletes an item', (tester) async {
    await pumpWithSelectedShoppingList(tester, ShoppingListPage(), shoppingList,
        withImages: false);

    var originalNumberOfItems = shoppingList.items.length();
    var itemToDelete = shoppingList.items.get(2);

    await tester.tap(find.byKey(Key(itemToDelete.id)));
    await tester.pumpAndSettle();

    expect(find.byType(ShoppingListItem),
        findsNWidgets(originalNumberOfItems - 1));
    expect(find.byKey(Key(itemToDelete.id)), findsNothing);
  });

}
