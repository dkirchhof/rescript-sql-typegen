type t = Ref.Untyped.t

let toSQL = (projection, tableAliases, queryToString) => {
  switch projection {
  | Ref.Untyped.ColumnRef(ref) => ColumnRef.toSQL(ref, tableAliases)
  | Ref.Untyped.ValueRef(ref) => ValueRef.toSQL(ref)
  | Ref.Untyped.QueryRef(ref) => QueryRef.toSQL(ref, queryToString)
  }
}
