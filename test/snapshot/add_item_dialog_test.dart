import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/model/shopping_list_collection.dart';
import 'package:go_list/view/shopping_list/add_item_dialog/add_item_dialog.dart';
import 'package:go_list/view/shopping_list_page.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../builders/item_builder.dart';
import '../builders/shopping_list_builder.dart';
import 'fixtures.dart';

void main() async {
  late ShoppingList shoppingListWithRecentlyUsedItems;

  setUp(() async {
    shoppingListWithRecentlyUsedItems = ShoppingListBuilder().withItems(
        [ItemBuilder().withName("item 1").build()]).withRecentlyUsedItems([
      ItemBuilder().withName("a recently used a").withAmount("").build(),
      ItemBuilder().withName("a recently used b").withAmount("").build(),
      ItemBuilder().withName("b recently used c").withAmount("").build(),
      ItemBuilder().withName("b recently used d").withAmount("").build()
    ]).build();
  });

  testWidgets('Opens the AddItemDialog when tapping the floating action button',
      (tester) async {
    await setViewSize(tester);

    await pumpWithGlobalAppState(
        tester,
        const ShoppingListPage(),
        ShoppingListCollection(entries: [shoppingListWithRecentlyUsedItems]),
        shoppingListWithRecentlyUsedItems.id);
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    await expectLater(find.byType(MaterialApp),
        matchesGoldenFile('goldens/opened_add_item_dialog.png'));
  });

  testGoldens('Renders recently used items', (tester) async {
    final builder = DeviceBuilder()
      ..overrideDevicesForAllScenarios(devices: [
        Device.phone,
        Device.iphone11,
        Device.tabletPortrait,
        Device.tabletLandscape
      ])
      ..addScenario(
        widget: wrapWithShoppingListProvider(
          shoppingListWithRecentlyUsedItems,
          wrapWithMaterialApp(const AddItemDialog()),
        ),
        name: 'Renders recently used items',
      );

    await tester.pumpDeviceBuilder(builder);

    await screenMatchesGolden(tester, 'add_item_dialog');
  });

  testGoldens('Previews and sorts correctly', (tester) async {
    final builder = DeviceBuilder()
      ..overrideDevicesForAllScenarios(devices: [Device.phone])
      ..addScenario(
        widget: wrapWithShoppingListProvider(
          shoppingListWithRecentlyUsedItems,
          wrapWithMaterialApp(const AddItemDialog()),
        ),
        name: 'Renders recently used items',
      )
      ..addScenario(
        widget: wrapWithShoppingListProvider(
          shoppingListWithRecentlyUsedItems,
          wrapWithMaterialApp(const AddItemDialog()),
        ),
        name: 'Previews an item with a not recently used name',
        onCreate: (scenarioWidgetKey) async {
          final finder = find.descendant(
            of: find.byKey(scenarioWidgetKey),
            matching: find.byType(TextField),
          );
          await tester.enterText(finder, "New Item 3");
          await tester.pumpAndSettle();
        },
      )
      ..addScenario(
        widget: wrapWithShoppingListProvider(
          shoppingListWithRecentlyUsedItems,
          wrapWithMaterialApp(const AddItemDialog()),
        ),
        name: 'Previews an item with a partial recently used name',
        onCreate: (scenarioWidgetKey) async {
          final finder = find.descendant(
            of: find.byKey(scenarioWidgetKey),
            matching: find.byType(TextField),
          );
          await tester.enterText(finder, "b");
          await tester.pumpAndSettle();
        },
      )
      ..addScenario(
        widget: wrapWithShoppingListProvider(
          shoppingListWithRecentlyUsedItems,
          wrapWithMaterialApp(const AddItemDialog()),
        ),
        name: 'Previews an item with a recently used name',
        onCreate: (scenarioWidgetKey) async {
          final finder = find.descendant(
            of: find.byKey(scenarioWidgetKey),
            matching: find.byType(TextField),
          );
          await tester.enterText(finder, "b recently used c");
          await tester.pumpAndSettle();
        },
      );

    await tester.pumpDeviceBuilder(builder);

    await screenMatchesGolden(tester, 'preview_and_sort');
  });
}
