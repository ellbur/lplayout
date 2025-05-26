
open LPLayout.Graph

let nodes = [
  { id: "b", width: 1.0, height: 1.0, centerX: 0.0, centerY: 0.0 },
  { id: "c", width: 1.0, height: 1.0, centerX: 0.0, centerY: 0.0 },
  { id: "d", width: 1.0, height: 1.0, centerX: 0.0, centerY: 0.0 },
  { id: "e", width: 1.0, height: 1.0, centerX: 0.0, centerY: 0.0 },
]

let edges = [
  { edgeID: "dc", source: "d", sink: "c", sourcePos: 0.0, sinkPos:  0.0 },
  { edgeID: "eb", source: "e", sink: "b", sourcePos: 0.0, sinkPos:  0.0 },
  { edgeID: "ed", source: "e", sink: "d", sourcePos: 0.0, sinkPos:  0.0 },
]

let layout = LPLayout.doLayout({nodes, edges}, { xSpacing: 0.2, ySpacing: 0.2, orientation: FlowingUp })

Js.Console.log(layout)

