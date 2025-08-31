import { GoListModel } from '../GoListModel.js';

export abstract class BaseCollection<T extends GoListModel> {
  entries: T[];
  order: string[];

  constructor(entries: T[] = []) {
    this.entries = entries;
    this.order = entries.map(entry => entry.id);
  }

  static fromJson<T extends GoListModel>(
    json: any[],
    createFromJson: (item: any) => T
  ): BaseCollection<T> {
    const collection = new (this as any)();
    collection.entries = json.map(createFromJson);
    collection.order = collection.entries.map(entry => entry.id);
    return collection;
  }

  toJson(): any[] {
    return this.entries.map(entry => entry.toJson());
  }

  get length(): number {
    return this.entries.length;
  }

  first(): T | null {
    return this.entries.length > 0 ? this.entries[0] : null;
  }

  entryWithId(id: string): T | null {
    return this.entries.find(entry => entry.id === id) || null;
  }

  containsEntryWithId(id: string): boolean {
    return this.entries.some(entry => entry.id === id);
  }

  upsert(entry: T): void {
    const existingIndex = this.entries.findIndex(e => e.id === entry.id);
    if (existingIndex >= 0) {
      this.entries[existingIndex] = entry;
    } else {
      this.entries.push(entry);
      this.order.push(entry.id);
    }
  }

  removeEntryWithId(id: string): void {
    this.entries = this.entries.filter(entry => entry.id !== id);
    this.order = this.order.filter(orderId => orderId !== id);
  }

  setOrder(order: string[]): void {
    this.order = order;
    // Sort entries according to order
    this.entries.sort((a, b) => {
      const indexA = this.order.indexOf(a.id);
      const indexB = this.order.indexOf(b.id);
      return indexA - indexB;
    });
  }

  moveEntryInOrder(oldIndex: number, newIndex: number): void {
    const [movedItem] = this.order.splice(oldIndex, 1);
    this.order.splice(newIndex, 0, movedItem);
    this.setOrder(this.order);
  }

  cleanup(): void {
    const cutoffDate = new Date();
    cutoffDate.setDate(cutoffDate.getDate() - 30);
    this.entries = this.entries.filter(entry => 
      !entry.deleted || entry.modified > cutoffDate
    );
    this.order = this.order.filter(id => this.containsEntryWithId(id));
  }

  merge(other: BaseCollection<T>): BaseCollection<T> {
    const merged = new (this.constructor as any)();
    merged.entries = [...this.entries];
    merged.order = [...this.order];

    for (const otherEntry of other.entries) {
      const existingEntry = merged.entryWithId(otherEntry.id);
      if (existingEntry) {
        merged.upsert(existingEntry.merge(otherEntry) as T);
      } else {
        merged.upsert(otherEntry);
      }
    }

    return merged;
  }

  equals(other: BaseCollection<T>): boolean {
    if (this.entries.length !== other.entries.length) {
      return false;
    }
    
    return this.entries.every(entry => {
      const otherEntry = other.entryWithId(entry.id);
      return otherEntry && entry.equals(otherEntry);
    });
  }
}