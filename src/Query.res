type query1<'projectables, 'selectables, 'projections> = {
  from: From.t,
  projections: Projections.t,
  selections: Selections.t,
}
type query2<'projectables, 'selectables, 'projections> = {from: string, joins: array<string>}
type query3<'projectables, 'selectables, 'projections> = {from: string, joins: array<string>}
