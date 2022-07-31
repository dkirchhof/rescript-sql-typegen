type t = {
  tableIndex: int,
  columnName: string,
}

external make: Schema.column<'a> => t = "%identity"

let toSQL = (ref, withAlias) =>
  if withAlias {
    `${Belt.Int.toString(ref.tableIndex)}.${ref.columnName}`
  } else {
    ref.columnName
  }