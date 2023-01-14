
open Graph
open Comps
open GraphUtils

let todo: () => 'a = Js.Exn.raiseError("Not implemented")

type layout = {
  nodeXs: Belt.Map.t<string, float, StringComp.identity>,
  nodeYs: Belt.Map.t<string, int, StringComp.identity>
}

let doLayout: graph => layout = ({nodes, edges}) => {
  let sourceMap = buildSourceMap(edges)
  
  let levelMap = doDFSCalc(
    nodes,
    sourceMap,
    ~root = _ => 0,
    ~nonRoot = (_, sourceLevels) =>
      sourceLevels->Js.Array2.map(((_, l)) => l)
        ->Js.Array2.reduce(Js.Math.max_int, 0) + 1
  )

  let rootCounter = ref(0.0)
  let yIndexMap = doDFSCalc(
    nodes,
    sourceMap,
    ~root = _ => {
      let x = rootCounter.contents
      rootCounter.contents = rootCounter.contents +. 1.0
      x
    },
    ~nonRoot = (nodeID, sourceYIndices) => {
      let level = levelMap->Belt.Map.getExn(nodeID)
      let scale = Js.Math.pow_float(~base=0.5, ~exp=level->Belt.Int.toFloat)
      let influences = sourceYIndices->Js.Array2.map((({sinkPos}, influence)) =>
        influence +. (scale*.sinkPos))
      
      let average = ( influences->Js.Array2.reduce((x, y) => x +. y, 0.0) ) /.
        ( influences->Js.Array2.length->Belt.Int.toFloat )
        
      average
    }
  )

  let maxLevel = levelMap->Belt.Map.valuesToArray->Js.Array2.reduce(Js.Math.max_int, 0)
  let numLevels = maxLevel + 1

  module NodeWithYIndex = {
    type t = {
      nodeID: string,
      yIndex: float
    }
  }

  let levelGroupings: array<array<NodeWithYIndex.t>> = Belt.Array.makeBy(numLevels, _ => [ ])
  levelMap->Belt.Map.forEach((nodeID, level) => {
    let levelArray = levelGroupings[level]
    levelArray->Js.Array2.push({
      NodeWithYIndex.nodeID: nodeID,
      NodeWithYIndex.yIndex: yIndexMap->Belt.Map.getExn(nodeID)
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
    
  open LP

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
    sourceMap->Belt.Map.getWithDefault(child, [])->Js.Array2.forEach(edge => {
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

  let model = {
    optimize: "badness",
    opType: #"min",
    constraints: constraints,
    variables: variables
  }

  let sol = solve(model)
  
  todo()
}

