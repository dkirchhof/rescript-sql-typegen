type t<'p0, 's0, 'p1, 's1, 'p2, 's2> = {
  from: From.t<'p0, 's0>,
  joins: Joins.t<'p1, 's1, 'p2, 's2>,
  selections: Selections.t,
  groupBys: GroupBys.t, 
  havings: Havings.t,
  orderBys: OrderBys.t, 
}

type executable<'p0, 's0, 'p1, 's1, 'p2, 's2, 'projections> = {
  query: t<'p0, 's0, 'p1, 's1, 'p2, 's2>,
  projections: 'projections,
}
