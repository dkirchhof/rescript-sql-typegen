type t = option<array<Projection.t>>

let toSQL = (projections, tableAliases, queryToString) =>
  switch projections {
  | Some(projections') =>
    `SELECT ${projections'->Belt.Array.joinWith(", ", Projection.toSQL(_, tableAliases, queryToString))}`
  | None => `SELECT *`
  }
