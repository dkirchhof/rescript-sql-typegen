type t = Ref.Untyped.t;

let toSQL = (projection, alias, queryToString) => {
  switch projection {
  | Ref.Untyped.AsteriskRef(ref) => `${AsteriskRef.toSQL(ref)} AS "${alias}"`
  | Ref.Untyped.ColumnRef(ref) => `${ColumnRef.toSQL(ref)} AS "${alias}"`
  | Ref.Untyped.ValueRef(ref) => `${ValueRef.toSQL(ref)} AS "${alias}"`
  | Ref.Untyped.QueryRef(ref) => `${QueryRef.toSQL(ref, queryToString)} AS "${alias}"`
  }
}
