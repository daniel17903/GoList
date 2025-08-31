// Category enum equivalent to Dart enum
export enum Category {
  FruitsVegetables = 'fruitsVegetables',
  Bread = 'bread',
  MilkCheese = 'milkCheese',
  MeatFish = 'meatFish',
  SpicesCanned = 'spicesCanned',
  ConvenienceProductFrozen = 'convenienceProductFrozen',
  Cereals = 'cereals',
  SweetsSnacks = 'sweetsSnacks',
  Beverages = 'beverages',
  Household = 'household',
  Other = 'other'
}

export function categoryFromString(value: string): Category {
  const categoryKey = Object.keys(Category).find(
    key => Category[key as keyof typeof Category] === value
  );
  return categoryKey ? Category[categoryKey as keyof typeof Category] : Category.Other;
}

export const defaultCategory = Category.Other;

// Icon mapping interface
export interface IconMapping {
  assetFileName: string;
  matchingNames: string[];
  category: string;
}

// HTTP method enum
export enum HttpMethod {
  GET = 'GET',
  POST = 'POST',
  PUT = 'PUT',
  DELETE = 'DELETE'
}