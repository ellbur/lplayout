
type node = {
  id: string,
  width: float,
  height: float,
  centerX: float,
  centerY: float,
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

