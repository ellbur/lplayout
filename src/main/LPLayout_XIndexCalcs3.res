
module Graph = LPLayout_Graph
type edge = Graph.edge

type rowInProgress = {
  groups: array<array<string>>,
  nodeToGroup: Dict.t<int>
}

type direction = FromSource | FromSink

type fillStyle = LeaveGroups | SpreadGroups

let makeUnsortedRow = (rowNodes: array<string>): rowInProgress => {
  {
    groups: [rowNodes->Array.copy],
    nodeToGroup: rowNodes->Array.map(n => (n, 0))->Dict.fromArray
  }
}

let refineRow = (edgeMap: Dict.t<edge>, direction: direction, initRow: rowInProgress, prevRow: rowInProgress, fillStyle: fillStyle): rowInProgress =>
{


  Exn.raiseError("Not implemented")
}

