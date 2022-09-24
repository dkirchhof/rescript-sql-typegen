type rec t =
  | And(array<t>)
  | Or(array<t>)
  | Equal(Ref.anyRef, Ref.anyRef)
  | NotEqual(Ref.anyRef, Ref.anyRef)
  | GreaterThan(Ref.anyRef, Ref.anyRef)
  | GreaterThanEqual(Ref.anyRef, Ref.anyRef)
  | LessThan(Ref.anyRef, Ref.anyRef)
  | LessThanEqual(Ref.anyRef, Ref.anyRef)
  | Between(Ref.anyRef, Ref.anyRef, Ref.anyRef)
  | NotBetween(Ref.anyRef, Ref.anyRef, Ref.anyRef)
  | In(Ref.anyRef, array<Ref.anyRef>)
  | NotIn(Ref.anyRef, array<Ref.anyRef>)

let and_: array<t> => t
let or_: array<t> => t

let eq: (Ref.t<'a>, Ref.t<'a>) => t
let neq: (Ref.t<'a>, Ref.t<'a>) => t
let gt: (Ref.t<'a>, Ref.t<'a>) => t
let gte: (Ref.t<'a>, Ref.t<'a>) => t
let lt: (Ref.t<'a>, Ref.t<'a>) => t
let lte: (Ref.t<'a>, Ref.t<'a>) => t
let btw: (Ref.t<'a>, Ref.t<'a>, Ref.t<'a>) => t
let nbtw: (Ref.t<'a>, Ref.t<'a>, Ref.t<'a>) => t
let in_: (Ref.t<'a>, array<Ref.t<'a>>) => t
let nin_: (Ref.t<'a>, array<Ref.t<'a>>) => t

let toSQL: (t, 'a => string) => string
