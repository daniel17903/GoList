import { GoListModel } from './GoListModel.js';
import { Item } from './Item.js';
import { ItemCollection } from './collections/ItemCollection.js';
import { RecentlyUsedItemCollection } from './collections/RecentlyUsedItemCollection.js';

export class ShoppingList extends GoListModel {
  items: ItemCollection;
  recentlyUsedItems: RecentlyUsedItemCollection;

  constructor({
    id,
    name,
    items,
    recentlyUsedItems,
    deleted = false,
    modified
  }: {
    id?: string;
    name: string;
    items?: ItemCollection;
    recentlyUsedItems?: RecentlyUsedItemCollection;
    deleted?: boolean;
    modified?: Date;
  }) {
    super({ id, name, deleted, modified });
    this.items = items || new ItemCollection([]);
    this.items.sort();
    this.recentlyUsedItems = recentlyUsedItems || this.items.copyForRecentlyUsed();
  }

  static fromJson(json: any): ShoppingList {
    return new ShoppingList({
      id: json.id,
      name: json.name,
      deleted: json.deleted,
      modified: new Date(json.modified),
      items: ItemCollection.fromJson(json.items || []),
      recentlyUsedItems: RecentlyUsedItemCollection.fromJson(json.recentlyUsedItems || [])
    });
  }

  toJson(): Record<string, any> {
    return {
      ...super.toJson(),
      items: this.items.toJson(),
      recentlyUsedItems: this.recentlyUsedItems.toJson()
    };
  }

  copyWith({
    name,
    items,
    deleted,
    modified,
    id
  }: {
    name?: string;
    items?: ItemCollection;
    deleted?: boolean;
    modified?: Date;
    id?: string;
  } = {}): ShoppingList {
    return new ShoppingList({
      name: name ?? this.name,
      items: items ?? this.items,
      deleted: deleted ?? this.deleted,
      modified: modified ?? new Date(),
      id: id ?? this.id
    });
  }

  deleteItem(itemId: string): void {
    const item = this.items.entryWithId(itemId);
    if (item) {
      item.deleted = true;
      this.modified = new Date();
    }
  }

  unDeleteItem(itemId: string): void {
    const item = this.items.entryWithId(itemId);
    if (item) {
      item.deleted = false;
      this.modified = new Date();
    }
  }

  upsertItem(item: Item): void {
    this.items.upsert(item);
    this.modified = new Date();
    this.recentlyUsedItems.upsert(item.copyForRecentlyUsed());
    this.items.sort();
  }

  notDeletedItems(): Item[] {
    return this.items.entries.filter(item => !item.deleted);
  }

  merge(other: GoListModel): GoListModel {
    if (!(other instanceof ShoppingList)) {
      return this;
    }

    const lastUpdatedShoppingList = this.lastModified(this, other) as ShoppingList;
    
    return new ShoppingList({
      id: lastUpdatedShoppingList.id,
      name: lastUpdatedShoppingList.name,
      items: this.items.merge(other.items) as ItemCollection,
      recentlyUsedItems: this.recentlyUsedItems.merge(other.recentlyUsedItems) as RecentlyUsedItemCollection,
      deleted: lastUpdatedShoppingList.deleted,
      modified: lastUpdatedShoppingList.modified
    });
  }

  itemsAsList(): Item[] {
    return this.items.entries;
  }

  equals(other: GoListModel): boolean {
    return other instanceof ShoppingList &&
           other.id === this.id &&
           other.name === this.name &&
           other.deleted === this.deleted &&
           this.items.equals(other.items) &&
           this.recentlyUsedItems.equals(other.recentlyUsedItems);
  }
}