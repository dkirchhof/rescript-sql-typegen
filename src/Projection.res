type t = Ref.t

let toSQL = (projection, tableAliases, queryToString) => {
  switch projection {
  | Ref.ColumnRef(ref) => ColumnRef.toSQL(ref, tableAliases)
  | Ref.ValueRef(ref) => ValueRef.toSQL(ref)
  | Ref.QueryRef(ref) => QueryRef.toSQL(ref, queryToString)
  }
}
