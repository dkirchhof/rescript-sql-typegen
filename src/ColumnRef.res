type t = {
  columnName: string,
  tableIndex: int,
  aggType: option<Aggregation.t>,
}

let toSQL = (ref, tableAliases) => {
  let columnString = `${tableAliases[ref.tableIndex]}.${ref.columnName}`

  switch ref.aggType {
  | Some(COUNT) => `COUNT(${columnString})`
  | Some(SUM) => `SUM(${columnString})`
  | Some(AVG) => `AVG(${columnString})`
  | Some(MIN) => `MIN(${columnString})`
  | Some(MAX) => `MAX(${columnString})`
  | None => columnString
  }
}
