
module Graph = LPLayout_Graph

open Graph
open LPLayout_GraphUtils
open LPLayout_Comps

type layout = {
  nodeCenterXs: Js.Dict.t<float>,
  nodeCenterYs: Js.Dict.t<float>
}

let sum = x => x->Belt.Array.reduce(0.0, (a, b) => a +. b)

let average = x => sum(x)/.(Belt.Array.length(x)->Belt.Int.toFloat)

let doLayout: graph => layout = ({nodes, edges}) => {
  let averageWidth = average(nodes->Js.Array2.map(({width}) => width))
  let averageHeight = average(nodes->Js.Array2.map(({height}) => height))
  
  let idMap = nodes->Js.Array2.map(node => {let {id} = node; (id, node)})
    ->Belt.Map.fromArray(~id=module(StringComp))
  
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
  let xIndexMap = doDFSCalc(
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

  module NodeWithXIndex = {
    type t = {
      nodeID: string,
      xIndex: float
    }
  }

  let levelGroupings: array<array<NodeWithXIndex.t>> = Belt.Array.makeBy(numLevels, _ => [ ])
  levelMap->Belt.Map.forEach((nodeID, level) => {
    let levelArray = levelGroupings[level]
    levelArray->Js.Array2.push({
      NodeWithXIndex.nodeID: nodeID,
      NodeWithXIndex.xIndex: xIndexMap->Belt.Map.getExn(nodeID)
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
    ({NodeWithXIndex.xIndex: y1}, {NodeWithXIndex.xIndex: y2}) => compFloat(y1, y2)))

  let siftedLevelGroupings = levelGroupings->Js.Array2.map(ar => ar->Js.Array2.map(({NodeWithXIndex.nodeID: n}) => n))
    
  open LPLayout_LP

  let indexVar = varName => `${varName}_i`
  let indexPlusVar = varName => `${varName}_iP`
  let indexMinusVar = varName => `${varName}_iN`

  let overlapVar = (node1, node2) => `o_${node1}_${node2}`
  let swingVar = (~parent, ~child) => `s_${parent}_${child}`

  let backgroudBadness = 0.1
  let swingingBadness = 1.0
  let overlapBadness = 10.0
  
  let horizontalSpacing = 0.2
  let verticalSpacing = 0.2

  let constraints = JsMap.make()
  let variables = JsMap.make()

  // Do background
  nodes->Js.Array2.forEach(node => {
    constraints->JsMap.set(node.id, {"min": 0.0})
    variables->JsMap.set(node.id, {"badness": backgroudBadness})
  })

  // Do overlaps
  siftedLevelGroupings->Js.Array2.forEach(nodeIDs => {
    let rec iter = i => {
      if i < Js.Array2.length(nodeIDs)-1 {
        open JsMap
        
        let node1 = nodeIDs[i]
        let node2 = nodeIDs[i+1]
        
        let {width: widthN1} = idMap->Belt.Map.getExn(node1)
        let {width: widthN2} = idMap->Belt.Map.getExn(node2)
        let width1 = widthN1 /. averageWidth
        let width2 = widthN2 /. averageWidth
        
        let separation = 0.5 *. (width1 +. width2) +. horizontalSpacing
        
        variables->set(overlapVar(node1, node2), {"badness": overlapBadness})
        constraints->set(overlapVar(node1, node2), {"min": 0.0})
        constraints->set(indexVar(overlapVar(node1, node2)), {"min": separation})
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
  
  let nodeCenterXs = Js.Dict.empty()
  let nodeCenterYs = Js.Dict.empty()
  
  let levelHeights = siftedLevelGroupings->Js.Array2.map(group =>
    group->Js.Array2.map(id => idMap->Belt.Map.getExn(id))
      ->Js.Array2.map(({height}) => height)
      ->Belt.Array.reduce(0.0, Js.Math.max_float)
  )

  let accumHeights = Belt.Array.make((levelHeights->Belt.Array.length) + 1, 0.0)
  
  {
    let scaledVerticalSpacing = verticalSpacing *. averageHeight
    let accum = ref(0.0)
    levelHeights->Js.Array2.forEachi((h, i) => {
      accumHeights[i] = accum.contents
      accum.contents = accum.contents +. h +. scaledVerticalSpacing
    })
    accumHeights[levelHeights->Belt.Array.length] = accum.contents
  }
  
  let midHeights = Belt.Array.make(levelHeights->Belt.Array.length, 0.0)

  {
    let len = levelHeights->Belt.Array.length
    let rec step = i => {
      if i < len {
        midHeights[i] = 0.5*.(accumHeights[i] +. accumHeights[i + 1])
        step(i + 1)
      }
    }
    step(0)
  }
  
  levelMap->Belt.Map.forEach((nodeID, level) =>
    nodeCenterYs->Js.Dict.set(nodeID, midHeights[level]))
  
  nodes->Js.Array2.forEach(({id: nodeId}) =>
    nodeCenterXs->Js.Dict.set(nodeId, 
      ( sol->JsMap.getWithDefault(nodeId, 0.0) ) *. averageWidth
    )
  )
    
  { nodeCenterXs, nodeCenterYs }
}

