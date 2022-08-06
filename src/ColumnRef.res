type t = {
  tableIndex: int,
  columnName: string,
}

external make: Schema.column<'a> => t = "%identity"

let toSQL = (ref, tableAliases) => `${tableAliases[ref.tableIndex]}.${ref.columnName}`
