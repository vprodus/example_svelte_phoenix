<script>
  import { Node, Svelvet } from "svelvet";
</script>

<Svelvet id="my-canvas" width={700} height={700} TD minimap controls>
  <Node id="A" connections={["B"]} label="I'm A" position={{ x: 0, y: 100 }} />
  <Node
    id="B"
    connections={["C"]}
    label="B is my name"
    position={{ x: 50, y: 300 }}
  />
  <Node id="C" label="They call me C" position={{ x: 100, y: 500 }} />
</Svelvet>
