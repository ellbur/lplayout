
open LPLayout_LP
let {fromObj} = module(LPLayout_JsMap)

Js.Console.log("Solving")
let res = solve({
  optimize: "capacity",
  opType: #"max",
  constraints: ({
    "plane": {"max": 44},
    "person": {"max": 512},
    "cost": {"max": 300000}
  })->fromObj,
  variables: ({
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
  })->fromObj
})

Js.Console.log("Solved")

Js.Console.log2("Solution:", res)

