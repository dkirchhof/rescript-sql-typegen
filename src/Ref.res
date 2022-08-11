type t = ColumnRef(ColumnRef.t) | ValueRef(ValueRef.t) | QueryRef(QueryRef.t)

@deriving(accessors)
type t2<'a> = ColumnRef2(ColumnRef.t) | ValueRef2(ValueRef.t) | QueryRef2(QueryRef.t)

external tFromT2: t2<'a> => t = "%identity"
external unboxRef2: t2<'a> => 'a = "%identity"
external boxRef: 'a => t = "%identity"

let updateT2WithAggType = (t2, aggType) => 
  switch t2 {
    | ColumnRef2(ref) => ColumnRef2({ ...ref, aggType })
    | ValueRef2(_) => t2
    | QueryRef2(_) => t2
  }

let toSQL = (ref, tableAliases) => {
  switch ref {
  | ColumnRef(ref) => ColumnRef.toSQL(ref, tableAliases)
  | ValueRef(ref) => ValueRef.toSQL(ref)
  | QueryRef(ref) => QueryRef.toSQL(ref)
  }
}
