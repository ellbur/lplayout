
type median<'t> =
    Empty
  | Odd('t)
  | Even('t, 't)

let medianCompare = (type t, elemCompare: (t, t) => Ordering.t) => (a: median<t>, b: median<t>) => {
  let {isLess, isGreater, isEqual, less, greater, equal} = module(Ordering)
  switch (a, b) {
    | (Empty, Empty) => Ordering.equal
    | (Empty, _) => Ordering.less
    | (_, Empty) =>  Ordering.greater
    | (Odd(a), Odd(b)) => elemCompare(a, b)
    | (Odd(a), Even(b, c)) =>
        let ab = elemCompare(a, b)
        if isLess(ab) {
          less
        }
        else {
          let ac = elemCompare(a, c)
          if isGreater(ac) {
            greater
          }
          else if isEqual(ab) && isLess(ac) {
            less
          }
          else if isGreater(ab) && isEqual(ac) {
            greater
          }
          else {
            // Technically, undecidable, but we have to pick one
            equal
          }
        }
    | (Even(a, b), Odd(c)) =>
        let ac = elemCompare(a, c)
        if isGreater(ac) {
          greater
        }
        else {
          let bc = elemCompare(b, c)
          if isLess(bc) {
            less
          }
          else if isEqual(ac) && isGreater(bc) {
            greater
          }
          else if isEqual(bc) && isLess(ac) {
            less
          }
          else {
            // Technically, undecidable, but we have to pick one
            equal
          }
        }
    | (Even(a, b), Even(c, d)) =>
        if isLess(elemCompare(b, c)) {
          less
        }
        else if isGreater(elemCompare(a, d)) {
          greater
        }
        else {
          let ac = elemCompare(a, c)
          let bd = elemCompare(b, d)
          if (isLess(ac) || isLess(bd)) && !isGreater(ac) && !isGreater(bd) {
            less
          }
          else if (isGreater(ac) || isGreater(bd)) && !isLess(ac) && !isLess(bd) {
            greater
          }
          else {
            equal
          }
        }
  }
}

let arrayMedian = (type t, ar: array<t>): median<t> => {
  let len = ar->Array.length
  let half = (len-1)/2
  if len == 0 {
    Empty
  }
  else if len == 1 {
    Odd(ar[0]->Option.getExn)
  }
  else if mod(len, 2) == 0 {
    Even(ar[half]->Option.getExn, ar[half+1]->Option.getExn)
  }
  else {
    Odd(ar[half]->Option.getExn)
  }
}


