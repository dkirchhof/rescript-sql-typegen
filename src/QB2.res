let toSQL = (query: Query.t2<_, _, _>) => {
  [
    Projections.toSQL(query.projections, true),
    From.toSQL(query.from, true),
    Joins.toSQL(query.joins, true),
    Selections.toSQL(query.selections, true),
  ]->Js.Array2.joinWith("\n")
}

let innerJoin = (
  query: Query.t2<('p1, 'p2), ('s1, 's2), 'projections>,
  table: Schema.table<'p, 'op, 's>,
) => {
  let query: Query.t3<('p1, 'p2, 'p), ('s1, 's2, 's), 'projections> = {
    ...query->Obj.magic,
    joins: query.joins->Js.Array2.concat([table.name]),
  }

  query
}

let leftJoin = (
  query: Query.t2<('p1, 'p2), ('s1, 's2), 'projections>,
  table: Schema.table<'p, 'op, 's>,
) => {
  let query: Query.t3<('p1, 'p2, 'p), ('s1, 's2, 's), 'projections> = {
    ...query->Obj.magic,
    joins: query.joins->Js.Array2.concat([table.name]),
  }

  query
}

let select = (
  query: Query.t2<'projectables, 'selectables, _>,
  getColumns: 'projectables => 'projections,
) => {
  let columnAccessor = Utils.createColumnAccessorWithJoins()
  let projections = getColumns(columnAccessor)->Obj.magic

  let query: Query.t2<'projectables, 'selectables, 'projections> = {
    ...query,
    projections: Some(projections),
  }

  query
}

let where = (
  query: Query.t2<'projectables, 'selectables, 'projections>,
  getSelections: 'selectables => Expr.t,
) => {
  let columnAccessor = Utils.createColumnAccessorWithJoins()
  let selections = getSelections(columnAccessor)

  let query: Query.t2<'projectables, 'selectables, 'projections> = {
    ...query,
    selections: Some(selections),
  }

  query
}
