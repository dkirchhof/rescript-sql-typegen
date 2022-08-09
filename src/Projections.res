type t = option<array<Projection.t>>

let toSQL = (projections, tableAliases) =>
  switch projections {
  | Some(projections') =>
    `SELECT ${projections'->Belt.Array.joinWith(", ", Projection.toSQL(_, tableAliases))}`
  | None => `SELECT *`
  }
