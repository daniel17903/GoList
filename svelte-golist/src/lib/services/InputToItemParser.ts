import type { IconMapping } from '../types/index.js';
import { Category, categoryFromString } from '../types/index.js';
import { Item } from '../models/Item.js';

export class InputToItemParser {
  private static instance: InputToItemParser;
  private mappings: IconMapping[] = [];
  private languageCode: string = 'en';

  private constructor() {}

  static getInstance(): InputToItemParser {
    if (!InputToItemParser.instance) {
      InputToItemParser.instance = new InputToItemParser();
    }
    return InputToItemParser.instance;
  }

  async init(languageCode: string = 'en'): Promise<void> {
    this.languageCode = languageCode;
    try {
      const response = await fetch(`/assets/mappings_${languageCode}.json`);
      if (response.ok) {
        this.mappings = await response.json();
      } else {
        // Fallback to English if language not found
        const fallbackResponse = await fetch('/assets/mappings_en.json');
        this.mappings = await fallbackResponse.json();
      }
    } catch (error) {
      console.error('Failed to load icon mappings:', error);
      this.mappings = [];
    }
  }

  findMappingForName(name: string): IconMapping {
    const normalizedName = name.toLowerCase().trim();
    
    // Find exact match first
    let mapping = this.mappings.find(mapping =>
      mapping.matchingNames.some(matchingName => 
        matchingName.toLowerCase() === normalizedName
      )
    );

    // If no exact match, find partial match
    if (!mapping) {
      mapping = this.mappings.find(mapping =>
        mapping.matchingNames.some(matchingName => 
          normalizedName.includes(matchingName.toLowerCase()) ||
          matchingName.toLowerCase().includes(normalizedName)
        )
      );
    }

    // Default mapping if nothing found
    if (!mapping) {
      mapping = {
        assetFileName: 'default',
        matchingNames: [name],
        category: 'other'
      };
    }

    return mapping;
  }

  parseInput(input: string): Item {
    const trimmedInput = input.trim();
    
    // Simple parsing - look for number + unit at the beginning
    const amountMatch = trimmedInput.match(/^(\d+(?:\.\d+)?\s*(?:kg|g|l|ml|pcs?|pieces?|x|×)?)\s+(.+)$/i);
    
    let amount: string | null = null;
    let name: string;
    
    if (amountMatch) {
      amount = amountMatch[1].trim();
      name = amountMatch[2].trim();
    } else {
      name = trimmedInput;
    }

    const iconMapping = this.findMappingForName(name);
    
    return new Item({
      name,
      amount,
      iconName: iconMapping.assetFileName,
      category: categoryFromString(iconMapping.category)
    });
  }
}