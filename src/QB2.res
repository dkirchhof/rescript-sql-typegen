let innerJoin = (
  type p s,
  query: Query.t2<('p1, 'p2), ('s1, 's2), 'projections>,
  f: module(Table.T with type projectables = p and type selectables = s),
) => {
  let module(T) = f

  let query: Query.t3<('p1, 'p2, p), ('s1, 's2, s), 'projections> = {
    ...query->Obj.magic,
    joins: query.joins->Js.Array2.concat([T.tableName]),
  }

  query
}

let leftJoin = (
  type p s,
  query: Query.t2<('p1, 'p2), ('s1, 's2), 'projections>,
  f: module(Table.T with type optionalProjectables = p and type selectables = s),
) => {
  let module(T) = f

  let query: Query.t3<('p1, 'p2, p), ('s1, 's2, s), 'projections> = {
    ...query->Obj.magic,
    joins: query.joins->Js.Array2.concat([T.tableName]),
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

let toSQL = (query: Query.t2<_, _, _>) => {
  [
    Projections.toSQL(query.projections, true),
    From.toSQL(query.from, true),
    Joins.toSQL(query.joins),
    Selections.toSQL(query.selections, true),
  ]
}
