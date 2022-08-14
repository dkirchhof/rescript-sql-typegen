module Untyped = {
  type t =
    | AsteriskRef(AsteriskRef.t)
    | ColumnRef(ColumnRef.t)
    | ValueRef(ValueRef.t)
    | QueryRef(QueryRef.t)

  let toSQL = (ref, tableAliases, queryToString) => {
    switch ref {
    | AsteriskRef(ref) => AsteriskRef.toSQL(ref)
    | ColumnRef(ref) => ColumnRef.toSQL(ref, tableAliases)
    | ValueRef(ref) => ValueRef.toSQL(ref)
    | QueryRef(ref) => QueryRef.toSQL(ref, queryToString)
    }
  }
}

module Typed = {
  @deriving(accessors)
  type t<'a> =
    | AsteriskRef(AsteriskRef.t)
    | ColumnRef(ColumnRef.t)
    | ValueRef(ValueRef.t)
    | QueryRef(QueryRef.t)

  let updateAggType = (t2, aggType) =>
    switch t2 {
    | AsteriskRef(ref) => AsteriskRef({...ref, aggType})
    | ColumnRef(ref) => ColumnRef({...ref, aggType})
    | ValueRef(_) => t2
    | QueryRef(_) => t2
    }

  external unbox: t<'a> => 'a = "%identity"
  external toUntyped: t<'a> => Untyped.t = "%identity"
}
