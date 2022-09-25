module From = {
  type t = {name: string, alias: option<string>}

  let make = (name, alias) => {name, alias}

  let toSQL = from => {
    switch from.alias {
    | Some(alias) => `FROM ${from.name} AS "${alias}"`
    | None => `FROM ${from.name}`
    }
  }
}

module Join = {
  type joinType = Inner | Left

  type t = {
    joinType: joinType,
    tableName: string,
    tableAlias: string,
    condition: Expr.t,
  }

  let make = (joinType, tableName, tableAlias, condition) => {
    joinType,
    tableName,
    tableAlias,
    condition,
  }

  let toSQL = (join, queryToSQL) => {
    let joinTypeString = switch join.joinType {
    | Inner => "INNER"
    | Left => "LEFT"
    }

    let selectionString = `ON ${Expr.toSQL(join.condition, queryToSQL)}`

    `${joinTypeString} JOIN ${join.tableName} AS "${join.tableAlias}" ${selectionString}`
  }
}

module Joins = {
  let toSQL = (optionalJoins, queryToSQL) => {
    optionalJoins->Belt.Option.map(joins => joins->Js.Array2.map(Join.toSQL(_, queryToSQL)))
  }
}

module Projections = {
  let toSQL = (projections, toSQL) => {
    let sql =
      projections
      ->Js.Dict.entries
      ->Js.Array2.map(((alias, ref)) => {
        Ref.toProjectionSQL(ref, alias, toSQL)
      })
      ->Js.Array2.joinWith(", ")

    `SELECT ${sql}`
  }
}

module Selections = {
  let toSQL = (optionalSelections, queryToSQL) =>
    optionalSelections->Belt.Option.map(expr => `WHERE ${Expr.toSQL(expr, queryToSQL)}`)
}

module GroupBy = {
  type t = Ref.anyRef

  let make = ref => ref->Ref.toAnyRef

  let toSQL = (groupBy, queryToString) => {
    Ref.toSQL(groupBy, queryToString)
  }
}

module GroupBys = {
  let toSQL = (optionalGroupBys, queryToSQL) => {
    optionalGroupBys->Belt.Option.map(groupBys => {
      let sql = groupBys->Js.Array2.map(GroupBy.toSQL(_, queryToSQL))->Js.Array2.joinWith(", ")

      `GROUP BY ${sql}`
    })
  }
}

module Havings = {
  let toSQL = (optionalHavings, queryToSQL) =>
    optionalHavings->Belt.Option.map(expr => `HAVING ${Expr.toSQL(expr, queryToSQL)}`)
}

module OrderBy = {
  type direction = ASC | DESC

  type t = {
    ref: Ref.anyRef,
    direction: direction,
  }

  let asc = ref => {
    {ref: ref->Ref.toAnyRef, direction: ASC}
  }

  let desc = ref => {
    {ref: ref->Ref.toAnyRef, direction: DESC}
  }

  let toSQL = (orderBy, queryToSQL) => {
    let refString = Ref.toSQL(orderBy.ref, queryToSQL)

    let directionString = switch orderBy.direction {
    | ASC => "ASC"
    | DESC => "DESC"
    }

    `${refString} ${directionString}`
  }
}

module OrderBys = {
  let toSQL = (optionalOrderBys, queryToSQL) => {
    optionalOrderBys->Belt.Option.map(orderBys => {
      let sql = orderBys->Js.Array2.map(OrderBy.toSQL(_, queryToSQL))->Js.Array2.joinWith(", ")

      `ORDER BY ${sql}`
    })
  }
}

module Offset = {
  let toSQL = optionalOffset => {
    optionalOffset->Belt.Option.map(offset => `OFFSET ${offset->Belt.Int.toString}`)
  }
}

module Limit = {
  let toSQL = optionalLimit => {
    optionalLimit->Belt.Option.map(limit => `LIMIT ${limit->Belt.Int.toString}`)
  }
}

