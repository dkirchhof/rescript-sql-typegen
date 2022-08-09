type t = Ref.t

let toSQL = (projection, tableAliases) => {
  switch projection {
  | Ref.ColumnRef(columnName, tableIndex, agg) =>
    Column.toSQL(columnName, tableIndex, agg, tableAliases)
  | Ref.ValueRef(ref) => ValueRef.toSQL(ref)
  }
}
