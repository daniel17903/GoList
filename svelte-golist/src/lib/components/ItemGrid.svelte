<script lang="ts">
  import type { Item } from '../models/Item.js';
  import ItemCard from './ItemCard.svelte';

  export let items: Item[] = [];
  export let onItemClick: (item: Item) => void = () => {};
  export let onItemLongPress: (item: Item) => void = () => {};
  export let itemBackgroundColor: string = 'var(--item-background)';
  export let animate: boolean = true;
  export let maxItemSize: number = 140;
</script>

<div class="item-grid" style="grid-template-columns: repeat(auto-fill, minmax({Math.min(maxItemSize, 120)}px, 1fr));">
  {#each items as item (item.id)}
    <ItemCard
      {item}
      onClick={onItemClick}
      onLongPress={onItemLongPress}
      backgroundColor={itemBackgroundColor}
      {animate}
    />
  {/each}
</div>