type t = Ref.t

let group = ref => Ref.tFromT2(ref)

let toSQL = (groupBy, tableAliases) => {
  Ref.toSQL(groupBy, tableAliases)
}
