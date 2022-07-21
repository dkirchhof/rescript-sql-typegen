module ColumnValueOrSubQuery = {
  type t<'t> = Column(Column.t<'t>) | Value('t) | SubQuery('t)

  let toSQL = columnValueOrSubQuery => {
    switch columnValueOrSubQuery {
    | Column(column) => Column.toSQL(column->Obj.magic)
    | Value(value) => value->Obj.magic->Js.Json.stringify
    | SubQuery(query) => `(${query})`
    }
  }
}

module Expr = {
  type rec t<'t> =
    | And(array<t<'t>>)
    | Or(array<t<'t>>)
    | Eq(ColumnValueOrSubQuery.t<'t>, ColumnValueOrSubQuery.t<'t>)
    | Neq(ColumnValueOrSubQuery.t<'t>, ColumnValueOrSubQuery.t<'t>)
    | Gt(ColumnValueOrSubQuery.t<'t>, ColumnValueOrSubQuery.t<'t>)
    | Gte(ColumnValueOrSubQuery.t<'t>, ColumnValueOrSubQuery.t<'t>)
    | Lt(ColumnValueOrSubQuery.t<'t>, ColumnValueOrSubQuery.t<'t>)
    | Lte(ColumnValueOrSubQuery.t<'t>, ColumnValueOrSubQuery.t<'t>)
    | In(ColumnValueOrSubQuery.t<'t>, array<ColumnValueOrSubQuery.t<'t>>)
    | Nin(ColumnValueOrSubQuery.t<'t>, array<ColumnValueOrSubQuery.t<'t>>)

  let rec toSQL = expr => {
    switch expr {
    | And(ands) => `(${Belt.Array.joinWith(ands, " AND ", toSQL)})`
    | Or(ors) => `(${Belt.Array.joinWith(ors, " OR ", toSQL)})`
    | Eq(left, right) =>
      `${ColumnValueOrSubQuery.toSQL(left)} = ${ColumnValueOrSubQuery.toSQL(right)}`
    | Neq(left, right) =>
      `${ColumnValueOrSubQuery.toSQL(left)} != ${ColumnValueOrSubQuery.toSQL(right)}`
    | Gt(left, right) =>
      `${ColumnValueOrSubQuery.toSQL(left)} > ${ColumnValueOrSubQuery.toSQL(right)}`
    | Gte(left, right) =>
      `${ColumnValueOrSubQuery.toSQL(left)} >= ${ColumnValueOrSubQuery.toSQL(right)}`
    | Lt(left, right) =>
      `${ColumnValueOrSubQuery.toSQL(left)} < ${ColumnValueOrSubQuery.toSQL(right)}`
    | Lte(left, right) =>
      `${ColumnValueOrSubQuery.toSQL(left)} <= ${ColumnValueOrSubQuery.toSQL(right)}`
    | In(left, rights) =>
      `${ColumnValueOrSubQuery.toSQL(left)} IN(${Belt.Array.joinWith(
          rights,
          ", ",
          ColumnValueOrSubQuery.toSQL,
        )})`
    | Nin(left, rights) =>
      `${ColumnValueOrSubQuery.toSQL(left)} NOT IN(${Belt.Array.joinWith(
          rights,
          ", ",
          ColumnValueOrSubQuery.toSQL,
        )})`
    }
  }
}

type any
type t = option<Expr.t<any>>

let toSQL = selection => {
  switch selection {
  | Some(expr) => `WHERE ${Expr.toSQL(expr)}`
  | None => ""
  }
}
