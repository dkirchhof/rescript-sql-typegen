module Ref = {
  type t = ColumnRef(ColumnRef.t) | ValueRef(ValueRef.t)

  let toSQL = ref => {
    switch ref {
    | ColumnRef(column) => ColumnRef.toSQL(column, false)
    | ValueRef(value) => ValueRef.toSQL(value)
    /* | SubQuery(query) => `(${query})` */
    }
  }
}

type rec t =
  | And(array<t>)
  | Or(array<t>)
  | Eq(Ref.t, Ref.t)
/* | Neq(Ref.t, Ref.t) */
/* | Gt(Ref.t, Ref.t) */
/* | Gte(Ref.t, Ref.t) */
/* | Lt(Ref.t, Ref.t) */
/* | Lte(Ref.t, Ref.t) */
/* | In(Ref.t, array<Ref.t>) */
/* | Nin(Ref.t, array<Ref.t>) */

let and_ = ands => And(ands)
let or_ = ors => Or(ors)

let eqV = (column: Schema.column<'a>, value: 'a) => Eq(
  ColumnRef(ColumnRef.make(column)),
  ValueRef(ValueRef.make(value)),
)

let eqC = (column: Schema.column<'a>, value: Schema.column<'a>) => Eq(
  ColumnRef(ColumnRef.make(column)),
  ColumnRef(ColumnRef.make(value)),
)

let rec toSQL = expr => {
  switch expr {
  | And(ands) => `(${Belt.Array.joinWith(ands, " AND ", toSQL)})`
  | Or(ors) => `(${Belt.Array.joinWith(ors, " OR ", toSQL)})`
  | Eq(left, right) => `${Ref.toSQL(left)} = ${Ref.toSQL(right)}`
  /* | Neq(left, right) => */
  /* `${Ref.toSQL(left)} != ${Ref.toSQL(right)}` */
  /* | Gt(left, right) => */
  /* `${Ref.toSQL(left)} > ${Ref.toSQL(right)}` */
  /* | Gte(left, right) => */
  /* `${Ref.toSQL(left)} >= ${Ref.toSQL(right)}` */
  /* | Lt(left, right) => */
  /* `${Ref.toSQL(left)} < ${Ref.toSQL(right)}` */
  /* | Lte(left, right) => */
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
