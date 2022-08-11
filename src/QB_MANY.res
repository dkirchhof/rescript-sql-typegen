let rec toSQL = (executable: Query.executable<_, _, _, _, _, _, _>) => {
  let tableAliases = Js.Array2.concat(
    [executable.query.from.alias],
    executable.query.joins->Joins.toArray->Joins.getTableAliases,
  )

  [
    Projections.toSQL(executable.projections->Obj.magic, tableAliases, toSQL),
    From.toSQL(executable.query.from),
    Joins.toSQL(executable.query.joins, tableAliases, toSQL),
    Selections.toSQL(executable.query.selections, tableAliases, toSQL),
    GroupBys.toSQL(executable.query.groupBys, tableAliases, toSQL),
    Havings.toSQL(executable.query.havings, tableAliases, toSQL),
    OrderBys.toSQL(executable.query.orderBys, tableAliases, toSQL),
  ]
  ->Js.Array2.filter(s => String.length(s) > 0)
  ->Js.Array2.joinWith(" ")
}