module Query = {
  type t<'projectables, 'selectables, 'projections> = {
    from: From.t,
    joins: option<array<Join.t>>,
    projections: Js.Dict.t<Ref.anyRef>,
    selections: option<Expr.t>,
    groupBys: option<array<GroupBy.t>>,
    havings: option<Expr.t>,
    orderBys: option<array<OrderBy.t>>,
    offset: option<int>,
    limit: option<int>,
    _projectables: 'projectables,
    _selectables: 'selectables,
  }

  let make = (from, joins, projectables, selectables) => {
    from,
    joins,
    projections: Js.Dict.empty(),
    selections: None,
    groupBys: None,
    havings: None,
    orderBys: None,
    offset: None,
    limit: None,
    _projectables: projectables,
    _selectables: selectables,
  }
}

let select = (
  query: Query.t<'projectables, 'selectables, _>,
  getProjections: 'projectables => 'projections,
): Query.t<'projectables, 'selectables, 'projections> => {
  let projections = getProjections(query._projectables)->Obj.magic

  {...query, projections}
}

let where = (query: Query.t<'projectables, 'selectables, 'projections>, getSelections): Query.t<
  'projectables,
  'selectables,
  'projections,
> => {
  let selections = getSelections(query._selectables)

  {...query, selections: Some(selections)}
}

let groupBy = (query: Query.t<'projectables, 'selectables, 'projections>, getGroupBys): Query.t<
  'projectables,
  'selectables,
  'projections,
> => {
  let groupBys = getGroupBys(query._selectables)

  {...query, groupBys: Some(groupBys)}
}

let having = (query: Query.t<'projectables, 'selectables, 'projections>, getHavings): Query.t<
  'projectables,
  'selectables,
  'projections,
> => {
  let havings = getHavings(query._selectables)

  {...query, havings: Some(havings)}
}

let orderBy = (query: Query.t<'projectables, 'selectables, 'projections>, getOrderBys): Query.t<
  'projectables,
  'selectables,
  'projections,
> => {
  let orderBys = getOrderBys(query._selectables)

  {...query, orderBys: Some(orderBys)}
}

let offset = (query: Query.t<'projectables, 'selectables, 'projections>, offset): Query.t<
  'projectables,
  'selectables,
  'projections,
> => {
  {...query, offset: Some(offset)}
}

let limit = (query: Query.t<'projectables, 'selectables, 'projections>, limit): Query.t<
  'projectables,
  'selectables,
  'projections,
> => {
  {...query, limit: Some(limit)}
}

let column = c => Ref.makeColumnRef(c)
let value = v => Ref.makeValueRef(v)
let subQuery = query => Ref.makeQueryRef(query)

let count = ref => Ref.updateAggType(ref, Some(COUNT))->Obj.magic
let sumI = ref => Ref.updateAggType(ref, Some(SUM))
let sumF = ref => Ref.updateAggType(ref, Some(SUM))
let avg = ref => Ref.updateAggType(ref, Some(AVG))
let min = ref => Ref.updateAggType(ref, Some(MIN))
let max = ref => Ref.updateAggType(ref, Some(MAX))

let group = GroupBy.make

let asc = OrderBy.asc
let desc = OrderBy.desc

let u = Ref.unbox

let rec toSQL = (query: Query.t<_, _, _>) => {
  open StringBuilder

  make()
  ->addS(Projections.toSQL(query.projections, toSQL))
  ->addS(From.toSQL(query.from))
  ->addMO(Joins.toSQL(query.joins, toSQL))
  ->addSO(Selections.toSQL(query.selections, toSQL))
  ->addSO(GroupBys.toSQL(query.groupBys, toSQL))
  ->addSO(Havings.toSQL(query.havings, toSQL))
  ->addSO(OrderBys.toSQL(query.orderBys, toSQL))
  ->addSO(Limit.toSQL(query.limit))
  ->addSO(Offset.toSQL(query.offset))
  ->build
}

let execute = (query: Query.t<_, _, 'projections>, get, connection) => {
  let map = row => {
    row
    ->Js.Dict.entries
    ->Js.Array2.map(((key, value)) => (key, Js.nullToOption(value)))
    ->Js.Dict.fromArray
    ->Obj.magic
    :> 'projections
  }
  
  toSQL(query)->get(connection)->Js.Promise.then_(rows => rows->Js.Array2.map(map)->Js.Promise.resolve, _)
}
