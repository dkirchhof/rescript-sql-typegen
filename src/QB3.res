let select = (
  query: Query.t3<'p1, 'p2, 'p3, 's1, 's2, 's3, _>,
  getColumns: ('p1, 'p2, 'p3) => 'projections,
) => {
  let columnAccessor = Utils.createColumnAccessorWithJoins()
  let projections = getColumns(columnAccessor)->Obj.magic

  let query: Query.t3<'p1, 'p2, 'p3, 's1, 's2, 's3, 'projections> = {
    ...query,
    projections: projections->Utils.ensureArray->Some,
  }

  query
}

let where = (
  query: Query.t3<'p1, 'p2, 'p3, 's1, 's2, 's3, 'projections>,
  getSelections: 'selectables => Expr.t,
) => {
  let columnAccessor = Utils.createColumnAccessorWithJoins()
  let selections = getSelections(columnAccessor)

  let query: Query.t3<'p1, 'p2, 'p3, 's1, 's2, 's3, 'projections> = {
    ...query,
    selections: Some(selections),
  }

  query
}

let toSQL = (query: Query.t3<_, _, _, _, _, _, _>) => {
  [
    Projections.toSQL(query.projections, true),
    From.toSQL(query.from, true),
    Joins.toSQL(query.joins, true),
    Selections.toSQL(query.selections, true),
  ]->Js.Array2.joinWith(" ")
}

let asSubQuery: Query.t3<_, _, _, _, _, _, 'projections> => SubQuery.t<'projections> = query => {
  query: query->Obj.magic,
  toSQL: toSQL->Obj.magic,
}
