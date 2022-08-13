type rec t =
  | And(array<t>)
  | Or(array<t>)
  | Equal(Ref.Untyped.t, Ref.Untyped.t)
  | NotEqual(Ref.Untyped.t, Ref.Untyped.t)
  | GreaterThan(Ref.Untyped.t, Ref.Untyped.t)
  | GreaterThanEqual(Ref.Untyped.t, Ref.Untyped.t)
  | LessThan(Ref.Untyped.t, Ref.Untyped.t)
  | LessThanEqual(Ref.Untyped.t, Ref.Untyped.t)
/* | In(Ref.Untyped.t, array<Ref.Untyped.t>) */
/* | Nin(Ref.Untyped.t, array<Ref.Untyped.t>) */

let and_ = ands => And(ands)
let or_ = ors => Or(ors)

let eq = (left: Ref.Typed.t<'a>, right: Ref.Typed.t<'a>) => Equal(Ref.Typed.toUntyped(left), Ref.Typed.toUntyped(right))

let neq = (left: Ref.Typed.t<'a>, right: Ref.Typed.t<'a>) => NotEqual(Ref.Typed.toUntyped(left), Ref.Typed.toUntyped(right))

let gt = (left: Ref.Typed.t<'a>, right: Ref.Typed.t<'a>) => GreaterThan(Ref.Typed.toUntyped(left), Ref.Typed.toUntyped(right))

let gte = (left: Ref.Typed.t<'a>, right: Ref.Typed.t<'a>) => GreaterThanEqual(Ref.Typed.toUntyped(left), Ref.Typed.toUntyped(right))

let lt = (left: Ref.Typed.t<'a>, right: Ref.Typed.t<'a>) => LessThan(Ref.Typed.toUntyped(left), Ref.Typed.toUntyped(right))

let lte = (left: Ref.Typed.t<'a>, right: Ref.Typed.t<'a>) => LessThanEqual(Ref.Typed.toUntyped(left), Ref.Typed.toUntyped(right))

let rec toSQL = (expr, tableAliases, queryToString) => {
  switch expr {
  | And(ands) => `(${Belt.Array.joinWith(ands, " AND ", toSQL(_, tableAliases, queryToString))})`
  | Or(ors) => `(${Belt.Array.joinWith(ors, " OR ", toSQL(_, tableAliases, queryToString))})`
  | Equal(left, right) => `${Ref.Untyped.toSQL(left, tableAliases, queryToString)} = ${Ref.Untyped.toSQL(right, tableAliases, queryToString)}`
  | NotEqual(left, right) => `${Ref.Untyped.toSQL(left, tableAliases, queryToString)} != ${Ref.Untyped.toSQL(right, tableAliases, queryToString)}`
  | GreaterThan(left, right) => `${Ref.Untyped.toSQL(left, tableAliases, queryToString)} > ${Ref.Untyped.toSQL(right, tableAliases, queryToString)}`
  | GreaterThanEqual(left, right) => `${Ref.Untyped.toSQL(left, tableAliases, queryToString)} >= ${Ref.Untyped.toSQL(right, tableAliases, queryToString)}`
  | LessThan(left, right) => `${Ref.Untyped.toSQL(left, tableAliases, queryToString)} < ${Ref.Untyped.toSQL(right, tableAliases, queryToString)}`
  | LessThanEqual(left, right) => `${Ref.Untyped.toSQL(left, tableAliases, queryToString)} <= ${Ref.Untyped.toSQL(right, tableAliases, queryToString)}`

  /* `${toSQL(left)} <= ${toSQL(right)}` */
  /* | In(left, rights) => */
  /* `${toSQL(left)} IN(${Belt.Array.joinWith( */
  /* rights, */
  /* ", ", */
  /* toSQL, */
  /* )})` */
  /* | Nin(left, rights) => */
  /* `${toSQL(left)} NOT IN(${Belt.Array.joinWith( */
  /* rights, */
  /* ", ", */
  /* toSQL, */
  /* )})` */
  }
}
