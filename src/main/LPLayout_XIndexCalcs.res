
module Graph = LPLayout_Graph
let {doDFSCalc} = module(LPLayout_GraphUtils)

let arrayMedianWithDefault = (ar, d) => {
  let len = ar->Array.length
  let half = (len-1)/2
  if len == 0 {
    d
  }
  else if len == 1 {
    ar[0]->Option.getExn
  }
  else if mod(len, 2) == 0 {
    0.5*.((ar[half]->Option.getExn) +. (ar[half+1]->Option.getExn))
  }
  else {
    ar[half]->Option.getExn
  }
}

let maxInt = (a: int, b: int): int => if a < b { b } else { a }

let buildXIndexMapV2 = (sourceMap: Js.Dict.t<array<Graph.edge>>, levelMap) => {
  let maxLevel = levelMap->Js.Dict.values->Array.reduce(0, maxInt)
  let numLevels = maxLevel + 1
  let levelGroupings: array<array<string>> = Belt.Array.makeBy(numLevels, _ => [ ])
  levelMap->Js.Dict.entries->Belt.Array.forEach(((nodeID, level)) => {
    let levelArray = levelGroupings[level]->Option.getExn
    levelArray->Array.push(nodeID)
  })
  
  let rec step = i => {
    if i < numLevels {
      let previousRow = levelGroupings[i-1]->Option.getExn
      let currentRow = levelGroupings[i]->Option.getExn
      
      let prevRowIndexMap = Js.Dict.empty()
      previousRow->Belt.Array.forEachWithIndex((i, node) => {
        prevRowIndexMap->Js.Dict.set(node, i)
      })
      
      let currentRowScoreMap = Js.Dict.empty()
      currentRow->Array.forEach(node => {
        let individualScores = [ ]
        sourceMap->Dict.get(node)->Option.getExn->Array.forEach(edge => {
          let {sink, sinkPos} = edge
          switch prevRowIndexMap->Js.Dict.get(sink) {
            | None => {
              // This might be a recursive edge?
              // Anyway, don't handle it.
              ()
            }
            | Some(index) => {
              let effectiveScore = (index->Belt.Int.toFloat)*.3.0 +. sinkPos
              individualScores->Belt.Array.push(effectiveScore)
            }
          }
        })
        individualScores->Array.sort((a, b) => Pervasives.compare(a, b)->Ordering.fromInt)
        let median = arrayMedianWithDefault(individualScores, 0.0)
        currentRowScoreMap->Js.Dict.set(node, median)
      })
      
      currentRow->Array.sort((node1, node2) => {
        Pervasives.compare(currentRowScoreMap->Js.Dict.get(node1), currentRowScoreMap->Js.Dict.get(node2))->Ordering.fromInt
      })
      
      step(i + 1)
    }
  }
  step(1)
  
  levelGroupings
}

