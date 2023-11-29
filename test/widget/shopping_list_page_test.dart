import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_list/model/collections/shopping_list_collection.dart';
import 'package:go_list/model/item.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/service/golist_client.dart';
import 'package:go_list/view/drawer/create_new_list_tile.dart';
import 'package:go_list/view/drawer/shopping_list_drawer.dart';
import 'package:go_list/view/drawer/shopping_list_tile.dart';
import 'package:go_list/view/shopping_list/add_item_dialog/add_item_dialog.dart';
import 'package:go_list/view/shopping_list/item_list_viewer.dart';
import 'package:go_list/view/shopping_list/shopping_list_item/shopping_list_item.dart';
import 'package:go_list/view/shopping_list_page.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../builders/item_builder.dart';
import '../builders/shopping_list_builder.dart';
import '../fixtures.dart';
import 'shopping_list_page_test.mocks.dart';

class MockStream extends Mock implements Stream<ShoppingList> {}

@GenerateMocks([GoListClient])
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
    await pumpWithGlobalAppState(tester, const ShoppingListPage(),
        ShoppingListCollection([shoppingList]));

    expect(find.byType(ShoppingListItem),
        findsNWidgets(shoppingList.items.length));
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
    await pumpWithGlobalAppState(tester, const ShoppingListPage(),
        ShoppingListCollection([shoppingList]));

    var originalNumberOfItems = shoppingList.items.length;
    var itemToDelete = shoppingList.items.get(2);

    await tester.tap(find.byKey(Key(itemToDelete.id)));
    await tester.pumpAndSettle();

    expect(find.byType(ShoppingListItem),
        findsNWidgets(originalNumberOfItems - 1));
    expect(find.byKey(Key(itemToDelete.id)), findsNothing);
  });

  testWidgets('Adds an item', (tester) async {
    await pumpWithGlobalAppState(tester, const ShoppingListPage(),
        ShoppingListCollection([shoppingList]));

    var originalNumberOfItems = shoppingList.items.length;
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), "apple");
    await tester.pumpAndSettle();
    await tester.tap(find.descendant(
        of: find.byType(ShoppingListItem), matching: find.text("apple")));
    await tester.pumpAndSettle();

    expect(find.byType(ShoppingListItem),
        findsNWidgets(originalNumberOfItems + 1));
    expect(find.text("apple"), findsOneWidget);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), "ap");
    await tester.pumpAndSettle();
    await tester.tap(find.descendant(
        of: find.byType(AddItemDialog), matching: find.text("apple")));
    await tester.pumpAndSettle();

    expect(find.byType(ShoppingListItem),
        findsNWidgets(originalNumberOfItems + 2));
    expect(find.text("apple"), findsNWidgets(2));

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    expect(
        find.descendant(
            of: find.byType(AddItemDialog),
            matching: find.byType(ShoppingListItem)),
        findsOneWidget);
    expect(
        find.descendant(
            of: find.byType(AddItemDialog), matching: find.text("apple")),
        findsOneWidget);
  });

  testWidgets('Deletes a list', (tester) async {
    ShoppingList shoppingListToKeep =
        ShoppingListBuilder().withName("list to keep").build();
    ShoppingList shoppingListToDelete =
        ShoppingListBuilder().withName("list to remove").build();
    await pumpWithGlobalAppState(tester, const ShoppingListPage(),
        ShoppingListCollection([shoppingListToKeep, shoppingListToDelete]));

    // open the drawer
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    // tap the delete icon
    await tester.tap(find.descendant(
        of: find.widgetWithText(ListTile, shoppingListToDelete.name),
        matching: find.byIcon(Icons.delete)));
    await tester.pumpAndSettle();

    // tap ok in dialog
    await tester.tap(find.text("OK"));
    await tester.pumpAndSettle();

    expect(find.byType(ShoppingListTile), findsOneWidget);
    expect(find.text(shoppingListToDelete.name), findsNothing);
    expect(
        find.descendant(
            of: find.byType(ShoppingListDrawer),
            matching: find.text(shoppingListToKeep.name)),
        findsOneWidget);
  });

  testWidgets('Adds a list', (tester) async {
    await pumpWithGlobalAppState(tester, const ShoppingListPage(),
        ShoppingListCollection([shoppingList]));

    // open the drawer
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    // click on 'create new list'
    await tester.tap(find.byType(CreateNewListTile));
    await tester.pumpAndSettle();

    // insert new list name and click save in dialog
    await tester.enterText(
        find.descendant(
            of: find.byType(AlertDialog), matching: find.byType(TextFormField)),
        "new list name");
    await tester.tap(find.text("Save"));
    await tester.pumpAndSettle();

    // expect the new list to be selected
    expect(
        find.descendant(
            of: find.byType(ItemListViewer),
            matching: find.text("new list name")),
        findsOneWidget);
  });

  testWidgets('Edits a lists name', (tester) async {
    await pumpWithGlobalAppState(tester, const ShoppingListPage(),
        ShoppingListCollection([shoppingList]));

    // open the edit dialog
    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();

    // insert new list name and click save in dialog
    await tester.enterText(
        find.descendant(
            of: find.byType(AlertDialog), matching: find.byType(TextFormField)),
        "new list name");
    await tester.tap(find.text("Save"));
    await tester.pumpAndSettle();

    // expect the new list name to be shown
    expect(
        find.descendant(
            of: find.byType(ItemListViewer),
            matching: find.text("new list name")),
        findsOneWidget);
  });

  testWidgets('Updates with a shopping list received via websocket',
      (tester) async {
    await setViewSize(tester);
    Item newItemFromStream = ItemBuilder().withName("new item").build();
    ShoppingListBuilder builder = ShoppingListBuilder();
    List<Item> items = [
      ItemBuilder().withName("item a").build(),
      ItemBuilder().withName("item b").build(),
    ];
    ShoppingList initialShoppingList = builder.withItems(items).build();
    ShoppingList updatedShoppingList = builder.withItems([
      ItemBuilder().withId(items[0].id).withName("updated").build(),
      ItemBuilder().withId(items[1].id).withDeleted(true).build(),
      newItemFromStream
    ]).build();

    GoListClient goListClientMock = MockGoListClient();
    StreamController<ShoppingList> streamController = StreamController();

    when(goListClientMock.listenForChanges(initialShoppingList.id))
        .thenAnswer((_) {
      streamController = StreamController();
      return Future.value(streamController.stream);
    });

    await pumpWithGlobalAppState(tester, const ShoppingListPage(),
        ShoppingListCollection([initialShoppingList]), goListClientMock);
    await tester.pumpAndSettle();

    streamController.add(updatedShoppingList);
    await tester.pumpAndSettle();

    expect(find.byKey(Key(items[0].id)), findsOneWidget);
    expect(find.byKey(Key(items[1].id)), findsNothing);
    expect(find.byKey(Key(newItemFromStream.id)), findsOneWidget);
  });
}
