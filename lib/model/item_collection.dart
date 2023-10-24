import 'package:go_list/model/extended_golist_collection.dart';
import 'package:go_list/model/item.dart';

class ItemCollection extends ExtendedGoListCollection<Item> {
  ItemCollection({List<Item>? entries, List<Item>? deletedEntries})
      : super(entries: entries, deletedEntries: deletedEntries) {
    this.entries.sort();
  }

  static ItemCollection fromJson(List<dynamic>? json) {
    ItemCollection itemCollection = ItemCollection();
    if (json != null) {
      json.map<Item>((itemJson) => Item.fromJson(itemJson)).forEach((item) {
        itemCollection.upsert(item);
      });
    }
    return itemCollection;
  }

  @override
  ItemCollection merge(ExtendedGoListCollection<Item> other) {
    return super.merge(other) as ItemCollection;
  }

  List<Item> copyEntries() {
    return entries.map<Item>((e) => e.copy()).toList();
  }

}
