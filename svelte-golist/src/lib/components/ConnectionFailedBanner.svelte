<script lang="ts">
  import { shouldShowConnectionFailure } from '../stores/globalAppState.js';
  import { t } from '../utils/i18n.js';
</script>

{#if $shouldShowConnectionFailure}
  <div class="connection-failed">
    {$t('connection_failed')}
  </div>
{/if}