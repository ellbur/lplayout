
open LPLayout.Graph

let nodes = [
  { id: "b", width: 1.0, height: 1.0, marginTop: 0.0, marginLeft: 0.0, marginBottom: 0.0, marginRight: 0.0  },
  { id: "c", width: 1.0, height: 1.0, marginTop: 0.0, marginLeft: 0.0, marginBottom: 0.0, marginRight: 0.0  },
  { id: "d", width: 1.0, height: 1.0, marginTop: 0.0, marginLeft: 0.0, marginBottom: 0.0, marginRight: 0.0  },
  { id: "e", width: 1.0, height: 1.0, marginTop: 0.0, marginLeft: 0.0, marginBottom: 0.0, marginRight: 0.0  },
]

let edges = [
  { edgeID: "dc", source: "d", sink: "c", sinkPos:  0.0 },
  { edgeID: "eb", source: "e", sink: "b", sinkPos:  0.0 },
  { edgeID: "ed", source: "e", sink: "d", sinkPos:  0.0 },
]

let layout = LPLayout.doLayout({nodes, edges}, { xSpacing: 0.2, ySpacing: 0.2 })

Js.Console.log(layout)

