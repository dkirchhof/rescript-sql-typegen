let toSQL = (executable: Query.executable<_, _, _, _, _, _, _>) => {
  let tableAliases = Js.Array2.concat(
    [executable.query.from.alias],
    executable.query.joins->Joins.toArray->Joins.getTableAliases,
  )

  [
    Projections.toSQL(executable.projections->Obj.magic, tableAliases),
    From.toSQL(executable.query.from),
    Joins.toSQL(executable.query.joins, tableAliases),
    Selections.toSQL(executable.query.selections, tableAliases),
  ]
  ->Js.Array2.filter(s => String.length(s) > 0)
  ->Js.Array2.joinWith(" ")
}

let asSubQuery: Query.executable<_, _, _, _, _, _, 'projections> => SubQuery.t<
  'projections,
> = query => {
  query: query->Obj.magic,
  toSQL: toSQL->Obj.magic,
}
