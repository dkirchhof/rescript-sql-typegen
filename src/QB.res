let from = (
  type p s,
  f: module(Table.T with type projectables = p and type selectables = s),
) => {
  let module(T) = f

  let query: Query.t1<p, s, _> = {
    from: T.tableName,
    projections: None,
    selections: None,
  }

  query
}
