type t<'projectables, 'selectables> = {
  from: From.t,
  joins: Joins.t,
  selections: Selections.t,
  groupBys: GroupBys.t, 
  havings: Havings.t,
  orderBys: OrderBys.t, 
}

type executable<'projectables, 'selectables, 'projections> = {
  query: t<'projectables, 'selectables>,
  projections: 'projections,
}
