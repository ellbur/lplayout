
module Graph = LPLayout_Graph
let {doDFSCalc} = module(LPLayout_GraphUtils)

type median<'t> =
    Empty
  | Odd('t)
  | Even('t, 't)

let medianCompare = (type t, elemCompare: (t, t) => Ordering.t) => (a: median<t>, b: median<t>) => {
  switch (a, b) {
    | (Empty, Empty) => Ordering.equal
    | (Empty, _) => Ordering.less
    | (_, Empty) =>  Ordering.greater
    | (Odd(a), Odd(b)) => elemCompare(a, b)
    | (Odd(a), Even(b, c)) =>
        let ab = elemCompare(a, b)
        if Ordering.isLess(ab) {
          Ordering.less
        }
        else {
          let ac = elemCompare(a, c)
          if Ordering.isGreater(ac) {
            Ordering.greater
          }
          else {
            // Technically, undecidable, but we have to pick one
            Ordering.equal
          }
        }
    | (Even(a, b), Odd(c)) =>
        let ac = elemCompare(a, c)
        if Ordering.isGreater(ac) {
          Ordering.greater
        }
        else {
          let bc = elemCompare(b, c)
          if Ordering.isLess(bc) {
            Ordering.less
          }
          else {
            // Technically, undecidable, but we have to pick one
            Ordering.equal
          }
        }
    | (Even(a, b), Even(c, d)) =>
        Exn.raiseError("Not implemented")
  }
}

let arrayMedian = (type t, ar: array<t>): median<t> => {
  let len = ar->Array.length
  let half = (len-1)/2
  if len == 0 {
    Empty
  }
  else if len == 1 {
    Odd(ar[0]->Option.getExn)
  }
  else if mod(len, 2) == 0 {
    Even(ar[half]->Option.getExn, ar[half+1]->Option.getExn)
  }
  else {
    Odd(ar[half]->Option.getExn)
  }
}

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
        individualScores->Array.sort((a, b) => Pervasives.compare(a, b)->Ordering.fromInt)
        let median = arrayMedian(individualScores)
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

