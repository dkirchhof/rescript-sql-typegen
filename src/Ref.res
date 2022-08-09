type t = ColumnRef(string, int, option<Column.aggType>) | ValueRef(ValueRef.t) | QueryRef(QueryRef.t)
type t2<'a> = ColumnRef2(string, int, option<Column.aggType>) | ValueRef2(ValueRef.t) | QueryRef2(QueryRef.t)

external tFromT2: t2<'a> => t = "%identity"
external unboxRef2: t2<'a> => 'a = "%identity"
external boxRef: 'a => t = "%identity"

let toSQL = (ref, tableAliases) => {
  switch ref {
  | ColumnRef(columnName, tableIndex, agg) => Column.toSQL(columnName, tableIndex, agg, tableAliases)
  | ValueRef(value) => ValueRef.toSQL(value)
  | QueryRef(query) => QueryRef.toSQL(query)
  }
}
