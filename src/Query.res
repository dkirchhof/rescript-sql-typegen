// only from
type t1<'p1, 's1, 'projections> = {
  from: From.t,
  projections: Projections.t,
  selections: Selections.t,
}

// from and 1 join
type t2<'p1, 'p2, 's1, 's2, 'projections> = {
  from: From.t,
  joins: Joins.t,
  projections: Projections.t,
  selections: Selections.t,
}

// from and 2 joins
type t3<'p1, 'p2, 'p3, 's1, 's2, 's3, 'projections> = {
  from: From.t,
  joins: Joins.t,
  projections: Projections.t,
  selections: Selections.t,
}

type t<'p0, 's0, 'p1, 's1, 'p2, 's2, 'projections> = {
  from: Table.t<'p0,'s0>,
  joins: (option<Join.t<'p1, 's1>>, option<Join.t<'p2, 's2>>),
  projections: Projections.t,
  selections: Selections.t,
}
