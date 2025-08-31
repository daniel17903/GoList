<script lang="ts">
  import type { Item } from '../models/Item.js';

  export let item: Item;
  export let onClick: (item: Item) => void = () => {};
  export let onLongPress: (item: Item) => void = () => {};
  export let backgroundColor: string = 'var(--item-background)';
  export let animate: boolean = true;

  let pressTimer: number | null = null;
  let isPressed = false;

  function handleMouseDown() {
    isPressed = true;
    pressTimer = setTimeout(() => {
      if (isPressed) {
        onLongPress(item);
      }
    }, 500);
  }

  function handleMouseUp() {
    isPressed = false;
    if (pressTimer) {
      clearTimeout(pressTimer);
      pressTimer = null;
      onClick(item);
    }
  }

  function handleMouseLeave() {
    isPressed = false;
    if (pressTimer) {
      clearTimeout(pressTimer);
      pressTimer = null;
    }
  }
</script>

<div
  class="item-card"
  class:animate
  style="background: {backgroundColor}"
  on:mousedown={handleMouseDown}
  on:mouseup={handleMouseUp}
  on:mouseleave={handleMouseLeave}
  on:touchstart={handleMouseDown}
  on:touchend={handleMouseUp}
  role="button"
  tabindex="0"
  on:keydown={(e) => {
    if (e.key === 'Enter' || e.key === ' ') {
      onClick(item);
    }
  }}
>
  <img
    class="item-icon"
    src="/assets/icons/{item.iconName}.png"
    alt={item.name}
    on:error={(e) => {
      e.currentTarget.src = '/assets/icons/default.png';
    }}
  />
  <div class="item-name">{item.name}</div>
  {#if item.amount}
    <div class="item-amount">{item.amount}</div>
  {/if}
</div>

<style>
  .item-card.animate {
    animation: slideIn 0.3s ease-out;
  }

  @keyframes slideIn {
    from {
      opacity: 0;
      transform: translateY(20px);
    }
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }
</style>