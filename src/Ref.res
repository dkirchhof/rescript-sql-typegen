module Untyped = {
  type t =
    | ColumnRef(ColumnRef.t)
    | ValueRef(ValueRef.t)
    | QueryRef(QueryRef.t)

  let toSQL = (ref, queryToString) => {
    switch ref {
    | ColumnRef(ref) => ColumnRef.toSQL(ref)
    | ValueRef(ref) => ValueRef.toSQL(ref)
    | QueryRef(ref) => QueryRef.toSQL(ref, queryToString)
    }
  }
}

module Typed = {
  @deriving(accessors)
  type t<'a> =
    | ColumnRef(ColumnRef.t)
    | ValueRef(ValueRef.t)
    | QueryRef(QueryRef.t)

  let updateAggType = (t, aggType) =>
    switch t {
    | ColumnRef(ref) => ColumnRef({...ref, aggType})
    | ValueRef(_) => t
    | QueryRef(_) => t
    }

  external unbox: t<'a> => 'a = "%identity"
  external toUntyped: t<'a> => Untyped.t = "%identity"
}
