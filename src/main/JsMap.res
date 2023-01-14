
type t

external toObj: t => {..} = "%identity"
external fromObj: {..} => t = "%identity"

external toDict: t => Js.Dict.t<'a> = "%identity"
external fromDict: Js.Dict.t<'a> => t = "%identity"

let make: () => t = () => Js.Obj.empty()->fromObj

let set: (t, string, 'a) => () = (m, k, v) => {
  m->toDict->Js.Dict.set(k, v)
}

let get: (t, string) => 'a = (m, k) => {
  m->toDict->Js.Dict.unsafeGet(k)
}

