<script lang="ts">
  export let size: number = 40;
  export let color: string = 'white';
</script>

<div class="spinner" style="width: {size}px; height: {size}px; border-color: {color};">
</div>

<style>
  .spinner {
    border: 4px solid rgba(255, 255, 255, 0.3);
    border-top: 4px solid var(--color, white);
    border-radius: 50%;
    animation: spin 1s linear infinite;
  }

  @keyframes spin {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
  }
</style>