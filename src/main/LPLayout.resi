
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

type layoutOptions = {
  xSpacing: float,
  ySpacing: float
}

type layout = {
  nodeCenterXs: Js.Dict.t<float>,
  nodeCenterYs: Js.Dict.t<float>,
  edgeExtraNodes: Js.Dict.t<array<string>>
}

let doLayout: (Graph.graph, layoutOptions) => layout

