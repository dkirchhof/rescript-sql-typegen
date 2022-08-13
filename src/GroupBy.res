type t = Ref.Untyped.t

let group = ref => Ref.Typed.toUntyped(ref)

let toSQL = (groupBy, tableAliases, queryToString) => {
  Ref.Untyped.toSQL(groupBy, tableAliases, queryToString)
}
