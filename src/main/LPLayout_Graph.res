
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
  sourcePos: float,
  sinkPos: float
}
  
type graph = {
  nodes: array<node>,
  edges: array<edge>
}

