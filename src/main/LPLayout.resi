
module Graph: {
  type node = {
    id: string
  }

  type edge = {
    edgeID: string,
    source: string,
    sink: string,
    sinkPos: float
  }
    
  type graph = {
    nodes: array<node>,
    edges: array<edge>
  }
}

type layout = {
  nodeXs: Js.Dict.t<float>,
  nodeYs: Js.Dict.t<int>
}

let doLayout: Graph.graph => layout

