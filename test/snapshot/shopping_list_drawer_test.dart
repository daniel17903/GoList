import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/model/shopping_list_collection.dart';
import 'package:go_list/view/shopping_list_page.dart';

import '../builders/shopping_list_builder.dart';
import 'fixtures.dart';

void main() async {
  late ShoppingListCollection shoppingListCollection;
  late ShoppingList shoppingList;

  setUp(() async {
    shoppingList =
        ShoppingListBuilder().withName("selected shopping list").build();

    shoppingListCollection = ShoppingListCollection(entries: [
      shoppingList,
      ShoppingListBuilder().withName("Other List 1").build(),
      ShoppingListBuilder().withName("Other List 2").build(),
      ShoppingListBuilder().withName("Other List 3").build(),
      ShoppingListBuilder().withName("Other List 4").build(),
    ]);
  });

  testWidgets('Opens the ShoppingListDrawer when tapping the menu button',
      (tester) async {
    await setViewSize(tester);

    await pumpWithGlobalAppState(
        tester, ShoppingListPage(), shoppingListCollection, shoppingList.id);
    await tester.longPress(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    await expectLater(find.byType(MaterialApp),
        matchesGoldenFile('goldens/opened_shopping_list_drawer.png'));
  });
}
