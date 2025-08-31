<script lang="ts">
  import { createEventDispatcher } from 'svelte';
  import { t } from '../utils/i18n.js';
  import type { ShoppingList } from '../models/ShoppingList.js';

  export let shoppingList: ShoppingList;

  const dispatch = createEventDispatcher<{
    close: void;
    save: ShoppingList;
    delete: string;
  }>();

  let name = shoppingList.name;
  let showDeleteConfirm = false;

  function handleSubmit() {
    const updatedList = shoppingList.copyWith({ name });
    dispatch('save', updatedList);
    dispatch('close');
  }

  function handleDelete() {
    if (showDeleteConfirm) {
      dispatch('delete', shoppingList.id);
      dispatch('close');
    } else {
      showDeleteConfirm = true;
    }
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
      <h2 class="dialog-title">{$t('edit_list')}</h2>
      <button class="close-button" on:click={() => dispatch('close')}>×</button>
    </div>
    
    <form on:submit|preventDefault={handleSubmit}>
      <div class="form-group">
        <label for="list-name">{$t('name')}</label>
        <input
          id="list-name"
          bind:value={name}
          type="text"
          class="input-field"
          required
        />
      </div>

      <div class="form-actions">
        <button 
          type="button" 
          class="button button-danger" 
          on:click={handleDelete}
        >
          {showDeleteConfirm ? $t('confirm_delete_list') : 'Delete'}
        </button>
        
        <div class="action-group">
          <button type="button" class="button button-secondary" on:click={() => dispatch('close')}>
            {$t('cancel')}
          </button>
          <button type="submit" class="button button-primary">
            {$t('save')}
          </button>
        </div>
      </div>
    </form>
  </div>
</div>

<style>
  .form-group {
    margin-bottom: 16px;
  }

  label {
    display: block;
    color: white;
    font-size: 14px;
    margin-bottom: 4px;
  }

  .form-actions {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-top: 24px;
  }

  .action-group {
    display: flex;
    gap: 12px;
  }

  .button-danger {
    background: #f44336;
    color: white;
  }

  .button-danger:hover {
    background: #d32f2f;
  }
</style>