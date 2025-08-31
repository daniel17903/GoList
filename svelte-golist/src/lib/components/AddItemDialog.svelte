<script lang="ts">
  import { createEventDispatcher, onMount } from 'svelte';
  import { t } from '../utils/i18n.js';
  import { selectedShoppingList } from '../stores/globalAppState.js';
  import { InputToItemParser } from '../services/InputToItemParser.js';
  import { Item } from '../models/Item.js';
  import ItemGrid from './ItemGrid.svelte';
  import type { RecentlyUsedItemCollection } from '../models/collections/RecentlyUsedItemCollection.js';

  const dispatch = createEventDispatcher<{
    close: void;
    addItem: Item;
  }>();

  let searchText = '';
  let previewItem: Item | null = null;
  let recentlyUsedItemsSorted: RecentlyUsedItemCollection;
  let inputElement: HTMLInputElement;

  $: if ($selectedShoppingList) {
    recentlyUsedItemsSorted = $selectedShoppingList.recentlyUsedItems;
  }

  $: {
    if (recentlyUsedItemsSorted) {
      recentlyUsedItemsSorted.searchBy(searchText);
      
      const previewItemMatchesFirstRecentlyUsedItem = 
        searchText === recentlyUsedItemsSorted.first()?.name;
      const previewItemDidChange = previewItem?.name !== searchText;
      
      if (searchText.length === 0 || previewItemMatchesFirstRecentlyUsedItem) {
        previewItem = null;
      } else if (previewItemDidChange) {
        previewItem = InputToItemParser.getInstance().parseInput(searchText);
      }
    }
  }

  $: itemsToShow = [
    ...(previewItem ? [previewItem] : []),
    ...(recentlyUsedItemsSorted ? recentlyUsedItemsSorted.itemsToShow() : [])
  ];

  onMount(() => {
    inputElement?.focus();
  });

  function addNewItemToList(item: Item | null) {
    if (item) {
      dispatch('addItem', item.copyAsNewItem());
      dispatch('close');
    }
  }

  function handleSubmit() {
    addNewItemToList(previewItem);
  }

  function handleKeyDown(event: KeyboardEvent) {
    if (event.key === 'Escape') {
      dispatch('close');
    }
  }
</script>

<svelte:window on:keydown={handleKeyDown} />

<div class="dialog-overlay" role="button" tabindex="0" on:click={() => dispatch('close')} on:keydown={(e) => e.key === 'Escape' && dispatch('close')}>
  <div class="dialog" role="dialog" on:click|stopPropagation>
    <div class="dialog-header">
      <h2 class="dialog-title">{$t('what_to_buy')}</h2>
      <button class="close-button" on:click={() => dispatch('close')}>×</button>
    </div>
    
    <form on:submit|preventDefault={handleSubmit}>
      <input
        bind:this={inputElement}
        bind:value={searchText}
        type="text"
        class="input-field"
        placeholder={$t('what_to_buy')}
        autocomplete="off"
      />
    </form>

    <div class="items-container">
      <ItemGrid
        items={itemsToShow}
        onItemClick={addNewItemToList}
        itemBackgroundColor="var(--add-item-dialog-item-background)"
        animate={false}
        maxItemSize={125}
      />
    </div>
  </div>
</div>

<style>
  .items-container {
    max-height: 400px;
    overflow-y: auto;
  }
</style>