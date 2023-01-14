
const lpLayout = require('../../lib/js/src/main/LPLayout.bs')

const nodes = [
  { id: "a" },
  { id: "b" },
  { id: "c" },
  { id: "d" },
  { id: "e" },
  { id: "f" },
  { id: "g" },
  { id: "h" },
]
  
const edges = [
  { edgeID: "ac1", source: "a", sink: "c", sinkPos: -0.5 },
  { edgeID: "bc1", source: "b", sink: "c", sinkPos: 0.5 },
  { edgeID: "de1", source: "d", sink: "e", sinkPos: 0.0 },
  { edgeID: "ef1", source: "e", sink: "f", sinkPos: 0.0 },
  { edgeID: "ga", source: "g", sink: "a", sinkPos: 0.0 },
  { edgeID: "gb", source: "g", sink: "b", sinkPos: 0.0 },
  { edgeID: "hg", source: "h", sink: "g", sinkPos: 0.0 },
  { edgeID: "hd", source: "h", sink: "d", sinkPos: 0.0 },
]

const layout = lpLayout.doLayout({nodes, edges})

console.log(layout)

