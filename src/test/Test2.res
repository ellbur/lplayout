
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

let layout = LPLayout.doLayout({nodes, edges}, { xSpacing: 0.2, ySpacing: 0.2 })

Js.Console.log(layout)

