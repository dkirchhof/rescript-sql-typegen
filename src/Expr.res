type ref<'t>

type rec t =
  | And(array<t>)
  | Or(array<t>)
  | Equal(Ref.t, Ref.t)
  | NotEqual(Ref.t, Ref.t)
  | GreaterThan(Ref.t, Ref.t)
  | GreaterThanEqual(Ref.t, Ref.t)
  | LessThan(Ref.t, Ref.t)
  | LessThanEqual(Ref.t, Ref.t)
/* | In(Ref.t, array<Ref.t>) */
/* | Nin(Ref.t, array<Ref.t>) */

let and_ = ands => And(ands)
let or_ = ors => Or(ors)

let eq = (left: Ref.t2<'a>, right: Ref.t2<'a>) => Equal(Ref.boxRef(left), Ref.boxRef(right))

let neq = (left: Ref.t2<'a>, right: Ref.t2<'a>) => NotEqual(Ref.boxRef(left), Ref.boxRef(right))

let gt = (left: Ref.t2<'a>, right: Ref.t2<'a>) => GreaterThan(Ref.boxRef(left), Ref.boxRef(right))

let gte = (left: Ref.t2<'a>, right: Ref.t2<'a>) => GreaterThanEqual(Ref.boxRef(left), Ref.boxRef(right))

let lt = (left: Ref.t2<'a>, right: Ref.t2<'a>) => LessThan(Ref.boxRef(left), Ref.boxRef(right))

let lte = (left: Ref.t2<'a>, right: Ref.t2<'a>) => LessThanEqual(Ref.boxRef(left), Ref.boxRef(right))

let rec toSQL = (expr, tableAliases) => {
  switch expr {
  | And(ands) => `(${Belt.Array.joinWith(ands, " AND ", toSQL(_, tableAliases))})`
  | Or(ors) => `(${Belt.Array.joinWith(ors, " OR ", toSQL(_, tableAliases))})`
  | Equal(left, right) => `${Ref.toSQL(left, tableAliases)} = ${Ref.toSQL(right, tableAliases)}`
  | NotEqual(left, right) => `${Ref.toSQL(left, tableAliases)} != ${Ref.toSQL(right, tableAliases)}`
  | GreaterThan(left, right) =>
    `${Ref.toSQL(left, tableAliases)} > ${Ref.toSQL(right, tableAliases)}`
  | GreaterThanEqual(left, right) =>
    `${Ref.toSQL(left, tableAliases)} >= ${Ref.toSQL(right, tableAliases)}`
  | LessThan(left, right) => `${Ref.toSQL(left, tableAliases)} < ${Ref.toSQL(right, tableAliases)}`
  | LessThanEqual(left, right) =>
    `${Ref.toSQL(left, tableAliases)} <= ${Ref.toSQL(right, tableAliases)}`

  /* `${Ref.toSQL(left)} <= ${Ref.toSQL(right)}` */
  /* | In(left, rights) => */
  /* `${Ref.toSQL(left)} IN(${Belt.Array.joinWith( */
  /* rights, */
  /* ", ", */
  /* Ref.toSQL, */
  /* )})` */
  /* | Nin(left, rights) => */
  /* `${Ref.toSQL(left)} NOT IN(${Belt.Array.joinWith( */
  /* rights, */
  /* ", ", */
  /* Ref.toSQL, */
  /* )})` */
  }
}
