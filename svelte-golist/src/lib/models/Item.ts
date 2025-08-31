import { GoListModel } from './GoListModel.js';
import { Category, categoryFromString } from '../types/index.js';
import { InputToItemParser } from '../services/InputToItemParser.js';

export class Item extends GoListModel {
  private _iconName: string;
  private _amount: string | null;
  private _category: Category;

  constructor({
    id,
    name,
    iconName,
    amount,
    category,
    deleted = false,
    modified
  }: {
    id?: string;
    name: string;
    iconName: string;
    amount?: string | null;
    category: Category;
    deleted?: boolean;
    modified?: Date;
  }) {
    super({ id, name, deleted, modified });
    this._iconName = iconName;
    this._amount = amount || null;
    this._category = category;
  }

  static fromJson(json: any): Item {
    return new Item({
      id: json.id,
      name: json.name,
      iconName: json.iconName,
      amount: json.amount,
      category: json.category ? categoryFromString(json.category) : Category.Other,
      deleted: json.deleted,
      modified: new Date(json.modified)
    });
  }

  static fromInput(name: string, amount?: string | null): Item {
    const item = new Item({
      name,
      iconName: 'default',
      amount,
      category: Category.Other
    });
    item.findMapping();
    return item;
  }

  findMapping(): void {
    try {
      const iconMapping = InputToItemParser.getInstance().findMappingForName(this.name);
      this._iconName = iconMapping.assetFileName;
      this._category = categoryFromString(iconMapping.category);
    } catch (error) {
      // Fallback if InputToItemParser is not initialized
      this._iconName = 'default';
      this._category = Category.Other;
    }
  }

  setName(name: string): void {
    this.name = name;
    this.findMapping();
    this.modified = new Date();
  }

  equalsById(other: Item): boolean {
    return this.id === other.id;
  }

  toJson(): Record<string, any> {
    return {
      ...super.toJson(),
      iconName: this.iconName,
      amount: this.amount,
      category: this.category.toString()
    };
  }

  compareTo(other: Item): number {
    if (this.category === other.category) {
      return this.name.toLowerCase().localeCompare(other.name.toLowerCase());
    }
    return Object.values(Category).indexOf(this.category) - Object.values(Category).indexOf(other.category);
  }

  copyAsNewItem(): Item {
    return new Item({
      name: this.name,
      iconName: this.iconName,
      amount: this.amount,
      category: this.category,
      deleted: false
    });
  }

  copy(): Item {
    return new Item({
      id: this.id,
      name: this.name,
      iconName: this.iconName,
      amount: this.amount,
      category: this.category,
      deleted: this.deleted,
      modified: this.modified
    });
  }

  copyForRecentlyUsed(): Item {
    return new Item({
      name: this.name,
      iconName: this.iconName,
      amount: '',
      category: this.category,
      deleted: false
    });
  }

  merge(other: GoListModel): GoListModel {
    return this.modified > other.modified ? this : other;
  }

  equals(other: GoListModel): boolean {
    return other instanceof Item &&
           other.id === this.id &&
           other.name === this.name &&
           other.deleted === this.deleted &&
           other.iconName === this.iconName &&
           other.amount === this.amount &&
           other.category === this.category;
  }

  // Getters and setters
  get iconName(): string {
    return this._iconName;
  }

  set iconName(value: string) {
    this.modified = new Date();
    this._iconName = value;
  }

  get amount(): string | null {
    return this._amount;
  }

  set amount(value: string | null) {
    this.modified = new Date();
    this._amount = value;
  }

  get category(): Category {
    return this._category;
  }

  set category(value: Category) {
    this.modified = new Date();
    this._category = value;
  }
}