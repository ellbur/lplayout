
module T = LPLayout_XIndexCalcs
module G = LPLayout.Graph

// a b c
// d e

let sourceMap: Js.Dict.t<array<G.edge>> = Js.Dict.fromArray([
  ("a", []),
  ("b", []),
  ("c", []),
  ("d", [{G.edgeID: "da", source: "d", sink: "a", sourcePos: 0.0, sinkPos: -1.0}, {G.edgeID: "dc", source: "d", sink: "c", sourcePos: 0.0, sinkPos: 0.0}]),
  ("e", [{G.edgeID: "ea", source: "e", sink: "a", sourcePos: 0.0, sinkPos: +1.0}, {G.edgeID: "eb", source: "e", sink: "b", sourcePos: 0.0, sinkPos: 0.0}]),
])

let levelMap: Js.Dict.t<int> = Js.Dict.fromArray([
  ("a", 0),
  ("b", 0),
  ("c", 0),
  ("d", 1),
  ("e", 1),
])

let levelGroupings = T.buildXIndexMapV2(sourceMap, levelMap)

levelGroupings->Js.Array2.forEach(group => {
  Js.Console.log(group->Belt.Array.joinWith(" ", x=>x))
})

