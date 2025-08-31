# Deployment Guide

## Quick Start

1. **Install dependencies**:
   ```bash
   npm install
   ```

2. **Configure environment**:
   ```bash
   cp .env.example .env
   # Edit .env with your backend settings
   ```

3. **Development server**:
   ```bash
   npm run dev
   ```

4. **Production build**:
   ```bash
   npm run build
   npm run preview
   ```

## Environment Variables

Create a `.env` file with:

```env
VITE_BACKEND=your-backend-url:port
VITE_ENV=production
VITE_API_KEY=your-api-key
```

## Deployment Options

### Static Hosting (Recommended)

Since this is a SPA (Single Page Application), you can deploy to any static hosting service:

#### Vercel
```bash
npm install -g vercel
vercel
```

#### Netlify
1. Connect your Git repository
2. Build command: `npm run build`
3. Publish directory: `build`

#### GitHub Pages
```bash
npm install --save-dev @sveltejs/adapter-static
# Update svelte.config.js to use adapter-static
npm run build
# Deploy the build folder
```

### Docker

```dockerfile
FROM node:18-alpine

WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

COPY . .
RUN npm run build

EXPOSE 3000
CMD ["npm", "run", "preview", "--", "--host", "0.0.0.0", "--port", "3000"]
```

### Traditional Web Server

After `npm run build`, serve the `build` directory with any web server:

```bash
# With Python
python -m http.server 8000 -d build

# With Node.js serve
npx serve build

# With nginx
# Copy build/* to your nginx document root
```

## Backend Requirements

The app requires a compatible backend server that provides:

- REST API for shopping list CRUD operations
- WebSocket endpoint for real-time updates
- Token-based list sharing
- CORS headers for web clients

Refer to the original Flutter app's backend configuration for API details.

## Performance Optimization

For production deployment:

1. **Enable compression** (gzip/brotli) on your web server
2. **Set proper cache headers** for static assets
3. **Use a CDN** for global distribution
4. **Enable HTTP/2** for better performance

## Monitoring

Consider adding:
- Error tracking (Sentry, LogRocket)
- Analytics (Google Analytics, Plausible)
- Performance monitoring (Web Vitals)

## Security

- Ensure HTTPS in production
- Configure proper CORS on your backend
- Validate environment variables
- Use secure WebSocket connections (WSS)