module From = {
  let toSQL = (table: DDL.Table.t<_>) => {
    `FROM ${table.name}`
  }
}

module Projections = {
  let toSQL = (projections, toSQL) => {
    let sql =
      projections
      ->Js.Dict.entries
      ->Js.Array2.map(((alias, ref)) => {
        Ref.toProjectionSQL(ref, false, alias, toSQL)
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
  type t<'columns, 'projections> = {
    table: DDL.Table.t<'columns>,
    projections: Js.Dict.t<Ref.anyRef>,
    selections: option<Expr.t>,
    groupBys: option<array<GroupBy.t>>,
    havings: option<Expr.t>,
    orderBys: option<array<OrderBy.t>>,
    offset: option<int>,
    limit: option<int>,
  }

  let make = table => {
    table,
    projections: Js.Dict.empty(),
    selections: None,
    groupBys: None,
    havings: None,
    orderBys: None,
    offset: None,
    limit: None,
  }
}

let select = (query: Query.t<'columns, _>, getProjections: 'columns => 'projections): Query.t<
  'columns,
  'projections,
> => {
  let projections = getProjections(query.table.columns)->Obj.magic

  {...query, projections}
}

let where = (query: Query.t<'columns, 'projections>, getSelections): Query.t<
  'columns,
  'projections,
> => {
  let selections = getSelections(query.table.columns)

  {...query, selections: Some(selections)}
}

let groupBy = (query: Query.t<'columns, 'projections>, getGroupBys): Query.t<
  'columns,
  'projections,
> => {
  let groupBys = getGroupBys(query.table.columns)

  {...query, groupBys: Some(groupBys)}
}

let having = (query: Query.t<'column, 'projections>, getHavings): Query.t<
  'columns,
  'projections,
> => {
  let havings = getHavings(query.table.columns)

  {...query, havings: Some(havings)}
}

let orderBy = (query: Query.t<'columns, 'projections>, getOrderBys): Query.t<
  'columns,
  'projections,
> => {
  let orderBys = getOrderBys(query.table.columns)

  {...query, orderBys: Some(orderBys)}
}

let offset = (query: Query.t<'columns, 'projections>, offset): Query.t<'columns, 'projections> => {
  {...query, offset: Some(offset)}
}

let limit = (query: Query.t<'columns, 'projections>, limit): Query.t<'columns, 'projections> => {
  {...query, limit: Some(limit)}
}

let u = Ref.unbox
let group = GroupBy.make
let asc = OrderBy.asc
let desc = OrderBy.desc

let rec toSQL = (query: Query.t<_, _>) => {
  open StringBuilder

  make()
  ->addS(Projections.toSQL(query.projections, toSQL))
  ->addS(From.toSQL(query.table))
  ->addSO(Selections.toSQL(query.selections, toSQL))
  ->addSO(GroupBys.toSQL(query.groupBys, toSQL))
  ->addSO(Havings.toSQL(query.havings, toSQL))
  ->addSO(OrderBys.toSQL(query.orderBys, toSQL))
  ->addSO(Offset.toSQL(query.offset))
  ->addSO(Limit.toSQL(query.limit))
  ->build
}
