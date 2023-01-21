
module Graph = LPLayout_Graph

open Graph
open LPLayout_GraphUtils
open LPLayout_Comps

type layout = {
  nodeCenterXs: Js.Dict.t<float>,
  nodeCenterYs: Js.Dict.t<float>,
  edgeExtraNodes: Js.Dict.t<array<string>>
}

type layoutOptions = {
  xSpacing: float,
  ySpacing: float
}

let sum = x => x->Belt.Array.reduce(0.0, (a, b) => a +. b)

let average = x => sum(x)/.(Belt.Array.length(x)->Belt.Int.toFloat)

let doLayout: (graph, layoutOptions) => layout = ({nodes, edges}, layoutOptions) => {
  let averageWidth = average(nodes->Js.Array2.map(({width}) => width +. layoutOptions.xSpacing))
  let averageHeight = average(nodes->Js.Array2.map(({height}) => height +. layoutOptions.ySpacing))
  
  let sourceMap = buildSourceMap(edges)
  
  let levelMap = doDFSCalc(
    nodes,
    sourceMap,
    ~root = _ => 0,
    ~nonRoot = (_, sourceLevels) =>
      sourceLevels->Js.Array2.map(((_, l)) => l)
        ->Js.Array2.reduce(Js.Math.max_int, 0) + 1
  )

  let augmentedNodes = Belt.Array.copy(nodes)
  
  let edgeExtraNodes = Js.Dict.empty()
  
  let augmentedEdges = edges->Belt.Array.flatMap(edge => {
    let {edgeID, source, sink, sinkPos} = edge
    let sourceLevel = levelMap->Js.Dict.get(source)->Belt.Option.getExn
    let sinkLevel = levelMap->Js.Dict.get(sink)->Belt.Option.getExn
    
    if sourceLevel > sinkLevel + 1 {
      let syntheticNodes = Belt.Array.makeBy(sourceLevel - sinkLevel - 1, i => {
        {
          id: edgeID ++ `_synth_node_${i->Belt.Int.toString}`,
          width: 0.0,
          height: 0.0,
          marginLeft: 0.0,
          marginBottom: 0.0,
          marginTop: 0.0,
          marginRight: 0.0
        }
      })
      
      syntheticNodes->Belt.Array.forEachWithIndex((i, node) => {
        augmentedNodes->Belt.Array.push(node)
        levelMap->Js.Dict.set(node.id, i + sinkLevel + 1)
      })
      
      edgeExtraNodes->Js.Dict.set(edgeID, syntheticNodes->Belt.Array.reverse->Belt.Array.map(({id})=>id))
      
      let involvedNodeIDs = {
        Belt.Array.concatMany([
          [ sink ],
          syntheticNodes->Belt.Array.map(({id}) => id),
          [ source ]
        ])
      }
      
      Belt.Array.makeBy(sourceLevel - sinkLevel, i => {
        {
          edgeID: `${edgeID}_pos_${i->Belt.Int.toString}`,
          source: involvedNodeIDs[i+1],
          sink: involvedNodeIDs[i],
          sinkPos: {
            if i == 0 {
              sinkPos
            }
            else {
              0.0
            }
          }
        }
      })
    }
    else {
      [edge]
    }
  })
  
  let augmentedSourceMap = buildSourceMap(augmentedEdges)
  
  let rootCounter = ref(0.0)
  let xIndexMap = doDFSCalc(
    augmentedNodes,
    augmentedSourceMap,
    ~root = _ => {
      let x = rootCounter.contents
      rootCounter.contents = rootCounter.contents +. 1.0
      x
    },
    ~nonRoot = (nodeID, sourceYIndices) => {
      let level = levelMap->Js.Dict.unsafeGet(nodeID)
      let scale = Js.Math.pow_float(~base=0.5, ~exp=level->Belt.Int.toFloat)
      let influences = sourceYIndices->Js.Array2.map((({sinkPos}, influence)) =>
        influence +. (scale*.sinkPos))
      
      let average = ( influences->Js.Array2.reduce((x, y) => x +. y, 0.0) ) /.
        ( influences->Js.Array2.length->Belt.Int.toFloat )
        
      average
    }
  )

  let maxLevel = levelMap->Js.Dict.values->Js.Array2.reduce(Js.Math.max_int, 0)
  let numLevels = maxLevel + 1

  module NodeWithXIndex = {
    type t = {
      nodeID: string,
      xIndex: float
    }
  }

  let levelGroupings: array<array<NodeWithXIndex.t>> = Belt.Array.makeBy(numLevels, _ => [ ])
  levelMap->Js.Dict.entries->Belt.Array.forEach(((nodeID, level)) => {
    let levelArray = levelGroupings[level]
    levelArray->Js.Array2.push({
      NodeWithXIndex.nodeID: nodeID,
      NodeWithXIndex.xIndex: xIndexMap->Js.Dict.unsafeGet(nodeID)
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
  
  let idMap = augmentedNodes->Js.Array2.map(node => {let {id} = node; (id, node)})
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
        
        let node1 = nodeIDs[i]
        let node2 = nodeIDs[i+1]
        
        let {width: widthN1, marginRight: marginRightN1} = idMap->Belt.Map.getExn(node1)
        let {width: widthN2, marginLeft: marginLeftN2} = idMap->Belt.Map.getExn(node2)
        let width1 = widthN1 /. averageWidth
        let marginRight1 = marginRightN1 /. averageWidth
        let width2 = widthN2 /. averageWidth
        let marginLeft2 = marginLeftN2 /. averageWidth
        
        let separation = 0.5 *. (width1 +. marginRight1 +. marginLeft2 +. width2) +. horizontalSpacing
        
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
  
  let nodeCenterXs = Js.Dict.empty()
  let nodeCenterYs = Js.Dict.empty()
  
  let levelHeights = siftedLevelGroupings->Js.Array2.map(group =>
    group->Js.Array2.map(id => idMap->Belt.Map.getExn(id))
      ->Js.Array2.map(({height, marginTop, marginBottom}) => height +. marginTop +. marginBottom)
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
  
  levelMap->Js.Dict.entries->Belt.Array.forEach(((nodeID, level)) => {
    let {marginTop, marginBottom} = idMap->Belt.Map.getExn(nodeID)
    let h1 = accumHeights[level]
    let h2 = accumHeights[level + 1]
    let h1 = h1 +. marginTop
    let h2 = h2 -. marginBottom
    let midHeight = 0.5 *. (h1 +. h2)
    nodeCenterYs->Js.Dict.set(nodeID, midHeight)
  })
  
  augmentedNodes->Js.Array2.forEach(({id: nodeId}) =>
    nodeCenterXs->Js.Dict.set(nodeId, 
      ( sol->JsMap.getWithDefault(nodeId, 0.0) ) *. averageWidth
    )
  )
    
  let overhangs = augmentedNodes->Js.Array2.map(({id, width}) => {
    let cx = nodeCenterXs->Js.Dict.unsafeGet(id)
    let overhang = (width/.2.0) +. (horizontalSpacing*.averageWidth/.2.0) -. cx
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

