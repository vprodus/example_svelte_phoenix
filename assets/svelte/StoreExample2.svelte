<script>
  import store from "./stores/store";
</script>

<label>
  <input type="checkbox" bind:checked={$store} />
  {$store}
</label>
