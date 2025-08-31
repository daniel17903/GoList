<script lang="ts">
  import { createEventDispatcher } from 'svelte';
  import { shoppingLists, settings, setSelectedShoppingListId } from '../stores/globalAppState.js';
  import { t } from '../utils/i18n.js';
  import type { ShoppingList } from '../models/ShoppingList.js';

  const dispatch = createEventDispatcher<{
    close: void;
    createNewList: void;
    editList: ShoppingList;
    shareList: ShoppingList;
  }>();

  export let isOpen = false;

  function selectList(listId: string) {
    setSelectedShoppingListId(listId);
    dispatch('close');
  }

  function handleBackdropClick() {
    dispatch('close');
  }
</script>

{#if isOpen}
  <div class="drawer-overlay" role="button" tabindex="0" on:click={handleBackdropClick} on:keydown={(e) => e.key === 'Escape' && handleBackdropClick()}>
    <div class="drawer" role="navigation" on:click|stopPropagation>
      <div class="drawer-header">
        <h2>{$t('my_lists')}</h2>
        <button class="close-button" on:click={() => dispatch('close')}>×</button>
      </div>
      
      <div class="drawer-content">
        <button 
          class="create-list-button"
          on:click={() => dispatch('createNewList')}
        >
          + {$t('create_new_list')}
        </button>
        
        <div class="lists">
          {#each $shoppingLists.entries as list (list.id)}
            {#if !list.deleted}
              <div 
                class="list-item"
                class:selected={$settings?.selectedShoppingListId === list.id}
              >
                <button 
                  class="list-name"
                  on:click={() => selectList(list.id)}
                >
                  {list.name}
                </button>
                
                <div class="list-actions">
                  <button 
                    class="action-button"
                    on:click={() => dispatch('editList', list)}
                    title="Edit"
                  >
                    ✏️
                  </button>
                  <button 
                    class="action-button"
                    on:click={() => dispatch('shareList', list)}
                    title="Share"
                  >
                    📤
                  </button>
                </div>
              </div>
            {/if}
          {/each}
        </div>
      </div>
    </div>
  </div>
{/if}

<style>
  .drawer-overlay {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(0, 0, 0, 0.5);
    z-index: 1000;
    display: flex;
  }

  .drawer {
    background: var(--app-bar-color);
    width: 300px;
    max-width: 80vw;
    height: 100vh;
    overflow-y: auto;
    box-shadow: 2px 0 10px rgba(0, 0, 0, 0.3);
  }

  .drawer-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 20px;
    border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  }

  .drawer-header h2 {
    color: white;
    margin: 0;
    font-size: 18px;
  }

  .drawer-content {
    padding: 20px;
  }

  .create-list-button {
    width: 100%;
    padding: 12px;
    background: var(--primary-color);
    color: white;
    border: none;
    border-radius: var(--border-radius);
    cursor: pointer;
    font-size: 14px;
    margin-bottom: 20px;
    transition: background 0.2s ease;
  }

  .create-list-button:hover {
    background: #1976D2;
  }

  .lists {
    display: flex;
    flex-direction: column;
    gap: 8px;
  }

  .list-item {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 12px;
    background: rgba(255, 255, 255, 0.05);
    border-radius: var(--border-radius);
    transition: background 0.2s ease;
  }

  .list-item:hover {
    background: rgba(255, 255, 255, 0.1);
  }

  .list-item.selected {
    background: rgba(33, 150, 243, 0.3);
  }

  .list-name {
    flex: 1;
    text-align: left;
    background: none;
    border: none;
    color: white;
    font-size: 14px;
    cursor: pointer;
    padding: 0;
  }

  .list-actions {
    display: flex;
    gap: 8px;
  }

  .action-button {
    background: none;
    border: none;
    cursor: pointer;
    padding: 4px;
    border-radius: 4px;
    transition: background 0.2s ease;
    font-size: 16px;
  }

  .action-button:hover {
    background: rgba(255, 255, 255, 0.1);
  }
</style>