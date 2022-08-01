type q

type t<'projections> = {
  query: q,
  toSQL: q => string,
}

let toSQL = ({ query, toSQL }) => toSQL(query)
