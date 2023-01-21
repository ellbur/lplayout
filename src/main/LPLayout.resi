
module Graph = LPLayout_Graph

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

