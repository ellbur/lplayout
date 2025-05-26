
module Graph = LPLayout_Graph

open Graph
open LPLayout_GraphUtils
open LPLayout_Comps

type layout = {
  nodeCenterXs: Js.Dict.t<float>,
  nodeCenterYs: Js.Dict.t<float>,
  edgeExtraNodes: Js.Dict.t<array<string>>
}

type orientation = FlowingUp | FlowingDown

type layoutOptions = {
  xSpacing: float,
  ySpacing: float,
  orientation: orientation
}

let sum = x => x->Belt.Array.reduce(0.0, (a, b) => a +. b)

let average = x => sum(x)/.(Belt.Array.length(x)->Belt.Int.toFloat)

let doLayout: (graph, layoutOptions) => layout = ({nodes, edges}, layoutOptions) => {
  let averageWidth = average(nodes->Js.Array2.map(({width}) => width +. layoutOptions.xSpacing))
  let averageHeight = average(nodes->Js.Array2.map(({height}) => height +. layoutOptions.ySpacing))
  
  let sourceMap = buildSourceMap(edges)
  
  let levelMap: Js.Dict.t<int> = doDFSCalc(
    nodes,
    sourceMap,
    ~root = _ => 0,
    ~nonRoot = (_, sourceLevels) =>
      sourceLevels->Js.Array2.map(((_, l)) => l)
        ->Js.Array2.reduce(Js.Math.max_int, 0) + 1
  )

  let (augmentedNodes, augmentedEdges, edgeExtraNodes) = LPLayout_EdgeAugmenting.augmentNodesAndEdges(levelMap, nodes, edges)

  let augmentedSourceMap = buildSourceMap(augmentedEdges)
  
  let siftedLevelGroupings = LPLayout_XIndexCalcs.buildXIndexMapV2(augmentedSourceMap, levelMap)
  
  let augmentedNodeMap = augmentedNodes->Js.Array2.map(node => {let {id} = node; (id, node)})
    ->Belt.Map.fromArray(~id=module(StringComp))
    
  open LPLayout_LP

  let indexVar = varName => `${varName}_i`
  let indexPlusVar = varName => `${varName}_iP`
  let indexMinusVar = varName => `${varName}_iN`

  let overlapVar = (node1, node2) => `o_${node1}_${node2}`
  let swingVar = (~parent, ~child) => `s_${parent}_${child}`

  let backgroudBadness = 0.01
  let swingingBadness = 1.0
  let overlapBadness = 10.0
  
  let horizontalSpacing = layoutOptions.xSpacing /. averageWidth
  let verticalSpacing = layoutOptions.ySpacing /. averageHeight

  let constraints = JsMap.make()
  let variables = JsMap.make()

  // Do background
  augmentedNodes->Js.Array2.forEach(node => {
    variables->JsMap.set(node.id, {"badness": backgroudBadness})
  })

  // Do overlaps
  siftedLevelGroupings->Js.Array2.forEach(nodeIDs => {
    let rec iter = i => {
      if i < Js.Array2.length(nodeIDs)-1 {
        open JsMap
        
        let node1 = nodeIDs[i]->Option.getExn
        let node2 = nodeIDs[i+1]->Option.getExn
        
        let {width: widthN1, centerX: centerXN1} = augmentedNodeMap->Belt.Map.getExn(node1)
        let {centerX: centerXN2} = augmentedNodeMap->Belt.Map.getExn(node2)

        let width1 = widthN1 /. averageWidth
        let centerX1 = centerXN1 /. averageWidth

        let centerX2 = centerXN2 /. averageWidth
        
        let spacingOnLeft = width1 -. centerX1
        let spacingOnRight = centerX2
        let separation = spacingOnLeft +. spacingOnRight +. horizontalSpacing
        
        variables->set(overlapVar(node1, node2), {"badness": overlapBadness})
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
  augmentedNodes->Js.Array2.forEach(node => {
    let child = node.id
    augmentedSourceMap->Js.Dict.get(child)->Belt.Option.getWithDefault([])->Js.Array2.forEach(edge => {
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
  
  let levelHeights = siftedLevelGroupings->Js.Array2.map(group => {
      let nodesInGroup = group->Js.Array2.map(id => augmentedNodeMap->Belt.Map.getExn(id))
      
      let maxAscent = nodesInGroup->Js.Array2.map(({centerY}) => centerY)->Belt.Array.reduce(0.0, Js.Math.max_float)
      let maxDescent = nodesInGroup->Js.Array2.map(({height, centerY}) => height -. centerY)->Belt.Array.reduce(0.0, Js.Math.max_float)

      Js.Math.max_float(maxAscent, maxDescent)
    }
  )

  let accumHeights = Belt.Array.make((levelHeights->Belt.Array.length) + 1, 0.0)
  
  let totalHeight = {
    let scaledVerticalSpacing = verticalSpacing *. averageHeight
    let accum = ref(0.0)
    levelHeights->Js.Array2.forEachi((h, i) => {
      accumHeights[i] = accum.contents
      accum.contents = accum.contents +. h +. scaledVerticalSpacing
    })
    accumHeights[levelHeights->Belt.Array.length] = accum.contents
    accum.contents
  }
  
  let nodeCenterYs = Js.Dict.empty()
  levelMap->Js.Dict.entries->Belt.Array.forEach(((nodeID, level)) => {
    let h1 = accumHeights[level]->Option.getExn
    let h2 = accumHeights[level + 1]->Option.getExn
    let midHeight = 0.5 *. (h1 +. h2)
    let centerY = switch layoutOptions.orientation {
      | FlowingUp => midHeight
      | FlowingDown => totalHeight -. midHeight
    }
    nodeCenterYs->Js.Dict.set(nodeID, centerY)
  })
  
  let nodeCenterXs = Js.Dict.empty()
  augmentedNodes->Js.Array2.forEach(({id: nodeId}) =>
    nodeCenterXs->Js.Dict.set(nodeId, 
      ( sol->JsMap.getWithDefault(nodeId, 0.0) ) *. averageWidth
    )
  )
    
  let overhangs = augmentedNodes->Js.Array2.map(({id, centerX}) => {
    let cx = nodeCenterXs->Js.Dict.unsafeGet(id)
    let overhang = centerX +. (horizontalSpacing*.averageWidth/.2.0) -. cx
    overhang
  })
  let worstOverhang = overhangs->Belt.Array.reduce(0.0, Js.Math.max_float)
  
  augmentedNodes->Js.Array2.forEach(({id: nodeId}) =>
    nodeCenterXs->Js.Dict.set(nodeId, (nodeCenterXs->Js.Dict.unsafeGet(nodeId)) +. worstOverhang)
  )
  
  {
    nodeCenterXs,
    nodeCenterYs,
    edgeExtraNodes
  }
}

