import 'package:flutter_test/flutter_test.dart';
import 'package:go_list/style/colors.dart';
import 'package:go_list/view/shopping_list/item_grid_view.dart';

import '../builders/item_builder.dart';
import '../fixtures.dart';

void main() {
  testWidgets('Renders ShoppingListItems', (tester) async {
    await setViewSize(tester);

    var items = [
      ItemBuilder().withName("apple").withAmount("").build(),
      ItemBuilder().withName("").withAmount("2").build(),
      ItemBuilder().withName("apple").withAmount("1").build(),
      ItemBuilder()
          .withName("name name name name name name name name long name")
          .withAmount("1")
          .build(),
      ItemBuilder()
          .withName("name name name name name name name name long name")
          .withAmount("")
          .build(),
      ItemBuilder()
          .withName("name name name name name name name name long name")
          .withAmount("amount amount amount amount amount amount amount")
          .build(),
      ItemBuilder()
          .withName("apple")
          .withAmount("amount amount amount amount amount amount long amount")
          .build(),
      ItemBuilder()
          .withName("namenamenamenamenamenamenamenamelongname")
          .withAmount("1")
          .build(),
      ItemBuilder()
          .withName("namenamenamenamenamenamenamenamelongname")
          .withAmount("")
          .build(),
      ItemBuilder()
          .withName("namenamenamenamenamenamenamenamelongname")
          .withAmount("amountamountamountamountamountamountamount")
          .build(),
      ItemBuilder()
          .withName("apple")
          .withAmount("amountamountamountamountamountamountlongamount")
          .build(),
    ];

    await pumpWrappedWithMaterialApp(
        tester,
        ItemGridView(
          items: items,
          onItemTapped: (_) {},
          itemBackgroundColor: GoListColors.itemBackground,
          maxItemSize: 140,
          animate: false,
        ));

    await expectLater(find.byType(ItemGridView),
        matchesGoldenFile('goldens/shopping_list_item.png'));
  });
}
