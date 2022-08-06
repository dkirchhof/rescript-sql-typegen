type t = option<array<Ref.t>>

let toSQL = (projections, withAlias) =>
  switch projections {
  | Some(projections') => `SELECT ${projections'->Belt.Array.joinWith(", ", p => {
    switch p {
      | Ref.ColumnRef(ref) => ColumnRef.toSQL(ref, true)
      | Ref.ValueRef(ref) => ValueRef.toSQL(ref)
    }
  })}`
  | None => `SELECT *`
  }
