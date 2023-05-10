import 'package:flutter_test/flutter_test.dart';
import 'package:go_list/model/item.dart';
import 'package:go_list/model/shopping_list.dart';

import '../builders/item_builder.dart';
import '../builders/shopping_list_builder.dart';

void main() {
  group("merge shopping list items", () {
    test("Merges two lists with distinct items", () async {
      Item item1 = ItemBuilder().build();
      Item item2 = ItemBuilder().build();

      ShoppingList list1 = ShoppingListBuilder().withItems([item1]).build();
      ShoppingList list2 = ShoppingListBuilder().withItems([item2]).build();

      ShoppingList mergedList1 = list1.merge(list2);
      ShoppingList mergedList2 = list2.merge(list1);

      expect(mergedList1.itemsAsList(), unorderedEquals([item1, item2]));
      expect(mergedList2.itemsAsList(), unorderedEquals([item1, item2]));
    });

    test("Merges two lists with merging items", () async {
      Item item1 = ItemBuilder()
          .withId("id")
          .withModified(DateTime(2020, 1, 1))
          .withName("oldItem1")
          .build();
      Item item2 = ItemBuilder()
          .withId("id")
          .withModified(DateTime(2020, 1, 2))
          .withName("updatedItem1")
          .build();
      Item item3 = ItemBuilder()
          .withId("id2")
          .withModified(DateTime(2020, 1, 1))
          .build();
      Item item4 = ItemBuilder()
          .withId("id2")
          .withModified(DateTime(2020, 1, 2))
          .build();
      Item item5 = ItemBuilder().withId("id3").build();

      ShoppingList list1 =
      ShoppingListBuilder().withItems([item2, item3]).build();
      ShoppingList list2 =
      ShoppingListBuilder().withItems([item1, item4, item5]).build();

      ShoppingList mergedList1 = list1.merge(list2);
      ShoppingList mergedList2 = list2.merge(list1);

      expect(mergedList1.itemsAsList(), unorderedEquals([item2, item4, item5]));
      expect(mergedList1.itemsAsList(), unorderedEquals(mergedList2.itemsAsList()));
    });
  });

  group("json ", () {
    Item item1 = ItemBuilder()
        .withId("id1")
        .withModified(DateTime(2020, 1, 1))
        .withName("name1")
        .build();
    Item item2 = ItemBuilder()
        .withId("id2")
        .withModified(DateTime(2020, 1, 2))
        .withName("name2")
        .build();

    ShoppingList list = ShoppingListBuilder()
        .withId("id")
        .withItems([item1, item2])
        .withModified(DateTime(2020, 1, 2))
        .build();

    const json = {
      'id': 'id',
      'deleted': false,
      'modified': '2020-01-02T00:00:00.000',
      'name': 'name',
      'items': [
        {
          'id': 'id1',
          'deleted': false,
          'modified': '2020-01-01T00:00:00.000',
          'name': 'name1',
          'iconName': 'iconName',
          'amount': '1',
          'category': 'Category.beverages'
        },
        {
          'id': 'id2',
          'deleted': false,
          'modified': '2020-01-02T00:00:00.000',
          'name': 'name2',
          'iconName': 'iconName',
          'amount': '1',
          'category': 'Category.beverages'
        }
      ],
      'device_count': 1
    };

    test("generates a shopping list json", () async {
      expect(list.toJson(), json);
    });

    test("parses a shopping list from json", () async {
      ShoppingList shoppingListFromJson = ShoppingList.fromJson(json);
      expect(shoppingListFromJson.isEqualTo(list), isTrue);
    });

    test("parses a shopping list from json with time as ms", () async {
      ShoppingList shoppingListFromJson = ShoppingList.fromJson(const {
        'id': 'id',
        'deleted': false,
        'modified': 1683059350203,
        'name': 'name',
        'items': [
          {
            'id': 'id',
            'deleted': false,
            'modified': 1683059350203,
            'name': 'name1',
            'iconName': 'iconName',
            'amount': '1',
            'category': 'Category.beverages'
          }
        ]
      });
      List<Item> expectedItems = [
        ItemBuilder()
            .withId("id")
            .withModified(
            DateTime.fromMillisecondsSinceEpoch(1683059350203))
            .withName("name1")
            .withIconName("iconName")
            .build()
      ];
      ShoppingList expectedShoppingList = ShoppingListBuilder()
          .withId("id")
          .withModified(DateTime.fromMillisecondsSinceEpoch(1683059350203))
          .withName("name")
          .withItems(expectedItems)
          .build();
      expect(shoppingListFromJson.isEqualTo(expectedShoppingList), isTrue);
    });
  });
}
