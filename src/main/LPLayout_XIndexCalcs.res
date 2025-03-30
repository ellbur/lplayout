
module Graph = LPLayout_Graph
let {doDFSCalc} = module(LPLayout_GraphUtils)

let buildXIndexMapV2 = (sourceMap: Js.Dict.t<array<Graph.edge>>, levelMap) => {
  let maxLevel = levelMap->Js.Dict.values->Js.Array2.reduce(Js.Math.max_int, 0)
  let numLevels = maxLevel + 1
  let levelGroupings: array<array<string>> = Belt.Array.makeBy(numLevels, _ => [ ])
  levelMap->Js.Dict.entries->Belt.Array.forEach(((nodeID, level)) => {
    let levelArray = levelGroupings[level]->Option.getExn
    levelArray->Js.Array2.push(nodeID)->ignore
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
      currentRow->Js.Array2.forEach(node => {
        let individualScores = [ ]
        sourceMap->Js.Dict.unsafeGet(node)->Js.Array2.forEach(edge => {
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
        individualScores->Js.Array2.sortInPlaceWith((a, b) => Pervasives.compare(a, b))->ignore
        let numScores = individualScores->Js.Array2.length
        let median = {
          let half = (numScores-1)/2
          if numScores == 0 {
            0.0
          }
          else if numScores == 1 {
            individualScores[0]->Option.getExn
          }
          else if mod(numScores, 2) == 0 {
            0.5*.((individualScores[half]->Option.getExn) +. (individualScores[half+1]->Option.getExn))
          }
          else {
            individualScores[half]->Option.getExn
          }
        }
        currentRowScoreMap->Js.Dict.set(node, median)
      })
      
      currentRow->Js.Array2.sortInPlaceWith((node1, node2) => {
        Pervasives.compare(currentRowScoreMap->Js.Dict.get(node1), currentRowScoreMap->Js.Dict.get(node2))
      })->ignore
      
      step(i + 1)
    }
  }
  step(1)
  
  levelGroupings
}

