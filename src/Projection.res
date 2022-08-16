type t = Ref.Untyped.t

let toSQL = (projection, queryToString) => {
  switch projection {
  | Ref.Untyped.AsteriskRef(ref) => AsteriskRef.toSQL(ref)
  | Ref.Untyped.ColumnRef(ref) => ColumnRef.toSQL(ref)
  | Ref.Untyped.ValueRef(ref) => ValueRef.toSQL(ref)
  | Ref.Untyped.QueryRef(ref) => QueryRef.toSQL(ref, queryToString)
  }
}
