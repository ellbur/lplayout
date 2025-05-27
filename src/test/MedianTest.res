
let {medianCompare} = module(LPLayout_Median)
let {less, greater, equal} = module(Ordering)

let intCompare = (a, b) => Pervasives.compare(a, b)->Ordering.fromInt

let assertEqual = (x, y) => {
  if x != y {
    Console.error3(x, "!=", y)
    Exn.raiseError(`Not equal`)
  }
  else {
    Console.log3(x, "=", y)
  }
}

let mc = medianCompare(intCompare)

Console.log("odd/odd")
assertEqual(mc(Odd(1), Odd(2)), less)
assertEqual(mc(Odd(2), Odd(1)), greater)
assertEqual(mc(Odd(2), Odd(2)), equal)
Console.log("")

Console.log("odd/even")
assertEqual(mc(Odd(0), Even(1, 3)), less)
assertEqual(mc(Odd(1), Even(1, 3)), less)
assertEqual(mc(Odd(2), Even(1, 3)), equal)
assertEqual(mc(Odd(3), Even(1, 3)), greater)
assertEqual(mc(Odd(4), Even(1, 3)), greater)
Console.log("")

Console.log("even/odd")
assertEqual(mc(Even(1, 3), Odd(0)), greater)
assertEqual(mc(Even(1, 3), Odd(1)), greater)
assertEqual(mc(Even(1, 3), Odd(2)), equal)
assertEqual(mc(Even(1, 3), Odd(3)), less)
assertEqual(mc(Even(1, 3), Odd(4)), less)
Console.log("")

Console.log("even/even")
assertEqual(mc(Even(0, 2), Even(3, 5)), less)
assertEqual(mc(Even(0, 3), Even(3, 5)), less)
assertEqual(mc(Even(0, 4), Even(3, 5)), less)
assertEqual(mc(Even(3, 4), Even(3, 5)), less)
assertEqual(mc(Even(4, 4), Even(3, 5)), equal)
assertEqual(mc(Even(3, 5), Even(3, 5)), equal)
assertEqual(mc(Even(4, 5), Even(3, 5)), greater)
assertEqual(mc(Even(4, 6), Even(3, 5)), greater)
assertEqual(mc(Even(5, 6), Even(3, 5)), greater)
assertEqual(mc(Even(6, 7), Even(3, 5)), greater)

