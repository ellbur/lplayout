
type model<'c, 'v> = {
  optimize: string,
  opType: [#"max" | #"min"],
  constraints: JsMap.t as 'c,
  variables: JsMap.t as 'v,
}

@module("javascript-lp-solver") external solve: model<'c, 'v> => JsMap.t = "Solve"

