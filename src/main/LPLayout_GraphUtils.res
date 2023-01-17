
open LPLayout_Graph

type sourceMap = Js.Dict.t<array<edge>>

let buildSourceMap: array<edge> => sourceMap = edges => {
  let sourceMap = Js.Dict.empty()
    
  edges->Js.Array2.forEach(edge => {
    switch sourceMap->Js.Dict.get(edge.source) {
      | None => sourceMap->Js.Dict.set(edge.source, [edge])
      | Some(edgeSet) => edgeSet->Js.Array2.push(edge)->ignore
    }
  })
  
  sourceMap
}

let doDFSCalc = (nodes: array<node>, sourceMap: sourceMap, ~root, ~nonRoot) => {
  let map = Js.Dict.empty()
  
  let rec calc = nodeID => {
    switch map->Js.Dict.get(nodeID) {
      | Some(x) => x
      | None =>
        let sourceEdges = sourceMap->Js.Dict.get(nodeID)->Belt.Option.getWithDefault([])
        let x = 
          if Js.Array2.length(sourceEdges) == 0 {
            root(nodeID)
          }
          else {
            nonRoot(nodeID, sourceEdges->Js.Array2.map(edge => (edge, calc(edge.sink))))
          }
          
        map->Js.Dict.set(nodeID, x)
        x
    }
  }
  
  nodes->Js.Array2.map(node => node.id)->Js.Array2.forEach(i=>i->calc->ignore)
  
  map
}
    
