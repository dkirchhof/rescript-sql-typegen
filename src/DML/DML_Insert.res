module Row = {
  let valueToSQL = value => {
    let str = Js.String.make(value)

    if Js.Types.test(value, Js.Types.String) {
      `'${Sanitize.sanitize(str)}'`
    } else {
      str
    }
  }

  let toSQL = values => {
    `(${values->Js.Dict.values->Belt.Array.joinWith(", ", valueToSQL)})`
  }
}

module Values = {
  let toSQL = values => {
    values->Js.Array2.map(Row.toSQL)
  }
}

module Query = {
  type t<'values> = {table: string, values: array<'values>}

  let make = (table, values) => {
    table,
    values: values->Obj.magic,
  }
}

let toSQL = (query: Query.t<_>) => {
  open StringBuilder

  let columns = query.values[0]->Js.Dict.keys->Js.Array2.joinWith(", ")

  let rows = make()->addM(Values.toSQL(query.values))->buildWithComma

  make()->addS(`INSERT INTO ${query.table} (${columns}) VALUES`)->addS(rows)->build
}

let execute = (query, db) => {
  let sql = toSQL(query)

  db->SQLite3.prepare(sql)->SQLite3.run
}
