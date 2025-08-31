import { ShoppingList } from '../../models/ShoppingList.js';
import { ShoppingListCollection } from '../../models/collections/ShoppingListCollection.js';
import { Settings } from '../../models/Settings.js';
import { LocalStorageProvider } from './LocalStorageProvider.js';
import { RemoteStorageProvider } from './RemoteStorageProvider.js';

export class ShoppingListStorage {
  private localStorageProvider: LocalStorageProvider;
  private remoteStorageProvider: RemoteStorageProvider;

  constructor(localStorageProvider: LocalStorageProvider, remoteStorageProvider: RemoteStorageProvider) {
    this.localStorageProvider = localStorageProvider;
    this.remoteStorageProvider = remoteStorageProvider;
  }

  loadShoppingListsFromLocalStorage(): ShoppingListCollection {
    const shoppingListsFromLocalStorage = this.localStorageProvider.loadShoppingLists();
    shoppingListsFromLocalStorage.cleanup();
    return shoppingListsFromLocalStorage;
  }

  loadShoppingListFromLocalStorage(shoppingListId: string): ShoppingList {
    const shoppingList = this.localStorageProvider.loadShoppingList(shoppingListId);
    shoppingList.items.removeItemsDeletedSinceDays();
    return shoppingList;
  }

  async* loadShoppingLists(): AsyncGenerator<ShoppingListCollection> {
    const shoppingListsFromLocalStorage = this.loadShoppingListsFromLocalStorage();
    yield shoppingListsFromLocalStorage;

    try {
      const shoppingListsFromRemoteStorage = await this.remoteStorageProvider.loadShoppingLists();
      shoppingListsFromRemoteStorage.cleanup();

      if (!shoppingListsFromRemoteStorage.equals(shoppingListsFromLocalStorage)) {
        const merged = shoppingListsFromLocalStorage.merge(shoppingListsFromRemoteStorage) as ShoppingListCollection;

        // Update local storage with changes from remote
        for (const entry of merged.entries) {
          this.localStorageProvider.upsertShoppingList(entry);
        }
        
        // Update remote storage with changes from local
        for (const entry of merged.entries) {
          await this.remoteStorageProvider.upsertShoppingList(entry);
        }

        yield merged;
      }
    } catch (error) {
      console.error('Failed to sync with remote storage:', error);
      // Continue with local data only
    }
  }

  async listenForChanges(shoppingListId: string): Promise<ReadableStream<ShoppingList>> {
    const remoteStream = await this.remoteStorageProvider.listenForChanges(shoppingListId);
    
    return new ReadableStream({
      start: (controller) => {
        const reader = remoteStream.getReader();
        
        const pump = async () => {
          try {
            while (true) {
              const { done, value } = await reader.read();
              if (done) break;
              
              const mergedWithLocal = this.loadShoppingListFromLocalStorage(value.id)
                .merge(value) as ShoppingList;
              this.localStorageProvider.upsertShoppingList(mergedWithLocal);
              controller.enqueue(mergedWithLocal);
            }
          } catch (error) {
            controller.error(error);
          } finally {
            controller.close();
          }
        };
        
        pump();
      }
    });
  }

  async upsertShoppingList(shoppingList: ShoppingList): Promise<void> {
    this.localStorageProvider.upsertShoppingList(shoppingList);
    await this.remoteStorageProvider.upsertShoppingList(shoppingList);
  }

  saveSettings(settings: Settings): void {
    this.localStorageProvider.saveSettings(settings);
  }

  loadSettings(): Settings | null {
    return this.localStorageProvider.loadSettings();
  }

  async deleteShoppingList(shoppingListId: string): Promise<void> {
    this.localStorageProvider.deleteShoppingList(shoppingListId);
    await this.remoteStorageProvider.deleteShoppingList(shoppingListId);
  }
}