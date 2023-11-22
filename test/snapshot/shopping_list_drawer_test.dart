import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/model/collections/shopping_list_collection.dart';
import 'package:go_list/view/shopping_list_page.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../builders/shopping_list_builder.dart';
import '../fixtures.dart';

void main() async {
  late ShoppingListCollection shoppingListCollection;
  late ShoppingList shoppingList;

  setUp(() async {
    shoppingList =
        ShoppingListBuilder().withName("selected shopping list").build();

    shoppingListCollection = ShoppingListCollection([
      shoppingList,
      ShoppingListBuilder().withName("Other List 1").build(),
      ShoppingListBuilder().withName("Other List 2").build(),
      ShoppingListBuilder().withName("Other List 3").build(),
      ShoppingListBuilder().withName("Other List 4").build(),
    ]);
  });

  testGoldens('Opens the ShoppingListDrawer when tapping the menu button',
      (tester) async {
    final builder = DeviceBuilder()
      ..overrideDevicesForAllScenarios(devices: [
        Device.phone,
        Device.iphone11,
        Device.tabletPortrait,
        Device.tabletLandscape
      ])
      ..addScenario(
        widget: wrapWithGlobalAppStateProvider(
          shoppingListCollection,
          shoppingList,
          const ShoppingListPage(),
        ),
        name: 'Renders recently used items',
        onCreate: (scenarioWidgetKey) async {
          final finder = find.descendant(
            of: find.byKey(scenarioWidgetKey),
            matching: find.byIcon(Icons.menu),
          );
          await tester.tap(finder);
          await tester.pumpAndSettle();
        },
      );

    await tester.pumpDeviceBuilder(builder);

    await screenMatchesGolden(tester, 'opened_shopping_list_drawer');
  });
}
