type rec t =
  | And(array<t>)
  | Or(array<t>)
  | Equal(Ref.Untyped.t, Ref.Untyped.t)
  | NotEqual(Ref.Untyped.t, Ref.Untyped.t)
  | GreaterThan(Ref.Untyped.t, Ref.Untyped.t)
  | GreaterThanEqual(Ref.Untyped.t, Ref.Untyped.t)
  | LessThan(Ref.Untyped.t, Ref.Untyped.t)
  | LessThanEqual(Ref.Untyped.t, Ref.Untyped.t)
  | Between(Ref.Untyped.t, Ref.Untyped.t, Ref.Untyped.t)
  | NotBetween(Ref.Untyped.t, Ref.Untyped.t, Ref.Untyped.t)
  | In(Ref.Untyped.t, array<Ref.Untyped.t>)
  | NotIn(Ref.Untyped.t, array<Ref.Untyped.t>)

let and_ = ands => And(ands)
let or_ = ors => Or(ors)

let eq = (left, right) => Equal(Ref.Typed.toUntyped(left), Ref.Typed.toUntyped(right))
let neq = (left, right) => NotEqual(Ref.Typed.toUntyped(left), Ref.Typed.toUntyped(right))
let gt = (left, right) => GreaterThan(Ref.Typed.toUntyped(left), Ref.Typed.toUntyped(right))
let gte = (left, right) => GreaterThanEqual(Ref.Typed.toUntyped(left), Ref.Typed.toUntyped(right))
let lt = (left, right) => LessThan(Ref.Typed.toUntyped(left), Ref.Typed.toUntyped(right))
let lte = (left, right) => LessThanEqual(Ref.Typed.toUntyped(left), Ref.Typed.toUntyped(right))

let btw = (left, r1, r2) => Between(
  Ref.Typed.toUntyped(left),
  Ref.Typed.toUntyped(r1),
  Ref.Typed.toUntyped(r2),
)

let nbtw = (left, r1, r2) => NotBetween(
  Ref.Typed.toUntyped(left),
  Ref.Typed.toUntyped(r1),
  Ref.Typed.toUntyped(r2),
)

let in_ = (left, rights) => In(
  Ref.Typed.toUntyped(left),
  Js.Array2.map(rights, Ref.Typed.toUntyped),
)

let nin_ = (left, rights) => In(
  Ref.Typed.toUntyped(left),
  Js.Array2.map(rights, Ref.Typed.toUntyped),
)

let leftRightToSQL = (left, op, right, queryToString) => {
  let ls = Ref.Untyped.toSQL(left, queryToString)
  let rs = Ref.Untyped.toSQL(right, queryToString)

  `${ls} ${op} ${rs}`
}

let betweenToSQL = (left, bool, r1, r2, queryToString) => {
  let ls = Ref.Untyped.toSQL(left, queryToString)
  let r1s = Ref.Untyped.toSQL(r1, queryToString)
  let r2s = Ref.Untyped.toSQL(r2, queryToString)

  if bool {
    `${ls} BETWEEN ${r1s} AND ${r2s}`
  } else {
    `${ls} NOT BETWEEN ${r1s} AND ${r2s}`
  }
}

let rec toSQL = (expr, queryToString) =>
  switch expr {
  | And(ands) => combine(ands, "AND", queryToString)
  | Or(ors) => combine(ors, "OR", queryToString)
  | Equal(left, right) => leftRightToSQL(left, "=", right, queryToString)
  | NotEqual(left, right) => leftRightToSQL(left, "!=", right, queryToString)
  | GreaterThan(left, right) => leftRightToSQL(left, ">", right, queryToString)
  | GreaterThanEqual(left, right) => leftRightToSQL(left, ">=", right, queryToString)
  | LessThan(left, right) => leftRightToSQL(left, "<", right, queryToString)
  | LessThanEqual(left, right) => leftRightToSQL(left, "<=", right, queryToString)
  | Between(left, r1, r2) => betweenToSQL(left, true, r1, r2, queryToString)
  | NotBetween(left, r1, r2) => betweenToSQL(left, false, r1, r2, queryToString)
  | In(left, rights) => leftRightsToSQL(left, "IN", rights, queryToString)
  | NotIn(left, rights) => leftRightsToSQL(left, "NOT IN", rights, queryToString)
  }

and combine = (exprs, bool, queryToString) =>
  `(${Belt.Array.joinWith(exprs, ` ${bool} `, toSQL(_, queryToString))})`

and leftRightsToSQL = (left, op, rights, queryToString) => {
  let ls = Ref.Untyped.toSQL(left, queryToString)
  let rs = Belt.Array.joinWith(rights, ", ", Ref.Untyped.toSQL(_, queryToString))

  `${ls} ${op}(${rs})`
}
