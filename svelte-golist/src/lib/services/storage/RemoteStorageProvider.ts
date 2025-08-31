import { GoListClient } from '../GoListClient.js';
import { ShoppingList } from '../../models/ShoppingList.js';
import { ShoppingListCollection } from '../../models/collections/ShoppingListCollection.js';

export class RemoteStorageProvider {
  private goListClient: GoListClient;

  constructor(goListClient: GoListClient) {
    this.goListClient = goListClient;
  }

  async loadShoppingLists(): Promise<ShoppingListCollection> {
    return await this.goListClient.getShoppingLists();
  }

  async upsertShoppingList(shoppingList: ShoppingList): Promise<void> {
    await this.goListClient.upsertShoppingList(shoppingList);
  }

  async deleteShoppingList(shoppingListId: string): Promise<void> {
    await this.goListClient.deleteShoppingList(shoppingListId);
  }

  async listenForChanges(shoppingListId: string): Promise<ReadableStream<ShoppingList>> {
    return await this.goListClient.listenForChanges(shoppingListId);
  }
}