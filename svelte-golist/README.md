# GoList - Svelte Version

A smart shopping list app converted from Flutter to Svelte. GoList helps you organize your shopping with intelligent item categorization, icon mapping, and real-time synchronization across devices.

## Features

- 🛒 Smart shopping list management
- 🏷️ Automatic item categorization and icon assignment
- 🔄 Real-time synchronization across devices
- 🌍 Multi-language support (English, German, Spanish)
- 📱 Mobile-first responsive design
- ⚡ Fast and lightweight web app
- 🔗 Share lists with others via tokens

## Getting Started

### Prerequisites

- Node.js 18+ 
- npm or yarn

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   npm install
   ```

3. Copy the environment configuration:
   ```bash
   cp .env.example .env
   ```

4. Update the `.env` file with your backend configuration:
   ```
   VITE_BACKEND=your-backend-url:port
   VITE_ENV=dev
   VITE_API_KEY=your-api-key
   ```

### Development

Start the development server:

```bash
npm run dev
```

The app will be available at `http://localhost:5173`

### Building for Production

```bash
npm run build
```

### Preview Production Build

```bash
npm run preview
```

## Architecture

The app follows a clean architecture pattern:

- **Models**: TypeScript classes representing data structures
- **Services**: API client and data processing logic  
- **Stores**: Svelte stores for reactive state management
- **Components**: Reusable Svelte components
- **Utils**: Utility functions including i18n

## Key Components

- **GlobalAppState**: Central state management using Svelte stores
- **ShoppingList & Item**: Core data models with JSON serialization
- **GoListClient**: HTTP/WebSocket API client
- **InputToItemParser**: Intelligent item name to icon/category mapping
- **LocalStorageProvider**: Browser local storage persistence

## Localization

The app supports multiple languages through a custom i18n system. Add new languages by:

1. Adding translations to `src/lib/utils/i18n.ts`
2. Adding corresponding icon mappings to `static/assets/mappings_[lang].json`

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project maintains the same license as the original Flutter version.