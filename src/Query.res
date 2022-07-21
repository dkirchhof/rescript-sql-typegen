type t<'projections> = {
  projections: Projections.t,
  from: From.t,
  joins: array<Join.t>,
  selection: Selection.t,
}

let toSQL = query => {
  [
    [Projections.toSQL(query.projections)],
    [From.toSQL(query.from)],
    Js.Array2.map(query.joins, Join.toSQL),
    [Selection.toSQL(query.selection->Obj.magic)]
  ]->Js.Array2.joinWith("\n")
}

let asSubQuery: t<'projections> => 'projections = query => toSQL(query)->Obj.magic
