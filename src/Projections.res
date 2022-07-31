type t = option<array<ColumnRef.t>>

let toSQL = (projections, withAlias) =>
  switch projections {
  | Some(projections') => [
      `SELECT ${projections'->Belt.Array.joinWith(", ", ColumnRef.toSQL(_, withAlias))}`,
    ]
  | None => [`SELECT *`]
  }
