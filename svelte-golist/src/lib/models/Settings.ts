import { v4 as uuidv4 } from 'uuid';

export class Settings {
  selectedShoppingListId: string;
  shoppingListOrder: string[];
  language: string;
  deviceId: string;

  constructor({
    selectedShoppingListId,
    shoppingListOrder = [],
    language = 'en',
    deviceId
  }: {
    selectedShoppingListId: string;
    shoppingListOrder?: string[];
    language?: string;
    deviceId?: string;
  }) {
    this.selectedShoppingListId = selectedShoppingListId;
    this.shoppingListOrder = shoppingListOrder;
    this.language = language;
    this.deviceId = deviceId || uuidv4();
  }

  static fromJson(json: any): Settings {
    return new Settings({
      selectedShoppingListId: json.selectedShoppingListId,
      shoppingListOrder: json.shoppingListOrder || [],
      language: json.language || 'en',
      deviceId: json.deviceId
    });
  }

  toJson(): Record<string, any> {
    return {
      selectedShoppingListId: this.selectedShoppingListId,
      shoppingListOrder: this.shoppingListOrder,
      language: this.language,
      deviceId: this.deviceId
    };
  }

  get locale(): string {
    return this.language;
  }
}