<script>
  export let number;
  let number2 = 5;

  $: combined = number + number2;
</script>

<h1 class="text-lg mb-4">Svelte template</h1>
{number} + {number2} = {combined}

<button phx-click="increment">+server</button>
<button on:click={() => (number2 += 1)}>+client</button>

<style lang="stylus">
  button
    background-color black
    color white
    padding 0.5rem 1rem
</style>
