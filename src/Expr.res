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

let eq = (left: Ref.t2<'a>, right: Ref.t2<'a>) => Equal(
  Ref.tFromT2(left),
  Ref.tFromT2(right),
)

let neq = (left: Ref.t2<'a>, right: Ref.t2<'a>) => NotEqual(
  Ref.tFromT2(left),
  Ref.tFromT2(right),
)

let gt = (left: Ref.t2<'a>, right: Ref.t2<'a>) => GreaterThan(
  Ref.tFromT2(left),
  Ref.tFromT2(right),
)

let gte = (left: Ref.t2<'a>, right: Ref.t2<'a>) => GreaterThanEqual(
  Ref.tFromT2(left),
  Ref.tFromT2(right),
)

let lt = (left: Ref.t2<'a>, right: Ref.t2<'a>) => LessThan(
  Ref.tFromT2(left),
  Ref.tFromT2(right),
)

let lte = (left: Ref.t2<'a>, right: Ref.t2<'a>) => LessThanEqual(
  Ref.tFromT2(left),
  Ref.tFromT2(right),
)

let rec toSQL = (expr, withAlias: bool) => {
  switch expr {
  | And(ands) => `(${Belt.Array.joinWith(ands, " AND ", toSQL(_, withAlias))})`
  | Or(ors) => `(${Belt.Array.joinWith(ors, " OR ", toSQL(_, withAlias))})`
  | Equal(left, right) => `${Ref.toSQL(left, withAlias)} = ${Ref.toSQL(right, withAlias)}`
  | NotEqual(left, right) => `${Ref.toSQL(left, withAlias)} != ${Ref.toSQL(right, withAlias)}`
  | GreaterThan(left, right) => `${Ref.toSQL(left, withAlias)} > ${Ref.toSQL(right, withAlias)}`
  | GreaterThanEqual(left, right) => `${Ref.toSQL(left, withAlias)} >= ${Ref.toSQL(right, withAlias)}`
  | LessThan(left, right) => `${Ref.toSQL(left, withAlias)} < ${Ref.toSQL(right, withAlias)}`
  | LessThanEqual(left, right) => `${Ref.toSQL(left, withAlias)} <= ${Ref.toSQL(right, withAlias)}`




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
