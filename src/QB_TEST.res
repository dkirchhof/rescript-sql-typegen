let applyColumnAccessors = fn =>
  fn(Utils.createColumnAccessor(0), Utils.createColumnAccessor(1), Utils.createColumnAccessor(2))

/* let _select = (query, getProjections) => { */
/* open Query */

/* let projections = getColumns(getProjections)->Obj.magic */

/* let query = { */
/* query, */
/* projections, */
/* } */

/* query */
/* } */

/* let select1 = _select */
/* let select2 = _select */
/* let select3 = _select */
/* let select4 = _select */
/* let select5 = _select */

let join1 = (joinType, query, table: Schema.table<_, _>, alias, getCondition) => {
  open Table
  open Query
  open Join

  let condition = applyColumnAccessors(getCondition)

  let (_, j2) = query.joins

  let j1 = Some({
    table: {name: table.name, alias},
    joinType,
    condition,
  })

  let query = {
    ...query,
    joins: (j1, j2),
  }

  query
}

let join2 = (joinType, query, table: Schema.table<_, _>, alias, getCondition) => {
  open Table
  open Query
  open Join

  let condition = applyColumnAccessors(getCondition)

  let (j1, _) = query.joins

  let j2 = Some({
    table: {name: table.name, alias},
    joinType,
    condition,
  })

  let query = {
    ...query,
    joins: (j1, j2),
  }

  query
}

let from = (table: Schema.table<_, _>, alias) => {
  open Table
  open Query

  let t0 = {
    name: table.name,
    alias,
  }

  let query = {
    from: t0,
    joins: (None, None),
    selections: None,
    groupBys: [],
    orderBys: [],
  }

  query
}

let innerJoin1 = (query, table, alias, getCondition) => {
  open Join

  join1(Inner, query, table, alias, getCondition)
}

let leftJoin1 = (query, table, alias, getCondition) => {
  open Join

  join1(Left, query, table, alias, getCondition)
}

let innerJoin2 = (query, table, alias, getCondition) => {
  open Join

  join2(Inner, query, table, alias, getCondition)
}

let leftJoin2 = (query, table, alias, getCondition) => {
  open Join

  join2(Left, query, table, alias, getCondition)
}

let where = (query, getSelections) => {
  open Query

  let selections = applyColumnAccessors(getSelections)

  let query = {
    ...query,
    selections: Some(selections),
  }

  query
}

let groupBy = (query, getGroupBys) => {
  open Query

  let groupBys = applyColumnAccessors(getGroupBys)

  let query = {
    ...query,
    groupBys,
  }

  query
}

let orderBy = (query, getOrderBys) => {
  open Query

  let orderBys = applyColumnAccessors(getOrderBys)

  let query = {
    ...query,
    orderBys,
  }

  query
}

let select = (query, getProjections) => {
  open Query

  let projections = applyColumnAccessors(getProjections)->Utils.ensureArray->Obj.magic

  let query = {
    query,
    projections,
  }

  query
}
