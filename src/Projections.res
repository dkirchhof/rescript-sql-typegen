type t = option<array<Ref.t>>

let toSQL = (projections, tableAliases) =>
  switch projections {
  | Some(projections') =>
    `SELECT ${projections'->Belt.Array.joinWith(", ", p => {
        switch p {
        | Ref.ColumnRef(ref) => ColumnRef.toSQL(ref, tableAliases)
        | Ref.ValueRef(ref) => ValueRef.toSQL(ref)
        }
      })}`
  | None => `SELECT *`
  }
