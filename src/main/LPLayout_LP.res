
module JsMap = LPLayout_JsMap

type model<'c, 'v> = {
  optimize: string,
  opType: [#"max" | #"min"],
  constraints: JsMap.t as 'c,
  variables: JsMap.t as 'v,
}

type jsLPSolver

@module("@ellbur/javascript-lp-solver") @new external newJSLPSolver: () => jsLPSolver = "default";
let jsLPSolver = newJSLPSolver()

@send external methSolve: (jsLPSolver, model<'c, 'v>) => JsMap.t = "Solve"

let solve: model<'c, 'v> => JsMap.t = jsLPSolver->methSolve

