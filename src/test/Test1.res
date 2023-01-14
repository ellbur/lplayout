
type node = {
  id: string
}

type edge = {
  edgeID: string,
  source: string,
  sink: string,
  sinkPos: float
}
  
let nodes = [
  { id: "a" },
  { id: "b" },
  { id: "c" },
  { id: "d" },
  { id: "e" },
  { id: "f" },
  { id: "g" },
  { id: "h" },
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

module StringComp = Belt.Id.MakeComparable({
  type t = string
  let cmp = Pervasives.compare
})

let sourceMap: Belt.MutableMap.t<string, array<edge>, _>
  = Belt.MutableMap.make(~id=module(StringComp))
  
edges->Js.Array2.forEach(edge => {
  switch sourceMap->Belt.MutableMap.get(edge.source) {
    | None => sourceMap->Belt.MutableMap.set(edge.source, [edge])
    | Some(edgeSet) => edgeSet->Js.Array2.push(edge)->ignore
  }
})

let sinkMap: Belt.MutableMap.t<string, array<edge>, _>
  = Belt.MutableMap.make(~id=module(StringComp))

edges->Js.Array2.forEach(edge => {
  switch sinkMap->Belt.MutableMap.get(edge.sink) {
    | None => sinkMap->Belt.MutableMap.set(edge.sink, [edge])
    | Some(edgeSet) => edgeSet->Js.Array2.push(edge)->ignore
  }
})
  
Js.Console.log("sinkMap:\n" ++ sinkMap->Belt.MutableMap.toArray
  ->Belt.Array.joinWith("\n", ((sink, edges)) =>
    "  " ++ sink ++ ": " ++ edges->Belt.Array.joinWith(", ", e => e.edgeID)) ++ "\n\n")

let doDFSCalc = (~root, ~nonRoot) => {
  let map: Belt.MutableMap.t<string, _, _> = Belt.MutableMap.make(~id=module(StringComp))
  
  let rec calc = nodeID => {
    switch map->Belt.MutableMap.get(nodeID) {
      | Some(x) => x
      | None =>
        let sourceEdges = sourceMap->Belt.MutableMap.getWithDefault(nodeID, [])
        let x = 
          if Js.Array2.length(sourceEdges) == 0 {
            root(nodeID)
          }
          else {
            nonRoot(nodeID, sourceEdges->Js.Array2.map(edge => (edge, calc(edge.sink))))
          }
          
        map->Belt.MutableMap.set(nodeID, x)
        x
    }
  }
  
  nodes->Js.Array2.map(node => node.id)->Js.Array2.forEach(i=>i->calc->ignore)
  
  map
}
    
let levelMap = doDFSCalc(
  ~root = _ => 0,
  ~nonRoot = (_, sourceLevels) =>
    sourceLevels->Js.Array2.map(((_, l)) => l)
      ->Js.Array2.reduce(Js.Math.max_int, 0) + 1
)
  
Js.Console.log("levelMap:\n" ++ levelMap->Belt.MutableMap.toArray
  ->Belt.Array.joinWith("\n", ((id, level)) =>
    "  " ++ id ++ ": " ++ (level->Belt.Int.toString)) ++ "\n\n")

let rootCounter = ref(0.0)
let yIndexMap = doDFSCalc(
  ~root = _ => {
    let x = rootCounter.contents
    rootCounter.contents = rootCounter.contents +. 1.0
    x
  },
  ~nonRoot = (nodeID, sourceYIndices) => {
    let level = levelMap->Belt.MutableMap.getExn(nodeID)
    let scale = Js.Math.pow_float(~base=0.5, ~exp=level->Belt.Int.toFloat)
    let influences = sourceYIndices->Js.Array2.map((({sinkPos}, influence)) =>
      influence +. (scale*.sinkPos))
    
    let average = ( influences->Js.Array2.reduce((x, y) => x +. y, 0.0) ) /.
      ( influences->Js.Array2.length->Belt.Int.toFloat )
      
    average
  }
)

Js.Console.log("yIndexMap:\n" ++ yIndexMap->Belt.MutableMap.toArray
  ->Belt.Array.joinWith("\n", ((id, pos)) =>
    "  " ++ id ++ ": " ++
        (pos->Belt.Float.toString)
      ) ++ "\n\n")
  
let maxLevel = levelMap->Belt.MutableMap.valuesToArray->Js.Array2.reduce(Js.Math.max_int, 0)
let numLevels = maxLevel + 1

module NodeWithYIndex = {
  type t = {
    nodeID: string,
    yIndex: float
  }
}

let levelGroupings: array<array<NodeWithYIndex.t>> = Belt.Array.makeBy(numLevels, _ => [ ])
levelMap->Belt.MutableMap.forEach((nodeID, level) => {
  let levelArray = levelGroupings[level]
  levelArray->Js.Array2.push({
    NodeWithYIndex.nodeID: nodeID,
    NodeWithYIndex.yIndex: yIndexMap->Belt.MutableMap.getExn(nodeID)
  })->ignore
})

let compFloat = (a, b) =>
  if a < b {
    -1
  }
  else if a > b {
    +1
  }
  else {
    0
  }

levelGroupings->Js.Array2.forEach(ar => ar->Belt.SortArray.stableSortInPlaceBy(
  ({NodeWithYIndex.yIndex: y1}, {NodeWithYIndex.yIndex: y2}) => compFloat(y1, y2)))

let siftedLevelGroupings = levelGroupings->Js.Array2.map(ar => ar->Js.Array2.map(({NodeWithYIndex.nodeID: n}) => n))
  
Js.Console.log("Level Groupings:")
siftedLevelGroupings->Js.Array2.forEachi((ar, level) =>
  Js.Console.log(`${level->Belt.Int.toString}: ${ar->Belt.Array.joinWith(", ", x=>x)}`))
Js.Console.log("")

open LPLayout_LP

let indexVar = varName => `${varName}_i`
let indexPlusVar = varName => `${varName}_iP`
let indexMinusVar = varName => `${varName}_iN`

let overlapVar = (node1, node2) => `o_${node1}_${node2}`
let swingVar = (~parent, ~child) => `s_${parent}_${child}`

let backgroudBadness = 0.1
let swingingBadness = 1.0
let overlapBadness = 10.0

let constraints = JsMap.make()
let variables = JsMap.make()

// Do background
nodes->Js.Array2.forEach(node => {
  constraints->JsMap.set(node.id, {"min": 0.0})
  variables->JsMap.set(node.id, {"badness": backgroudBadness})
})

// Do overlaps
siftedLevelGroupings->Js.Array2.forEach(nodes => {
  let rec iter = i => {
    if i < Js.Array2.length(nodes)-1 {
      open JsMap
      
      let node1 = nodes[i]
      let node2 = nodes[i+1]
      
      variables->set(overlapVar(node1, node2), {"badness": overlapBadness})
      constraints->set(overlapVar(node1, node2), {"min": 0.0})
      constraints->set(indexVar(overlapVar(node1, node2)), {"min": 1.0})
      variables->get(node1)->set(indexVar(overlapVar(node1, node2)), -1.0)
      variables->get(node2)->set(indexVar(overlapVar(node1, node2)), 1.0)
      variables->get(overlapVar(node1, node2))->set(indexVar(overlapVar(node1, node2)), 1.0)
      
      iter(i + 1)
    }
  }
  iter(0)
})

// Do swinging
nodes->Js.Array2.forEach(node => {
  let child = node.id
  sourceMap->Belt.MutableMap.getWithDefault(child, [])->Js.Array2.forEach(edge => {
    open JsMap
      
    let parent = edge.sink
    // swing > |child - parent - pos|
    //
    // swing > child - parent - pos
    // swing - child + parent > -pos
    //
    // swing > parent - child + pos
    // swing - parent + child > pos
    
    variables->set(swingVar(~parent, ~child), {"badness": swingingBadness})
    constraints->set(swingVar(~parent, ~child), {"min": 0.0})
    
    constraints->set(indexPlusVar(swingVar(~parent, ~child)), {"min": -. edge.sinkPos})
    variables->get(parent)->set(indexPlusVar(swingVar(~parent, ~child)), +1.0)
    variables->get(child)->set(indexPlusVar(swingVar(~parent, ~child)), -1.0)
    variables->get(swingVar(~parent, ~child))->set(indexPlusVar(swingVar(~parent, ~child)), 1.0)
    
    constraints->set(indexMinusVar(swingVar(~parent, ~child)), {"min": edge.sinkPos})
    variables->get(parent)->set(indexMinusVar(swingVar(~parent, ~child)), -1.0)
    variables->get(child)->set(indexMinusVar(swingVar(~parent, ~child)), +1.0)
    variables->get(swingVar(~parent, ~child))->set(indexMinusVar(swingVar(~parent, ~child)), 1.0)
  })
})

Js.Console.log2("Constraints:", constraints)
Js.Console.log("")

Js.Console.log2("Variables:", variables)
Js.Console.log("")

let model = {
  optimize: "badness",
  opType: #"min",
  constraints: constraints,
  variables: variables
}

let sol = solve(model)

Js.Console.log2("Solution:", sol)
Js.Console.log("")

