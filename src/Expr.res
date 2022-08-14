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

let and_ = ands => And(ands)
let or_ = ors => Or(ors)

let eq = (left, right) => Equal(Ref.Typed.toUntyped(left), Ref.Typed.toUntyped(right))
let neq = (left, right) => NotEqual(Ref.Typed.toUntyped(left), Ref.Typed.toUntyped(right))
let gt = (left, right) => GreaterThan(Ref.Typed.toUntyped(left), Ref.Typed.toUntyped(right))
let gte = (left, right) => GreaterThanEqual(Ref.Typed.toUntyped(left), Ref.Typed.toUntyped(right))
let lt = (left, right) => LessThan(Ref.Typed.toUntyped(left), Ref.Typed.toUntyped(right))
let lte = (left, right) => LessThanEqual(Ref.Typed.toUntyped(left), Ref.Typed.toUntyped(right))

let in_ = (left, rights) => In(
  Ref.Typed.toUntyped(left),
  Js.Array2.map(rights, Ref.Typed.toUntyped),
)

let nin_ = (left, rights) => In(
  Ref.Typed.toUntyped(left),
  Js.Array2.map(rights, Ref.Typed.toUntyped),
)

let leftRightToSQL = (left, op, right, tableAliases, queryToString) => {
  let ls = Ref.Untyped.toSQL(left, tableAliases, queryToString)
  let rs = Ref.Untyped.toSQL(right, tableAliases, queryToString)

  `${ls} ${op} ${rs}`
}

let rec toSQL = (expr, tableAliases, queryToString) =>
  switch expr {
  | And(ands) => combine(ands, "AND", tableAliases, queryToString)
  | Or(ors) => combine(ors, "OR", tableAliases, queryToString)
  | Equal(left, right) => leftRightToSQL(left, "=", right, tableAliases, queryToString)
  | NotEqual(left, right) => leftRightToSQL(left, "!=", right, tableAliases, queryToString)
  | GreaterThan(left, right) => leftRightToSQL(left, ">", right, tableAliases, queryToString)
  | GreaterThanEqual(left, right) => leftRightToSQL(left, ">=", right, tableAliases, queryToString)
  | LessThan(left, right) => leftRightToSQL(left, "<", right, tableAliases, queryToString)
  | LessThanEqual(left, right) => leftRightToSQL(left, "<=", right, tableAliases, queryToString)
  | In(left, rights) => leftRightsToSQL(left, "IN", rights, tableAliases, queryToString)
  | NotIn(left, rights) => leftRightsToSQL(left, "NOT IN", rights, tableAliases, queryToString)
  }

and combine = (exprs, bool, tableAliases, queryToString) =>
  `(${Belt.Array.joinWith(exprs, ` ${bool} `, toSQL(_, tableAliases, queryToString))})`

and leftRightsToSQL = (left, op, rights, tableAliases, queryToString) => {
  let ls = Ref.Untyped.toSQL(left, tableAliases, queryToString)
  let rs = Belt.Array.joinWith(rights, ", ", Ref.Untyped.toSQL(_, tableAliases, queryToString))

  `${ls} ${op}(${rs})`
}
