
module LPSolver = {
  type model<'c, 'v> = {
    optimize: string,
    opType: [#"max"],
    constraints: {..} as 'c,
    variables: {..} as 'v,
  }
  
  @module("javascript-lp-solver") external solve: model<'c, 'v> => {..} = "Solve"
}

open LPSolver

Js.Console.log("Solving")
let res = solve({
  optimize: "capacity",
  opType: #"max",
  constraints: {
    "plane": {"max": 44},
    "person": {"max": 512},
    "cost": {"max": 300000}
  },
  variables: {
    "brit": {
      "capacity": 20000,
      "plane": 1,
      "person": 8,
      "cost": 5000
    },
    "yank": {
      "capacity": 30000,
      "plane": 1,
      "person": 16,
      "cost": 9000
    }
  }
})

Js.Console.log("Solved")

Js.Console.log2("Solution:", res)

