
module Graph = LPLayout_Graph
let {doDFSCalc} = module(LPLayout_GraphUtils)
let {arrayMedian, optionMedianCompare} = module(LPLayout_Median)

let maxInt = (a: int, b: int): int => if a < b { b } else { a }

type score = {
  index: int,
  pos: float
}

let scoreOrdering = (s1: score, s2: score): Ordering.t => {
  if s1.index < s2.index {
    Ordering.less
  }
  else if s1.index > s2.index {
    Ordering.greater
  }
  else {
    if s1.pos < s2.pos {
      Ordering.less
    }
    else if s1.pos > s2.pos {
      Ordering.greater
    }
    else {
      Ordering.equal
    }
  }
}

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
              let score: score = { index, pos: sinkPos }
              individualScores->Belt.Array.push(score)
            }
          }
        })
        individualScores->Array.sort(scoreOrdering)
        let median = arrayMedian(individualScores)
        currentRowScoreMap->Js.Dict.set(node, median)
      })
      
      currentRow->Array.sort((node1, node2) => {
        optionMedianCompare(scoreOrdering)(currentRowScoreMap->Js.Dict.get(node1), currentRowScoreMap->Js.Dict.get(node2))
      })
      
      step(i + 1)
    }
  }
  step(1)
  
  levelGroupings
}

