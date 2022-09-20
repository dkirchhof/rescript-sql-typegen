module Patch = {
  let toSQL = optionalPatch => {
    switch optionalPatch {
    | Some(patch) =>
      patch
      ->Obj.magic
      ->Js.Dict.entries
      ->Js.Array2.map(((key, value)) => `${key} = ${Sanitizer.valueToSQL(value)}`)
      ->Js.Array2.joinWith(", ")
    | None => raise(Errors.MissingPatch)
    }
  }
}

module Selections = {
  let toSQL = (optionalSelections, queryToSQL) =>
    optionalSelections->Belt.Option.map(expr => `WHERE ${Expr.toSQL(expr, queryToSQL)}`)
}

module Query = {
  type t<'patch, 'selectables> = {
    table: string,
    patch: option<'patch>,
    selections: option<Expr.t>,
    _selectables: 'selectables,
  }

  let make = (table, selectables) => {
    table,
    patch: None,
    selections: None,
    _selectables: selectables,
  }
}

let set = (query: Query.t<'patch, _>, patch: 'patch) => {
  {...query, patch: Some(patch)}
}

let where = (query: Query.t<_, _>, getSelections) => {
  let selections = getSelections(query._selectables)

  {...query, selections: Some(selections)}
}

let rec toSQL = (query: Query.t<_>) => {
  open StringBuilder

  make()
  ->addS(`UPDATE ${query.table} SET ${Patch.toSQL(query.patch)}`)
  ->addSO(Selections.toSQL(query.selections, toSQL))
  ->build
}

let execute = (query, db) => {
  let sql = toSQL(query)

  db->SQLite3.prepare(sql)->SQLite3.run
}
