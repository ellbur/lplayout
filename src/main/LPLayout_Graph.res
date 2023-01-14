
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

