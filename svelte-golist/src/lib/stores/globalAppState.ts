import { writable, derived, get } from 'svelte/store';
import { browser } from '$app/environment';
import { ShoppingList } from '../models/ShoppingList.js';
import { ShoppingListCollection } from '../models/collections/ShoppingListCollection.js';
import { Settings } from '../models/Settings.js';
import { Item } from '../models/Item.js';
import { GoListClient } from '../services/GoListClient.js';
import { LocalStorageProvider } from '../services/storage/LocalStorageProvider.js';
import { RemoteStorageProvider } from '../services/storage/RemoteStorageProvider.js';
import { ShoppingListStorage } from '../services/storage/ShoppingListStorage.js';
import { InputToItemParser } from '../services/InputToItemParser.js';

// Core stores
export const shoppingLists = writable<ShoppingListCollection>(new ShoppingListCollection([]));
export const settings = writable<Settings | null>(null);
export const shouldShowConnectionFailure = writable<boolean>(false);
export const recentlyDeletedItems = writable<string[]>([]);

// Services
let goListClient: GoListClient;
let shoppingListStorage: ShoppingListStorage;
let removeRecentlyDeletedItemTimers: Map<string, number> = new Map();
let showConnectionFailureTimer: number | null = null;
let streamReader: ReadableStreamDefaultReader<ShoppingList> | null = null;

// Derived stores
export const selectedShoppingList = derived(
  [shoppingLists, settings],
  ([$shoppingLists, $settings]) => {
    if (!$settings) return null;
    return $shoppingLists.entryWithId($settings.selectedShoppingListId);
  }
);

export const languageCode = derived(settings, ($settings) => $settings?.language || 'en');

export const locale = derived(languageCode, ($languageCode) => $languageCode);

// Initialize the app state
export async function initializeApp(): Promise<void> {
  if (!browser) return;

  await LocalStorageProvider.init();
  const localStorageProvider = new LocalStorageProvider();
  await localStorageProvider.migrateFromPreviousVersion();

  goListClient = new GoListClient();
  const remoteStorageProvider = new RemoteStorageProvider(goListClient);
  shoppingListStorage = new ShoppingListStorage(localStorageProvider, remoteStorageProvider);

  const shoppingListsFromStorage = shoppingListStorage.loadShoppingListsFromLocalStorage();
  shoppingLists.set(shoppingListsFromStorage);

  // Load or create settings
  let settingsFromStorage = shoppingListStorage.loadSettings();
  if (!settingsFromStorage || !shoppingListsFromStorage.containsEntryWithId(settingsFromStorage.selectedShoppingListId)) {
    settingsFromStorage = new Settings({
      selectedShoppingListId: shoppingListsFromStorage.first()?.id || '',
      shoppingListOrder: shoppingListsFromStorage.order
    });
    shoppingListStorage.saveSettings(settingsFromStorage);
  }

  settings.set(settingsFromStorage);
  shoppingListsFromStorage.setOrder(settingsFromStorage.shoppingListOrder);
  goListClient.deviceId = settingsFromStorage.deviceId;

  // Initialize input parser
  await InputToItemParser.getInstance().init(settingsFromStorage.language);

  // Create default list if empty
  initWithDefaultListIfEmpty();
  
  // Start listening for changes
  listenForChangesInSelectedShoppingList();
}

function initWithDefaultListIfEmpty(): void {
  const currentShoppingLists = get(shoppingLists);
  const currentSettings = get(settings);
  
  if (currentShoppingLists.length === 0) {
    const defaultList = new ShoppingList({ name: 'Shopping List' });
    currentShoppingLists.upsert(defaultList);
    shoppingListStorage.upsertShoppingList(defaultList);
    
    if (currentSettings) {
      currentSettings.selectedShoppingListId = defaultList.id;
      shoppingListStorage.saveSettings(currentSettings);
      settings.set(currentSettings);
    }
    
    shoppingLists.set(currentShoppingLists);
  }
}

export async function loadListsFromStorage(): Promise<void> {
  try {
    for await (const updatedShoppingLists of shoppingListStorage.loadShoppingLists()) {
      shoppingLists.set(updatedShoppingLists);
    }
    listenForChangesInSelectedShoppingList();
  } catch (error) {
    console.error('Failed to load lists from storage:', error);
    showConnectionFailure();
  }
}

function showConnectionFailure(): void {
  shouldShowConnectionFailure.set(true);
  
  if (showConnectionFailureTimer) {
    clearTimeout(showConnectionFailureTimer);
  }
  
  showConnectionFailureTimer = setTimeout(() => {
    shouldShowConnectionFailure.set(false);
  }, 5000);
}

export function setShoppingListOrder(order: string[]): void {
  const currentShoppingLists = get(shoppingLists);
  const currentSettings = get(settings);
  
  if (currentSettings) {
    currentShoppingLists.setOrder(order);
    currentSettings.shoppingListOrder = order;
    shoppingListStorage.saveSettings(currentSettings);
    shoppingLists.set(currentShoppingLists);
    settings.set(currentSettings);
  }
}

