
open LPLayout.Graph

let nodes = [
  { id: "a", width: 1.0, height: 1.0 },
  { id: "b", width: 2.0, height: 2.0 },
  { id: "c", width: 1.0, height: 1.0 },
]

let edges = [
  { edgeID: "ac", source: "a", sink: "c", sinkPos: -1.0 },
  { edgeID: "bc", source: "b", sink: "c", sinkPos: 1.0 },
]

let layout = LPLayout.doLayout({nodes, edges})

Js.Console.log(layout)
