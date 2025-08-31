import { Item } from '../Item.js';
import { ItemCollection } from './ItemCollection.js';

export class RecentlyUsedItemCollection extends ItemCollection {
  private searchText: string = '';
  private static readonly MAX_ITEMS_TO_SHOW = 20;

  constructor(entries: Item[] = []) {
    super(entries);
  }

  static fromJson(json: any[]): RecentlyUsedItemCollection {
    const collection = new RecentlyUsedItemCollection();
    collection.entries = json.map(Item.fromJson);
    collection.order = collection.entries.map(entry => entry.id);
    return collection;
  }

  searchBy(searchText: string): void {
    this.searchText = searchText.toLowerCase();
  }

  itemsToShow(): Item[] {
    let filteredItems = this.entries;
    
    if (this.searchText) {
      filteredItems = this.entries.filter(item => 
        item.name.toLowerCase().includes(this.searchText)
      );
    }

    // Sort by usage frequency (most recent first) and limit
    return filteredItems
      .sort((a, b) => b.modified.getTime() - a.modified.getTime())
      .slice(0, RecentlyUsedItemCollection.MAX_ITEMS_TO_SHOW);
  }

  upsert(item: Item): void {
    // Remove existing item with same name to avoid duplicates
    this.entries = this.entries.filter(existing => 
      existing.name.toLowerCase() !== item.name.toLowerCase()
    );
    
    // Add the new/updated item
    super.upsert(item);
    
    // Keep only the most recent items
    if (this.entries.length > RecentlyUsedItemCollection.MAX_ITEMS_TO_SHOW * 2) {
      this.entries.sort((a, b) => b.modified.getTime() - a.modified.getTime());
      this.entries = this.entries.slice(0, RecentlyUsedItemCollection.MAX_ITEMS_TO_SHOW * 2);
      this.order = this.entries.map(entry => entry.id);
    }
  }
}