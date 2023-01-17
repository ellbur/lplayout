
open LPLayout.Graph

let nodes = [
  { id: "b", width: 1.0, height: 1.0  },
  { id: "c", width: 1.0, height: 1.0  },
  { id: "d", width: 1.0, height: 1.0  },
  { id: "e", width: 1.0, height: 1.0  },
]

let edges = [
  { edgeID: "dc", source: "d", sink: "c", sinkPos:  0.0 },
  { edgeID: "eb", source: "e", sink: "b", sinkPos:  0.0 },
  { edgeID: "ed", source: "e", sink: "d", sinkPos:  0.0 },
]

let layout = LPLayout.doLayout({nodes, edges})

// The problem is that b, d, and e are all positioned at 0.6,
// so the eb edge crosses d.
Js.Console.log(layout)

