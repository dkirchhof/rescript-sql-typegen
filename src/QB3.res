let toSQL = (query: Query.t3<_, _, _>) => {
  [
    Projections.toSQL(query.projections, true),
    From.toSQL(query.from, true),
    Joins.toSQL(query.joins, true),
    Selections.toSQL(query.selections, true),
  ]->Js.Array2.joinWith("\n")
}

let select = (
  query: Query.t3<'projectables, 'selectables, _>,
  getColumns: 'projectables => 'projections,
) => {
  let columnAccessor = Utils.createColumnAccessorWithJoins()
  let projections = getColumns(columnAccessor)->Obj.magic

  let query: Query.t3<'projectables, 'selectables, 'projections> = {
    ...query,
    projections: Some(projections),
  }

  query
}

let where = (
  query: Query.t3<'projectables, 'selectables, 'projections>,
  getSelections: 'selectables => Expr.t,
) => {
  let columnAccessor = Utils.createColumnAccessorWithJoins()
  let selections = getSelections(columnAccessor)

  let query: Query.t3<'projectables, 'selectables, 'projections> = {
    ...query,
    selections: Some(selections),
  }

  query
}
