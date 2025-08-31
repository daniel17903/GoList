<script lang="ts">
  import { createEventDispatcher } from 'svelte';
  import { t } from '../utils/i18n.js';
  import type { Item } from '../models/Item.js';

  export let item: Item;

  const dispatch = createEventDispatcher<{
    close: void;
    save: Item;
  }>();

  let name = item.name;
  let amount = item.amount || '';

  function handleSubmit() {
    const updatedItem = item.copy();
    updatedItem.setName(name);
    updatedItem.amount = amount || null;
    dispatch('save', updatedItem);
    dispatch('close');
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
      <h2 class="dialog-title">{$t('edit_item')}</h2>
      <button class="close-button" on:click={() => dispatch('close')}>×</button>
    </div>
    
    <form on:submit|preventDefault={handleSubmit}>
      <div class="form-group">
        <label for="item-name">{$t('name')}</label>
        <input
          id="item-name"
          bind:value={name}
          type="text"
          class="input-field"
          required
        />
      </div>
      
      <div class="form-group">
        <label for="item-amount">{$t('amount')}</label>
        <input
          id="item-amount"
          bind:value={amount}
          type="text"
          class="input-field"
          placeholder="2 kg, 500g, 3 pcs..."
        />
      </div>

      <div class="form-actions">
        <button type="button" class="button button-secondary" on:click={() => dispatch('close')}>
          {$t('cancel')}
        </button>
        <button type="submit" class="button button-primary">
          {$t('save')}
        </button>
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
    gap: 12px;
    justify-content: flex-end;
    margin-top: 24px;
  }
</style>