type t = Ref.anyRef

let group = ref => ref->Ref.toAnyRef

let toSQL = (groupBy, queryToString) => {
  Ref.toSQL(groupBy, queryToString)
}
