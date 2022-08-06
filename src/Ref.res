type t = ColumnRef(ColumnRef.t) | ValueRef(ValueRef.t) | QueryRef(QueryRef.t)
type t2<'a> = ColumnRef2(ColumnRef.t) | ValueRef2(ValueRef.t) | QueryRef2(QueryRef.t)

external tFromT2: t2<'a> => t = "%identity"

let toSQL = (ref, withAlias) => {
  switch ref {
  | ColumnRef(column) => ColumnRef.toSQL(column, withAlias)
  | ValueRef(value) => ValueRef.toSQL(value)
  | QueryRef(query) => QueryRef.toSQL(query)
  }
}
