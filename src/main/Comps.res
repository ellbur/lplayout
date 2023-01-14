
module StringComp = Belt.Id.MakeComparable({
  type t = string
  let cmp = Pervasives.compare
})

