import 'package:flutter_test/flutter_test.dart';
import 'package:go_list/model/item.dart';
import 'package:go_list/model/recently_used_item_collection.dart';
import 'package:go_list/model/shopping_list.dart';
import 'package:go_list/service/items/category.dart';

import '../../builders/item_builder.dart';
import '../../builders/shopping_list_builder.dart';

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
      expect(mergedList1.itemsAsList(),
          unorderedEquals(mergedList2.itemsAsList()));
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
        .withRecentlyUsedItems([item1, item2])
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
      'recentlyUsedItems': [
        {
          'id': 'id2',
          'deleted': false,
          'modified': '2020-01-02T00:00:00.000',
          'name': 'name2',
          'iconName': 'iconName',
          'amount': '1',
          'category': 'Category.beverages'
        },
        {
          'id': 'id1',
          'deleted': false,
          'modified': '2020-01-01T00:00:00.000',
          'name': 'name1',
          'iconName': 'iconName',
          'amount': '1',
          'category': 'Category.beverages'
        },
      ]
    };

    test("generates a shopping list json", () async {
      expect(list.toJson(), json);
    });

    test("parses a shopping list from json", () async {
      ShoppingList shoppingListFromJson = ShoppingList.fromJson(json);
      expect(shoppingListFromJson, list);
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
        ],
        'recentlyUsedItems': [
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
            .withModified(DateTime.fromMillisecondsSinceEpoch(1683059350203))
            .withName("name1")
            .withIconName("iconName")
            .build()
      ];
      ShoppingList expectedShoppingList = ShoppingListBuilder()
          .withId("id")
          .withModified(DateTime.fromMillisecondsSinceEpoch(1683059350203))
          .withName("name")
          .withItems(expectedItems)
          .withRecentlyUsedItems(expectedItems)
          .build();
      expect(shoppingListFromJson, expectedShoppingList);
    });
  });

  group("upserts items", () {
    test("upserts an item at correct index", () async {
      Item itemWithLowerSortedCategory = ItemBuilder()
          .withName("itemWithLowerSortedCategory")
          .withCategory(Category.household)
          .withModified(DateTime(2020, 1, 2))
          .build();
      Item itemWitMidSortedCategory = ItemBuilder()
          .withName("itemWitMidSortedCategory")
          .withCategory(Category.spicesCanned)
          .build();
      Item itemWithHigherSortedCategory = ItemBuilder()
          .withName("itemWithHigherSortedCategory")
          .withCategory(Category.bread)
          .withModified(DateTime(2020, 1, 1))
          .build();

      ShoppingList shoppingList = ShoppingListBuilder().withItems([
        itemWithLowerSortedCategory,
        itemWithHigherSortedCategory
      ]).withRecentlyUsedItems(
          [itemWithLowerSortedCategory, itemWithHigherSortedCategory]).build();

      shoppingList.upsertItem(itemWitMidSortedCategory);

      expect(
          shoppingList.itemsAsList(),
          orderedEquals([
            itemWithHigherSortedCategory,
            itemWitMidSortedCategory,
            itemWithLowerSortedCategory,
          ]));

      expect(
          shoppingList.recentlyUsedItems.entries.map((e) => e.name),
          orderedEquals([
            itemWitMidSortedCategory.name,
            itemWithLowerSortedCategory.name,
            itemWithHigherSortedCategory.name,
          ]));
    });

    test("keeps names of recently used items unique", () async {
      Item firstItem = ItemBuilder()
          .withName("firstItem")
          .withModified(DateTime(2020, 1, 1))
          .build();
      Item secondItem = ItemBuilder()
          .withName("secondItem")
          .withModified(DateTime(2020, 1, 2))
          .build();
      Item itemWithExistingName = ItemBuilder().withName("firstItem").build();

      ShoppingList shoppingList = ShoppingListBuilder()
          .withItems([firstItem, secondItem]).withRecentlyUsedItems(
              [firstItem, secondItem]).build();
      shoppingList.upsertItem(itemWithExistingName);

      expect(
          shoppingList.recentlyUsedItems.entries.map((e) => e.name),
          orderedEquals([
            firstItem.name,
            secondItem.name,
          ]));
    });
  });

  test("does not create more than maxItems recently used items", () async {
    ShoppingList shoppingList = ShoppingListBuilder().build();
    for (int i = 0; i < 10000; i++) {
      shoppingList.upsertItem(
          ItemBuilder().withName(i.toString()).withId(i.toString()).build());
    }
    expect(shoppingList.recentlyUsedItems.entries.length,
        RecentlyUsedItemCollection.maxItems);
  });
}
