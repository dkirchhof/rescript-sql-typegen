let innerJoin = (
  type p s,
  query: Query.query1<'projectables, 'selectables, 'projections>,
  f: module(Table.T with type projectables = p and type selectables = s),
) => {
  let module(T) = f

  let query: Query.query2<('projectables, p), ('selectables, s), 'projections> = {
    ...query->Obj.magic,
    joins: [T.tableName],
  }

  query
}

let leftJoin = (
  type p s,
  query: Query.query1<'p1, 's1, 'projections>,
  f: module(Table.T with type optionalProjectables = p and type selectables = s),
) => {
  let module(T) = f

  let query: Query.query2<('p1, p), ('s1, s), 'projections> = {
    ...query->Obj.magic,
    joins: [T.tableName],
  }

  query
}

let select = (
  query: Query.query1<'projectables, 'selectables, _>,
  getColumns: 'projectables => 'projections,
) => {
  let columnAccessor = Utils.createColumnAccessorWithoutJoins()
  let projections = getColumns(columnAccessor)->Obj.magic

  let query: Query.query1<'projectables, 'selectables, 'projections> = {
    ...query,
    projections: Some(projections),
  }

  query
}

let where = (
  query: Query.query1<'projectables, 'selectables, 'projections>,
  getSelections: 'selectables => Expr.t,
) => {
  let columnAccessor = Utils.createColumnAccessorWithoutJoins()
  let selections = getSelections(columnAccessor)

  let query: Query.query1<'projectables, 'selectables, 'projections> = {
    ...query,
    selections: Some(selections),
  }

  query
}


let toSQL = (query: Query.query1<_, _, _>) => {
  [
    Projections.toSQL(query.projections, false),
    From.toSQL(query.from),
    Selections.toSQL(query.selections),
  ]
}
