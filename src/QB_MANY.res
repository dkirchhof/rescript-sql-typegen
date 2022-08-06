let from = (table: Schema.table<'p, _, 's>, alias) => {
  open Table
  open Query

  let t0: Table.t<'p, 's> = {
    name: table.name,
    alias,
  }

  let query = {
    from: t0,
    joins: (None, None),
    projections: None,
    selections: None,
  }

  query
}

let join1 = (
  joinType,
  query: Query.t<'p0, 's0, _, _, 'p2, 's2, 'projections>,
  table: Table.t<'p1, 's1>,
  getCondition: ('s0, 's1, 's2) => Expr.t,
) => {
  open Join

  let condition = getCondition(
    Utils.createColumnAccessor(0),
    Utils.createColumnAccessor(1),
    Utils.createColumnAccessor(2),
  )

  let (_, j2) = query.joins

  let j1 = Some({
    table,
    joinType,
    condition,
  })

  let query = {
    ...query,
    joins: (j1, j2),
  }

  query
}

let innerJoin1 = (
  query: Query.t<'p0, 's0, _, _, 'p2, 's2, 'projections>,
  table: Schema.table<'p1, 'op1, 's1>,
  alias,
  getCondition: ('s0, 's1, 's2) => Expr.t,
) => {
  let t1: Table.t<'p1, 's1> = {
    name: table.name,
    alias,
  }

  join1(Inner, query, t1, getCondition)
}

let leftJoin1 = (
  query: Query.t<'p0, 's0, _, _, 'p2, 's2, 'projections>,
  table: Schema.table<'p1, 'op1, 's1>,
  alias,
  getCondition: ('s0, 's1, 's2) => Expr.t,
) => {
  let t1: Table.t<'op1, 's1> = {
    name: table.name,
    alias,
  }

  join1(Left, query, t1, getCondition)
}

let join2 = (
  joinType,
  query: Query.t<'p0, 's0, 'p1, 's1, _, _, 'projections>,
  table: Table.t<'p2, 's2>,
  getCondition: ('s0, 's1, 's2) => Expr.t,
) => {
  open Join

  let condition = getCondition(
    Utils.createColumnAccessor(0),
    Utils.createColumnAccessor(1),
    Utils.createColumnAccessor(2),
  )

  let (j1, _) = query.joins

  let j2 = Some({
    table,
    joinType,
    condition,
  })

  let query = {
    ...query,
    joins: (j1, j2),
  }

  query
}

let innerJoin2 = (
  query: Query.t<'p0, 's0, 'p1, 's1, _, _, 'projections>,
  table: Schema.table<'p2, 'op2, 's2>,
  alias,
  getCondition: ('s0, 's1, 's2) => Expr.t,
) => {
  let t2: Table.t<'p2, 's2> = {
    name: table.name,
    alias,
  }

  join2(Inner, query, t2, getCondition)
}

let leftJoin2 = (
  query: Query.t<'p0, 's0, 'p1, 's1, _, _, 'projections>,
  table: Schema.table<'p2, 'op2, 's2>,
  alias,
  getCondition: ('s0, 's1, 's2) => Expr.t,
) => {
  let t2: Table.t<'op2, 's2> = {
    name: table.name,
    alias,
  }

  join2(Left, query, t2, getCondition)
}

let select = (
  query: Query.t<'p0, 's0, 'p1, 's1, 'p2, 's2, 'projections>,
  getColumns: ('p0, 'p1, 'p2) => 'projections,
) => {
  let projections =
    getColumns(
      Utils.createColumnAccessor(0),
      Utils.createColumnAccessor(1),
      Utils.createColumnAccessor(2),
    )->Obj.magic

  let query: Query.t<'p0, 's0, 'p1, 's1, 'p2, 's2, 'projections> = {
    ...query,
    projections: projections->Utils.ensureArray->Some,
  }

  query
}

/* let where = ( */
/* query: Query.t2<'p1, 'p2, 's1, 's2, 'projections>, */
/* getSelections: ('s1, 's2) => Expr.t, */
/* ) => { */
/* let selections = getSelections(Utils.createColumnAccessor(0), Utils.createColumnAccessor(1)) */

/* let query: Query.t2<'p1, 'p2, 's1, 's2, 'projections> = { */
/* ...query, */
/* selections: Some(selections), */
/* } */

/* query */
/* } */

/* let toSQL = (query: Query.t<_, _, _, _, _, _, _, _, _>) => { */
/* [ */
/* Projections.toSQL(query.projections, true), */
/* From.toSQL(query.from, true), */
/* Joins.toSQL(query.joins, true), */
/* Selections.toSQL(query.selections, true), */
/* ]->Js.Array2.joinWith(" ") */
/* } */

/* let asSubQuery: Query.t2<_, _, _, _, 'projections> => SubQuery.t<'projections> = query => { */
/* query: query->Obj.magic, */
/* toSQL: toSQL->Obj.magic, */
/* } */
