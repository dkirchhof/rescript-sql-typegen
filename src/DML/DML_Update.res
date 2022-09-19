module Values = {
  let toSQL = values => {
    values
    ->Obj.magic
    ->Js.Dict.entries
    ->Js.Array2.map(((key, value)) => `${key} = ${Sanitizer.valueToSQL(value)}`)
    ->Js.Array2.joinWith(", ")
  }
}

module Selections = {
  let toSQL = (optionalSelections, queryToSQL) =>
    optionalSelections->Belt.Option.map(expr => `WHERE ${Expr.toSQL(expr, queryToSQL)}`)
}

module Query = {
  type t<'values, 'selectables> = {
    table: string,
    values: 'values,
    selections: option<Expr.t>,
    _selectables: 'selectables,
  }

  let make = (table, selectables, values) => {
    table,
    values,
    selections: None,
    _selectables: selectables,
  }
}

let where = (query: Query.t<_, _>, getSelections) => {
  let selections = getSelections(query._selectables)

  {...query, selections: Some(selections)}
}

let rec toSQL = (query: Query.t<_>) => {
  open StringBuilder

  make()
  ->addS(`UPDATE ${query.table} SET ${Values.toSQL(query.values)}`)
  ->addSO(Selections.toSQL(query.selections, toSQL))
  ->build
}

let execute = (query, db) => {
  let sql = toSQL(query)

  db->SQLite3.prepare(sql)->SQLite3.run
}
