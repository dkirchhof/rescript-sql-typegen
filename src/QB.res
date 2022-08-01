let from = (table: Schema.table<'p, _, 's>) => {
  let query: Query.t1<'p, 's, _> = {
    from: table.name,
    projections: None,
    selections: None,
  }

  query
}
