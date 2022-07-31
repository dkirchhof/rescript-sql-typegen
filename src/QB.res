let from = (
  type p s,
  f: module(Table.T with type projectables = p and type selectables = s),
): Query.query1<p, s, p> => {
  let module(T) = f

  {from: T.tableName, projections: None, selections: None}
}
