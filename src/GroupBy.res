type t = ColumnRef.t

let toSQL = (groupBy, tableAliases) => {
  ColumnRef.toSQL(groupBy, tableAliases)
}