export function setSelectedShoppingListId(selectedShoppingListId: string): void {
  const currentSettings = get(settings);
  
  if (currentSettings && selectedShoppingListId !== currentSettings.selectedShoppingListId) {
    recentlyDeletedItems.set([]);
    removeRecentlyDeletedItemTimers.clear();
    
    currentSettings.selectedShoppingListId = selectedShoppingListId;
    shoppingListStorage.saveSettings(currentSettings);
    settings.set(currentSettings);
    
    listenForChangesInSelectedShoppingList(true);
  }
}

async function listenForChangesInSelectedShoppingList(forceReconnect = false): Promise<void> {
  const currentSettings = get(settings);
  if (!currentSettings) return;

  try {
    if (forceReconnect && streamReader) {
      await streamReader.cancel();
      streamReader = null;
    }

    if (streamReader) return;

    const stream = await shoppingListStorage.listenForChanges(currentSettings.selectedShoppingListId);
    streamReader = stream.getReader();

    const pump = async () => {
      try {
        while (true) {
          const { done, value } = await streamReader!.read();
          if (done) break;
          
          const currentShoppingLists = get(shoppingLists);
          currentShoppingLists.upsert(value);
          shoppingLists.set(currentShoppingLists);
        }
      } catch (error) {
        console.error('Stream error:', error);
        showConnectionFailure();
      } finally {
        streamReader = null;
        // Attempt to reconnect after a delay
        setTimeout(() => listenForChangesInSelectedShoppingList(), 5000);
      }
    };

    pump();
  } catch (error) {
    console.error('Failed to listen for changes:', error);
    showConnectionFailure();
  }
}

export function deleteShoppingList(shoppingListId: string): void {
  const currentShoppingLists = get(shoppingLists);
  const currentSettings = get(settings);
  
  currentShoppingLists.removeEntryWithId(shoppingListId);
  initWithDefaultListIfEmpty();
  
  if (currentSettings && currentSettings.selectedShoppingListId === shoppingListId) {
    const firstList = currentShoppingLists.first();
    if (firstList) {
      currentSettings.selectedShoppingListId = firstList.id;
      shoppingListStorage.saveSettings(currentSettings);
      settings.set(currentSettings);
    }
  }
  
  shoppingListStorage.deleteShoppingList(shoppingListId);
  shoppingLists.set(currentShoppingLists);
}

export function upsertAndSelectShoppingList(shoppingList: ShoppingList): void {
  const currentShoppingLists = get(shoppingLists);
  currentShoppingLists.upsert(shoppingList);
  shoppingListStorage.upsertShoppingList(shoppingList);
  setSelectedShoppingListId(shoppingList.id);
  shoppingLists.set(currentShoppingLists);
}

export function deleteItem(itemId: string): void {
  const currentSelectedList = get(selectedShoppingList);
  if (!currentSelectedList) return;

  currentSelectedList.deleteItem(itemId);
  shoppingListStorage.upsertShoppingList(currentSelectedList);
  
  const currentRecentlyDeleted = get(recentlyDeletedItems);
  recentlyDeletedItems.set([...currentRecentlyDeleted, itemId]);
  
  // Clear existing timer for this item
  const existingTimer = removeRecentlyDeletedItemTimers.get(itemId);
  if (existingTimer) {
    clearTimeout(existingTimer);
  }
  
  // Set new timer to remove from recently deleted
  const timer = setTimeout(() => {
    const currentRecentlyDeleted = get(recentlyDeletedItems);
    recentlyDeletedItems.set(currentRecentlyDeleted.filter(id => id !== itemId));
    removeRecentlyDeletedItemTimers.delete(itemId);
  }, 5000); // 5 seconds to undo
  
  removeRecentlyDeletedItemTimers.set(itemId, timer);
  
  // Trigger reactivity
  const currentShoppingLists = get(shoppingLists);
  shoppingLists.set(currentShoppingLists);
}

export function unDeleteItem(): void {
  const currentRecentlyDeleted = get(recentlyDeletedItems);
  const currentSelectedList = get(selectedShoppingList);
  
  if (currentRecentlyDeleted.length === 0 || !currentSelectedList) return;

  const lastDeletedItemId = currentRecentlyDeleted[0];
  currentSelectedList.unDeleteItem(lastDeletedItemId);
  shoppingListStorage.upsertShoppingList(currentSelectedList);
  
  recentlyDeletedItems.set(currentRecentlyDeleted.filter(id => id !== lastDeletedItemId));
  
  const timer = removeRecentlyDeletedItemTimers.get(lastDeletedItemId);
  if (timer) {
    clearTimeout(timer);
    removeRecentlyDeletedItemTimers.delete(lastDeletedItemId);
  }
  
  // Trigger reactivity
  const currentShoppingLists = get(shoppingLists);
  shoppingLists.set(currentShoppingLists);
}

export function upsertItem(item: Item): void {
  const currentSelectedList = get(selectedShoppingList);
  if (!currentSelectedList) return;

  currentSelectedList.upsertItem(item);
  shoppingListStorage.upsertShoppingList(currentSelectedList);
  
  // Trigger reactivity
  const currentShoppingLists = get(shoppingLists);
  shoppingLists.set(currentShoppingLists);
}

export function setLocale(newLocale: string): void {
  const currentSettings = get(settings);
  if (!currentSettings) return;

  currentSettings.language = newLocale;
  shoppingListStorage.saveSettings(currentSettings);
  InputToItemParser.getInstance().init(newLocale);
  settings.set(currentSettings);
}