
let {doDFSCalc} = module(LPLayout_GraphUtils)

let buildXIndexMapV2 = (nodes: array<LPLayout_Graph.node>, sourceMap, levelMap) => {
  let res = Js.Dict.empty()
  
  let maxLevel = levelMap->Js.Dict.values->Js.Array2.reduce(Js.Math.max_int, 0)
  let numLevels = maxLevel + 1
  let levelGroupings: array<array<string>> = Belt.Array.makeBy(numLevels, _ => [ ])
  levelMap->Js.Dict.entries->Belt.Array.forEach(((nodeID, level)) => {
    let levelArray = levelGroupings[level]
    levelArray->Js.Array2.push(nodeID)->ignore
  })
  
  
  
  res
}

let buildXIndexMapV1 = (nodes, sourceMap, levelMap) => {
  let rootCounter = ref(0.0)
  
  doDFSCalc(
    nodes,
    sourceMap,
    ~root = _ => {
      let x = rootCounter.contents
      rootCounter.contents = rootCounter.contents +. 1.0
      x
    },
    ~nonRoot = (nodeID, sourceXIndices) => {
      let level = levelMap->Js.Dict.unsafeGet(nodeID)
      let scale = Js.Math.pow_float(~base=0.5, ~exp=level->Belt.Int.toFloat)
      let influences = sourceXIndices->Js.Array2.map((({sinkPos}, influence)) =>
        influence +. (scale*.sinkPos)
      )

      let average = ( influences->Js.Array2.reduce((x, y) => x +. y, 0.0) ) /.
      ( influences->Js.Array2.length->Belt.Int.toFloat )

      average
    }
  )
}

let buildXIndexMapV0 = (nodes: array<LPLayout_Graph.node>, _sourceMap, _levelMap) => {
  let res = Js.Dict.empty()
  
  nodes->Js.Array2.forEach(n => {
    res->Js.Dict.set(n.id, 0.0)
  })
  
  res
}

