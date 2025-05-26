
let getOrElse: (option<'x>, () => 'x) => 'x = (o, f) => switch o {
  | None => f()
  | Some(x) => x
}

type node = LPLayout_Graph.node
type edge = LPLayout_Graph.edge

let augmentNodesAndEdges = (levelMap: Js.Dict.t<int>, nodes: array<LPLayout_Graph.node>, edges: array<LPLayout_Graph.edge>): (array<node>, array<edge>, Js.Dict.t<array<string>>) => {
  let augmentedNodes = Belt.Array.copy(nodes)
  let edgeExtraNodes = Js.Dict.empty()
  let augmentedEdges = edges->Belt.Array.flatMap(edge => {
    let {edgeID, source, sink, sourcePos, sinkPos} = edge
    let sourceLevel = levelMap->Js.Dict.get(source)->getOrElse(() => Js.Exn.raiseError(`Malformed graph: edge ${edgeID} has ` ++
      `source ${source} not among nodes [${nodes->Belt.Array.joinWith(", ", n => n.id)}]`))
    let sinkLevel = levelMap->Js.Dict.get(sink)->getOrElse(() => Js.Exn.raiseError(`Malformed graph: edge ${edgeID} has ` ++
      `sink ${sink} not among nodes [${nodes->Belt.Array.joinWith(", ", n => n.id)}]`))
  
    if sourceLevel > sinkLevel + 1 {
      let syntheticNodes: array<LPLayout_Graph.node> = Belt.Array.makeBy(sourceLevel - sinkLevel - 1, i => {
        {
          LPLayout_Graph.id: edgeID ++ `_synth_node_${i->Belt.Int.toString}`,
          width: 0.0,
          height: 0.0,
          centerX: 0.0,
          centerY: 0.0
        }
      })
    
      syntheticNodes->Belt.Array.forEachWithIndex((i, node) => {
        augmentedNodes->Belt.Array.push(node)
        levelMap->Js.Dict.set(node.id, i + sinkLevel + 1)
      })
    
      edgeExtraNodes->Js.Dict.set(edgeID, syntheticNodes->Belt.Array.reverse->Belt.Array.map(({id})=>id))
    
      let involvedNodeIDs = {
        Belt.Array.concatMany([
          [ sink ],
          syntheticNodes->Belt.Array.map(({id}) => id),
          [ source ]
        ])
      }
    
      Belt.Array.makeBy(sourceLevel - sinkLevel, i => {
        {
          LPLayout_Graph.edgeID: `${edgeID}_pos_${i->Belt.Int.toString}`,
          source: involvedNodeIDs[i+1]->Option.getExn,
          sink: involvedNodeIDs[i]->Option.getExn,
          sourcePos: {
            if i == sourceLevel - sinkLevel - 1 {
              sourcePos
            }
            else {
              0.0
            }
          },
          sinkPos: {
            if i == 0 {
              sinkPos
            }
            else {
              0.0
            }
          }
        }
      })
    }
    else {
      [edge]
    }
  })

  (augmentedNodes, augmentedEdges, edgeExtraNodes)
}

