<script lang="ts">
  import { selectedShoppingList, deleteItem, upsertItem, loadListsFromStorage, deleteShoppingList, upsertAndSelectShoppingList } from '../lib/stores/globalAppState.js';
  import { t } from '../lib/utils/i18n.js';
  import { ShoppingList } from '../lib/models/ShoppingList.js';
  import ItemGrid from '../lib/components/ItemGrid.svelte';
  import AddItemDialog from '../lib/components/AddItemDialog.svelte';
  import EditItemDialog from '../lib/components/EditItemDialog.svelte';
  import EditListDialog from '../lib/components/EditListDialog.svelte';
  import UndoButton from '../lib/components/UndoButton.svelte';
  import BottomNavigation from '../lib/components/BottomNavigation.svelte';
  import ShoppingListDrawer from '../lib/components/ShoppingListDrawer.svelte';
  import type { Item } from '../lib/models/Item.js';

  let showAddItemDialog = false;
  let showEditItemDialog = false;
  let showEditListDialog = false;
  let showDrawer = false;
  let editingItem: Item | null = null;
  let editingList: ShoppingList | null = null;
  let isRefreshing = false;

  $: notDeletedItems = $selectedShoppingList?.notDeletedItems() || [];

  function handleItemClick(item: Item) {
    deleteItem(item.id);
  }

  function handleItemLongPress(item: Item) {
    editingItem = item;
    showEditItemDialog = true;
  }

  function handleEditItem(event: CustomEvent<Item>) {
    upsertItem(event.detail);
  }

  function handleAddItem(event: CustomEvent<Item>) {
    upsertItem(event.detail);
  }

  function handleEditList(event: CustomEvent<ShoppingList>) {
    upsertAndSelectShoppingList(event.detail);
  }

  async function handleRefresh() {
    isRefreshing = true;
    try {
      await loadListsFromStorage();
    } finally {
      isRefreshing = false;
    }
  }

  function handleCreateNewList() {
    const newList = new ShoppingList({ name: $t('default_name') });
    upsertAndSelectShoppingList(newList);
    showDrawer = false;
  }

  function handleShareList(event: CustomEvent<ShoppingList>) {
    // TODO: Implement sharing functionality
    console.log('Share list:', event.detail);
  }

  function handleEditListFromDrawer(event: CustomEvent<ShoppingList>) {
    editingList = event.detail;
    showEditListDialog = true;
    showDrawer = false;
  }
</script>

<svelte:head>
  <title>GoList - {$selectedShoppingList?.name || 'Shopping Lists'}</title>
</svelte:head>

<main class="main-content">
  <div class="header">
    <h1 class="list-title">{$selectedShoppingList?.name || 'GoList'}</h1>
    <button 
      class="icon-button"
      on:click={() => {
        editingList = $selectedShoppingList;
        showEditListDialog = true;
      }}
      disabled={!$selectedShoppingList}
    >
      ✏️
    </button>
  </div>

  <div class="shopping-list-container">
    {#if notDeletedItems.length > 0}
      <ItemGrid
        items={notDeletedItems}
        onItemClick={handleItemClick}
        onItemLongPress={handleItemLongPress}
        animate={true}
      />
    {:else}
      <div class="empty-state">
        <p>{$t('empty_list', { default: 'Your shopping list is empty' })}</p>
        <p>{$t('add_items_hint', { default: 'Tap the + button to add items' })}</p>
      </div>
    {/if}
  </div>
</main>

<button class="fab" on:click={() => showAddItemDialog = true}>
  +
</button>

<UndoButton />

<BottomNavigation
  on:openDrawer={() => showDrawer = true}
  on:openSettings={() => {/* TODO: Implement settings */}}
  on:refresh={handleRefresh}
/>

<ShoppingListDrawer
  bind:isOpen={showDrawer}
  on:createNewList={handleCreateNewList}
  on:editList={handleEditListFromDrawer}
  on:shareList={handleShareList}
/>

{#if showAddItemDialog}
  <AddItemDialog
    on:close={() => showAddItemDialog = false}
    on:addItem={handleAddItem}
  />
{/if}

{#if showEditItemDialog && editingItem}
  <EditItemDialog
    item={editingItem}
    on:close={() => {
      showEditItemDialog = false;
      editingItem = null;
    }}
    on:save={handleEditItem}
  />
{/if}

{#if showEditListDialog && editingList}
  <EditListDialog
    shoppingList={editingList}
    on:close={() => {
      showEditListDialog = false;
      editingList = null;
    }}
    on:save={handleEditList}
    on:delete={(e) => {
      deleteShoppingList(e.detail);
      showEditListDialog = false;
      editingList = null;
    }}
  />
{/if}

<style>
  .shopping-list-container {
    flex: 1;
  }

  .empty-state {
    text-align: center;
    padding: 40px 20px;
    color: rgba(255, 255, 255, 0.7);
  }

  .empty-state p {
    margin: 8px 0;
  }
</style>