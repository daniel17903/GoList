import { ShoppingList } from '../../models/ShoppingList.js';
import { ShoppingListCollection } from '../../models/collections/ShoppingListCollection.js';
import { Settings } from '../../models/Settings.js';

export class LocalStorageProvider {
  private static readonly SHOPPING_LISTS_KEY = 'shopping_lists';
  private static readonly SETTINGS_KEY = 'settings';

  static async init(): Promise<void> {
    // Initialize any required setup
    // In web environment, localStorage is available immediately
  }

  async migrateFromPreviousVersion(): Promise<void> {
    // Handle any migration logic from previous versions
    // This could include converting old data formats
  }

  loadShoppingLists(): ShoppingListCollection {
    try {
      const data = localStorage.getItem(LocalStorageProvider.SHOPPING_LISTS_KEY);
      if (data) {
        const json = JSON.parse(data);
        return ShoppingListCollection.fromJson(json);
      }
    } catch (error) {
      console.error('Failed to load shopping lists from localStorage:', error);
    }
    return new ShoppingListCollection([]);
  }

  loadShoppingList(shoppingListId: string): ShoppingList {
    const shoppingLists = this.loadShoppingLists();
    const shoppingList = shoppingLists.entryWithId(shoppingListId);
    
    if (!shoppingList) {
      throw new Error(`Shopping list with id ${shoppingListId} not found`);
    }
    
    // Clean up old deleted items
    shoppingList.items.removeItemsDeletedSinceDays();
    return shoppingList;
  }

  upsertShoppingList(shoppingList: ShoppingList): void {
    const shoppingLists = this.loadShoppingLists();
    shoppingLists.upsert(shoppingList);
    this.saveShoppingLists(shoppingLists);
  }

  private saveShoppingLists(shoppingLists: ShoppingListCollection): void {
    try {
      localStorage.setItem(
        LocalStorageProvider.SHOPPING_LISTS_KEY,
        JSON.stringify(shoppingLists.toJson())
      );
    } catch (error) {
      console.error('Failed to save shopping lists to localStorage:', error);
    }
  }

  deleteShoppingList(shoppingListId: string): void {
    const shoppingLists = this.loadShoppingLists();
    shoppingLists.removeEntryWithId(shoppingListId);
    this.saveShoppingLists(shoppingLists);
  }

  saveSettings(settings: Settings): void {
    try {
      localStorage.setItem(
        LocalStorageProvider.SETTINGS_KEY,
        JSON.stringify(settings.toJson())
      );
    } catch (error) {
      console.error('Failed to save settings to localStorage:', error);
    }
  }

  loadSettings(): Settings | null {
    try {
      const data = localStorage.getItem(LocalStorageProvider.SETTINGS_KEY);
      if (data) {
        const json = JSON.parse(data);
        return Settings.fromJson(json);
      }
    } catch (error) {
      console.error('Failed to load settings from localStorage:', error);
    }
    return null;
  }
}