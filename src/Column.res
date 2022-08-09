type aggType = COUNT | SUM | AVG | MIN | MAX

type t<'t> = {
  tableIndex: int,
  columnName: string,
}

type untyped = {
  tableIndex: int,
  columnName: string,
}

external asUntyped: t<'t> => untyped = "%identity"
external fromSchema: Schema.column<'t> => t<'t> = "%identity"
external fromSchemaToUntyped: Schema.column<'t> => untyped = "%identity"

let toSQL = (columnName, tableIndex, agg, tableAliases) => {
  let columnString = `${tableAliases[tableIndex]}.${columnName}`

  switch agg {
  | Some(COUNT) => `COUNT(${columnString})`
  | Some(SUM) => `SUM(${columnString})`
  | Some(AVG) => `AVG(${columnString})`
  | Some(MIN) => `MIN(${columnString})`
  | Some(MAX) => `MAX(${columnString})`
  | None => columnString
  }
}
