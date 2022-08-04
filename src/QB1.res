let innerJoin = (query: Query.t1<'p1, 's1, 'projections>, table: Schema.table<'p2, 'op2, 's2>) => {
  let query: Query.t2<'p1, 'p2, 's1, 's2, 'projections> = {
    ...query->Obj.magic,
    joins: [table.name],
  }

  query
}

let leftJoin = (query: Query.t1<'p1, 's1, 'projections>, table: Schema.table<'p, 'op, 's>) => {
  let query: Query.t2<'p1, 'p, 's1, 's, 'projections> = {
    ...query->Obj.magic,
    joins: [table.name],
  }

  query
}

let select = (query: Query.t1<'p1, 's1, _>, getColumns: 'p1 => 'projections) => {
  let projections = getColumns(Utils.createColumnAccessor(0))->Obj.magic

  let query: Query.t1<'p1, 's1, 'projections> = {
    ...query,
    projections: projections->Utils.ensureArray->Some,
  }

  query
}

let where = (query: Query.t1<'p1, 's1, 'projections>, getSelections: 's1 => Expr.t) => {
  let selections = getSelections(Utils.createColumnAccessor(0))

  let query: Query.t1<'p1, 's1, 'projections> = {
    ...query,
    selections: Some(selections),
  }

  query
}

let toSQL = (query: Query.t1<_, _, _>) => {
  [
    Projections.toSQL(query.projections, false),
    From.toSQL(query.from, false),
    Selections.toSQL(query.selections, false),
  ]->Js.Array2.joinWith(" ")
}

let asSubQuery: Query.t1<_, _, 'projections> => SubQuery.t<'projections> = query => {
  query: query->Obj.magic,
  toSQL: toSQL->Obj.magic,
}
