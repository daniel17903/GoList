<script lang="ts">
  import { recentlyDeletedItems, unDeleteItem } from '../stores/globalAppState.js';
  import { t } from '../utils/i18n.js';

  $: canUndo = $recentlyDeletedItems.length > 0;
</script>

{#if canUndo}
  <button class="undo-button" on:click={unDeleteItem}>
    ↶ {$t('undo', { default: 'Undo' })}
  </button>
{/if}