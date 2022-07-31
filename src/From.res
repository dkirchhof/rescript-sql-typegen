type t = string

let toSQL = (from, withAlias) =>
  if withAlias {
    `FROM ${from} AS 0`
  } else {
    `FROM ${from}`
  }
