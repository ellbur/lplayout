
open LPLayout.Graph

let nodes = [
  { id: "a", width: 1.0, height: 1.0, centerX: 0.0, centerY: 0.0 },
  { id: "b", width: 1.0, height: 1.0, centerX: 0.0, centerY: 0.0 },
  { id: "c", width: 1.0, height: 1.0, centerX: 0.0, centerY: 0.0 },
  { id: "d", width: 1.0, height: 1.0, centerX: 0.0, centerY: 0.0 },
  { id: "e", width: 1.0, height: 1.0, centerX: 0.0, centerY: 0.0 },
  { id: "f", width: 1.0, height: 1.0, centerX: 0.0, centerY: 0.0 },
  { id: "g", width: 1.0, height: 1.0, centerX: 0.0, centerY: 0.0 },
  { id: "h", width: 1.0, height: 1.0, centerX: 0.0, centerY: 0.0 },
]
  
let edges = [
  { edgeID: "ac1", source: "a", sink: "c", sourcePos: 0.0, sinkPos: -1.0 },
  { edgeID: "bc1", source: "b", sink: "c", sourcePos: 0.0, sinkPos: 1.0 },
  { edgeID: "de1", source: "d", sink: "e", sourcePos: 0.0, sinkPos: 0.0 },
  { edgeID: "ef1", source: "e", sink: "f", sourcePos: 0.0, sinkPos: 0.0 },
  { edgeID: "ga", source: "g", sink: "a", sourcePos: 0.0, sinkPos: 0.0 },
  { edgeID: "gb", source: "g", sink: "b", sourcePos: 0.0, sinkPos: 0.0 },
  { edgeID: "hg", source: "h", sink: "g", sourcePos: 0.0, sinkPos: 0.0 },
  { edgeID: "hd", source: "h", sink: "d", sourcePos: 0.0, sinkPos: 0.0 },
]

let layout = LPLayout.doLayout({nodes, edges}, { xSpacing: 0.2, ySpacing: 0.2, orientation: FlowingUp })

Js.Console.log(layout)

