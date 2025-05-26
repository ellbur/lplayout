
module SVGGraph = {
  type nodeMetrics = {
    nodeBorderStrokeWidth: string,
    nodeHorizontalPadding: float,
    nodeVerticalPadding: float,
    nodeFontSize: string,
    nodeFontFamily: string,
    nodeSideTextFontSize: string,
    nodeSideTextFontFamily: string,
    nodeSideTextXOffset: float,
    nodeRoundingX: float,
    nodeRoundingY: float,
  }

  type nodeAnnotations = {
    lowerLeft?: string,
    upperLeft?: string,
    lowerRight?: string,
    upperRight?: string,
  }

  type node = {
    id: string,
    text: string,
    nodeAnnotations: nodeAnnotations,
    nodeMetrics: nodeMetrics,
  }

  type edgeMetrics = {
    edgeStrokeWidth: string,
    edgeSinkLabelFontSize: string,
    edgeSinkLabelFontFamily: string,
    edgeSinkLabelXOffset: float,
    edgeSinkLabelYOffset: float,
    edgeRectangularness: float,
  }

  type edge = {
    edgeID: string,
    source: string,
    sink: string,
    sinkPos: float,
    sinkLabel: string,
    edgeMetrics: edgeMetrics,
  }

  type graphMetrics = {
    xSpacing: float,
    ySpacing: float,
  }

  type graph = {
    nodes: array<node>,
    edges: array<edge>,
    graphMetrics: graphMetrics,
  }
}

external coerce: 'a => 'b = "%identity"

let graph: SVGGraph.graph = SnarlTestData.testData->coerce

Js.Console.log(graph)

module Document = Webapi.Dom.Document
module Element = Webapi.Dom.Element

module SVGRect = {
  type t = {
    x: float,
    y: float,
    width: float,
    height: float
  }
}

@send external getBBox: Dom.element => SVGRect.t = "getBBox"

let {setAttribute} = module(Webapi.Dom.Element)
let fts = Belt.Float.toString

let removeAllChildren = el => {
  let rec step = () => {
    switch el->Element.lastChild {
      | None => ()
      | Some(child) => {
        el->Element.removeChild(~child)->ignore
        step()
      }
    }
  }
  step()
}

module SVGUtils = {
  module Document = Webapi.Dom.Document
  module Element = Webapi.Dom.Element

  let svgNS = "http://www.w3.org/2000/svg"

  let sa = (el, k, v) => v->Belt.Option.forEach(v => el->Element.setAttribute(k, v))
  type os = option<string>

  let svg = (
    document: Document.t
  ) => {
    let el = document->Document.createElementNS(svgNS, "svg")
    el
  }

  let g = (
    document: Document.t,
    ~children: array<Element.t>
  ) => {
    let el = document->Document.createElementNS(svgNS, "g")
    children->Belt.Array.forEach(child => {
      el->Element.appendChild(~child)
    })
    el
  }

  let rect = (
    document: Document.t,
    ~rx: os=?,
    ~ry: os=?,
    ~fill: os=?,
    ~strokeWidth: os=?,
    ~class: os=?,
    ~stroke: os=?,
    ()
  ) => {
    let el = document->Document.createElementNS(svgNS, "rect")
    el->sa("rx", rx)
    el->sa("ry", ry)
    el->sa("fill", fill)
    el->sa("stroke-width", strokeWidth)
    el->sa("class", class)
    el->sa("stroke", stroke)
    el
  }

  let text = (
    document: Document.t,
    ~textAnchor: os=?,
    ~dominantBaseline: os=?,
    ~fontSize: os=?,
    ~fontFamily: os=?,
    ~class: os=?,
    ~textContent: os=?,
    ()
  ) => {
    let el = document->Document.createElementNS(svgNS, "text")
    el->sa("text-anchor", textAnchor)
    el->sa("dominant-baseline", dominantBaseline)
    el->sa("font-size", fontSize)
    el->sa("font-family", fontFamily)
    el->sa("class", class)
    textContent->Belt.Option.forEach(c => el->Element.setTextContent(c))
    el
  }

  let path = (
    document: Document.t,
    ~d: os=?,
    ~fill: os=?,
    ~strokeWidth: os=?,
    ~stroke: os=?,
    ~markerEnd: os=?,
    ~class: os=?,
    ()
  ) => {
    let el = document->Document.createElementNS(svgNS, "path")
    el->sa("d", d)
    el->sa("fill", fill)
    el->sa("stroke-width", strokeWidth)
    el->sa("stroke", stroke)
    el->sa("marker-end", markerEnd)
    el->sa("class", class)
    el
  }

