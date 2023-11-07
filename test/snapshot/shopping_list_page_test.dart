import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_list/model/collections/shopping_list_collection.dart';
import 'package:go_list/model/item.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/view/shopping_list_page.dart';

import '../builders/item_builder.dart';
import '../builders/shopping_list_builder.dart';
import '../fixtures.dart';

void main() async {
  late ShoppingList shoppingList;
  late Item itemToEdit;

  setUp(() async {
    itemToEdit = ItemBuilder().withName("item b").withAmount("2").build();
    shoppingList = ShoppingListBuilder().withItems([
      ItemBuilder().withName("item a").withAmount("1").build(),
      itemToEdit,
      ItemBuilder().withName("item c").withAmount("3").build(),
      ItemBuilder().withName("item d").withAmount("4").build(),
      ItemBuilder().withName("item e").withAmount("5").build(),
    ]).build();
  });

  testWidgets('Renders a ShoppingListPage with items', (tester) async {
    await setViewSize(tester);

    await pumpWithGlobalAppState(tester, const ShoppingListPage(),
        ShoppingListCollection([shoppingList]), shoppingList);

    await expectLater(find.byType(MaterialApp),
        matchesGoldenFile('goldens/shopping_list_page.png'));
  });

  testWidgets('Opens the EditItemDialog when long tapping an item',
      (tester) async {
    await setViewSize(tester);

    await pumpWithGlobalAppState(tester, const ShoppingListPage(),
        ShoppingListCollection([shoppingList]), shoppingList);
    await tester.longPress(find.text(itemToEdit.name));
    await tester.pumpAndSettle();

    await expectLater(find.byType(MaterialApp),
        matchesGoldenFile('goldens/opened_edit_item_dialog.png'));
  });
}
