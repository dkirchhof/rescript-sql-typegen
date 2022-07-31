// only from
type t1<'projectables, 'selectables, 'projections> = {
  from: From.t,
  projections: Projections.t,
  selections: Selections.t,
}

// from and 1 join
type t2<'projectables, 'selectables, 'projections> = {
  from: From.t,
  joins: Joins.t,
  projections: Projections.t,
  selections: Selections.t,
}

// from and 2 joins
type t3<'projectables, 'selectables, 'projections> = {
  from: From.t,
  joins: Joins.t,
  projections: Projections.t,
  selections: Selections.t,
}
