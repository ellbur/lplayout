
Simple hierarchical directed acyclic graph (DAG) layout in [ReScript](https://rescript-lang.org/). Just computes the numbers, doesn't draw anything.

The algorithm is based on a linear programming model that has the advantages of being fast and deterministic at the cost of looking slightly less natural than models based on second-order cost functions such as force-directed layouts.

Each edge has an attribute `sinkPos` that represents the left-to-right ordering of source edges for that sink node. For example, if nodes `a` and `b` feed into node `c`, you can assign the corresponding `ac` and `bc` edges a `sinkPos` of `-1.0` and `+1.0` respectively, to indicate that `ac` is to the left of `bc`. If a node has only one source, the corresponding edge should have a `sinkPos` of `0.0` representing centered. For three sources, `-1.0`, `0.0`, `+1.0`. For four sources, `-1.0`, `-0.33`, `+0.33`, `+1.0`, and so on.

# Example

```sh
npm i @ellbur/lplayout
```

```rescript
open LPLayout.Graph

let nodes = [
  { id: "a" },
  { id: "b" },
  { id: "c" },
  { id: "d" },
  { id: "e" },
  { id: "f" },
  { id: "g" },
  { id: "h" },
]
  
let edges = [
  { edgeID: "ac1", source: "a", sink: "c", sinkPos: -1.0 },
  { edgeID: "bc1", source: "b", sink: "c", sinkPos: 1.0 },
  { edgeID: "de1", source: "d", sink: "e", sinkPos: 0.0 },
  { edgeID: "ef1", source: "e", sink: "f", sinkPos: 0.0 },
  { edgeID: "ga", source: "g", sink: "a", sinkPos: 0.0 },
  { edgeID: "gb", source: "g", sink: "b", sinkPos: 0.0 },
  { edgeID: "hg", source: "h", sink: "g", sinkPos: 0.0 },
  { edgeID: "hd", source: "h", sink: "d", sinkPos: 0.0 },
]

let layout = LPLayout.doLayout({nodes, edges})

Js.Console.log(layout)
```

# In JavaScript

Although written in ReScript, the code is usable from JavaScript. The above example can be written:

```javascript
const lplayout = require('@ellbur/lplayout');

const nodes = [
  { id: "a" },
  { id: "b" },
  { id: "c" },
  { id: "d" },
  { id: "e" },
  { id: "f" },
  { id: "g" },
  { id: "h" },
];
  
const edges = [
  { edgeID: "ac1", source: "a", sink: "c", sinkPos: -1.0 },
  { edgeID: "bc1", source: "b", sink: "c", sinkPos: 1.0 },
  { edgeID: "de1", source: "d", sink: "e", sinkPos: 0.0 },
  { edgeID: "ef1", source: "e", sink: "f", sinkPos: 0.0 },
  { edgeID: "ga", source: "g", sink: "a", sinkPos: 0.0 },
  { edgeID: "gb", source: "g", sink: "b", sinkPos: 0.0 },
  { edgeID: "hg", source: "h", sink: "g", sinkPos: 0.0 },
  { edgeID: "hd", source: "h", sink: "d", sinkPos: 0.0 },
];

const layout = lplayout.doLayout({nodes, edges});

console.log(layout);
```

