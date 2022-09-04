type t = Ref.t<Ref.any>

let group = ref => ref->Ref.toAnyRef

let toSQL = (groupBy, queryToString) => {
  Ref.toSQL(groupBy, queryToString)
}
