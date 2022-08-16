type t = {
  tableAlias: string,
  columnName: string,
  aggType: option<Aggregation.t>,
}

let toSQL = ref => {
  let columnString = `${ref.tableAlias}.${ref.columnName}`

  switch ref.aggType {
  | Some(COUNT) => `COUNT(${columnString})`
  | Some(SUM) => `SUM(${columnString})`
  | Some(AVG) => `AVG(${columnString})`
  | Some(MIN) => `MIN(${columnString})`
  | Some(MAX) => `MAX(${columnString})`
  | None => columnString
  }
}
