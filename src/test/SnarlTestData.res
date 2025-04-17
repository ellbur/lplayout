
let testData = {
    "nodes": [
        {
            "id": "Root",
            "text": "Root",
            "nodeAnnotations": {
                "upperLeft": "",
                "lowerRight": "",
                "upperRight": ""
            },
            "nodeMetrics": {
                "nodeBorderStrokeWidth": "1",
                "nodeHorizontalPadding": 10,
                "nodeVerticalPadding": 7,
                "nodeFontSize": "14",
                "nodeFontFamily": "monospace",
                "nodeSideTextFontSize": "14",
                "nodeSideTextFontFamily": "monospace",
                "nodeSideTextXOffset": 5,
                "nodeRoundingX": 5,
                "nodeRoundingY": 5
            }
        },
        {
            "id": "t0.Jct",
            "text": "t0.Jct",
            "nodeAnnotations": {
                "upperLeft": "*",
                "lowerRight": "min(t1.Jct, t2.Jct, t3.Jct)->0",
                "upperRight": "0"
            },
            "nodeMetrics": {
                "nodeBorderStrokeWidth": "1",
                "nodeHorizontalPadding": 10,
                "nodeVerticalPadding": 7,
                "nodeFontSize": "14",
                "nodeFontFamily": "monospace",
                "nodeSideTextFontSize": "14",
                "nodeSideTextFontFamily": "monospace",
                "nodeSideTextXOffset": 5,
                "nodeRoundingX": 5,
                "nodeRoundingY": 5
            }
        },
        {
            "id": "t0.0",
            "text": "t0.0",
            "nodeAnnotations": {
                "upperLeft": "",
                "lowerRight": "",
                "upperRight": "0"
            },
            "nodeMetrics": {
                "nodeBorderStrokeWidth": "1",
                "nodeHorizontalPadding": 10,
                "nodeVerticalPadding": 7,
                "nodeFontSize": "14",
                "nodeFontFamily": "monospace",
                "nodeSideTextFontSize": "14",
                "nodeSideTextFontFamily": "monospace",
                "nodeSideTextXOffset": 5,
                "nodeRoundingX": 5,
                "nodeRoundingY": 5
            }
        },
        {
            "id": "t2.Jct",
            "text": "t2.Jct",
            "nodeAnnotations": {
                "upperLeft": "*",
                "lowerRight": "min(t4.b2)->4",
                "upperRight": "4"
            },
            "nodeMetrics": {
                "nodeBorderStrokeWidth": "1",
                "nodeHorizontalPadding": 10,
                "nodeVerticalPadding": 7,
                "nodeFontSize": "14",
                "nodeFontFamily": "monospace",
                "nodeSideTextFontSize": "14",
                "nodeSideTextFontFamily": "monospace",
                "nodeSideTextXOffset": 5,
                "nodeRoundingX": 5,
                "nodeRoundingY": 5
            }
        },
        {
            "id": "t2.dep",
            "text": "t2.dep",
            "nodeAnnotations": {
                "upperLeft": "*",
                "lowerRight": ">(t0.0 t2.Jct)->4",
                "upperRight": "4"
            },
            "nodeMetrics": {
                "nodeBorderStrokeWidth": "1",
                "nodeHorizontalPadding": 10,
                "nodeVerticalPadding": 7,
                "nodeFontSize": "14",
                "nodeFontFamily": "monospace",
                "nodeSideTextFontSize": "14",
                "nodeSideTextFontFamily": "monospace",
                "nodeSideTextXOffset": 5,
                "nodeRoundingX": 5,
                "nodeRoundingY": 5
            }
        },
        {
            "id": "t2.top",
            "text": "t2.top",
            "nodeAnnotations": {
                "upperLeft": "*",
                "lowerRight": ">(t2.dep)->5",
                "upperRight": "5"
            },
            "nodeMetrics": {
                "nodeBorderStrokeWidth": "1",
                "nodeHorizontalPadding": 10,
                "nodeVerticalPadding": 7,
                "nodeFontSize": "14",
                "nodeFontFamily": "monospace",
                "nodeSideTextFontSize": "14",
                "nodeSideTextFontFamily": "monospace",
                "nodeSideTextXOffset": 5,
                "nodeRoundingX": 5,
                "nodeRoundingY": 5
            }
        },
        {
            "id": "t3.Jct",
            "text": "t3.Jct",
            "nodeAnnotations": {
                "upperLeft": "*",
                "lowerRight": "min(t6.Jct)->11",
                "upperRight": "11"
            },
            "nodeMetrics": {
                "nodeBorderStrokeWidth": "1",
                "nodeHorizontalPadding": 10,
                "nodeVerticalPadding": 7,
                "nodeFontSize": "14",
                "nodeFontFamily": "monospace",
                "nodeSideTextFontSize": "14",
                "nodeSideTextFontFamily": "monospace",
                "nodeSideTextXOffset": 5,
                "nodeRoundingX": 5,
                "nodeRoundingY": 5
            }
        },
        {
            "id": "t3.dep",
            "text": "t3.dep",
            "nodeAnnotations": {
                "upperLeft": "*",
                "lowerRight": ">(t0.0 t3.Jct)->11",
                "upperRight": "11"
            },
            "nodeMetrics": {
                "nodeBorderStrokeWidth": "1",
                "nodeHorizontalPadding": 10,
                "nodeVerticalPadding": 7,
                "nodeFontSize": "14",
                "nodeFontFamily": "monospace",
                "nodeSideTextFontSize": "14",
                "nodeSideTextFontFamily": "monospace",
                "nodeSideTextXOffset": 5,
                "nodeRoundingX": 5,
                "nodeRoundingY": 5
            }
        },
        {
            "id": "t3.top",
            "text": "t3.top",
            "nodeAnnotations": {
                "upperLeft": "*",
                "lowerRight": ">(t3.dep)->12",
                "upperRight": "12"
            },
            "nodeMetrics": {
                "nodeBorderStrokeWidth": "1",
                "nodeHorizontalPadding": 10,
                "nodeVerticalPadding": 7,
                "nodeFontSize": "14",
                "nodeFontFamily": "monospace",
                "nodeSideTextFontSize": "14",
                "nodeSideTextFontFamily": "monospace",
                "nodeSideTextXOffset": 5,
                "nodeRoundingX": 5,
                "nodeRoundingY": 5
            }
        },
        {
            "id": "t6.Jct",
            "text": "t6.Jct",
            "nodeAnnotations": {
                "upperLeft": "*",
                "lowerRight": "min(t7.b2)->11",
                "upperRight": "11"
            },
            "nodeMetrics": {
                "nodeBorderStrokeWidth": "1",
                "nodeHorizontalPadding": 10,
                "nodeVerticalPadding": 7,
                "nodeFontSize": "14",
                "nodeFontFamily": "monospace",
                "nodeSideTextFontSize": "14",
                "nodeSideTextFontFamily": "monospace",
                "nodeSideTextXOffset": 5,
                "nodeRoundingX": 5,
                "nodeRoundingY": 5
            }
        },
        {
            "id": "t6.dep",
            "text": "t6.dep",
            "nodeAnnotations": {
                "upperLeft": "*",
                "lowerRight": ">(t3.top t6.Jct)->13",
                "upperRight": "13"
            },
            "nodeMetrics": {
                "nodeBorderStrokeWidth": "1",
                "nodeHorizontalPadding": 10,
                "nodeVerticalPadding": 7,
                "nodeFontSize": "14",
                "nodeFontFamily": "monospace",
                "nodeSideTextFontSize": "14",
                "nodeSideTextFontFamily": "monospace",
                "nodeSideTextXOffset": 5,
                "nodeRoundingX": 5,
                "nodeRoundingY": 5
            }
        },
        {
            "id": "t6.top",
            "text": "t6.top",
            "nodeAnnotations": {
                "upperLeft": "*",
                "lowerRight": ">(t6.dep)->14",
                "upperRight": "14"
            },
            "nodeMetrics": {
                "nodeBorderStrokeWidth": "1",
                "nodeHorizontalPadding": 10,
                "nodeVerticalPadding": 7,
                "nodeFontSize": "14",
                "nodeFontFamily": "monospace",
                "nodeSideTextFontSize": "14",
                "nodeSideTextFontFamily": "monospace",
                "nodeSideTextXOffset": 5,
                "nodeRoundingX": 5,
                "nodeRoundingY": 5
            }
        },
        {
            "id": "t1.Jct",
            "text": "t1.Jct",
            "nodeAnnotations": {
                "upperLeft": "*",
                "lowerRight": "min(t4.Jct)->0",
                "upperRight": "0"
            },
            "nodeMetrics": {
                "nodeBorderStrokeWidth": "1",
                "nodeHorizontalPadding": 10,
                "nodeVerticalPadding": 7,
                "nodeFontSize": "14",
                "nodeFontFamily": "monospace",
                "nodeSideTextFontSize": "14",
                "nodeSideTextFontFamily": "monospace",
                "nodeSideTextXOffset": 5,
                "nodeRoundingX": 5,
                "nodeRoundingY": 5
            }
        },
        {
            "id": "t1.dep",
            "text": "t1.dep",
            "nodeAnnotations": {
                "upperLeft": "*",
                "lowerRight": ">(t0.0 t1.Jct)->1",
                "upperRight": "1"
            },
            "nodeMetrics": {
                "nodeBorderStrokeWidth": "1",
                "nodeHorizontalPadding": 10,
                "nodeVerticalPadding": 7,
                "nodeFontSize": "14",
                "nodeFontFamily": "monospace",
                "nodeSideTextFontSize": "14",
                "nodeSideTextFontFamily": "monospace",
                "nodeSideTextXOffset": 5,
                "nodeRoundingX": 5,
                "nodeRoundingY": 5
            }
        },
        {
            "id": "t1.top",
            "text": "t1.top",
            "nodeAnnotations": {
                "upperLeft": "*",
                "lowerRight": ">(t1.dep)->2",
                "upperRight": "2"
            },
            "nodeMetrics": {
                "nodeBorderStrokeWidth": "1",
                "nodeHorizontalPadding": 10,
                "nodeVerticalPadding": 7,
                "nodeFontSize": "14",
                "nodeFontFamily": "monospace",
                "nodeSideTextFontSize": "14",
                "nodeSideTextFontFamily": "monospace",
                "nodeSideTextXOffset": 5,
                "nodeRoundingX": 5,
                "nodeRoundingY": 5
            }
        },
        {
            "id": "t4.Jct",
            "text": "t4.Jct",
            "nodeAnnotations": {
                "upperLeft": "*",
                "lowerRight": "min(t5.Jct)->0",
                "upperRight": "0"
            },
            "nodeMetrics": {
                "nodeBorderStrokeWidth": "1",
                "nodeHorizontalPadding": 10,
                "nodeVerticalPadding": 7,
                "nodeFontSize": "14",
                "nodeFontFamily": "monospace",
                "nodeSideTextFontSize": "14",
                "nodeSideTextFontFamily": "monospace",
                "nodeSideTextXOffset": 5,
                "nodeRoundingX": 5,
                "nodeRoundingY": 5
            }
        },
        {
            "id": "t4.dep1",
            "text": "t4.dep1",
            "nodeAnnotations": {
                "upperLeft": "*",
                "lowerRight": ">(t1.top t4.Jct)->3",
                "upperRight": "3"
            },
            "nodeMetrics": {
                "nodeBorderStrokeWidth": "1",
                "nodeHorizontalPadding": 10,
                "nodeVerticalPadding": 7,
                "nodeFontSize": "14",
                "nodeFontFamily": "monospace",
                "nodeSideTextFontSize": "14",
                "nodeSideTextFontFamily": "monospace",
                "nodeSideTextXOffset": 5,
                "nodeRoundingX": 5,
                "nodeRoundingY": 5
            }
        },
        {
            "id": "t4.b2",
            "text": "t4.b2",
            "nodeAnnotations": {
                "upperLeft": "*",
                "lowerRight": ">(t4.dep1)->4",
                "upperRight": "4"
            },
            "nodeMetrics": {
                "nodeBorderStrokeWidth": "1",
                "nodeHorizontalPadding": 10,
                "nodeVerticalPadding": 7,
                "nodeFontSize": "14",
                "nodeFontFamily": "monospace",
                "nodeSideTextFontSize": "14",
                "nodeSideTextFontFamily": "monospace",
                "nodeSideTextXOffset": 5,
                "nodeRoundingX": 5,
                "nodeRoundingY": 5
            }
        },
        {
            "id": "t4.flex",
            "text": "t4.flex",
            "nodeAnnotations": {
                "upperLeft": "*",
                "lowerRight": ">mut(t2.top)->6",
                "upperRight": "6"
            },
            "nodeMetrics": {
                "nodeBorderStrokeWidth": "1",
                "nodeHorizontalPadding": 10,
                "nodeVerticalPadding": 7,
                "nodeFontSize": "14",
                "nodeFontFamily": "monospace",
                "nodeSideTextFontSize": "14",
                "nodeSideTextFontFamily": "monospace",
                "nodeSideTextXOffset": 5,
                "nodeRoundingX": 5,
                "nodeRoundingY": 5
            }
        },
        {
            "id": "t4.dep2",
            "text": "t4.dep2",
            "nodeAnnotations": {
                "upperLeft": "*",
                "lowerRight": ">(t4.flex t4.b2)->6",
                "upperRight": "6"
            },
            "nodeMetrics": {
                "nodeBorderStrokeWidth": "1",
                "nodeHorizontalPadding": 10,
                "nodeVerticalPadding": 7,
                "nodeFontSize": "14",
                "nodeFontFamily": "monospace",
                "nodeSideTextFontSize": "14",
                "nodeSideTextFontFamily": "monospace",
                "nodeSideTextXOffset": 5,
                "nodeRoundingX": 5,
                "nodeRoundingY": 5
            }
        },
        {
            "id": "t4.top",
            "text": "t4.top",
            "nodeAnnotations": {
                "upperLeft": "*",
                "lowerRight": ">(t4.dep2)->7",
                "upperRight": "7"
            },
            "nodeMetrics": {
                "nodeBorderStrokeWidth": "1",
                "nodeHorizontalPadding": 10,
                "nodeVerticalPadding": 7,
                "nodeFontSize": "14",
                "nodeFontFamily": "monospace",
                "nodeSideTextFontSize": "14",
                "nodeSideTextFontFamily": "monospace",
                "nodeSideTextXOffset": 5,
                "nodeRoundingX": 5,
                "nodeRoundingY": 5
            }
        },
        {
            "id": "t5.Jct",
            "text": "t5.Jct",
            "nodeAnnotations": {
                "upperLeft": "*",
                "lowerRight": "min(t7.Jct)->0",
                "upperRight": "0"
            },
            "nodeMetrics": {
                "nodeBorderStrokeWidth": "1",
                "nodeHorizontalPadding": 10,
                "nodeVerticalPadding": 7,
                "nodeFontSize": "14",
                "nodeFontFamily": "monospace",
                "nodeSideTextFontSize": "14",
                "nodeSideTextFontFamily": "monospace",
                "nodeSideTextXOffset": 5,
                "nodeRoundingX": 5,
                "nodeRoundingY": 5
            }
        },
        {
            "id": "t5.dep",
            "text": "t5.dep",
            "nodeAnnotations": {
                "upperLeft": "*",
                "lowerRight": ">(t4.top t5.Jct)->8",
                "upperRight": "8"
            },
            "nodeMetrics": {
                "nodeBorderStrokeWidth": "1",
                "nodeHorizontalPadding": 10,
                "nodeVerticalPadding": 7,
                "nodeFontSize": "14",
                "nodeFontFamily": "monospace",
                "nodeSideTextFontSize": "14",
                "nodeSideTextFontFamily": "monospace",
                "nodeSideTextXOffset": 5,
                "nodeRoundingX": 5,
                "nodeRoundingY": 5
            }
        },
        {
            "id": "t5.top",
            "text": "t5.top",
            "nodeAnnotations": {
                "upperLeft": "*",
                "lowerRight": ">(t5.dep)->9",
                "upperRight": "9"
            },
            "nodeMetrics": {
                "nodeBorderStrokeWidth": "1",
                "nodeHorizontalPadding": 10,
                "nodeVerticalPadding": 7,
                "nodeFontSize": "14",
                "nodeFontFamily": "monospace",
                "nodeSideTextFontSize": "14",
                "nodeSideTextFontFamily": "monospace",
                "nodeSideTextXOffset": 5,
                "nodeRoundingX": 5,
                "nodeRoundingY": 5
            }
        },
        {
            "id": "t7.Jct",
            "text": "t7.Jct",
            "nodeAnnotations": {
                "upperLeft": "*",
                "lowerRight": "min(Root)->0",
                "upperRight": "0"
            },
            "nodeMetrics": {
                "nodeBorderStrokeWidth": "1",
                "nodeHorizontalPadding": 10,
                "nodeVerticalPadding": 7,
                "nodeFontSize": "14",
                "nodeFontFamily": "monospace",
                "nodeSideTextFontSize": "14",
                "nodeSideTextFontFamily": "monospace",
                "nodeSideTextXOffset": 5,
                "nodeRoundingX": 5,
                "nodeRoundingY": 5
            }
        },
        {
            "id": "t7.dep1",
            "text": "t7.dep1",
            "nodeAnnotations": {
                "upperLeft": "*",
                "lowerRight": ">(t5.top t7.Jct)->10",
                "upperRight": "10"
            },
            "nodeMetrics": {
                "nodeBorderStrokeWidth": "1",
                "nodeHorizontalPadding": 10,
                "nodeVerticalPadding": 7,
                "nodeFontSize": "14",
                "nodeFontFamily": "monospace",
                "nodeSideTextFontSize": "14",
                "nodeSideTextFontFamily": "monospace",
                "nodeSideTextXOffset": 5,
                "nodeRoundingX": 5,
                "nodeRoundingY": 5
            }
        },
        {
            "id": "t7.b2",
            "text": "t7.b2",
            "nodeAnnotations": {
                "upperLeft": "*",
                "lowerRight": ">(t7.dep1)->11",
                "upperRight": "11"
            },
            "nodeMetrics": {
                "nodeBorderStrokeWidth": "1",
                "nodeHorizontalPadding": 10,
                "nodeVerticalPadding": 7,
                "nodeFontSize": "14",
                "nodeFontFamily": "monospace",
                "nodeSideTextFontSize": "14",
                "nodeSideTextFontFamily": "monospace",
                "nodeSideTextXOffset": 5,
                "nodeRoundingX": 5,
                "nodeRoundingY": 5
            }
        },
        {
            "id": "t7.flex",
            "text": "t7.flex",
            "nodeAnnotations": {
                "upperLeft": "*",
                "lowerRight": ">mut(t6.top)->15",
                "upperRight": "15"
            },
            "nodeMetrics": {
                "nodeBorderStrokeWidth": "1",
                "nodeHorizontalPadding": 10,
                "nodeVerticalPadding": 7,
                "nodeFontSize": "14",
                "nodeFontFamily": "monospace",
                "nodeSideTextFontSize": "14",
                "nodeSideTextFontFamily": "monospace",
                "nodeSideTextXOffset": 5,
                "nodeRoundingX": 5,
                "nodeRoundingY": 5
            }
        },
        {
            "id": "t7.dep2",
            "text": "t7.dep2",
            "nodeAnnotations": {
                "upperLeft": "*",
                "lowerRight": ">(t7.flex t7.b2)->15",
                "upperRight": "15"
            },
            "nodeMetrics": {
                "nodeBorderStrokeWidth": "1",
                "nodeHorizontalPadding": 10,
                "nodeVerticalPadding": 7,
                "nodeFontSize": "14",
                "nodeFontFamily": "monospace",
                "nodeSideTextFontSize": "14",
                "nodeSideTextFontFamily": "monospace",
                "nodeSideTextXOffset": 5,
                "nodeRoundingX": 5,
                "nodeRoundingY": 5
            }
        },
        {
            "id": "t7.top",
            "text": "t7.top",
            "nodeAnnotations": {
                "upperLeft": "*",
                "lowerRight": ">(t7.dep2)->16",
                "upperRight": "16"
            },
            "nodeMetrics": {
                "nodeBorderStrokeWidth": "1",
                "nodeHorizontalPadding": 10,
                "nodeVerticalPadding": 7,
                "nodeFontSize": "14",
                "nodeFontFamily": "monospace",
                "nodeSideTextFontSize": "14",
                "nodeSideTextFontFamily": "monospace",
                "nodeSideTextXOffset": 5,
                "nodeRoundingX": 5,
                "nodeRoundingY": 5
            }
        }
    ],
    "edges": [
        {
            "edgeID": "t1.Jct_t0.Jct",
            "source": "t1.Jct",
            "sink": "t0.Jct",
            "sinkPos": -1,
            "sinkLabel": "",
            "edgeMetrics": {
                "edgeStrokeWidth": "1",
                "edgeSinkLabelFontSize": "14",
                "edgeSinkLabelFontFamily": "monospace",
                "edgeSinkLabelXOffset": 8,
                "edgeSinkLabelYOffset": -5,
                "edgeRectangularness": 1
            }
        },
        {
            "edgeID": "t2.Jct_t0.Jct",
            "source": "t2.Jct",
            "sink": "t0.Jct",
            "sinkPos": 0,
            "sinkLabel": "",
            "edgeMetrics": {
                "edgeStrokeWidth": "1",
                "edgeSinkLabelFontSize": "14",
                "edgeSinkLabelFontFamily": "monospace",
                "edgeSinkLabelXOffset": 8,
                "edgeSinkLabelYOffset": -5,
                "edgeRectangularness": 1
            }
        },
        {
            "edgeID": "t3.Jct_t0.Jct",
            "source": "t3.Jct",
            "sink": "t0.Jct",
            "sinkPos": 1,
            "sinkLabel": "",
            "edgeMetrics": {
                "edgeStrokeWidth": "1",
                "edgeSinkLabelFontSize": "14",
                "edgeSinkLabelFontFamily": "monospace",
                "edgeSinkLabelXOffset": 8,
                "edgeSinkLabelYOffset": -5,
                "edgeRectangularness": 1
            }
        },
        {
            "edgeID": "t4.b2_t2.Jct",
            "source": "t4.b2",
            "sink": "t2.Jct",
            "sinkPos": 0,
            "sinkLabel": "",
            "edgeMetrics": {
                "edgeStrokeWidth": "1",
                "edgeSinkLabelFontSize": "14",
                "edgeSinkLabelFontFamily": "monospace",
                "edgeSinkLabelXOffset": 8,
                "edgeSinkLabelYOffset": -5,
                "edgeRectangularness": 1
            }
        },
        {
            "edgeID": "t0.0_t2.dep",
            "source": "t0.0",
            "sink": "t2.dep",
            "sinkPos": -1,
            "sinkLabel": "",
            "edgeMetrics": {
                "edgeStrokeWidth": "1",
                "edgeSinkLabelFontSize": "14",
                "edgeSinkLabelFontFamily": "monospace",
                "edgeSinkLabelXOffset": 8,
                "edgeSinkLabelYOffset": -5,
                "edgeRectangularness": 1
            }
        },
        {
            "edgeID": "t2.Jct_t2.dep",
            "source": "t2.Jct",
            "sink": "t2.dep",
            "sinkPos": 1,
            "sinkLabel": "",
            "edgeMetrics": {
                "edgeStrokeWidth": "1",
                "edgeSinkLabelFontSize": "14",
                "edgeSinkLabelFontFamily": "monospace",
                "edgeSinkLabelXOffset": 8,
                "edgeSinkLabelYOffset": -5,
                "edgeRectangularness": 1
            }
        },
        {
            "edgeID": "t2.dep_t2.top",
            "source": "t2.dep",
            "sink": "t2.top",
            "sinkPos": 0,
            "sinkLabel": "",
            "edgeMetrics": {
                "edgeStrokeWidth": "1",
                "edgeSinkLabelFontSize": "14",
                "edgeSinkLabelFontFamily": "monospace",
                "edgeSinkLabelXOffset": 8,
                "edgeSinkLabelYOffset": -5,
                "edgeRectangularness": 1
            }
        },
        {
            "edgeID": "t6.Jct_t3.Jct",
            "source": "t6.Jct",
            "sink": "t3.Jct",
            "sinkPos": 0,
            "sinkLabel": "",
            "edgeMetrics": {
                "edgeStrokeWidth": "1",
                "edgeSinkLabelFontSize": "14",
                "edgeSinkLabelFontFamily": "monospace",
                "edgeSinkLabelXOffset": 8,
                "edgeSinkLabelYOffset": -5,
                "edgeRectangularness": 1
            }
        },
        {
            "edgeID": "t0.0_t3.dep",
            "source": "t0.0",
            "sink": "t3.dep",
            "sinkPos": -1,
            "sinkLabel": "",
            "edgeMetrics": {
                "edgeStrokeWidth": "1",
                "edgeSinkLabelFontSize": "14",
                "edgeSinkLabelFontFamily": "monospace",
                "edgeSinkLabelXOffset": 8,
                "edgeSinkLabelYOffset": -5,
                "edgeRectangularness": 1
            }
        },
        {
            "edgeID": "t3.Jct_t3.dep",
            "source": "t3.Jct",
            "sink": "t3.dep",
            "sinkPos": 1,
            "sinkLabel": "",
            "edgeMetrics": {
                "edgeStrokeWidth": "1",
                "edgeSinkLabelFontSize": "14",
                "edgeSinkLabelFontFamily": "monospace",
                "edgeSinkLabelXOffset": 8,
                "edgeSinkLabelYOffset": -5,
                "edgeRectangularness": 1
            }
        },
        {
            "edgeID": "t3.dep_t3.top",
            "source": "t3.dep",
            "sink": "t3.top",
            "sinkPos": 0,
            "sinkLabel": "",
            "edgeMetrics": {
                "edgeStrokeWidth": "1",
                "edgeSinkLabelFontSize": "14",
                "edgeSinkLabelFontFamily": "monospace",
                "edgeSinkLabelXOffset": 8,
                "edgeSinkLabelYOffset": -5,
                "edgeRectangularness": 1
            }
        },
        {
            "edgeID": "t7.b2_t6.Jct",
            "source": "t7.b2",
            "sink": "t6.Jct",
            "sinkPos": 0,
            "sinkLabel": "",
            "edgeMetrics": {
                "edgeStrokeWidth": "1",
                "edgeSinkLabelFontSize": "14",
                "edgeSinkLabelFontFamily": "monospace",
                "edgeSinkLabelXOffset": 8,
                "edgeSinkLabelYOffset": -5,
                "edgeRectangularness": 1
            }
        },
        {
            "edgeID": "t3.top_t6.dep",
            "source": "t3.top",
            "sink": "t6.dep",
            "sinkPos": -1,
            "sinkLabel": "",
            "edgeMetrics": {
                "edgeStrokeWidth": "1",
                "edgeSinkLabelFontSize": "14",
                "edgeSinkLabelFontFamily": "monospace",
                "edgeSinkLabelXOffset": 8,
                "edgeSinkLabelYOffset": -5,
                "edgeRectangularness": 1
            }
        },
        {
            "edgeID": "t6.Jct_t6.dep",
            "source": "t6.Jct",
            "sink": "t6.dep",
            "sinkPos": 1,
            "sinkLabel": "",
            "edgeMetrics": {
                "edgeStrokeWidth": "1",
                "edgeSinkLabelFontSize": "14",
                "edgeSinkLabelFontFamily": "monospace",
                "edgeSinkLabelXOffset": 8,
                "edgeSinkLabelYOffset": -5,
                "edgeRectangularness": 1
            }
        },
        {
            "edgeID": "t6.dep_t6.top",
            "source": "t6.dep",
            "sink": "t6.top",
            "sinkPos": 0,
            "sinkLabel": "",
            "edgeMetrics": {
                "edgeStrokeWidth": "1",
                "edgeSinkLabelFontSize": "14",
                "edgeSinkLabelFontFamily": "monospace",
                "edgeSinkLabelXOffset": 8,
                "edgeSinkLabelYOffset": -5,
                "edgeRectangularness": 1
            }
        },
        {
            "edgeID": "t4.Jct_t1.Jct",
            "source": "t4.Jct",
            "sink": "t1.Jct",
            "sinkPos": 0,
            "sinkLabel": "",
            "edgeMetrics": {
                "edgeStrokeWidth": "1",
                "edgeSinkLabelFontSize": "14",
                "edgeSinkLabelFontFamily": "monospace",
                "edgeSinkLabelXOffset": 8,
                "edgeSinkLabelYOffset": -5,
                "edgeRectangularness": 1
            }
        },
        {
            "edgeID": "t0.0_t1.dep",
            "source": "t0.0",
            "sink": "t1.dep",
            "sinkPos": -1,
            "sinkLabel": "",
            "edgeMetrics": {
                "edgeStrokeWidth": "1",
                "edgeSinkLabelFontSize": "14",
                "edgeSinkLabelFontFamily": "monospace",
                "edgeSinkLabelXOffset": 8,
                "edgeSinkLabelYOffset": -5,
                "edgeRectangularness": 1
            }
        },
        {
            "edgeID": "t1.Jct_t1.dep",
            "source": "t1.Jct",
            "sink": "t1.dep",
            "sinkPos": 1,
            "sinkLabel": "",
            "edgeMetrics": {
                "edgeStrokeWidth": "1",
                "edgeSinkLabelFontSize": "14",
                "edgeSinkLabelFontFamily": "monospace",
                "edgeSinkLabelXOffset": 8,
                "edgeSinkLabelYOffset": -5,
                "edgeRectangularness": 1
            }
        },
        {
            "edgeID": "t1.dep_t1.top",
            "source": "t1.dep",
            "sink": "t1.top",
            "sinkPos": 0,
            "sinkLabel": "",
            "edgeMetrics": {
                "edgeStrokeWidth": "1",
                "edgeSinkLabelFontSize": "14",
                "edgeSinkLabelFontFamily": "monospace",
                "edgeSinkLabelXOffset": 8,
                "edgeSinkLabelYOffset": -5,
                "edgeRectangularness": 1
            }
        },
        {
            "edgeID": "t5.Jct_t4.Jct",
            "source": "t5.Jct",
            "sink": "t4.Jct",
            "sinkPos": 0,
            "sinkLabel": "",
            "edgeMetrics": {
                "edgeStrokeWidth": "1",
                "edgeSinkLabelFontSize": "14",
                "edgeSinkLabelFontFamily": "monospace",
                "edgeSinkLabelXOffset": 8,
                "edgeSinkLabelYOffset": -5,
                "edgeRectangularness": 1
            }
        },
        {
            "edgeID": "t1.top_t4.dep1",
            "source": "t1.top",
            "sink": "t4.dep1",
            "sinkPos": -1,
            "sinkLabel": "",
            "edgeMetrics": {
                "edgeStrokeWidth": "1",
                "edgeSinkLabelFontSize": "14",
                "edgeSinkLabelFontFamily": "monospace",
                "edgeSinkLabelXOffset": 8,
                "edgeSinkLabelYOffset": -5,
                "edgeRectangularness": 1
            }
        },
        {
            "edgeID": "t4.Jct_t4.dep1",
            "source": "t4.Jct",
            "sink": "t4.dep1",
            "sinkPos": 1,
            "sinkLabel": "",
            "edgeMetrics": {
                "edgeStrokeWidth": "1",
                "edgeSinkLabelFontSize": "14",
                "edgeSinkLabelFontFamily": "monospace",
                "edgeSinkLabelXOffset": 8,
                "edgeSinkLabelYOffset": -5,
                "edgeRectangularness": 1
            }
        },
        {
            "edgeID": "t4.dep1_t4.b2",
            "source": "t4.dep1",
            "sink": "t4.b2",
            "sinkPos": 0,
            "sinkLabel": "",
            "edgeMetrics": {
                "edgeStrokeWidth": "1",
                "edgeSinkLabelFontSize": "14",
                "edgeSinkLabelFontFamily": "monospace",
                "edgeSinkLabelXOffset": 8,
                "edgeSinkLabelYOffset": -5,
                "edgeRectangularness": 1
            }
        },
        {
            "edgeID": "t2.top_t4.flex",
            "source": "t2.top",
            "sink": "t4.flex",
            "sinkPos": 0,
            "sinkLabel": "",
            "edgeMetrics": {
                "edgeStrokeWidth": "1",
                "edgeSinkLabelFontSize": "14",
                "edgeSinkLabelFontFamily": "monospace",
                "edgeSinkLabelXOffset": 8,
                "edgeSinkLabelYOffset": -5,
                "edgeRectangularness": 1
            }
        },
        {
            "edgeID": "t4.flex_t4.dep2",
            "source": "t4.flex",
            "sink": "t4.dep2",
            "sinkPos": -1,
            "sinkLabel": "",
            "edgeMetrics": {
                "edgeStrokeWidth": "1",
                "edgeSinkLabelFontSize": "14",
                "edgeSinkLabelFontFamily": "monospace",
                "edgeSinkLabelXOffset": 8,
                "edgeSinkLabelYOffset": -5,
                "edgeRectangularness": 1
            }
        },
        {
            "edgeID": "t4.b2_t4.dep2",
            "source": "t4.b2",
            "sink": "t4.dep2",
            "sinkPos": 1,
            "sinkLabel": "",
            "edgeMetrics": {
                "edgeStrokeWidth": "1",
                "edgeSinkLabelFontSize": "14",
                "edgeSinkLabelFontFamily": "monospace",
                "edgeSinkLabelXOffset": 8,
                "edgeSinkLabelYOffset": -5,
                "edgeRectangularness": 1
            }
        },
        {
            "edgeID": "t4.dep2_t4.top",
            "source": "t4.dep2",
            "sink": "t4.top",
            "sinkPos": 0,
            "sinkLabel": "",
            "edgeMetrics": {
                "edgeStrokeWidth": "1",
                "edgeSinkLabelFontSize": "14",
                "edgeSinkLabelFontFamily": "monospace",
                "edgeSinkLabelXOffset": 8,
                "edgeSinkLabelYOffset": -5,
                "edgeRectangularness": 1
            }
        },
        {
            "edgeID": "t7.Jct_t5.Jct",
            "source": "t7.Jct",
            "sink": "t5.Jct",
            "sinkPos": 0,
            "sinkLabel": "",
            "edgeMetrics": {
                "edgeStrokeWidth": "1",
                "edgeSinkLabelFontSize": "14",
                "edgeSinkLabelFontFamily": "monospace",
                "edgeSinkLabelXOffset": 8,
                "edgeSinkLabelYOffset": -5,
                "edgeRectangularness": 1
            }
        },
        {
            "edgeID": "t4.top_t5.dep",
            "source": "t4.top",
            "sink": "t5.dep",
            "sinkPos": -1,
            "sinkLabel": "",
            "edgeMetrics": {
                "edgeStrokeWidth": "1",
                "edgeSinkLabelFontSize": "14",
                "edgeSinkLabelFontFamily": "monospace",
                "edgeSinkLabelXOffset": 8,
                "edgeSinkLabelYOffset": -5,
                "edgeRectangularness": 1
            }
        },
        {
            "edgeID": "t5.Jct_t5.dep",
            "source": "t5.Jct",
            "sink": "t5.dep",
            "sinkPos": 1,
            "sinkLabel": "",
            "edgeMetrics": {
                "edgeStrokeWidth": "1",
                "edgeSinkLabelFontSize": "14",
                "edgeSinkLabelFontFamily": "monospace",
                "edgeSinkLabelXOffset": 8,
                "edgeSinkLabelYOffset": -5,
                "edgeRectangularness": 1
            }
        },
        {
            "edgeID": "t5.dep_t5.top",
            "source": "t5.dep",
            "sink": "t5.top",
            "sinkPos": 0,
            "sinkLabel": "",
            "edgeMetrics": {
                "edgeStrokeWidth": "1",
                "edgeSinkLabelFontSize": "14",
                "edgeSinkLabelFontFamily": "monospace",
                "edgeSinkLabelXOffset": 8,
                "edgeSinkLabelYOffset": -5,
                "edgeRectangularness": 1
            }
        },
        {
            "edgeID": "Root_t7.Jct",
            "source": "Root",
            "sink": "t7.Jct",
            "sinkPos": 0,
            "sinkLabel": "",
            "edgeMetrics": {
                "edgeStrokeWidth": "1",
                "edgeSinkLabelFontSize": "14",
                "edgeSinkLabelFontFamily": "monospace",
                "edgeSinkLabelXOffset": 8,
                "edgeSinkLabelYOffset": -5,
                "edgeRectangularness": 1
            }
        },
        {
            "edgeID": "t5.top_t7.dep1",
            "source": "t5.top",
            "sink": "t7.dep1",
            "sinkPos": -1,
            "sinkLabel": "",
            "edgeMetrics": {
                "edgeStrokeWidth": "1",
                "edgeSinkLabelFontSize": "14",
                "edgeSinkLabelFontFamily": "monospace",
                "edgeSinkLabelXOffset": 8,
                "edgeSinkLabelYOffset": -5,
                "edgeRectangularness": 1
            }
        },
        {
            "edgeID": "t7.Jct_t7.dep1",
            "source": "t7.Jct",
            "sink": "t7.dep1",
            "sinkPos": 1,
            "sinkLabel": "",
            "edgeMetrics": {
                "edgeStrokeWidth": "1",
                "edgeSinkLabelFontSize": "14",
                "edgeSinkLabelFontFamily": "monospace",
                "edgeSinkLabelXOffset": 8,
                "edgeSinkLabelYOffset": -5,
                "edgeRectangularness": 1
            }
        },
        {
            "edgeID": "t7.dep1_t7.b2",
            "source": "t7.dep1",
            "sink": "t7.b2",
            "sinkPos": 0,
            "sinkLabel": "",
            "edgeMetrics": {
                "edgeStrokeWidth": "1",
                "edgeSinkLabelFontSize": "14",
                "edgeSinkLabelFontFamily": "monospace",
                "edgeSinkLabelXOffset": 8,
                "edgeSinkLabelYOffset": -5,
                "edgeRectangularness": 1
            }
        },
        {
            "edgeID": "t6.top_t7.flex",
            "source": "t6.top",
            "sink": "t7.flex",
            "sinkPos": 0,
            "sinkLabel": "",
            "edgeMetrics": {
                "edgeStrokeWidth": "1",
                "edgeSinkLabelFontSize": "14",
                "edgeSinkLabelFontFamily": "monospace",
                "edgeSinkLabelXOffset": 8,
                "edgeSinkLabelYOffset": -5,
                "edgeRectangularness": 1
            }
        },
        {
            "edgeID": "t7.flex_t7.dep2",
            "source": "t7.flex",
            "sink": "t7.dep2",
            "sinkPos": -1,
            "sinkLabel": "",
            "edgeMetrics": {
                "edgeStrokeWidth": "1",
                "edgeSinkLabelFontSize": "14",
                "edgeSinkLabelFontFamily": "monospace",
                "edgeSinkLabelXOffset": 8,
                "edgeSinkLabelYOffset": -5,
                "edgeRectangularness": 1
            }
        },
        {
            "edgeID": "t7.b2_t7.dep2",
            "source": "t7.b2",
            "sink": "t7.dep2",
            "sinkPos": 1,
            "sinkLabel": "",
            "edgeMetrics": {
                "edgeStrokeWidth": "1",
                "edgeSinkLabelFontSize": "14",
                "edgeSinkLabelFontFamily": "monospace",
                "edgeSinkLabelXOffset": 8,
                "edgeSinkLabelYOffset": -5,
                "edgeRectangularness": 1
            }
        },
        {
            "edgeID": "t7.dep2_t7.top",
            "source": "t7.dep2",
            "sink": "t7.top",
            "sinkPos": 0,
            "sinkLabel": "",
            "edgeMetrics": {
                "edgeStrokeWidth": "1",
                "edgeSinkLabelFontSize": "14",
                "edgeSinkLabelFontFamily": "monospace",
                "edgeSinkLabelXOffset": 8,
                "edgeSinkLabelYOffset": -5,
                "edgeRectangularness": 1
            }
        }
    ],
    "graphMetrics": {
        "xSpacing": 40,
        "ySpacing": 40
    }
}

