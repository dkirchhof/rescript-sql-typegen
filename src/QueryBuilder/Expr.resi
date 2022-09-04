type rec t =
  | And(array<t>)
  | Or(array<t>)
  | Equal(Ref.t<Ref.any>, Ref.t<Ref.any>)
  | NotEqual(Ref.t<Ref.any>, Ref.t<Ref.any>)
  | GreaterThan(Ref.t<Ref.any>, Ref.t<Ref.any>)
  | GreaterThanEqual(Ref.t<Ref.any>, Ref.t<Ref.any>)
  | LessThan(Ref.t<Ref.any>, Ref.t<Ref.any>)
  | LessThanEqual(Ref.t<Ref.any>, Ref.t<Ref.any>)
  | Between(Ref.t<Ref.any>, Ref.t<Ref.any>, Ref.t<Ref.any>)
  | NotBetween(Ref.t<Ref.any>, Ref.t<Ref.any>, Ref.t<Ref.any>)
  | In(Ref.t<Ref.any>, array<Ref.t<Ref.any>>)
  | NotIn(Ref.t<Ref.any>, array<Ref.t<Ref.any>>)

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
