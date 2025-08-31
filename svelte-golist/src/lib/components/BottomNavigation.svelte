<script lang="ts">
  import { createEventDispatcher } from 'svelte';
  import { t } from '../utils/i18n.js';

  const dispatch = createEventDispatcher<{
    openDrawer: void;
    openSettings: void;
    refresh: void;
  }>();
</script>

<nav class="bottom-nav">
  <button class="nav-button" on:click={() => dispatch('openDrawer')}>
    <span class="nav-icon">☰</span>
    <span class="nav-label">{$t('my_lists')}</span>
  </button>
  
  <button class="nav-button" on:click={() => dispatch('refresh')}>
    <span class="nav-icon">↻</span>
    <span class="nav-label">Refresh</span>
  </button>
  
  <button class="nav-button" on:click={() => dispatch('openSettings')}>
    <span class="nav-icon">⚙</span>
    <span class="nav-label">{$t('settings')}</span>
  </button>
</nav>

<style>
  .nav-button {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 4px;
  }

  .nav-icon {
    font-size: 20px;
  }

  .nav-label {
    font-size: 10px;
  }
</style>