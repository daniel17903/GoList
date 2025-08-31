import { Item } from '../Item.js';
import { BaseCollection } from './BaseCollection.js';

export class ItemCollection extends BaseCollection<Item> {
  constructor(entries: Item[] = []) {
    super(entries);
  }

  static fromJson(json: any[]): ItemCollection {
    return super.fromJson(json, Item.fromJson) as ItemCollection;
  }

  sort(): void {
    this.entries.sort((a, b) => a.compareTo(b));
  }

  removeItemsDeletedSinceDays(days: number = 30): void {
    const cutoffDate = new Date();
    cutoffDate.setDate(cutoffDate.getDate() - days);
    this.entries = this.entries.filter(item => 
      !item.deleted || item.modified > cutoffDate
    );
  }

  copyForRecentlyUsed(): ItemCollection {
    const recentlyUsedItems = this.entries.map(item => item.copyForRecentlyUsed());
    return new ItemCollection(recentlyUsedItems);
  }
}