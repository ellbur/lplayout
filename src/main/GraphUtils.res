
open Graph
open Comps

type sourceMap = Belt.Map.t<string, array<edge>, StringComp.identity>
type sinkMap = Belt.Map.t<string, array<edge>, StringComp.identity>

let buildSourceMap: array<edge> => sourceMap = edges => {
  let sourceMap: Belt.MutableMap.t<string, array<edge>, _>
    = Belt.MutableMap.make(~id=module(StringComp))
    
  edges->Js.Array2.forEach(edge => {
    switch sourceMap->Belt.MutableMap.get(edge.source) {
      | None => sourceMap->Belt.MutableMap.set(edge.source, [edge])
      | Some(edgeSet) => edgeSet->Js.Array2.push(edge)->ignore
    }
  })
  
  sourceMap->Belt.MutableMap.toArray->Belt.Map.fromArray(~id=module(StringComp))
}

let buildSinkMap: array<edge> => sinkMap = edges => {
  let sinkMap: Belt.MutableMap.t<string, array<edge>, _>
    = Belt.MutableMap.make(~id=module(StringComp))

  edges->Js.Array2.forEach(edge => {
    switch sinkMap->Belt.MutableMap.get(edge.sink) {
      | None => sinkMap->Belt.MutableMap.set(edge.sink, [edge])
      | Some(edgeSet) => edgeSet->Js.Array2.push(edge)->ignore
    }
  })
  
  sinkMap->Belt.MutableMap.toArray->Belt.Map.fromArray(~id=module(StringComp))
}

let doDFSCalc = (nodes: array<node>, sourceMap: sourceMap, ~root, ~nonRoot) => {
  let map: Belt.MutableMap.t<string, _, _> = Belt.MutableMap.make(~id=module(StringComp))
  
  let rec calc = nodeID => {
    switch map->Belt.MutableMap.get(nodeID) {
      | Some(x) => x
      | None =>
        let sourceEdges = sourceMap->Belt.Map.getWithDefault(nodeID, [])
        let x = 
          if Js.Array2.length(sourceEdges) == 0 {
            root(nodeID)
          }
          else {
            nonRoot(nodeID, sourceEdges->Js.Array2.map(edge => (edge, calc(edge.sink))))
          }
          
        map->Belt.MutableMap.set(nodeID, x)
        x
    }
  }
  
  nodes->Js.Array2.map(node => node.id)->Js.Array2.forEach(i=>i->calc->ignore)
  
  map->Belt.MutableMap.toArray->Belt.Map.fromArray(~id=module(StringComp))
}
    

