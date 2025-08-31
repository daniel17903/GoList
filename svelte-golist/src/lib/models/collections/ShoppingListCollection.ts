import { ShoppingList } from '../ShoppingList.js';
import { BaseCollection } from './BaseCollection.js';

export class ShoppingListCollection extends BaseCollection<ShoppingList> {
  constructor(entries: ShoppingList[] = []) {
    super(entries);
  }

  static fromJson(json: any[]): ShoppingListCollection {
    return super.fromJson(json, ShoppingList.fromJson) as ShoppingListCollection;
  }
}