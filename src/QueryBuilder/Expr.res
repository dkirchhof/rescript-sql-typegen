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

let and_ = ands => And(ands)
let or_ = ors => Or(ors)

let eq = (left, right) => Equal(Ref.toAnyRef(left), Ref.toAnyRef(right))
let neq = (left, right) => NotEqual(Ref.toAnyRef(left), Ref.toAnyRef(right))
let gt = (left, right) => GreaterThan(Ref.toAnyRef(left), Ref.toAnyRef(right))
let gte = (left, right) => GreaterThanEqual(Ref.toAnyRef(left), Ref.toAnyRef(right))
let lt = (left, right) => LessThan(Ref.toAnyRef(left), Ref.toAnyRef(right))
let lte = (left, right) => LessThanEqual(Ref.toAnyRef(left), Ref.toAnyRef(right))

let btw = (left, r1, r2) => Between(
  Ref.toAnyRef(left),
  Ref.toAnyRef(r1),
  Ref.toAnyRef(r2),
)

let nbtw = (left, r1, r2) => NotBetween(
  Ref.toAnyRef(left),
  Ref.toAnyRef(r1),
  Ref.toAnyRef(r2),
)

let in_ = (left, rights) => In(
  Ref.toAnyRef(left),
  Js.Array2.map(rights, Ref.toAnyRef),
)

let nin_ = (left, rights) => In(
  Ref.toAnyRef(left),
  Js.Array2.map(rights, Ref.toAnyRef),
)

let leftRightToSQL = (left, op, right, queryToString) => {
  let ls = Ref.toSQL(left, queryToString)
  let rs = Ref.toSQL(right, queryToString)

  `${ls} ${op} ${rs}`
}

let betweenToSQL = (left, bool, r1, r2, queryToString) => {
  let ls = Ref.toSQL(left, queryToString)
  let r1s = Ref.toSQL(r1, queryToString)
  let r2s = Ref.toSQL(r2, queryToString)

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
  let ls = Ref.toSQL(left, queryToString)
  let rs = Belt.Array.joinWith(rights, ", ", Ref.toSQL(_, queryToString))

  `${ls} ${op}(${rs})`
}
