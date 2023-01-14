
module LPSolver = {
  type model<'c, 'v> = {
    optimize: string,
    opType: [#"max" | #"min"],
    constraints: {..} as 'c,
    variables: {..} as 'v,
  }
  
  @module("javascript-lp-solver") external solve: model<'c, 'v> => {..} = "Solve"
}

open LPSolver

Js.Console.log("Solving")
let res = solve({
  optimize: "badness",
  opType: #"min",
  constraints: {
    "p1": { "min": 0.0 },
    "p2": { "min": 0.0 },
    "p3": { "min": 0.0 },
    
    "d_1_2": { "min": 0.0 },
    "d_2_3": { "min": 0.0 },
    
    "o_1_2": { "min": 0.0 },
    "o_2_3": { "min": 0.0 },

    "d_1_2_i": { "min": -1.0 },
    "o_1_2_i": { "min": +1.0 },
    
    "d_2_3_i": { "min": -1.0 },
    "o_2_3_i": { "min": +1.0 },
  },
  variables: {
    "p1": {
      "badness": 0.1,
      "d_1_2_i": 1.0,
      "o_1_2_i": -1.0,
    },
    "p2": {
      "badness": 0.1,
      "d_1_2_i": -1.0,
      "o_1_2_i": 1.0,
      "d_2_3_i": 1.0,
      "o_2_3_i": -1.0,
    },
    "p3": {
      "badness": 0.1,
      "d_2_3_i": -1.0,
      "o_2_3_i": 1.0,
    },
    "d_1_2": {
      "badness": 0.5,
      "d_1_2_i": 1.0
    },
    "d_2_3": {
      "badness": 0.5,
      "d_2_3_i": 1.0
    },
    "o_1_2": {
      "badness": 10.0,
      "o_1_2_i": 1.0
    },
    "o_2_3": {
      "badness": 10.0,
      "o_2_3_i": 1.0
    },
  }
})

Js.Console.log("Solved")

Js.Console.log2("Solution:", res)

