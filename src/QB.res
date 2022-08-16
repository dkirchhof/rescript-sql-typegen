let applyColumnAccessors = fn =>
  fn(Utils.createColumnAccessor())

let all = () => {
  Ref.Typed.AsteriskRef(AsteriskRef.make())->Obj.magic
}

let value = value => {
  Ref.Typed.ValueRef(ValueRef.make(value))
}

let subQuery = query => {
  Ref.Typed.QueryRef(QueryRef.make(query))
}

let count = ref => {
  (Ref.Typed.updateAggType(ref, Some(Aggregation.COUNT)) :> Ref.Typed.t<int>)
}

let countAll = () => {
  Ref.Typed.AsteriskRef({aggType: Some(Aggregation.COUNT)})
}

let sumI = ref => {
  Ref.Typed.updateAggType(ref, Some(Aggregation.SUM))
}

let sumF = ref => {
  Ref.Typed.updateAggType(ref, Some(Aggregation.SUM))
}

let avg = ref => {
  Ref.Typed.updateAggType(ref, Some(Aggregation.AVG))
}

let min = ref => {
  Ref.Typed.updateAggType(ref, Some(Aggregation.MIN))
}

let max = ref => {
  Ref.Typed.updateAggType(ref, Some(Aggregation.MAX))
}

let join = (query, index, getCondition) => {
  open Query

  let condition = applyColumnAccessors(getCondition)

  let joins = query.joins->Js.Array2.mapi((join, i) => {
    if i === index {
      {...join, condition: Some(condition) }
    } else {
      join
    }
  }) 

  let query = {
    ...query,
    joins: joins,
  }

  query
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

let having = (query, getHavings) => {
  open Query

  let havings = applyColumnAccessors(getHavings)

  let query = {
    ...query,
    havings: Some(havings),
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

let rec toSQL = executable => {
  open Query

  [
    Projections.toSQL(executable.projections->Obj.magic, toSQL),
    From.toSQL(executable.query.from),
    Joins.toSQL(executable.query.joins, toSQL),
    Selections.toSQL(executable.query.selections, toSQL),
    GroupBys.toSQL(executable.query.groupBys, toSQL),
    Havings.toSQL(executable.query.havings, toSQL),
    OrderBys.toSQL(executable.query.orderBys, toSQL),
  ]
  ->Js.Array2.filter(s => String.length(s) > 0)
  ->Js.Array2.joinWith(" ")
}
