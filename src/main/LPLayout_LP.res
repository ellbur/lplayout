
module JsMap = LPLayout_JsMap

type model<'c, 'v> = {
  optimize: string,
  opType: [#"max" | #"min"],
  constraints: JsMap.t as 'c,
  variables: JsMap.t as 'v,
}

%%raw(`
import __solver from 'javascript-lp-solver';
function __solve(x) {
  return __solver.Solve(x);
}
`)

let ucSolve: (.model<'c, 'v>) => JsMap.t = %raw("__solve")
let solve: model<'c, 'v> => JsMap.t = m => ucSolve(. m)

