import 'package:get_storage/get_storage.dart';
import 'package:go_list/model/collections/shopping_list_collection.dart';
import 'package:go_list/model/settings.dart';
import 'package:mockito/mockito.dart';

class MockStorage extends Mock implements GetStorage {
  ShoppingListCollection shoppingListCollection;
  Settings settings;

  MockStorage.withShoppingListCollection(this.shoppingListCollection)
      : settings = Settings(
            selectedShoppingListId: shoppingListCollection.first()!.id,
            shoppingListOrder:
                shoppingListCollection.map((s) => s.id).toList());

  @override
  bool hasData(String key) {
    return true;
  }

  @override
  T? read<T>(String key) {
    if (key == "shoppingLists") {
      return shoppingListCollection.toJson() as T;
    }

    if (key == "settings") {
      return settings.toJson() as T;
    }

    return null;
  }

  @override
  Future<void> write(String key, value) async {
    if (key == "shoppingLists") {
      shoppingListCollection = ShoppingListCollection.fromJson(value);
    }
    if (key == "settings") {
      settings = Settings.fromJson(value);
    }
  }
}
