module Ref = {
  type t = ColumnRef(ColumnRef.t) | ValueRef(ValueRef.t) | QueryRef(QueryRef.t)

  let toSQL = (ref, withAlias) => {
    switch ref {
    | ColumnRef(column) => ColumnRef.toSQL(column, withAlias)
    | ValueRef(value) => ValueRef.toSQL(value)
    | QueryRef(query) => QueryRef.toSQL(query)
    }
  }
}

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

let eqV = (column: Schema.column<'a>, value: 'a) => Equal(
  ColumnRef(ColumnRef.make(column)),
  ValueRef(ValueRef.make(value)),
)

let eqC = (column: Schema.column<'a>, value: Schema.column<'a>) => Equal(
  ColumnRef(ColumnRef.make(column)),
  ColumnRef(ColumnRef.make(value)),
)

let eqS = (column: Schema.column<'a>, value: SubQuery.t<'a>) => Equal(
  ColumnRef(ColumnRef.make(column)),
  QueryRef(QueryRef.make(value)),
)

let neqV = (column: Schema.column<'a>, value: 'a) => NotEqual(
  ColumnRef(ColumnRef.make(column)),
  ValueRef(ValueRef.make(value)),
)

let neqC = (column: Schema.column<'a>, value: Schema.column<'a>) => NotEqual(
  ColumnRef(ColumnRef.make(column)),
  ColumnRef(ColumnRef.make(value)),
)

let neqS = (column: Schema.column<'a>, value: SubQuery.t<'a>) => NotEqual(
  ColumnRef(ColumnRef.make(column)),
  QueryRef(QueryRef.make(value)),
)

let gtV = (column: Schema.column<'a>, value: 'a) => GreaterThan(
  ColumnRef(ColumnRef.make(column)),
  ValueRef(ValueRef.make(value)),
)

let gtC = (column: Schema.column<'a>, value: Schema.column<'a>) => GreaterThan(
  ColumnRef(ColumnRef.make(column)),
  ColumnRef(ColumnRef.make(value)),
)

let gtS = (column: Schema.column<'a>, value: SubQuery.t<'a>) => GreaterThan(
  ColumnRef(ColumnRef.make(column)),
  QueryRef(QueryRef.make(value)),
)

let gteV = (column: Schema.column<'a>, value: 'a) => GreaterThanEqual(
  ColumnRef(ColumnRef.make(column)),
  ValueRef(ValueRef.make(value)),
)

let gteC = (column: Schema.column<'a>, value: Schema.column<'a>) => GreaterThanEqual(
  ColumnRef(ColumnRef.make(column)),
  ColumnRef(ColumnRef.make(value)),
)

let gteS = (column: Schema.column<'a>, value: SubQuery.t<'a>) => GreaterThanEqual(
  ColumnRef(ColumnRef.make(column)),
  QueryRef(QueryRef.make(value)),
)

let ltV = (column: Schema.column<'a>, value: 'a) => LessThan(
  ColumnRef(ColumnRef.make(column)),
  ValueRef(ValueRef.make(value)),
)

let ltC = (column: Schema.column<'a>, value: Schema.column<'a>) => LessThan(
  ColumnRef(ColumnRef.make(column)),
  ColumnRef(ColumnRef.make(value)),
)

let ltS = (column: Schema.column<'a>, value: SubQuery.t<'a>) => LessThan(
  ColumnRef(ColumnRef.make(column)),
  QueryRef(QueryRef.make(value)),
)

let lteV = (column: Schema.column<'a>, value: 'a) => LessThanEqual(
  ColumnRef(ColumnRef.make(column)),
  ValueRef(ValueRef.make(value)),
)

let lteC = (column: Schema.column<'a>, value: Schema.column<'a>) => LessThanEqual(
  ColumnRef(ColumnRef.make(column)),
  ColumnRef(ColumnRef.make(value)),
)

let lteS = (column: Schema.column<'a>, value: SubQuery.t<'a>) => LessThanEqual(
  ColumnRef(ColumnRef.make(column)),
  QueryRef(QueryRef.make(value)),
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
