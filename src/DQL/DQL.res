module Source = {
  type t = {name: string, alias: option<string>}
}

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
    projections: Js.Dict.t<Ref.anyRef>,
    selections: option<Expr.t>,
    groupBys: option<array<GroupBy.t>>,
    havings: option<Expr.t>,
    orderBys: option<array<OrderBy.t>>,
    offset: option<int>,
    limit: option<int>,
    _projectables: 'projectables,
    _selectabes: 'selectables,
  }

  let make = (from, projectables, selectables) => {
    from,
    projections: Js.Dict.empty(),
    selections: None,
    groupBys: None,
    havings: None,
    orderBys: None,
    offset: None,
    limit: None,
    _projectables: projectables,
    _selectabes: selectables,
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
  let selections = getSelections(query._selectabes)

  {...query, selections: Some(selections)}
}

let groupBy = (query: Query.t<'projectables, 'selectables, 'projections>, getGroupBys): Query.t<
  'projectables,
  'selectables,
  'projections,
> => {
  let groupBys = getGroupBys(query._selectabes)

  {...query, groupBys: Some(groupBys)}
}

let having = (query: Query.t<'projectables, 'selectables, 'projections>, getHavings): Query.t<
  'projectables,
  'selectables,
  'projections,
> => {
  let havings = getHavings(query._selectabes)

  {...query, havings: Some(havings)}
}

let orderBy = (query: Query.t<'projectables, 'selectables, 'projections>, getOrderBys): Query.t<
  'projectables,
  'selectables,
  'projections,
> => {
  let orderBys = getOrderBys(query._selectabes)

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

let u = Ref.unbox
let group = GroupBy.make
let asc = OrderBy.asc
let desc = OrderBy.desc

let rec toSQL = (query: Query.t<_, _, _>) => {
  open StringBuilder

  make()
  ->addS(Projections.toSQL(query.projections, toSQL))
  ->addS(From.toSQL(query.from))
  ->addSO(Selections.toSQL(query.selections, toSQL))
  ->addSO(GroupBys.toSQL(query.groupBys, toSQL))
  ->addSO(Havings.toSQL(query.havings, toSQL))
  ->addSO(OrderBys.toSQL(query.orderBys, toSQL))
  ->addSO(Offset.toSQL(query.offset))
  ->addSO(Limit.toSQL(query.limit))
  ->build
}
