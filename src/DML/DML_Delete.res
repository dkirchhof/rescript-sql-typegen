module Selections = {
  let toSQL = (optionalSelections, queryToSQL) =>
    optionalSelections->Belt.Option.map(expr => `WHERE ${Expr.toSQL(expr, queryToSQL)}`)
}

module Query = {
  type t<'selectables> = {
    table: string,
    selections: option<Expr.t>,
    _selectables: 'selectables,
  }

  let make = (table, selectables) => {
    table,
    selections: None,
    _selectables: selectables,
  }
}

let where = (query: Query.t<_>, getSelections) => {
  let selections = getSelections(query._selectables)

  {...query, selections: Some(selections)}
}

let rec toSQL = (query: Query.t<_>) => {
  open StringBuilder

  make()
  ->addS(`DELETE FROM ${query.table}`)
  ->addSO(Selections.toSQL(query.selections, toSQL))
  ->build
}

let execute = (query, mutate: Provider.mutate<_>, connection) => {
  toSQL(query)->mutate(connection)
}
