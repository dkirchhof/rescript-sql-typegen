type t<'projectables, 'selectables, 'projections> = {
  from: From.t,
  joins: Joins.t,
  selections: Selections.t,
  groupBys: GroupBys.t,
  havings: Havings.t,
  orderBys: OrderBys.t,
  projections: 'projections,
}

let makeSelectQuery = from => {
  from: from,
  joins: [],
  selections: None,
  groupBys: [],
  havings: None,
  orderBys: [],
  projections: Js.Obj.empty(),
}

let makeJoinQuery = (from, joins) => {
  ...makeSelectQuery(from),
  joins,
}
