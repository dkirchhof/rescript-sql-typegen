type t = option<array<Projection.t>>

let toSQL = (projections, queryToString) =>
  switch projections {
  | Some(projections') =>
    `SELECT ${projections'->Belt.Array.joinWith(", ", Projection.toSQL(_, queryToString))}`
  | None => `SELECT *`
  }
