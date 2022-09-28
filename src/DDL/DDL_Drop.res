module Query = {
  type t<'columns> = {table: DDL_Table.t<'columns>}

  let make = table => {
    table: table,
  }
}

let toSQL = (query: Query.t<_>) => {
  `DROP TABLE ${query.table.name}`
}

let execute = (query, mutate: Provider.mutate<_>, connection) => {
  toSQL(query)->mutate(connection)
}
