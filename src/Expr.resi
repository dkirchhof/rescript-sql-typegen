type rec t =
  | And(array<t>)
  | Or(array<t>)
  | Equal(Ref.Untyped.t, Ref.Untyped.t)
  | NotEqual(Ref.Untyped.t, Ref.Untyped.t)
  | GreaterThan(Ref.Untyped.t, Ref.Untyped.t)
  | GreaterThanEqual(Ref.Untyped.t, Ref.Untyped.t)
  | LessThan(Ref.Untyped.t, Ref.Untyped.t)
  | LessThanEqual(Ref.Untyped.t, Ref.Untyped.t)
  | In(Ref.Untyped.t, array<Ref.Untyped.t>)
  | NotIn(Ref.Untyped.t, array<Ref.Untyped.t>)

let and_: array<t> => t
let or_: array<t> => t

let eq: (Ref.Typed.t<'a>, Ref.Typed.t<'a>) => t
let neq: (Ref.Typed.t<'a>, Ref.Typed.t<'a>) => t
let gt: (Ref.Typed.t<'a>, Ref.Typed.t<'a>) => t
let gte: (Ref.Typed.t<'a>, Ref.Typed.t<'a>) => t
let lt: (Ref.Typed.t<'a>, Ref.Typed.t<'a>) => t
let lte: (Ref.Typed.t<'a>, Ref.Typed.t<'a>) => t
let in_: (Ref.Typed.t<'a>, array<Ref.Typed.t<'a>>) => t
let nin_: (Ref.Typed.t<'a>, array<Ref.Typed.t<'a>>) => t

let toSQL: (t, array<string>, 'a => string) => string
