<script lang="ts">
  import { onMount } from 'svelte';
  import { browser } from '$app/environment';
  import { initializeApp } from '../lib/stores/globalAppState.js';
  import { initializeLocale } from '../lib/utils/i18n.js';
  import ConnectionFailedBanner from '../lib/components/ConnectionFailedBanner.svelte';
  import '../app.css';

  let isInitialized = false;

  onMount(async () => {
    if (browser) {
      initializeLocale();
      await initializeApp();
      isInitialized = true;
    }
  });
</script>

<div class="app-container">
  {#if isInitialized}
    <slot />
    <ConnectionFailedBanner />
  {:else}
    <div class="loading">
      <div class="loading-spinner"></div>
      <p>Loading GoList...</p>
    </div>
  {/if}
</div>

<style>
  .loading {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    height: 100vh;
    color: white;
  }

  .loading-spinner {
    width: 40px;
    height: 40px;
    border: 4px solid rgba(255, 255, 255, 0.3);
    border-top: 4px solid white;
    border-radius: 50%;
    animation: spin 1s linear infinite;
    margin-bottom: 16px;
  }

  @keyframes spin {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
  }
</style>