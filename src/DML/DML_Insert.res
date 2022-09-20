module Row = {
  let toSQL = row => {
    `(${row->Obj.magic->Js.Dict.values->Belt.Array.joinWith(", ", Sanitizer.valueToSQL)})`
  }
}

module Values = {
  let toSQL = values => {
    values->Js.Array2.map(Row.toSQL)
  }
}

module Query = {
  type t<'values> = {table: string, values: option<array<'values>>}

  let make = table => {
    table,
    values: None,
  }
}

let values = (query: Query.t<'values>, values: array<'values>) => {
  {...query, values: Some(values)}
}

let toSQL = (query: Query.t<_>) => {
  open StringBuilder

  switch query.values {
  | None | Some([]) => raise(Errors.MissingValues)
  | Some(values) => {
      let columns = values[0]->Obj.magic->Js.Dict.keys->Js.Array2.joinWith(", ")

      let rows = make()->addM(Values.toSQL(values))->buildWithComma

      make()->addS(`INSERT INTO ${query.table} (${columns}) VALUES`)->addS(rows)->build
    }
  }
}

let execute = (query, db) => {
  let sql = toSQL(query)

  db->SQLite3.prepare(sql)->SQLite3.run
}
