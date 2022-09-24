module Query = {
  type t<'columns> = {table: DDL_Table.t<'columns>}

  let make = table => {
    table: table,
  }
}

let toSQL = (query: Query.t<_>) => {
  `DROP TABLE ${query.table.name}`
}

let execute = (query, db) => {
  let sql = toSQL(query)

  db->SQLite3.prepare(sql)->SQLite3.run->ignore
}
