type t = Ref.Untyped.t

let group = ref => Ref.Typed.toUntyped(ref)

let toSQL = (groupBy, queryToString) => {
  Ref.Untyped.toSQL(groupBy, queryToString)
}
