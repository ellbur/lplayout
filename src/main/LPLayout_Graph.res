
type node = {
  id: string,
  width: float,
  height: float,
  marginLeft: float,
  marginRight: float,
  marginTop: float,
  marginBottom: float,
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

