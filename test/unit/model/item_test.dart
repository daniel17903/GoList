import 'package:flutter_test/flutter_test.dart';
import 'package:go_list/model/item.dart';
import 'package:go_list/service/items/category.dart';

import '../../builders/item_builder.dart';


void main() {
  group("merge items", () {
    test("returns values of last updated item", () async {
      Item item1 = ItemBuilder()
          .withModified(DateTime(2020, 1, 1))
          .withName("item1")
          .withDeleted(false)
          .withIconName("iconName1")
          .withCategory(Category.beverages)
          .withAmount("1")
          .build();
      Item item2 = ItemBuilder()
          .withModified(DateTime(2020, 1, 2))
          .withDeleted(true)
          .withName("item2")
          .withIconName("iconName2")
          .withCategory(Category.cereals)
          .withAmount("2")
          .build();

      expect(item1.merge(item2), item2);
      expect(item2.merge(item1), item2);
    });
  });
}