  let defs = (
    document: Document.t,
    ~children: array<Element.t>
  ) => {
    let el = document->Document.createElementNS(svgNS, "defs")
    children->Belt.Array.forEach(child => {
      el->Element.appendChild(~child)
    })
    el
  }

  let marker = (
    document: Document.t,
    ~id: os=?,
    ~viewBox: os=?,
    ~refX: os=?,
    ~refY: os=?,
    ~markerUnits: os=?,
    ~markerWidth: os=?,
    ~markerHeight: os=?,
    ~orient: os=?,
    ~children: array<Element.t>,
    ()
  ) => {
    let el = document->Document.createElementNS(svgNS, "marker")
    el->sa("id", id)
    el->sa("viewBox", viewBox)
    el->sa("refX", refX)
    el->sa("refY", refY)
    el->sa("markerUnits", markerUnits)
    el->sa("markerWidth", markerWidth)
    el->sa("markerHeight", markerHeight)
    el->sa("orient", orient)
    children->Belt.Array.forEach(child => {
      el->Element.appendChild(~child)
    })
    el
  }
}

let renderGraph = (~document: Document.t, ~svg: Element.t, ~graph: SVGGraph.graph) => {
  let {rect, text, defs, marker, path, g} = module(SVGUtils)
  
  removeAllChildren(svg)
  
  svg->Element.appendChild(~child=document->defs(~children=[
    document->marker(
      ~id="arrow",
      ~viewBox="0 0 10 10",
      ~refX="0",
      ~refY="5",
      ~markerUnits="userSpaceOnUse",
      ~markerWidth="10",
      ~markerHeight="10",
      ~orient="auto",
      ~children=[
        document->path(
          ~d="M 0 0 L 10 5 L 0 10 z",
          ~fill="#999",
          ~class="edge-marker-end",
          ()
        )
      ],
      ()
    )
  ]))
  
  let mainG = document->g(~children=[])
  svg->Element.appendChild(~child=mainG)
  
  module NodeRendering = {
    type t = {
      nodeG: Element.t,
      nodeRelativeCX: float,
      nodeRelativeCY: float,
      nodeBoxWidth: float,
      nodeBoxHeight: float,
      nodeMarginLeft: float,
      nodeMarginRight: float,
      nodeMarginTop: float,
      nodeMarginBottom: float,
      nodeFlatWidth: float,
    }
  }
  
  module EdgeRendering = {
    type t = {
      pathElem: Element.t,
      sinkLabelElem: Element.t,
    }
  }
  
  let nodeRenderings = Js.Dict.empty()
  let edgeRenderings = Js.Dict.empty()
  
  {
    let {SVGGraph.nodes: nodes} = graph
    nodes->Belt.Array.forEach(({id, nodeMetrics}) => {
      let rectElem = document->rect(
        ~rx=nodeMetrics.nodeRoundingX->Belt.Float.toString,
        ~ry=nodeMetrics.nodeRoundingY->Belt.Float.toString,
        ~fill="none",
        ~strokeWidth=nodeMetrics.nodeBorderStrokeWidth,
        ~class="node-border",
        ~stroke="#999",
        ()
      )
      
      let textElem = document->text(
        ~textAnchor="middle",
        ~dominantBaseline="middle",
        ~fontSize=nodeMetrics.nodeFontSize,
        ~fontFamily=nodeMetrics.nodeFontFamily,
        ~class="node-text",
        ~textContent=".",
        ()
      )
      
      let lowerLeftElem: option<Element.t> = None
      let upperLeftElem: option<Element.t> = None
      let lowerRightElem: option<Element.t> = None
      let upperRightElem: option<Element.t> = None
      
      let nodeChildren = [Some(rectElem), Some(textElem), lowerLeftElem, upperLeftElem, lowerRightElem, upperRightElem]->Belt.Array.flatMap(el =>
        el->Belt.Option.mapWithDefault([], x => [x])
      )
      
      let nodeG = document->g(~children=nodeChildren)
      mainG->Element.appendChild(~child=nodeG)
      
      let leftAnnotationSize = [lowerLeftElem, upperLeftElem]->Belt.Array.map(el => el->Belt.Option.mapWithDefault(0.0, el => {
        let {width} = el->getBBox
        width +. nodeMetrics.nodeSideTextXOffset
      }))->Belt.Array.reduce(0.0, Js.Math.max_float)
      
      let rightAnnotationSize = [lowerRightElem, upperRightElem]->Belt.Array.map(el => el->Belt.Option.mapWithDefault(0.0, el => {
        let {width} = el->getBBox
        width +. nodeMetrics.nodeSideTextXOffset
      }))->Belt.Array.reduce(0.0, Js.Math.max_float)
      
      let {width: textWidth, height: textHeight} = textElem->getBBox
      let rectWidth = textWidth
      let rectHeight = textHeight
      
      rectElem->Element.setAttribute("x", fts(leftAnnotationSize))
      rectElem->Element.setAttribute("y", "0")
      rectElem->Element.setAttribute("width", fts(rectWidth))
      rectElem->Element.setAttribute("height", fts(rectHeight))
      
      textElem->Element.setAttribute("x", fts(leftAnnotationSize +. rectWidth/.2.0))
      textElem->Element.setAttribute("y", fts(rectHeight/.2.0))
      
      lowerLeftElem->Belt.Option.forEach(el => el->Element.setAttribute("x", fts(leftAnnotationSize-.nodeMetrics.nodeSideTextXOffset)))
      lowerLeftElem->Belt.Option.forEach(el => el->Element.setAttribute("y", fts(rectHeight -. 0.5*.nodeMetrics.nodeRoundingY)))
      
      upperLeftElem->Belt.Option.forEach(el => el->Element.setAttribute("x", fts(leftAnnotationSize-.nodeMetrics.nodeSideTextXOffset)))
      upperLeftElem->Belt.Option.forEach(el => el->Element.setAttribute("y", "0.0"))
      
      lowerRightElem->Belt.Option.forEach(el => el->Element.setAttribute("x", fts(leftAnnotationSize+.rectWidth+.nodeMetrics.nodeSideTextXOffset)))
      lowerRightElem->Belt.Option.forEach(el => el->Element.setAttribute("y", fts(rectHeight -. 0.5*.nodeMetrics.nodeRoundingY)))
      
      upperRightElem->Belt.Option.forEach(el => el->Element.setAttribute("x", fts(leftAnnotationSize+.rectWidth+.nodeMetrics.nodeSideTextXOffset)))
      upperRightElem->Belt.Option.forEach(el => el->Element.setAttribute("y", "0.0"))
      
      let nodeRendering: NodeRendering.t = {
        nodeG,
        nodeRelativeCX: leftAnnotationSize +. rectWidth/.2.0,
        nodeRelativeCY: rectHeight/.2.0,
        nodeBoxWidth: rectWidth,
        nodeBoxHeight: rectHeight,
        nodeMarginLeft: leftAnnotationSize,
        nodeMarginRight: rightAnnotationSize,
        nodeMarginTop: 0.0,
        nodeMarginBottom: 0.0,
        nodeFlatWidth: rectWidth-. 2.0*.nodeMetrics.nodeRoundingX,
      }
      
      nodeRenderings->Js.Dict.set(id, nodeRendering)
    })
  }

  {
    let {edges} = graph
    edges->Belt.Array.forEach(({edgeID, sinkLabel, edgeMetrics}) => {
      let edgePath = document->path(
        ~fill="none",
        ~strokeWidth=edgeMetrics.edgeStrokeWidth,
        ~markerEnd="url(#arrow)",
        ~class="edge",
        ~stroke="#999",
        ()
      )
        
      let edgeSinkText = document->text(
        ~textAnchor="start",
        ~dominantBaseline="hanging",
        ~fontSize=edgeMetrics.edgeSinkLabelFontSize,
        ~fontFamily=edgeMetrics.edgeSinkLabelFontFamily,
        ~class="edge-sink-text",
        ~textContent=sinkLabel,
        ()
      )
      
      mainG->Element.appendChild(~child=edgePath)
      mainG->Element.appendChild(~child=edgeSinkText)
      
      edgeRenderings->Js.Dict.set(edgeID, {
        EdgeRendering.pathElem: edgePath,
        EdgeRendering.sinkLabelElem: edgeSinkText
      })
    })
  }
  
  module F = SVGGraph
  module T = LPLayout.Graph
  
  let lpGraph: T.graph = {
    nodes: graph.nodes->Belt.Array.map(node => {
      let {id} = node
      
      let nodeRendering = nodeRenderings->Js.Dict.unsafeGet(id)
      let {nodeBoxWidth, nodeBoxHeight, nodeMarginLeft, nodeMarginRight, nodeMarginTop, nodeMarginBottom, nodeRelativeCX, nodeRelativeCY} = nodeRendering
      
      ({
        id: id,
        width: nodeBoxWidth +. nodeMarginLeft +. nodeMarginRight,
        height: nodeBoxHeight +. nodeMarginTop +. nodeMarginBottom,
        centerX: nodeRelativeCX,
        centerY: nodeRelativeCY
      }: T.node)
    }),
    
    edges: graph.edges->Belt.Array.map(edge => {
      let {edgeID, source, sink, sinkPos} = edge
      
      ({
        edgeID,
        source,
        sink,
        sourcePos: 0.0,
        sinkPos
      }: T.edge)
    })
  }
  
  let layout = LPLayout.doLayout(lpGraph, {xSpacing: 40.0, ySpacing: 20.0, orientation: FlowingUp})
  let {nodeCenterXs, nodeCenterYs, edgeExtraNodes} = layout
  
  graph.nodes->Belt.Array.forEach(node => {
    let {id } = node
    
    let cx = nodeCenterXs->Js.Dict.unsafeGet(id)
    let cy = nodeCenterYs->Js.Dict.unsafeGet(id)
    
    let nodeRendering = nodeRenderings->Js.Dict.unsafeGet(id)
    let {nodeG, nodeRelativeCX, nodeRelativeCY} = nodeRendering
    
    let cxT = cx -. nodeRelativeCX
    let cyT = cy -. nodeRelativeCY
    
    let transform = `translate(${fts(cxT)}, ${fts(cyT)})`
    
    nodeG->Element.setAttribute("transform", transform)
  })
  
  graph.edges->Belt.Array.forEach(edge => {
    let {edgeID, source, sink, sinkPos, edgeMetrics} = edge
    let edgeRendering = edgeRenderings->Js.Dict.unsafeGet(edgeID)
    let {pathElem, sinkLabelElem} = edgeRendering
    let sinkRendering = nodeRenderings->Js.Dict.unsafeGet(sink)
    let sourceRendering = nodeRenderings->Js.Dict.unsafeGet(source)
    
    let cx1 = nodeCenterXs->Js.Dict.unsafeGet(source)
    let cy1 = nodeCenterYs->Js.Dict.unsafeGet(source)
    
    let cx2 = nodeCenterXs->Js.Dict.unsafeGet(sink)
    let cy2 = nodeCenterYs->Js.Dict.unsafeGet(sink)
    
    let boxHeight1 = sourceRendering.NodeRendering.nodeBoxHeight
    let boxFlatWidth2 = sinkRendering.NodeRendering.nodeFlatWidth
    let boxHeight2 = sinkRendering.NodeRendering.nodeBoxHeight
    
    let xStart = cx1
    let yStart = cy1 -. boxHeight1/.2.0
    
    let xEnd = cx2 +. sinkPos*.boxFlatWidth2*.0.9/.2.0
    let yEnd = cy2 +. boxHeight2/.2.0 +. 10.0
    
    let pointsToTravelThrough = [(xStart, yStart)]
    edgeExtraNodes->Js.Dict.get(edgeID)->Belt.Option.forEach(extraNodes => {
      extraNodes->Belt.Array.forEach(extraNode => {
        let px = nodeCenterXs->Js.Dict.unsafeGet(extraNode)
        let py = nodeCenterYs->Js.Dict.unsafeGet(extraNode)
        
        pointsToTravelThrough->Belt.Array.push((px, py))
      })
    })
    pointsToTravelThrough->Belt.Array.push((xEnd, yEnd))
    
    let workingD = ref(`M ${fts(xStart)} ${fts(yStart)}`)
    {
      let len = pointsToTravelThrough->Js.Array2.length
      let rec step = i => {
        if i < len {
          let p1 = pointsToTravelThrough[i-1]->Option.getExn
          let p2 = pointsToTravelThrough[i]->Option.getExn
          
          let (x1, y1) = p1
          let (x2, y2) = p2
          
          let bx1 = x1
          let by1 = (1.0 -. edgeMetrics.edgeRectangularness)*.y1 +. edgeMetrics.edgeRectangularness*.y2

          let bx2 = x2
          let by2 = edgeMetrics.edgeRectangularness*.y1 +. (1.0 -. edgeMetrics.edgeRectangularness)*.y2
          
          workingD.contents = workingD.contents ++ ` C ${fts(bx1)} ${fts(by1)} ${fts(bx2)} ${fts(by2)} ${fts(x2)} ${fts(y2)}`
          
          step(i + 1)
        }
      }
      step(1)
    }
    
    pathElem->setAttribute("d", workingD.contents)
    
    sinkLabelElem->setAttribute("x", fts(xEnd +. edgeMetrics.edgeSinkLabelXOffset))
    sinkLabelElem->setAttribute("y", fts(yEnd +. edgeMetrics.edgeSinkLabelYOffset))
  })
  
  let bbox = mainG->getBBox
  let totalWidth = bbox.x*.2.0 +. bbox.width
  let totalHeight = bbox.y*.2.0 +. bbox.height
  svg->setAttribute("width", fts(totalWidth))
  svg->setAttribute("height", fts(totalHeight))
}

let document = Webapi.Dom.document

let svgNS = "http://www.w3.org/2000/svg"

let container = document->Document.getElementById("root")->Belt.Option.getExn
let svg = document->Document.createElementNS(svgNS, "svg")
container->Element.appendChild(~child=svg)

renderGraph(~document, ~svg, ~graph)->ignore

