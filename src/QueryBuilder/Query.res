type t<'projectables, 'selectables, 'projections> = {
  from: From.t,
  joins: Joins.t,
  selections: Selections.t,
  groupBys: GroupBys.t,
  havings: Havings.t,
  orderBys: OrderBys.t,
  projections: 'projections,
}

let makeSelectQuery = (from, joins) => {
  from,
  joins,
  selections: None,
  groupBys: [],
  havings: None,
  orderBys: [],
  projections: Js.Obj.empty(),
}
