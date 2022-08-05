let innerJoin = (
  query: Query.t2<'p1, 'p2, 's1, 's2, 'projections>,
  table: Schema.table<'p3, 'op3, 's3>,
  getCondition: ('s1, 's2, 's3) => Expr.t,
) => {
  open Joins

  let condition = getCondition(Utils.createColumnAccessor(0), Utils.createColumnAccessor(1), Utils.createColumnAccessor(2))

  let join = {
    joinType: Inner,
    tableName: table.name,
    condition,
  }

  let query: Query.t3<'p1, 'p2, 'p3, 's1, 's2, 's3, 'projections> = {
    ...query->Obj.magic,
    joins: query.joins->Js.Array2.concat([join]),
  }

  query
}

let leftJoin = (
  query: Query.t2<'p1, 'p2, 's1, 's2, 'projections>,
  table: Schema.table<'p3, 'op3, 's3>,
  getCondition: ('s1, 's2, 's3) => Expr.t,
) => {
  open Joins

  let condition = getCondition(Utils.createColumnAccessor(0), Utils.createColumnAccessor(1), Utils.createColumnAccessor(2))

  let join = {
    joinType: Left,
    tableName: table.name,
    condition,
  }

  let query: Query.t3<'p1, 'p2, 'p3, 's1, 's2, 's3, 'projections> = {
    ...query->Obj.magic,
    joins: query.joins->Js.Array2.concat([join]),
  }

  query
}

let select = (query: Query.t2<'p1, 'p2, 's1, 's2, _>, getColumns: ('p1, 'p2) => 'projections) => {
  let projections =
    getColumns(Utils.createColumnAccessor(0), Utils.createColumnAccessor(1))->Obj.magic

  let query: Query.t2<'p1, 'p2, 's1, 's2, 'projections> = {
    ...query,
    projections: projections->Utils.ensureArray->Some,
  }

  query
}

let where = (
  query: Query.t2<'p1, 'p2, 's1, 's2, 'projections>,
  getSelections: ('s1, 's2) => Expr.t,
) => {
  let selections = getSelections(Utils.createColumnAccessor(0), Utils.createColumnAccessor(1))

  let query: Query.t2<'p1, 'p2, 's1, 's2, 'projections> = {
    ...query,
    selections: Some(selections),
  }

  query
}

let toSQL = (query: Query.t2<_, _, _, _, _>) => {
  [
    Projections.toSQL(query.projections, true),
    From.toSQL(query.from, true),
    Joins.toSQL(query.joins, true),
    Selections.toSQL(query.selections, true),
  ]->Js.Array2.joinWith(" ")
}

let asSubQuery: Query.t2<_, _, _, _, 'projections> => SubQuery.t<'projections> = query => {
  query: query->Obj.magic,
  toSQL: toSQL->Obj.magic,
}
