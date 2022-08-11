type aggType = COUNT | SUM | AVG | MIN | MAX

type t = {
  columnName: string,
  tableIndex: int,
  aggType: option<aggType>,
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
