
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
  { id: "a", width: 1.0, height: 1.0, marginTop: 0.0, marginLeft: 0.0, marginBottom: 0.0, marginRight: 0.0 },
  { id: "b", width: 1.0, height: 1.0, marginTop: 0.0, marginLeft: 0.0, marginBottom: 0.0, marginRight: 0.0 },
  { id: "c", width: 1.0, height: 1.0, marginTop: 0.0, marginLeft: 0.0, marginBottom: 0.0, marginRight: 0.0 },
  { id: "d", width: 1.0, height: 1.0, marginTop: 0.0, marginLeft: 0.0, marginBottom: 0.0, marginRight: 0.0 },
  { id: "e", width: 1.0, height: 1.0, marginTop: 0.0, marginLeft: 0.0, marginBottom: 0.0, marginRight: 0.0 },
  { id: "f", width: 1.0, height: 1.0, marginTop: 0.0, marginLeft: 0.0, marginBottom: 0.0, marginRight: 0.0 },
  { id: "g", width: 1.0, height: 1.0, marginTop: 0.0, marginLeft: 0.0, marginBottom: 0.0, marginRight: 0.0 },
  { id: "h", width: 1.0, height: 1.0, marginTop: 0.0, marginLeft: 0.0, marginBottom: 0.0, marginRight: 0.0 },
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

let layout = LPLayout.doLayout({nodes, edges}, {xSpacing: 0.2, ySpacing: 0.2})

Js.Console.log(layout)
```

Which gives:

```javascript
{
  nodeCenterXs: {
    a: 0.6,
    b: 1.7999999999999998,
    c: 0.8,
    d: 3,
    e: 3,
    f: 3,
    g: 1.7999999999999998,
    h: 1.7999999999999998
  },
  nodeCenterYs: {
    a: 1.8000000000000003,
    b: 1.8000000000000003,
    c: 0.6,
    d: 3.0000000000000004,
    e: 1.8000000000000003,
    f: 0.6,
    g: 3.0000000000000004,
    h: 4.200000000000001
  }
}
```

# In JavaScript

Although written in ReScript, the code is usable from JavaScript. The above example can be written:

```javascript
const lplayout = require('@ellbur/lplayout');

const nodes = [
  { id: "a", width: 1.0, height: 1.0, marginTop: 0.0, marginLeft: 0.0, marginBottom: 0.0, marginRight: 0.0 },
  { id: "b", width: 1.0, height: 1.0, marginTop: 0.0, marginLeft: 0.0, marginBottom: 0.0, marginRight: 0.0 },
  { id: "c", width: 1.0, height: 1.0, marginTop: 0.0, marginLeft: 0.0, marginBottom: 0.0, marginRight: 0.0 },
  { id: "d", width: 1.0, height: 1.0, marginTop: 0.0, marginLeft: 0.0, marginBottom: 0.0, marginRight: 0.0 },
  { id: "e", width: 1.0, height: 1.0, marginTop: 0.0, marginLeft: 0.0, marginBottom: 0.0, marginRight: 0.0 },
  { id: "f", width: 1.0, height: 1.0, marginTop: 0.0, marginLeft: 0.0, marginBottom: 0.0, marginRight: 0.0 },
  { id: "g", width: 1.0, height: 1.0, marginTop: 0.0, marginLeft: 0.0, marginBottom: 0.0, marginRight: 0.0 },
  { id: "h", width: 1.0, height: 1.0, marginTop: 0.0, marginLeft: 0.0, marginBottom: 0.0, marginRight: 0.0 },
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

const layout = lplayout.doLayout({nodes, edges}, {xSpacing: 0.2, ySpacing: 0.2});

console.log(layout);
```

