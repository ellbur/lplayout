
const lpLayout = require('../../lib/js/src/main/LPLayout.bs')

const nodes = [
  { id: "a", width: 1.0, height: 1. },
  { id: "b", width: 1.0, height: 1. },
  { id: "c", width: 1.0, height: 1. },
  { id: "d", width: 1.0, height: 1. },
  { id: "e", width: 1.0, height: 1. },
  { id: "f", width: 1.0, height: 1. },
  { id: "g", width: 1.0, height: 1. },
  { id: "h", width: 1.0, height: 1. },
]
  
const edges = [
  { edgeID: "ac1", source: "a", sink: "c", sinkPos: -1.0 },
  { edgeID: "bc1", source: "b", sink: "c", sinkPos: 1.0 },
  { edgeID: "de1", source: "d", sink: "e", sinkPos: 0.0 },
  { edgeID: "ef1", source: "e", sink: "f", sinkPos: 0.0 },
  { edgeID: "ga", source: "g", sink: "a", sinkPos: 0.0 },
  { edgeID: "gb", source: "g", sink: "b", sinkPos: 0.0 },
  { edgeID: "hg", source: "h", sink: "g", sinkPos: 0.0 },
  { edgeID: "hd", source: "h", sink: "d", sinkPos: 0.0 },
]

const layout = lpLayout.doLayout({nodes, edges}, {xSpacing: 0.2, ySpacing: 0.2})

console.log(layout)

