type t = string

let toSQL = (from, withAlias) =>
  if withAlias {
    [`FROM ${from} AS a`]
  } else {
    [`FROM ${from}`]
  }
