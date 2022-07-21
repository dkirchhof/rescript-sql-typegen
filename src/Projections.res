type t = option<array<Column.u>>

let toSQL = projections => {
  switch projections {
  | Some(projections') => `SELECT ${projections'->Belt.Array.joinWith(", ", p => Column.toSQL(p))}`
  | None => `SELECT *`
  }
}
