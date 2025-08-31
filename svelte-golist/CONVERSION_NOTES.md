# Flutter to Svelte Conversion Notes

## Overview

This document outlines the conversion of the GoList Flutter app to a Svelte web application.

## Architecture Changes

### State Management
- **Flutter**: Provider pattern with ChangeNotifier
- **Svelte**: Reactive stores with derived values

### Data Models
- **Flutter**: Dart classes with inheritance
- **Svelte**: TypeScript classes with the same inheritance structure

### Navigation
- **Flutter**: Material/Cupertino navigation
- **Svelte**: Custom modal dialogs and drawer navigation

### Storage
- **Flutter**: GetStorage package for local storage
- **Svelte**: Browser localStorage API

### Networking
- **Flutter**: http package and web_socket_channel
- **Svelte**: Fetch API and WebSocket API

## Key Conversions

### Models
- `GoListModel` → `GoListModel.ts` (abstract base class)
- `Item` → `Item.ts` (with category and icon mapping)
- `ShoppingList` → `ShoppingList.ts` (contains items and recently used items)
- `Settings` → `Settings.ts` (app configuration)

### Collections
- `BaseCollection` → `BaseCollection.ts` (generic collection with CRUD operations)
- `ItemCollection` → `ItemCollection.ts` (items with sorting)
- `ShoppingListCollection` → `ShoppingListCollection.ts` (shopping lists)
- `RecentlyUsedItemCollection` → `RecentlyUsedItemCollection.ts` (search and filtering)

### Services
- `GoListClient` → `GoListClient.ts` (HTTP/WebSocket API client)
- `LocalStorageProvider` → `LocalStorageProvider.ts` (browser localStorage)
- `RemoteStorageProvider` → `RemoteStorageProvider.ts` (API wrapper)
- `ShoppingListStorage` → `ShoppingListStorage.ts` (storage orchestration)
- `InputToItemParser` → `InputToItemParser.ts` (item name to icon mapping)

### UI Components
- `ShoppingListPage` → `+page.svelte` (main page)
- `MainItemListViewer` → Integrated into main page
- `ItemGridView` → `ItemGrid.svelte`
- `AddItemDialog` → `AddItemDialog.svelte`
- `EditItemDialog` → `EditItemDialog.svelte`
- `EditListDialog` → `EditListDialog.svelte`
- `ShoppingListDrawer` → `ShoppingListDrawer.svelte`
- `UndoButton` → `UndoButton.svelte`
- `BottomNavigationBar` → `BottomNavigation.svelte`

### Localization
- **Flutter**: flutter_gen/gen_l10n
- **Svelte**: Custom i18n system with reactive stores

## Features Preserved

✅ **Core Functionality**
- Create, edit, delete shopping lists
- Add, edit, delete items with smart categorization
- Real-time synchronization via WebSocket
- Offline-first with local storage
- Undo functionality for deleted items

✅ **User Experience**
- Mobile-first responsive design
- Touch-friendly interactions
- Smooth animations and transitions
- Intuitive navigation

✅ **Data Management**
- Automatic item icon assignment
- Category-based sorting
- Recently used items suggestions
- Cross-device synchronization

✅ **Internationalization**
- Multi-language support (EN, DE, ES)
- Locale-specific item mappings

## Technical Improvements

### Performance
- Smaller bundle size compared to Flutter web
- Faster initial load time
- Better caching with SvelteKit
- Tree-shaking and code splitting

### Development Experience
- Hot module replacement in development
- TypeScript for better type safety
- Modern JavaScript/ES modules
- Simplified build process

### Web Platform Integration
- Better SEO support with SvelteKit
- Progressive Web App capabilities
- Standard web APIs (localStorage, fetch, WebSocket)
- Better browser developer tools integration

## Deployment

The Svelte version can be deployed to any static hosting service:
- Vercel
- Netlify
- GitHub Pages
- Any CDN or web server

## Missing Features (Future Work)

- Settings page (language selection, etc.)
- Share functionality UI
- App links handling for joining lists
- Service worker for offline functionality
- Push notifications

## Environment Configuration

The app uses environment variables for backend configuration:
- `VITE_BACKEND`: Backend server URL
- `VITE_ENV`: Environment (dev/prod)
- `VITE_API_KEY`: API authentication key