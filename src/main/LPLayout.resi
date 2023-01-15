
module Graph: {
  type node = {
    id: string,
    width: float,
    height: float
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
  nodeCenterXs: Js.Dict.t<float>,
  nodeCenterYs: Js.Dict.t<float>
}

let doLayout: Graph.graph => layout

