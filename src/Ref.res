module Untyped = {
  type t = ColumnRef(ColumnRef.t) | ValueRef(ValueRef.t) | QueryRef(QueryRef.t)

  let toSQL = (ref, tableAliases, queryToString) => {
    switch ref {
    | ColumnRef(ref) => ColumnRef.toSQL(ref, tableAliases)
    | ValueRef(ref) => ValueRef.toSQL(ref)
    | QueryRef(ref) => QueryRef.toSQL(ref, queryToString)
    }
  }
}

module Typed = {
  @deriving(accessors)
  type t<'a> = ColumnRef(ColumnRef.t) | ValueRef(ValueRef.t) | QueryRef(QueryRef.t)

  let updateAggType = (t2, aggType) =>
    switch t2 {
    | ColumnRef(ref) => ColumnRef({...ref, aggType})
    | ValueRef(_) => t2
    | QueryRef(_) => t2
    }

  external unbox: t<'a> => 'a = "%identity"
  external toUntyped: t<'a> => Untyped.t = "%identity"
}

